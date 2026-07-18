-- ============================================================
-- ชื่อตัวชี้วัด : ภาวะโลหิตจางในหญิงตั้งครรภ์ที่มารับบริการฝากครรภ์ (ANC)
-- หมวด        : อนามัยแม่และเด็ก (mch-anc)
-- HIS         : HOSxP (MySQL/MariaDB)
-- ทดสอบกับรุ่น  : ยังไม่มีการยืนยันจากโรงพยาบาลจริง (รอ community ช่วยทดสอบ)
-- สถานะ       : draft
-- ผู้เขียน      : MOPH KPI SQL Community
-- อัปเดตล่าสุด  : 2026-07-18
-- นิยามอ้างอิง  : หญิงตั้งครรภ์ (รหัส Z34/Z35) ที่ผล Hb ครั้งแรกในช่วงเวลา
--               ต่ำกว่าเกณฑ์ (ค่าเริ่มต้น 11.0 g/dL ตาม WHO 2011)
--               รายละเอียดเต็มดู README.md ในโฟลเดอร์เดียวกัน
-- สิ่งที่ต้องปรับตามโรงพยาบาล :
--               1) @hb_codes รหัส lab_items_code ของ Hb
--               2) @start_date / @end_date ช่วงวันที่
--               3) (ทางเลือก) รหัสคลินิก ANC ใน ovst.spclty
-- ข้อจำกัด     : นับเฉพาะผู้ที่ถูกลงรหัส Z34/Z35 ที่โรงพยาบาลนี้,
--               ผล lab ภายนอกหรือที่บันทึกเป็นข้อความไม่ถูกนับ,
--               นิยามทางการของ HDC อาจต่างจาก query นี้เล็กน้อย
-- ============================================================

-- ============================================================
-- พารามิเตอร์ (แก้ค่าที่นี่ที่เดียว ไม่ต้องไล่แก้ใน query)
-- ============================================================

SET @start_date := '2025-10-01';  -- ปีงบประมาณ 2569 : เริ่ม 1 ต.ค. 2568
SET @end_date   := '2026-09-30';  -- ปีงบประมาณ 2569 : สิ้นสุด 30 ก.ย. 2569

SET @hb_codes := '0000';  -- [ปรับตามโรงพยาบาล] รหัส lab_items_code ของ Hb
                          -- ใส่ได้หลายรหัส คั่นด้วยจุลภาค ห้ามมีช่องว่าง เช่น '123,456'
                          -- (query ใช้ FIND_IN_SET จึงรองรับหลายรหัสในตัวแปรเดียว)
                          -- หารหัสของโรงพยาบาลคุณด้วย helper query ด้านล่าง

SET @hb_cutoff := 11.0;   -- เกณฑ์ Hb (g/dL) ที่ถือว่าโลหิตจาง
                          -- ค่าเริ่มต้น 11.0 ตาม WHO 2011 ดูหัวข้อนิยามใน README.md

-- ============================================================
-- Helper query : หารหัส lab ของ Hb ในโรงพยาบาลของคุณ
-- (เปิด comment แล้วรันครั้งแรกครั้งเดียว เพื่อเอารหัสไปใส่ @hb_codes)
-- ============================================================

-- ระวัง: ห้ามใช้รหัสของ HbA1c ต้องเป็น Hb จาก CBC เท่านั้น
-- (ค่า HbA1c อยู่ช่วง 4-8 ถ้าใส่ผิด แทบทุกคนจะถูกนับเป็นโลหิตจางโดยไม่มี error เตือน)

-- SELECT lab_items_code, lab_items_name
-- FROM lab_items
-- WHERE ( lab_items_name LIKE '%Hb%'
--      OR lab_items_name LIKE '%emoglobin%'
--      OR lab_items_name LIKE '%CBC%' )
--   AND lab_items_name NOT LIKE '%A1c%';

-- ============================================================
-- 1) Query สรุป (ตัวตั้ง/ตัวหาร/ร้อยละ)
-- ============================================================
-- หมายเหตุ: ผลจาก query นี้ใช้ตรวจสอบภายในเท่านั้น ค่าทางการอ้างอิงจากระบบ HDC

SELECT
    COUNT(*)                                          AS `จำนวนหญิงตั้งครรภ์ทั้งหมด`,
    SUM(CASE WHEN hb.hb_value IS NOT NULL
             THEN 1 ELSE 0 END)                       AS `มีผล Hb (ตัวหาร)`,
    SUM(CASE WHEN hb.hb_value IS NULL
             THEN 1 ELSE 0 END)                       AS `ไม่มีผล Hb`,
    SUM(CASE WHEN hb.hb_value < @hb_cutoff
             THEN 1 ELSE 0 END)                       AS `Hb ต่ำกว่าเกณฑ์ (ตัวตั้ง)`,
    ROUND(
        SUM(CASE WHEN hb.hb_value < @hb_cutoff THEN 1 ELSE 0 END) * 100.0
        / NULLIF(SUM(CASE WHEN hb.hb_value IS NOT NULL THEN 1 ELSE 0 END), 0)
    , 2)                                              AS `ร้อยละ`
FROM
    -- cohort: หญิงตั้งครรภ์ที่มี visit ในช่วงวันที่ และมีรหัส Z34/Z35
    ( SELECT DISTINCT o.hn
      FROM ovst o
          JOIN ovstdiag od ON od.vn = o.vn
      WHERE o.vstdate BETWEEN @start_date AND @end_date
        -- match รหัสแบบทนทาน: HOSxP ส่วนใหญ่เก็บ icd10 ไม่มีจุด แต่บางแห่งมีจุด
        AND ( REPLACE(od.icd10, '.', '') LIKE 'Z34%'
           OR REPLACE(od.icd10, '.', '') LIKE 'Z35%' )
        -- [ปรับตามโรงพยาบาล] ถ้าต้องการกรองเฉพาะคลินิก ANC ให้เปิด comment บรรทัดล่าง
        -- และแก้รหัสให้ตรงกับของโรงพยาบาลคุณ (ดูรหัสจาก: SELECT spclty, name FROM spclty;)
        -- ถ้าเปิดใช้ ต้องแก้จุดเดียวกันใน Query 2 ให้เหมือนกันด้วย
        -- AND o.spclty = 'XX'
    ) c
    LEFT JOIN
    -- ผล Hb ครั้งแรก (ค่าตัวเลข) ของแต่ละ hn ในช่วงวันที่
    -- หมายเหตุประสิทธิภาพ: subquery นี้กวาดผล lab ของผู้ป่วยทุกคนในช่วงวันที่ก่อน
    -- แล้วค่อยถูกตัดเหลือเฉพาะ cohort ตอน join โรงพยาบาลขนาดใหญ่ที่ข้อมูล lab ทั้งปี
    -- มีหลายล้านแถว รอบแรกอาจช้า แนะนำรันนอกเวลาเร่งด่วนและตั้งช่วงวันที่ให้แคบพอ
    ( SELECT
          fh.hn,
          fh.first_hb_date,
          -- ถ้าวันแรกมีผลหลายรายการ ใช้ค่าต่ำสุดของวันนั้น เพื่อให้ผลคงที่ทุกครั้งที่รัน
          MIN(CAST(lo2.lab_order_result AS DECIMAL(5,2))) AS hb_value
      FROM
          ( SELECT lh.hn, MIN(lh.order_date) AS first_hb_date
            FROM labs_head lh
                JOIN lab_order lo ON lo.lab_order_number = lh.lab_order_number
            WHERE lh.order_date BETWEEN @start_date AND @end_date
              AND FIND_IN_SET(lo.lab_items_code, @hb_codes)  -- [ปรับตามโรงพยาบาล] ผ่าน @hb_codes ด้านบน
              -- lab_order_result เป็น VARCHAR ต้องกรองเฉพาะค่าตัวเลขก่อน CAST เสมอ
              AND lo.lab_order_result REGEXP '^[0-9]+([.][0-9]+)?$'
            GROUP BY lh.hn
          ) fh
          JOIN labs_head lh2
              ON lh2.hn = fh.hn
             AND lh2.order_date = fh.first_hb_date
          JOIN lab_order lo2
              ON lo2.lab_order_number = lh2.lab_order_number
      WHERE FIND_IN_SET(lo2.lab_items_code, @hb_codes)       -- [ปรับตามโรงพยาบาล] ผ่าน @hb_codes ด้านบน
        AND lo2.lab_order_result REGEXP '^[0-9]+([.][0-9]+)?$'
      GROUP BY fh.hn, fh.first_hb_date
    ) hb
    ON hb.hn = c.hn;

-- ============================================================
-- 2) Query รายละเอียดรายบุคคล (ใช้ภายใน ห้ามแชร์)
-- ============================================================
-- คำเตือน: ผลรายบุคคลมีข้อมูลส่วนบุคคลของผู้ป่วย
--          ใช้ตรวจสอบภายในโรงพยาบาลเท่านั้น ห้ามแชร์ออกนอกโรงพยาบาลทุกช่องทาง
--          (ดู docs/data-privacy.md)
-- เงื่อนไขการนับตรงกับ Query 1 ทุกประการ ใช้ไล่ตรวจว่าใครถูกนับในตัวตั้ง/ตัวหาร
-- ระหว่างพัฒนา แนะนำเติม LIMIT 100 ท้าย query เพื่อลดภาระฐานข้อมูล

SELECT
    c.hn,
    hb.first_hb_date                                  AS `วันที่ตรวจ Hb ครั้งแรก`,
    hb.hb_value                                       AS `ค่า Hb (g/dL)`,
    CASE
        WHEN hb.hb_value IS NULL        THEN 'ไม่มีผล Hb'
        WHEN hb.hb_value < @hb_cutoff   THEN 'ต่ำกว่าเกณฑ์'
        ELSE 'ไม่ต่ำกว่าเกณฑ์'
    END                                               AS `ผลการคัดกรอง`
FROM
    -- cohort: ต้องเหมือน Query 1 ทุกบรรทัด
    ( SELECT DISTINCT o.hn
      FROM ovst o
          JOIN ovstdiag od ON od.vn = o.vn
      WHERE o.vstdate BETWEEN @start_date AND @end_date
        AND ( REPLACE(od.icd10, '.', '') LIKE 'Z34%'
           OR REPLACE(od.icd10, '.', '') LIKE 'Z35%' )
        -- [ปรับตามโรงพยาบาล] ถ้าเปิดใช้ตัวกรองคลินิก ANC ใน Query 1 ต้องเปิดที่นี่ด้วย
        -- AND o.spclty = 'XX'
    ) c
    LEFT JOIN
    ( SELECT
          fh.hn,
          fh.first_hb_date,
          MIN(CAST(lo2.lab_order_result AS DECIMAL(5,2))) AS hb_value
      FROM
          ( SELECT lh.hn, MIN(lh.order_date) AS first_hb_date
            FROM labs_head lh
                JOIN lab_order lo ON lo.lab_order_number = lh.lab_order_number
            WHERE lh.order_date BETWEEN @start_date AND @end_date
              AND FIND_IN_SET(lo.lab_items_code, @hb_codes)  -- [ปรับตามโรงพยาบาล] ผ่าน @hb_codes ด้านบน
              AND lo.lab_order_result REGEXP '^[0-9]+([.][0-9]+)?$'
            GROUP BY lh.hn
          ) fh
          JOIN labs_head lh2
              ON lh2.hn = fh.hn
             AND lh2.order_date = fh.first_hb_date
          JOIN lab_order lo2
              ON lo2.lab_order_number = lh2.lab_order_number
      WHERE FIND_IN_SET(lo2.lab_items_code, @hb_codes)       -- [ปรับตามโรงพยาบาล] ผ่าน @hb_codes ด้านบน
        AND lo2.lab_order_result REGEXP '^[0-9]+([.][0-9]+)?$'
      GROUP BY fh.hn, fh.first_hb_date
    ) hb
    ON hb.hn = c.hn
ORDER BY
    (hb.hb_value IS NULL),  -- คนที่มีผล Hb ขึ้นก่อน คนที่ไม่มีผลอยู่ท้ายสุด
    hb.hb_value;            -- เรียงจากค่า Hb ต่ำสุดขึ้นก่อน

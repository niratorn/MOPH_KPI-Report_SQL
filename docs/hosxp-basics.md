# พื้นฐานโครงสร้างข้อมูล HOSxP สำหรับงานตัวชี้วัด

เอกสารนี้สรุปตาราง core ของ HOSxP (MySQL/MariaDB) ที่ใช้บ่อยในการดึงข้อมูลตัวชี้วัด
เขียนสำหรับเจ้าหน้าที่ IT โรงพยาบาลที่รู้ SQL พื้นฐาน
ใช้คู่กับ [docs/query-style-guide.md](query-style-guide.md) เมื่อจะเขียน query แบ่งปันเข้าชุมชน

## คำเตือนสำคัญ: ตรวจโครงสร้างจริงก่อนเสมอ

- โครงสร้างตารางต่างกันระหว่าง HOSxP v3, v4 และ XE และแต่ละโรงพยาบาลอาจ customize เพิ่มเอง
  คอลัมน์ที่มีในโรงพยาบาลหนึ่งอาจไม่มีในอีกโรงพยาบาลหนึ่ง
- ก่อนรัน query ใดก็ตาม ให้ตรวจโครงสร้างจริงของฐานข้อมูลตัวเองก่อน:

```sql
DESCRIBE ovst;
-- หรือ
SHOW COLUMNS FROM ovst;
```

- ตารางที่นอกเหนือจาก core list ในเอกสารนี้ ให้ถือว่าต้องตรวจสอบเองทุกครั้ง
  ว่ามีอยู่จริงในรุ่นของโรงพยาบาลตัวเองและเก็บข้อมูลตามที่คาดหรือไม่
  query ในชุมชนนี้จะ comment กำกับจุดที่เป็น version-dependent ไว้เสมอ

## ตาราง core และ key

| ตาราง | คอลัมน์สำคัญ | ใช้ทำอะไร |
|---|---|---|
| patient | hn, cid, pname, fname, lname, birthday, sex | ข้อมูลผู้ป่วย 1 คนต่อ 1 แถว, key คือ hn, ใช้คำนวณอายุจาก birthday |
| ovst | vn, hn, vstdate, vsttime, an, spclty | visit ผู้ป่วยนอก 1 ครั้งต่อ 1 แถว, key คือ vn, เชื่อมกับ patient ด้วย hn, ถ้า visit นั้น admit จะมีค่า an |
| ovstdiag | vn, icd10, diagtype | การวินิจฉัยฝั่ง OPD หลายแถวต่อ 1 vn, diagtype = '1' คือการวินิจฉัยหลัก (principal) |
| ipt | an, hn, vn, regdate, regtime, dchdate, dchtime, ward, spclty | admission 1 ครั้งต่อ 1 แถว, key คือ an, regdate คือวันรับเข้า, dchdate คือวันจำหน่าย |
| iptdiag | an, icd10, diagtype | การวินิจฉัยฝั่ง IPD หลายแถวต่อ 1 an, diagtype = '1' คือการวินิจฉัยหลัก |
| labs_head | lab_order_number, vn, hn, order_date | หัวใบสั่ง lab 1 ใบต่อ 1 แถว, key คือ lab_order_number, เชื่อมกับ visit ด้วย vn หรือผู้ป่วยด้วย hn |
| lab_order | lab_order_number, lab_items_code, lab_order_result | ผล lab รายรายการ, หลายแถวต่อ 1 ใบสั่ง, lab_order_result เป็น VARCHAR ไม่ใช่ตัวเลข |
| lab_items | lab_items_code, lab_items_name | ชื่อรายการ lab, รหัส lab_items_code ต่างกันทุกโรงพยาบาล |
| spclty | spclty, name | รหัสและชื่อแผนก/คลินิก ใช้ join กับ ovst.spclty หรือ ipt.spclty |

## แผนภาพการเชื่อมตาราง

```
patient --(hn)--> ovst --(vn)--> ovstdiag
                   |
                   +--(vn)--> labs_head --(lab_order_number)--> lab_order --(lab_items_code)--> lab_items

patient --(hn)--> ipt --(an)--> iptdiag

ovst.spclty / ipt.spclty --(spclty)--> spclty
```

อ่านแบบนี้: เริ่มจากผู้ป่วย (patient) เชื่อมไป visit (ovst) ด้วย hn
จาก visit เชื่อมไปการวินิจฉัย (ovstdiag) หรือใบสั่ง lab (labs_head) ด้วย vn
ฝั่ง IPD เริ่มจาก patient เชื่อมไป admission (ipt) ด้วย hn แล้วไปการวินิจฉัย (iptdiag) ด้วย an

## รูปแบบที่ใช้บ่อย

### กรองช่วงปีงบประมาณด้วย BETWEEN

```sql
SET @start_date := '2025-10-01';  -- ปีงบประมาณ 2569 : 1 ต.ค. 2568
SET @end_date   := '2026-09-30';  -- ปีงบประมาณ 2569 : 30 ก.ย. 2569

SELECT COUNT(DISTINCT o.vn)
FROM ovst o
WHERE o.vstdate BETWEEN @start_date AND @end_date;
```

### หา lab_items_code ของโรงพยาบาลตัวเอง

รหัส lab ต่างกันทุกโรงพยาบาล ห้าม copy รหัสจากโรงพยาบาลอื่นมาใช้ตรง ๆ
ให้ค้นจากชื่อรายการก่อน เช่น หา Hemoglobin:

```sql
SELECT lab_items_code, lab_items_name
FROM lab_items
WHERE lab_items_name LIKE '%Hb%'
   OR lab_items_name LIKE '%emoglobin%'
   OR lab_items_name LIKE '%CBC%';
```

แล้วเอารหัสที่ได้ไปใส่ในตัวแปร `SET @...` ที่หัวไฟล์ query

### CAST ผล lab ที่เป็น VARCHAR อย่างปลอดภัย

`lab_order.lab_order_result` เป็น VARCHAR อาจมีค่าเช่น 'N/A', 'ปฏิเสธ', 'ส่งต่อ' ปนอยู่
ถ้า CAST ตรง ๆ ค่าเหล่านี้จะกลายเป็น 0 และทำให้ผลนับผิด ให้กรองด้วย REGEXP ก่อนเสมอ:

```sql
SELECT CAST(lo.lab_order_result AS DECIMAL(5,2)) AS hb_value
FROM lab_order lo
WHERE lo.lab_items_code = @hb_lab_code
  AND lo.lab_order_result REGEXP '^[0-9]+([.][0-9]+)?$';
```

ข้อควรระวังในการเขียน pattern: ให้ใช้ `[.]` แทน `\.` เสมอ
เพราะ MySQL ตัด backslash ออกจาก string ก่อนส่งให้ regex ทำให้ `\.` กลายเป็น `.`
ซึ่ง match ทุกตัวอักษร ค่าอย่าง '10-11' หรือ '11,2' จะหลุดผ่านตัวกรองแล้วถูก CAST เป็นตัวเลขผิด ๆ

### จับ ICD-10 ให้ทนทานเรื่องจุด

HOSxP ส่วนใหญ่เก็บรหัส ICD-10 (WHO) แบบไม่มีจุด เช่น O801 ไม่ใช่ O80.1
แต่บางแห่งเก็บมีจุด ให้ลบจุดออกก่อน match เสมอ:

```sql
SELECT od.vn
FROM ovstdiag od
WHERE REPLACE(od.icd10, '.', '') LIKE 'O60%'
  AND od.diagtype = '1';  -- การวินิจฉัยหลัก
```

### นับไม่ซ้ำ

- นับจำนวนคน: `COUNT(DISTINCT hn)`
- นับจำนวน admission: `COUNT(DISTINCT an)`
- นับจำนวน visit: `COUNT(DISTINCT vn)`

เลือกให้ตรงกับนิยามตัวชี้วัด เพราะผู้ป่วย 1 คนมาได้หลาย visit และ admit ได้หลายครั้ง
ตรวจสอบนิยามและค่าเป้าหมายจาก template ตัวชี้วัดของปีงบประมาณปัจจุบันใน HDC หรือ Health KPI

## ข้อปฏิบัติในการรัน query

- ใช้ DB user แบบ read-only (สิทธิ์ SELECT อย่างเดียว) ห้ามใช้ user ที่แก้ข้อมูลได้
- query หนัก (join หลายตาราง, ช่วงเวลาทั้งปี) ให้รันนอกเวลาเร่งด่วน หรือรันบน replica ถ้ามี
  เพื่อไม่ให้กระทบระบบบริการหน้างาน
- ระหว่างพัฒนา query ให้เติม `LIMIT 100` ท้าย query ก่อน เมื่อผลถูกต้องแล้วค่อยเอาออก
- ผลลัพธ์ที่มีข้อมูลรายบุคคล ใช้ตรวจสอบภายในโรงพยาบาลเท่านั้น
  ห้ามแชร์ออกนอกโรงพยาบาล (ดู [docs/data-privacy.md](data-privacy.md))
- ตัวเลขจาก query ในชุมชนนี้ใช้ตรวจสอบและเตรียมข้อมูลภายในโรงพยาบาล ไม่ใช่ค่าทางการ
  ค่าทางการอ้างอิงจากระบบ HDC ของกระทรวง (https://hdcservice.moph.go.th)

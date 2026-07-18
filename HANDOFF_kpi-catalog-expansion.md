# HANDOFF : ขยาย KPI catalog จาก PDF ตัวชี้วัดตรวจราชการ

วันที่: 2026-07-18
สถานะ session ที่แล้ว: bootstrap repo เสร็จสมบูรณ์และ push แล้ว (commit แรก `571a14c` + commit ปิด session)
ไฟล์นี้เป็น shift note ชั่วคราว อ่านแล้วทำต่อเสร็จให้ลบทิ้ง

## งานที่เสร็จแล้ว (อย่าทำซ้ำ)

- โครงสร้าง repo ทั้งหมด 25 ไฟล์: README, CONTRIBUTING (มีขั้นตอน click-by-click สำหรับคนไม่ใช้ git), issue forms 3 แบบ, docs 4 ไฟล์, template, query ตัวอย่าง 2 ตัว (maternal-anemia, preterm-birth) สถานะ draft
- ผ่านการตรวจ 3 ชั้น: style audit, SQL review (sqlglot parse ผ่าน dialect mysql), coherence audit แก้ครบทั้ง 15 ประเด็นแล้ว
- กติกาถาวรทั้งหมดอยู่ใน CLAUDE.md ของ repo แล้ว อ่านก่อนแก้ไฟล์ใด

## งานที่ค้าง (เรียงตามลำดับที่ควรทำ)

1. **ขยาย docs/kpi-catalog.md จาก PDF ตัวชี้วัดตรวจราชการ**
   - ผู้ใช้มีไฟล์ PDF "ตัวชี้วัดตรวจราชการของกระทรวงสาธารณสุขจริง" และขอให้หาตัวชี้วัดที่เหมาะจะแบ่งปัน query ระหว่างโรงพยาบาลเพิ่มเติม
   - **PDF ยังไม่เคยมาถึงมือ agent**: session ที่แล้วหาไฟล์ในเครื่องไม่พบ (คาดว่าแนบไม่สำเร็จหรืออยู่บนเครื่อง local) ขั้นแรกคือขอให้ผู้ใช้แนบไฟล์อีกครั้ง หรือวางไว้ในโฟลเดอร์โปรเจกต์
   - วิธีคัดที่ตกลงกันโดยพฤตินัย: เลือกตัวชี้วัดที่ (ก) คำนวณได้จากตาราง core ของ HOSxP ตาม whitelist ใน docs/hosxp-basics.md (ข) นิยามอิง ICD-10 หรือ lab ที่ทุกโรงพยาบาลมี (ค) เป็นภาระ frontline จริง
   - เพิ่มเข้า catalog เป็นสถานะ "ยังไม่มี รอผู้แบ่งปัน" พร้อมหมวดที่ถูกต้อง ห้ามใส่รหัส KPI ทางการและค่าเป้าหมาย (กฎเหล็กข้อ 3 ใน CLAUDE.md)
   - ถ้าจะ commit ตัว PDF เข้า repo ให้ถามผู้ใช้ก่อน (เอกสารราชการเผยแพร่ได้ แต่ควรยืนยัน)
2. **ตั้งค่า repo บน GitHub** (ทำบนหน้าเว็บ ผู้ใช้ทำเองได้)
   - branch เดียวที่มีคือ `claude/health-sql-query-community-vj08nw` และเป็น default อยู่ ถ้าอยากได้ชื่อ `main` ให้ rename ที่ Settings > Branches (rename ปลอดภัยกว่าสร้างใหม่ ลิงก์เก่า redirect ให้อัตโนมัติ)
   - เปิดใช้ Issues ใน Settings ถ้ายังไม่เปิด เพราะ flow ของชุมชนพึ่ง issue forms ทั้งหมด
3. **หาโรงพยาบาลนำร่อง 1-2 แห่ง** รัน query ทั้งสองตัวเทียบข้อมูลจริง เพื่อเปลี่ยนสถานะ draft เป็น validated (นิยามของ validated อยู่ใน CONTRIBUTING.md หัวข้อการ review)

## การตัดสินใจที่จบแล้ว (อย่ารื้อ)

- ภาษาไทยเป็นหลัก, MIT license, สถานะ query มีแค่ draft/validated
- SQL ต้องรันได้บน MySQL 5.x (ห้าม CTE/window functions) เหตุผล: หลายโรงพยาบาลยังใช้ HOSxP บน MySQL เก่า
- นิยามเชิงคลินิกและเกณฑ์ตัวเลขทั้งหมด: อ่านจาก README ของ query แต่ละตัว ห้าม copy ตัวเลขจาก handoff นี้ไปใช้
- ชื่อ issue form ต้อง copy ตรงตัวจาก field `name:` ใน .github/ISSUE_TEMPLATE/*.yml (ดู CLAUDE.md)

## Lesson bank : ยังไม่ได้บันทึก เพราะ session นี้อยู่บน cloud มองไม่เห็นไดรฟ์ D:

Session ถัดไปที่รันบนเครื่อง local ให้เอาบล็อกด้านล่างไปต่อท้ายไฟล์
`D:\Phichithospital\Research Claude Skills\lessons\moph-kpi-sql.md` (สร้างไฟล์ใหม่ถ้ายังไม่มี) แล้วลบหัวข้อนี้ออกจาก handoff

```markdown
# บทเรียนจากโปรเจกต์ MOPH_KPI-Report_SQL

## 2026-07-18 : bootstrap ชุมชนแบ่งปัน SQL query ตัวชี้วัด (session บน Claude Code cloud)

- **MySQL REGEXP ห้ามเขียนจุดเป็น `\.` ใน string pattern** (general) MySQL ตัด backslash ออกจาก
  string literal ก่อนส่งให้ regex engine ทำให้ `'^[0-9]+(\.[0-9]+)?$'` กลายเป็นจุดที่ match
  ทุกตัวอักษร ค่า lab อย่าง '10-11' หรือ '11,2' จึงหลุดผ่านตัวกรองแล้วถูก CAST เป็นตัวเลขผิด
  โดยไม่มี error ใด ๆ อาการ: ตัวเลขความชุกสูงเกินจริงเงียบ ๆ วิธีแก้: เขียนจุดเป็น `[.]` เสมอ
  ทนทั้ง sql_mode ปกติและ NO_BACKSLASH_ESCAPES
- **กับดัก HbA1c ตอนค้นรหัส lab ของ Hb**: helper ที่ค้นด้วย LIKE '%Hb%' จะเจอ HbA1c ด้วย
  ถ้าใส่รหัส HbA1c ผิดเป็น Hb ค่าที่ได้อยู่ช่วงประมาณ 4-8 แทบทุกคนจะถูกนับเป็นโลหิตจาง
  โดยไม่มีสัญญาณเตือน ให้เติม `NOT LIKE '%A1c%'` และเขียนคำเตือนติดกับ helper เสมอ
- **fan-out หลาย agent เขียนเอกสารชุดเดียวกัน: string ที่ผู้ใช้เห็นต้อง pin ค่า exact ใน contract**
  (general) ชื่อ issue form ถูกสะกดต่างกัน 3 แบบใน 3 ไฟล์ทั้งที่มี style contract ร่วมแล้ว
  เพราะ contract บอกแค่แนวคิดไม่ได้ pin ข้อความ บทเรียน: ชื่อฟอร์ม ชื่อปุ่ม label
  ให้เขียนค่า exact ลง contract และต้องมี verifier ตรวจ coherence ข้ามไฟล์เสมอ
  (รอบนี้ verifier 3 ตัวจับได้ 15 ประเด็น เป็น blocker 4)
- **repo ว่างเปล่า push branch แรกแล้วเปิด PR ไม่ได้** (general) branch แรกกลายเป็น
  default branch อัตโนมัติ ไม่มี base ให้เทียบ ถ้าอยากได้ PR review สำหรับ commit แรก
  ต้องสร้าง branch เปล่าไว้ก่อน หรือยอมรับว่างานก้อนแรกเข้าโดยไม่ผ่าน PR
- **sqlglot ตรวจ syntax SQL ได้โดยไม่ต้องมี MySQL server** (general)
  `pip install sqlglot` แล้ว `sqlglot.parse(sql, read='mysql')` เหมาะใช้เป็นด่านตรวจ
  ของ repo แบ่งปัน query ที่ไม่มีฐานข้อมูลจริงให้ทดสอบ
```

## Skill ที่ควรใช้ใน session ถัดไป

- `pdf` : อ่านไฟล์ตัวชี้วัดตรวจราชการ
- `project-playbook` : อ่านก่อนเริ่ม เพราะมีกฎ citation และ clinical threshold ที่ repo นี้ใช้
- `lesson-bank` : ถ้าบทเรียนด้านบนถูกย้ายเข้าไฟล์ lessons แล้ว ให้พิจารณารัน consolidate mode เพราะบทเรียน fan-out และ REGEXP เป็น general

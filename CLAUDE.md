# CLAUDE.md : กติกาสำหรับ AI agent ที่ทำงานใน repo นี้

Conventions for AI agents (Claude and others) working on this repository. อ่านให้จบก่อนแก้ไฟล์ใด ๆ

## จุดประสงค์ของ repo (1 บรรทัด)

ชุมชนแบ่งปัน SQL query ตัวชี้วัด (KPI) กระทรวงสาธารณสุข สำหรับเจ้าหน้าที่ IT หน่วยบริการสุขภาพ ที่ใช้ HOSxP (MySQL/MariaDB) เพื่อลดการเขียน query ซ้ำกันเองทุกโรงพยาบาล

## โครงสร้าง canonical ของ repo

โครงสร้างด้านล่างคือโครงสร้างที่ถูกต้อง ห้ามสร้างไฟล์หรือโฟลเดอร์นอกแบบแผนนี้โดยไม่มีเหตุผลชัดเจน:

```
README.md
CONTRIBUTING.md
CODE_OF_CONDUCT.md
LICENSE
CLAUDE.md
.gitignore
.github/PULL_REQUEST_TEMPLATE.md
.github/ISSUE_TEMPLATE/config.yml
.github/ISSUE_TEMPLATE/01-kpi-query-request.yml
.github/ISSUE_TEMPLATE/02-query-problem.yml
.github/ISSUE_TEMPLATE/03-share-query.yml
docs/kpi-catalog.md
docs/query-style-guide.md
docs/hosxp-basics.md
docs/data-privacy.md
templates/query-template.sql
queries/README.md
queries/mch-anc/README.md
queries/mch-anc/maternal-anemia/README.md
queries/mch-anc/maternal-anemia/hosxp.sql
queries/mch-anc/preterm-birth/README.md
queries/mch-anc/preterm-birth/hosxp.sql
queries/ncd/README.md
queries/cancer-screening/README.md
queries/service-quality/README.md
```

## กฎเหล็ก 5 ข้อ (HARD RULES : ผิดข้อใดข้อหนึ่ง = blocker)

1. **ห้ามใช้ em dash และ en dash** ในทุกไฟล์ ทุกภาษา ใช้ hyphen, colon, comma หรือคำไทยเช่น "ถึง" แทน
2. **ห้ามแต่งแหล่งอ้างอิง** ห้ามสร้าง citation, URL, หรือเลขที่เอกสารขึ้นเอง แหล่งอ้างอิงที่อนุญาต: เอกสาร WHO เรื่อง haemoglobin cutoffs (2011 และ 2024), นิยาม preterm birth ของ WHO, ICD-10 (WHO), HDC (https://hdcservice.moph.go.th), Health KPI กระทรวงสาธารณสุข (https://healthkpi.moph.go.th), กองยุทธศาสตร์และแผนงาน สำนักงานปลัดกระทรวงสาธารณสุข (อ้างชื่อได้ ห้ามใส่ URL), พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 (อ้างชื่อได้)
3. **ห้ามระบุค่าเป้าหมายหรือรหัสตัวชี้วัดทางการ** ห้ามเขียนเปอร์เซ็นต์เป้าหมายหรือรหัส KPI ของกระทรวง ให้เขียนแทนว่า: "ตรวจสอบนิยามและค่าเป้าหมายจาก template ตัวชี้วัดของปีงบประมาณปัจจุบันใน HDC หรือ Health KPI"
4. **ห้ามมีข้อมูลผู้ป่วยจริง** ตัวอย่างผลลัพธ์ต้องเป็นข้อมูลสมมติที่เห็นชัดว่าปลอม (HN แบบ 000001, 000002) และติดป้าย "ข้อมูลสมมติ" เสมอ
5. **ค่าทางการมาจาก HDC เท่านั้น** ทุกเอกสารของ query ต้องสื่อชัดว่า query ในชุมชนนี้ใช้เพื่อตรวจสอบและเตรียมข้อมูลภายในโรงพยาบาล ไม่ใช่ค่าทางการ ค่าทางการอ้างอิงจากระบบ HDC ของกระทรวง

## สรุปกฎการเขียน SQL

รายละเอียดเต็มอยู่ที่ [docs/query-style-guide.md](docs/query-style-guide.md) สรุปสาระสำคัญ:

- MySQL/MariaDB syntax ต้องรันได้บน MySQL 5.x เก่า: **ห้ามใช้ CTE (WITH) และ window functions** ใช้ derived table/subquery แทน
- พารามิเตอร์อยู่บนสุดของไฟล์ผ่าน `SET @start_date := '2025-10-01';` และ `SET @end_date := '2026-09-30';` (ตัวอย่างคือปีงบประมาณ 2569: 1 ต.ค. 2568 ถึง 30 ก.ย. 2569)
- ทุกค่าที่ต่างกันตามโรงพยาบาล ต้องมี comment `-- [ปรับตามโรงพยาบาล]` พร้อมคำอธิบาย
- ตาราง HOSxP ที่ใช้เป็นข้อเท็จจริงได้มีเฉพาะ: patient, ovst, ovstdiag, ipt, iptdiag, labs_head, lab_order, lab_items, spclty (ดู column whitelist ใน [docs/hosxp-basics.md](docs/hosxp-basics.md)) ตารางหรือ column อื่นทั้งหมดต้อง comment ว่า version-dependent และให้ผู้ใช้ตรวจด้วย DESCRIBE/SHOW COLUMNS ก่อน ห้ามเขียนชื่อตารางแปลก ๆ ราวกับว่ามีอยู่จริงแน่นอน
- ICD-10 ใน HOSxP มักเก็บแบบไม่มีจุด (O801 ไม่ใช่ O80.1) แต่บางที่ต่างไป ให้ match แบบทนทาน เช่น `REPLACE(icd10, '.', '') LIKE 'O60%'`
- `lab_order.lab_order_result` เป็น VARCHAR ต้องกรองด้วย `REGEXP '^[0-9]+([.][0-9]+)?$'` ก่อน `CAST(... AS DECIMAL(5,2))` (ใช้ `[.]` ห้ามใช้ `\.` เพราะ MySQL ตัด backslash ใน string ทำให้จุด match ทุกตัวอักษร)
- Principal diagnosis คือ `diagtype = '1'`
- ทุกไฟล์ .sql ต้องมี metadata header ตามแบบใน [templates/query-template.sql](templates/query-template.sql)

## เมื่อเพิ่ม query ใหม่

1. สร้างโฟลเดอร์ของตัวเองใต้หมวดที่ถูกต้อง เช่น `queries/ncd/<ชื่อ-query>/`
2. ในโฟลเดอร์ต้องมีอย่างน้อย 2 ไฟล์: `README.md` (นิยาม เงื่อนไข ข้อจำกัด วิธีปรับ) และ `hosxp.sql`
3. อัปเดต [docs/kpi-catalog.md](docs/kpi-catalog.md) ให้มีรายการ query ใหม่พร้อมสถานะทุกครั้ง
4. สถานะเริ่มต้นของ query ใหม่คือ draft จนกว่าจะมีโรงพยาบาลจริงยืนยันผลการทดสอบ

## ภาษาและโทน

- ภาษาไทยเป็นหลัก ศัพท์เทคนิคภาษาอังกฤษคงไว้เป็นอังกฤษ (query, join, subquery)
- ประโยคสั้น ตรงประเด็น เขียนให้เจ้าหน้าที่ IT โรงพยาบาลที่รู้ SQL พื้นฐานอ่านเข้าใจ
- emoji ใช้น้อยที่สุด อนุญาตเฉพาะหัวข้อใน README และ catalog

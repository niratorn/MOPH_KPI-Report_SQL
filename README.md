# MOPH KPI Report SQL : ชุมชนแบ่งปัน SQL Query ตัวชี้วัดกระทรวงสาธารณสุข

repo นี้คือชุมชนของเจ้าหน้าที่ IT หน่วยบริการสุขภาพ (โรงพยาบาล, รพ.สต.) ที่ช่วยกันเขียน แบ่งปัน และตรวจทาน SQL query สำหรับตัวชี้วัด (KPI) ของกระทรวงสาธารณสุข โดยเน้นระบบ HIS หลักคือ HOSxP (MySQL/MariaDB) เป้าหมายคือให้เจ้าหน้าที่หน้างานไม่ต้องเขียน query ตัวเดียวกันซ้ำกันเองทุกโรงพยาบาล ลดเวลาที่เสียไปกับการเตรียมข้อมูลและตรวจสอบข้อมูลย้อนหลัง แล้วเอาเวลาไปพัฒนาคุณภาพข้อมูลจริง

## About (English)

This is a community-maintained collection of SQL queries for Thai Ministry of Public Health (MOPH) KPIs. It targets primarily the HOSxP hospital information system (MySQL/MariaDB) used across Thai public hospitals and health centers. The goal is simple: frontline and IT staff at each health unit should stop rewriting the same KPI queries from scratch. Queries here are drafts for internal data preparation and audit, not a source of official values; official KPI values come from the ministry's HDC system.

## 🎯 ทำไมต้องมี repo นี้

- ทุกโรงพยาบาลเขียน query ตัวชี้วัดเดียวกันซ้ำกันเอง เสียเวลาเจ้าหน้าที่ IT ทั้งประเทศไปกับงานเดิม
- การตรวจสอบข้อมูลย้อนหลังกับ HDC ใช้เวลามาก เพราะไม่มี query กลางที่ช่วยไล่ดูข้อมูลระดับรายคนในโรงพยาบาลได้
- ภาระงาน quality metrics และ data collection ตกอยู่ที่เจ้าหน้าที่หน้างานที่ต้องทำงานประจำไปพร้อมกัน
- query ที่เขียนคนเดียว ไม่มีคนช่วยตรวจ มีโอกาสตีความนิยามตัวชี้วัดผิดโดยไม่รู้ตัว การแชร์และช่วยกัน review ช่วยลดความเสี่ยงนี้

## 📁 มีอะไรในนี้บ้าง

```
MOPH_KPI-Report_SQL/
├── README.md                 คุณอยู่ที่นี่
├── CONTRIBUTING.md           วิธีร่วมส่ง query และมาตรฐานการ review
├── CODE_OF_CONDUCT.md        ข้อตกลงการอยู่ร่วมกันในชุมชน
├── LICENSE                   MIT License
├── CLAUDE.md                 กติกาสำหรับ AI agent ที่ช่วยงานใน repo นี้
├── .github/                  template สำหรับ issue และ pull request
├── docs/
│   ├── kpi-catalog.md        รายการตัวชี้วัดทั้งหมดใน repo และสถานะ
│   ├── query-style-guide.md  มาตรฐานการเขียน SQL ของชุมชน
│   ├── hosxp-basics.md       โครงสร้างตาราง HOSxP ที่ใช้บ่อย
│   └── data-privacy.md       แนวปฏิบัติเรื่องข้อมูลส่วนบุคคล
├── templates/
│   └── query-template.sql    แม่แบบสำหรับเขียน query ใหม่
└── queries/
    ├── mch-anc/              อนามัยแม่และเด็ก, ฝากครรภ์
    ├── ncd/                  โรคไม่ติดต่อเรื้อรัง
    ├── cancer-screening/     มะเร็งและการคัดกรอง
    └── service-quality/      คุณภาพบริการ
```

ลิงก์ที่ใช้บ่อย:

- [docs/kpi-catalog.md](docs/kpi-catalog.md) : ดูว่ามี query ตัวชี้วัดอะไรบ้าง
- [docs/query-style-guide.md](docs/query-style-guide.md) : ก่อนเขียน query ใหม่ อ่านนี่ก่อน
- [docs/hosxp-basics.md](docs/hosxp-basics.md) : ตาราง HOSxP หลักที่ query ในชุมชนนี้ใช้
- [docs/data-privacy.md](docs/data-privacy.md) : ข้อควรระวังเรื่องข้อมูลผู้ป่วย
- [templates/query-template.sql](templates/query-template.sql) : แม่แบบ query พร้อม header
- [queries/README.md](queries/README.md) : โครงสร้างโฟลเดอร์ query และวิธีหา query ที่ต้องการ
- [CONTRIBUTING.md](CONTRIBUTING.md) : วิธีส่ง query เข้าชุมชน

## ✅ Query ที่พร้อมใช้

| ตัวชี้วัด | หมวด | สถานะ |
|---|---|---|
| [ภาวะโลหิตจางในหญิงตั้งครรภ์ที่มารับบริการฝากครรภ์ (maternal anemia)](queries/mch-anc/maternal-anemia/) | อนามัยแม่และเด็ก, ฝากครรภ์ | draft รอ community ช่วยทดสอบ |
| [ร้อยละการคลอดก่อนกำหนด (preterm delivery rate)](queries/mch-anc/preterm-birth/) | อนามัยแม่และเด็ก, ฝากครรภ์ | draft รอ community ช่วยทดสอบ |

นิยามและค่าเป้าหมายของตัวชี้วัดแต่ละตัว ให้ตรวจสอบจาก template ตัวชี้วัดของปีงบประมาณปัจจุบันใน HDC (https://hdcservice.moph.go.th) หรือ Health KPI กระทรวงสาธารณสุข (https://healthkpi.moph.go.th)

## 🛡️ วิธีใช้งาน query อย่างปลอดภัย

1. อ่าน README ของ query นั้นก่อนเสมอ เพื่อเข้าใจนิยาม เงื่อนไข และข้อจำกัด
2. ปรับพารามิเตอร์ทุกจุดที่ทำเครื่องหมาย `[ปรับตามโรงพยาบาล]` เช่น ช่วงวันที่ รหัส lab ของโรงพยาบาลตัวเอง
3. ทดสอบบน replica หรือรันในช่วงเวลาที่ระบบไม่ยุ่ง อย่ารัน query หนักบน production ช่วงเวลาให้บริการ
4. ใช้ DB user แบบ read-only (SELECT อย่างเดียว) ในการรัน query จาก repo นี้
5. ตรวจทานผลลัพธ์กับเจ้าหน้าที่หน้างานหรือผู้รับผิดชอบตัวชี้วัดก่อนนำไปใช้ทำรายงาน

## 🤝 ร่วมแบ่งปัน query

ทำได้ 3 ทาง:

1. **ขอ query ตัวชี้วัดที่ยังไม่มี** : เปิด issue ด้วยฟอร์ม ["ขอ Query ตัวชี้วัด"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=01-kpi-query-request.yml)
2. **แบ่งปัน query ที่ใช้อยู่แล้วในโรงพยาบาล** : เปิด issue ด้วยฟอร์ม ["แบ่งปัน Query (ไม่ต้องใช้ git)"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) ไม่ต้องรู้วิธีใช้ git ก็ส่งได้
3. **ส่ง Pull Request** : สำหรับคนที่ใช้ git เป็น อ่านขั้นตอนและมาตรฐานได้ที่ [CONTRIBUTING.md](CONTRIBUTING.md)

พบปัญหาใน query ที่มีอยู่แล้ว เปิด issue ด้วยฟอร์ม ["รายงานปัญหา Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=02-query-problem.yml) ได้เลย

## 🔒 ข้อมูลส่วนบุคคล

query ใน repo นี้ดึงข้อมูลระดับรายบุคคลจากฐานข้อมูลโรงพยาบาล ผลลัพธ์จึงเป็นข้อมูลส่วนบุคคลตาม พ.ร.บ.คุ้มครองข้อมูลส่วนบุคคล พ.ศ. 2562 ห้ามนำผลลัพธ์จริงมาแชร์ใน repo หรือใน issue เด็ดขาด อ่านแนวปฏิบัติฉบับเต็มที่ [docs/data-privacy.md](docs/data-privacy.md)

## ⚠️ ข้อจำกัดความรับผิดชอบ (Disclaimer)

- query ในชุมชนนี้เป็นเครื่องมือสำหรับตรวจสอบและเตรียมข้อมูลภายในโรงพยาบาลเท่านั้น ไม่ใช่ค่าทางการ
- ค่าทางการของตัวชี้วัดอ้างอิงจากระบบ HDC (https://hdcservice.moph.go.th) ของกระทรวงสาธารณสุข
- ผลลัพธ์ที่ได้ขึ้นกับคุณภาพการบันทึกข้อมูลของแต่ละแห่ง ตัวเลขที่ต่างจาก HDC ไม่ได้แปลว่า query ผิดเสมอไป ต้องไล่ตรวจสอบทั้งสองฝั่ง
- repo นี้ไม่ใช่เครื่องมือวินิจฉัยทางการแพทย์ และไม่ใช้แทนดุลยพินิจของบุคลากรทางการแพทย์

## License

โครงการนี้ใช้ [MIT License](LICENSE) นำไปใช้ ดัดแปลง และแจกจ่ายต่อได้อย่างอิสระ

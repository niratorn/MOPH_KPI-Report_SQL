# โฟลเดอร์ queries

โฟลเดอร์นี้เก็บ SQL query ทั้งหมดของชุมชน จัดโครงสร้างเป็น:

```
queries/<หมวด>/<ชื่อ query>/
├── README.md    นิยาม เงื่อนไข วิธีใช้ ข้อจำกัด
└── hosxp.sql    query สำหรับ HOSxP (MySQL/MariaDB)
```

ทุก query folder ต้องมี README.md คู่กับ hosxp.sql เสมอ ก่อนเขียนหรือแก้ query อ่าน [docs/query-style-guide.md](../docs/query-style-guide.md) ก่อน

ดูภาพรวมว่าตัวชี้วัดไหนมี query แล้ว ตัวไหนยังรอผู้แบ่งปัน ได้ที่ [docs/kpi-catalog.md](../docs/kpi-catalog.md)

## หมวดปัจจุบัน

| โฟลเดอร์ | หมวด |
|---|---|
| [mch-anc/](mch-anc/) | อนามัยแม่และเด็ก |
| [ncd/](ncd/) | โรคไม่ติดต่อเรื้อรัง (NCD) |
| [cancer-screening/](cancer-screening/) | มะเร็งและการคัดกรอง |
| [service-quality/](service-quality/) | คุณภาพบริการ |

ผลจาก query เหล่านี้ใช้เพื่อตรวจสอบและเตรียมข้อมูลภายในโรงพยาบาลเท่านั้น ไม่ใช่ค่าทางการ ค่าทางการอ้างอิงจากระบบ HDC ของกระทรวง

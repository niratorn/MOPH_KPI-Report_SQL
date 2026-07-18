# 📋 KPI Catalog: รายการตัวชี้วัดในชุมชน

หน้านี้รวบรวมตัวชี้วัดที่ชุมชนมี query แล้ว และตัวชี้วัดที่ยังรอผู้แบ่งปัน

**หมายเหตุสำคัญ**

- รายการนี้เป็นเพียงจุดเริ่มต้น ไม่ใช่รายการตัวชี้วัดทั้งหมดของกระทรวง เพิ่มหัวข้อใหม่ได้โดยเปิด issue ["ขอ Query ตัวชี้วัด"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=01-kpi-query-request.yml)
- นิยามทางการและค่าเป้าหมายของแต่ละตัวชี้วัด ให้ยึด template ตัวชี้วัดของปีงบประมาณปัจจุบันจาก [HDC](https://hdcservice.moph.go.th) หรือ [Health KPI กระทรวงสาธารณสุข](https://healthkpi.moph.go.th) เสมอ
- query ในชุมชนนี้ใช้เพื่อตรวจสอบและเตรียมข้อมูลภายในโรงพยาบาลเท่านั้น ไม่ใช่ค่าทางการ ค่าทางการอ้างอิงจากระบบ HDC ของกระทรวง

สถานะที่ใช้ในตาราง

| สถานะ | ความหมาย |
|---|---|
| มีแล้ว (draft) | มี query ใน repo แล้ว แต่ยังรอ community ช่วยทดสอบกับข้อมูลจริง |
| ยังไม่มี รอผู้แบ่งปัน | ยังไม่มี query ใครมีอยู่แล้วช่วยแบ่งปันได้เลย |

## 🤰 อนามัยแม่และเด็ก (mch-anc)

| ตัวชี้วัด | สถานะ | ที่อยู่ |
|---|---|---|
| ภาวะโลหิตจางในหญิงตั้งครรภ์ที่มารับบริการฝากครรภ์ (maternal anemia) | มีแล้ว (draft) | [queries/mch-anc/maternal-anemia/](../queries/mch-anc/maternal-anemia/) |
| ร้อยละการคลอดก่อนกำหนด (preterm delivery rate) | มีแล้ว (draft) | [queries/mch-anc/preterm-birth/](../queries/mch-anc/preterm-birth/) |
| ฝากครรภ์ครั้งแรกก่อน 12 สัปดาห์ | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| ฝากครรภ์ครบ 5 ครั้งตามเกณฑ์ | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| ทารกแรกเกิดน้ำหนักน้อยกว่า 2,500 กรัม | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |

## 💉 NCD (ncd)

| ตัวชี้วัด | สถานะ | ที่อยู่ |
|---|---|---|
| ผู้ป่วยเบาหวานควบคุมระดับน้ำตาลได้ดี (HbA1c) | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| ผู้ป่วยความดันโลหิตสูงควบคุมความดันได้ดี | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| การคัดกรองภาวะแทรกซ้อนทางไต (CKD) ในผู้ป่วยเบาหวาน | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |

## 🎗️ มะเร็งและการคัดกรอง (cancer-screening)

| ตัวชี้วัด | สถานะ | ที่อยู่ |
|---|---|---|
| คัดกรองมะเร็งปากมดลูก | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| คัดกรองมะเร็งลำไส้ใหญ่ | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| คัดกรองมะเร็งเต้านม | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |

## 🏥 คุณภาพบริการ (service-quality)

| ตัวชี้วัด | สถานะ | ที่อยู่ |
|---|---|---|
| อัตราตายผู้ป่วย sepsis | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| การเข้าถึงบริการ stroke fast track | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| ความสมบูรณ์ของเวชระเบียน | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |
| การใช้ยาอย่างสมเหตุผล (RDU) | ยังไม่มี รอผู้แบ่งปัน | [เปิด issue "แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) |

## อยากช่วยเติมรายการนี้?

- มี query อยู่แล้วในโรงพยาบาล: เปิด issue ["แบ่งปัน Query"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=03-share-query.yml) หรือส่ง PR ตามขั้นตอนใน [CONTRIBUTING.md](../CONTRIBUTING.md)
- อยากได้ query ตัวใหม่: เปิด issue ["ขอ Query ตัวชี้วัด"](https://github.com/niratorn/MOPH_KPI-Report_SQL/issues/new?template=01-kpi-query-request.yml)
- ก่อนเขียน query ใหม่ อ่าน [query-style-guide.md](query-style-guide.md) และใช้ [templates/query-template.sql](../templates/query-template.sql)

# Huong Dan Giang Vien Cho NB01 - Task Checklist

> **Cap nhat 2026-07-22:** file nay da duoc sap xep lai theo dung 9 muc trong phan checklist NB01 cua `docs/Task Checklist for Each Notebook.docx` (ban thay update ngay 2026-07-22), de doi chieu voi notebook cho de.
>
> Thay doi so voi ban 2026-07-20: bo sung **Muc VI. Khao sat du lieu cua bang phu** (muc moi thay them, ban cu chua co) va cap nhat lai phan doi chieu voi NB01 hien tai.

## Nguon

- File checklist: `docs/Task Checklist for Each Notebook.docx`, phan `NOTEBOOK 01: DATA UNDERSTANDING`.
- Clip: [Task Checklist for Each Notebook](https://youtu.be/87Eai12Bd_0?si=0IA37d19_9ytAaiB).
- Doi chieu thuc te: `notebooks/01_data_understanding.ipynb`.

## Muc tieu cua NB01 (theo thay)

Hieu bai toan va bo du lieu, danh gia chat luong du lieu, xac dinh cau truc du lieu va chuan bi cho cac buoc xu ly tiep theo.

NB01 khong phai notebook doc CSV roi in thong tin. Day la buoc dat nen mong: nhan dien som cac van de du lieu de NB02/NB03/NB04/NB05 xu ly, va chuan bi cho database o NB02.

## Muc I. Hieu bai toan

- Gioi thieu bai toan AI can giai quyet.
- Bien muc tieu (Target).

Ap dung cho Home Credit:

- Bai toan: du bao rui ro khach hang vay von.
- Target: `TARGET`; `1` = khach gap kho khan tra no, `0` = tra no binh thuong.
- Dang bai toan: phan loai nhi phan co giam sat.

## Muc II. Tim hieu Dataset

- Mo ta Dataset, danh sach cac file du lieu.
- Data Dictionary (mo ta cac cot quan trong).
- Neu dataset co nhieu bang: xac dinh **bang chinh** (Main/Fact Table), **cac bang phu** (Dimension/Transaction), vai tro tung bang.
- Xac dinh **muc du lieu (Grain)**. Thay lay vi du: Rossmann = 1 dong 1 cua hang 1 ngay; **Home Credit = 1 dong 1 khach hang**.

Ap dung cho Home Credit:

- `application_train`: bang chinh vi co `TARGET`.
- `application_test`: ho so can du doan, khong co `TARGET`.
- `bureau`, `bureau_balance`: lich su tin dung tai to chuc khac.
- `previous_application`: cac khoan vay truoc tai Home Credit.
- `installments_payments`, `POS_CASH_balance`, `credit_card_balance`: lich su thanh toan/du no cua cac khoan vay truoc.
- Can noi ro cac bang phu la quan he 1-n voi khach hang, khong join truc tiep duoc neu chua aggregate.

## Muc III. Khao sat du lieu cua bang chinh

1. **Doc du lieu:** doc file CSV, hien thi vai dong dau (`head()`).
2. **Kich thuoc du lieu:** so dong, so cot, bo nho su dung.
3. **Khao sat cau truc:** danh sach cot, kieu du lieu (`info()`), thong ke kieu du lieu, `nunique()`, ty le gia tri khac nhau (Unique Ratio).
4. **Thong ke mo ta:** `describe()` - Count, Mean, Median, Std, Min, Max, cac phan vi 25/50/75%.

Ap dung cho Home Credit:

- Khong in tran lan 122 cot cua `application_train`. Nen tom tat theo nhom cot: ID, target, nhan khau, tai chinh, `DAYS_*`, `EXT_SOURCE_*`, category.
- Dung Min/Median/Max de phat hien bat thuong som - day la diem thay nhan manh trong clip.

## Muc IV. Kiem tra chat luong du lieu cua bang chinh

1. **Missing Values:** so luong va ty le (%).
2. **Duplicate:** kiem tra ban ghi trung.
3. **Gia tri sai logic (bat thuong):** gia tri am vo ly, ngoai pham vi, khong hop le.

Ap dung cho Home Credit:

- `DAYS_EMPLOYED = 365243` (~1000 nam) la ma dac biet, ghi nhan de NB03 xu ly.
- `CODE_GENDER = XNA` la gia tri khong hop le.
- `DAYS_BIRTH` nen doi sang tuoi khi dien giai.
- Duplicate: kiem tra ca trung toan dong lan trung theo `SK_ID_CURR`.

Luu y: NB01 chi **phat hien va dat van de**, khong bien thanh notebook cleaning.

## Muc V. Khao sat cac nhom du lieu cua bang chinh

- **Numeric:** thong ke mo ta, histogram neu can.
- **Category:** `value_counts()`, so luong nhom, bar chart neu can.
- **Date:** Min Date, Max Date, khoang thoi gian, so ngay.
- **Target:** phan bo Target, missing cua Target, histogram/boxplot don gian.

Ap dung cho Home Credit:

- Bo du lieu nay **khong co cot ngay thang that**. Moi cot `DAYS_*` la so nguyen am dem lui tu ngay nop ho so, nen phan "Date" xu ly nhu numeric va giai thich quy uoc dau am.
- Voi dataset nhieu cot, chi chon nhom/cot co y nghia, khong `value_counts()` tat ca cot category mot cach may moc.

## Muc VI. Khao sat du lieu cua bang phu

> Day la muc **thay moi them** trong ban checklist cap nhat. NB01 hien tai cua nhom chua co muc nay.

Sau y thay yeu cau, ap dung cho tung bang phu:

1. Xem du lieu va cac cot.
2. Xem kieu du lieu.
3. Thong ke mo ta.
4. Kiem tra Missing Values & Duplicates.
5. Phan tich cac cot phan loai.
6. Xem thong tin bo nho - Memory.

Ap dung cho Home Credit - **luu y ve khoi luong**:

- Co 6 bang phu, neu lam day du 6 y cho ca 6 bang thi notebook se rat dai va lap lai.
- Nen viet **mot ham dung chung** nhan ten bang roi tra ve 6 thong tin tren, sau do goi cho tung bang va trinh bay o dang bang tong hop. Cach nay vua du y thay vua khong lam notebook phinh to.
- Uu tien phan tich sau hon cho cac bang co anh huong lon: `bureau` (lich su tin dung ben ngoai) va `previous_application` (lich su vay tai Home Credit).
- Voi bang lon nhu `bureau_balance` (27,3 trieu dong) va `installments_payments` (13,6 trieu dong), can can nhac doc theo chunk hoac chi doc cac cot can thiet de khong het RAM.
- Phan "cot phan loai" dang chu y: `credit_active` trong `bureau`, `name_contract_status` trong `previous_application`/`pos_cash_balance`/`credit_card_balance`.

## Muc VII. Kiem tra quan he giua cac bang (neu co)

- **Primary Key:** co trung khoa chinh khong?
- **Foreign Key:** co khoa ngoai bi thieu khong?
- **Kiem tra Join:** join duoc khong, co mat du lieu khong?
- Quan he giua cac bang: 1-1, 1-N hay N-N.

Ap dung cho Home Credit:

- `SK_ID_CURR`: khoa noi bang chinh voi cac bang o cap khach hang.
- `SK_ID_BUREAU`: khoa noi `bureau` voi `bureau_balance`.
- `SK_ID_PREV`: khoa noi `previous_application` voi `installments_payments`, `POS_CASH_balance`, `credit_card_balance`.
- Can canh bao **row explosion**: bang 1-n phai aggregate ve 1 dong moi `SK_ID_CURR` truoc khi join vao bang chinh.
- Y "co khoa ngoai bi thieu khong" rat dang lam that o day. Khi lam NB02 da do duoc: moi quan he deu co ban ghi mo coi, vi du `bureau` co 42.320 khach khong nam trong `application_train` (ho thuoc `application_test`). Day la ly do NB02 khong khai bao duoc `FOREIGN KEY`.

## Muc VIII. Danh gia so bo

- Nhung cot duoc gia dinh la quan trong (dua tren muc tieu bai toan va Data Dictionary).
- Nhung cot co nhieu Missing.
- Nhung cot can xu ly.
- Nhung cot can Feature Engineering.

Thay ghi ro: day chi la **danh gia ban dau**, chua phai ket luan cuoi cung; cac gia thuyet se duoc kiem chung o NB04 (EDA) va NB05 (Feature Engineering).

## Muc IX. Ket luan

> Trong file goc muc nay bi danh nham la `IV. Ket luan`.

Vi du thay dua ra:

- Dataset co bao nhieu ban ghi.
- Co bao nhieu bang.
- Co Missing hay khong.
- Co Duplicate hay khong.
- Du lieu da san sang de dua vao PostgreSQL.

## Bon cau hoi cot loi NB01 phai tra loi

Trich nguyen van tu file thay:

1. **Du lieu dang co la gi?** (Business & Data Understanding)
2. **Du lieu co dang tin cay khong?** (Data Quality Assessment)
3. **Du lieu duoc to chuc va lien ket nhu the nao?** (Structure, Keys & Relationships)
4. **Can chuan bi gi cho cac buoc tiep theo?** (Pipeline Planning)

## Cac diem can tranh khi sua NB01

- Khong bien NB01 thanh notebook cleaning/modeling.
- Khong phan tich tung cot mot cach may moc voi dataset 122+ cot.
- Khong copy nguyen vi du Rossmann/Sales cua thay vao Home Credit; phai doi sang ngon ngu rui ro tin dung.
- Khong xoa cot/ket luan cot vo dung ngay trong NB01 neu chua co bang chung.
- Khong join truc tiep bang phu 1-n vao bang chinh trong NB01.
- Khong viet markdown dai truoc code. Theo feedback ngay 2026-07-18, markdown truoc code chi dan ngan gon; nhan xet/kien giai dat sau output.

## Doi chieu voi NB01 hien tai cua nhom

NB01 hien co 8 muc lon:

| Muc trong NB01 | Muc checklist tuong ung |
|---|---|
| 1. Muc tieu notebook | Muc tieu |
| 2. Bai toan va bien muc tieu | I |
| 3. Ban do dataset Home Credit | II |
| 4. Khao sat bang chinh `application_train` | III |
| 5. Chat luong du lieu ban dau | IV |
| 6. Bang phu, khoa noi va rui ro row explosion | VII (mot phan II) |
| 7. Bieu do va tuong quan ban dau voi `TARGET` | V |
| 8. Tong ket | VIII + IX |

**Viec can lam:** NB01 chua co **Muc VI. Khao sat du lieu cua bang phu**. Muc 6 hien tai chi noi ve khoa noi va row explosion, chua khao sat du lieu ben trong tung bang phu theo 6 y cua thay.

De xuat: them mot muc rieng cho phan khao sat bang phu, dat truoc phan khoa noi/quan he, dung ham dung chung nhu goi y o Muc VI ben tren. Day nen la mot task rieng, khong gop vao PR dang lam.

## Hai loi danh so trong file checklist goc - nen hoi lai thay

- Muc `VI. Khao sat du lieu cua bang phu aaa`: chu `aaa` la **cho trong de dien ten bang phu**, khong phai loi go. Y thay la lam muc nay cho tung bang phu cu the.
- NB01 ket thuc bang `IV. Ket luan`, dang le la `IX`.

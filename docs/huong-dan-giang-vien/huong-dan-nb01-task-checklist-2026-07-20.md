# Huong Dan Giang Vien Cho NB01 - Task Checklist

> Ghi chu nay tong hop rieng phan Notebook 01 tu file `docs/Task Checklist for Each Notebook.docx` va clip YouTube "Task Checklist for Each Notebook" cua kenh Thay Long Web.
> Muc dich: giup nhom va AI Agent hieu dung y thay khi ra soat/sua `notebooks/01_data_understanding.ipynb`.

## Nguon

- File checklist: `docs/Task Checklist for Each Notebook.docx`.
- Clip: [Task Checklist for Each Notebook](https://youtu.be/87Eai12Bd_0?si=0IA37d19_9ytAaiB).
- Tom tat clip do Hung cung cap ngay 2026-07-20; chua co transcript chinh thuc day du.

## Vai tro cua NB01

NB01 khong chi la notebook doc CSV va in thong tin ban dau. Theo y thay, NB01 la buoc dat nen mong cho toan bo du an:

- Hieu bai toan AI can giai quyet.
- Hieu dataset dang co nhung bang nao, bang nao la bang chinh, bang nao la bang phu.
- Danh gia chat luong va cau truc du lieu ban dau.
- Nhan dien som cac van de du lieu de chuyen sang NB02/NB03/NB04/NB05 xu ly/kiem chung.
- Chuan bi cho pipeline tiep theo, dac biet la database va quan he khoa.

## Cac muc thay nhan manh cho NB01

### 1. Gioi thieu bai toan va bien muc tieu

NB01 phai mo dau bang viec noi ro:

- Du an giai quyet bai toan gi.
- Muc tieu cuoi cung cua du an la gi.
- Bien muc tieu/target variable la cot nao.
- Bai toan thuoc loai nao trong Machine Learning.

Ap dung cho Home Credit:

- Bai toan: du doan rui ro khach hang vay von/default risk.
- Target: `TARGET`.
- `TARGET = 1`: khach hang gap kho khan tra no/default.
- `TARGET = 0`: khach hang tra no binh thuong.
- Dang bai toan: phan loai nhi phan co giam sat.

### 2. Mo ta dataset, bang chinh va bang phu

NB01 can mo ta dataset thay vi chi liet ke file. Can lam ro:

- Dataset gom nhung file/bang nao.
- Bang nao la bang chinh/main table/fact table.
- Bang nao la bang phu/dimension/transaction/history table.
- Vai tro nghiep vu cua tung bang.
- Grain cua tung bang: mot dong dai dien cho cai gi.

Ap dung cho Home Credit:

- `application_train`: bang chinh vi co `TARGET`.
- `application_test`: bang ho so can du doan, khong co `TARGET`.
- `bureau`, `bureau_balance`: lich su tin dung tu to chuc khac.
- `previous_application`: cac khoan vay truoc tai Home Credit.
- `installments_payments`, `POS_CASH_balance`, `credit_card_balance`: lich su thanh toan/du no/giao dich lien quan cac khoan vay truoc.
- Can noi ro cac bang phu thuong la quan he 1-n voi khach hang, khong the join truc tiep neu chua aggregate.

### 3. Khao sat cau truc bang chinh

Thay nhac cac thao tac nen co voi bang chinh:

- Doc du lieu.
- Xem mot vai dong dau (`head()`).
- Kiem tra so dong, so cot.
- Kiem tra bo nho su dung.
- Kiem tra danh sach cot va kieu du lieu bang `info()`.
- Thong ke mo ta bang `describe()`.
- Xem so luong gia tri khac nhau (`nunique()`) va ty le unique neu can.

Ap dung cho Home Credit:

- Khong nen in tran lan 122 cot cua `application_train`.
- Nen tom tat theo nhom cot: ID, target, thong tin nhan khau, thong tin tai chinh, cac cot `DAYS_*`, cac diem ngoai `EXT_SOURCE_*`, bien category.
- Neu in danh sach cot, nen in co chon loc hoac chia nhom de nguoi doc khong bi ngop.

### 4. Dung Min/Median/Max de phat hien bat thuong som

Trong clip, thay nhan manh viec quan sat cac gia tri nhu Min, Median, Max de nhin ra outlier/bat thuong ngay tu dau.

Ap dung cho Home Credit:

- `DAYS_EMPLOYED = 365243` la ma bat thuong can ghi nhan de NB03 xu ly.
- `DAYS_BIRTH` nen doi sang tuoi khi dien giai de nguoi doc de hieu.
- Cac cot tien nhu `AMT_INCOME_TOTAL`, `AMT_CREDIT`, `AMT_ANNUITY` can xem min/median/max de phat hien gia tri qua lon/qua nho.
- Cac gia tri category hiem/khong hop le nhu `CODE_GENDER = XNA` can duoc ghi nhan.

Luu y: NB01 chi phat hien va dat van de. Khong nen bien NB01 thanh notebook cleaning sau.

### 5. Kiem tra chat luong du lieu ban dau

Checklist va clip nhac 3 nhom kiem tra chinh:

- Missing values: so luong va ty le thieu.
- Duplicate: trung dong hoac trung khoa chinh.
- Gia tri bat thuong/sai logic nghiep vu.

Ap dung cho Home Credit:

- Thong ke cac cot missing cao trong `application_train`.
- Kiem tra duplicate toan dong va duplicate theo `SK_ID_CURR`.
- Kiem tra phan bo `TARGET` de thay mat can bang lop.
- Ghi lai cac van de nghi ngo de NB03 lam sach va NB04/NB05 kiem chung tiep.

### 6. Khao sat du lieu theo nhom

Thay goi y:

- Numeric: histogram/describe.
- Category: `value_counts()`.
- Date/time: min, max, khoang thoi gian neu dataset co cot thoi gian.
- Target: phan bo target, missing target, histogram/boxplot don gian neu phu hop.

Ap dung cho Home Credit:

- Numeric: tuoi, thu nhap, khoan vay, annuity, cac bien ngay dang `DAYS_*`.
- Category: gioi tinh, loai hop dong, trinh do hoc van, tinh trang hon nhan, nghe nghiep.
- Target: ty le `0/1`, nhan manh bai toan mat can bang lop.
- Voi dataset nhieu cot, chi chon nhom/cot co y nghia, khong value_counts tat ca cot category mot cach may moc.

### 7. Kiem tra khoa chinh, khoa ngoai va quan he bang

NB01 can chuan bi cho NB02 bang cach chi ra quan he du lieu:

- Khoa chinh co trung khong.
- Khoa ngoai co bi thieu khong.
- Join co lam mat du lieu khong.
- Quan he giua cac bang la 1-1, 1-n hay n-n.

Ap dung cho Home Credit:

- `SK_ID_CURR`: khoa noi bang chinh voi cac bang o cap khach hang/khoan vay.
- `SK_ID_BUREAU`: khoa noi `bureau` voi `bureau_balance`.
- `SK_ID_PREV`: khoa noi `previous_application` voi `installments_payments`, `POS_CASH_balance`, `credit_card_balance`.
- Can canh bao row explosion: voi bang 1-n, phai aggregate ve 1 dong moi `SK_ID_CURR` truoc khi join vao bang chinh.

### 8. Danh gia so bo va chuan bi buoc tiep theo

Cuoi NB01 can co phan danh gia so bo:

- Dataset co bao nhieu bang, bang chinh co bao nhieu dong/cot.
- Du lieu co missing/duplicate/bat thuong khong.
- Cac cot/nhom cot nao duoc gia dinh la quan trong.
- Cac cot/nhom bang nao can cleaning.
- Cac bang phu nao co tiem nang feature engineering.
- Du lieu da san sang dua vao PostgreSQL/NB02 chua.

## Bon cau hoi cot loi NB01 phai tra loi

NB01 dat yeu cau neu nguoi doc tra loi duoc:

1. Du lieu dang co la gi?
2. Du lieu co dang tin cay khong?
3. Du lieu duoc to chuc va lien ket nhu the nao?
4. Can chuan bi gi cho cac buoc tiep theo?

## Cac diem can tranh khi sua NB01

- Khong bien NB01 thanh notebook cleaning/modeling.
- Khong phan tich tung cot mot cach may moc voi dataset 122+ cot.
- Khong copy nguyen vi du Rossmann/Sales cua thay vao Home Credit; phai doi sang ngon ngu rui ro tin dung.
- Khong xoa cot/ket luan cot vo dung ngay trong NB01 neu chua co bang chung.
- Khong join truc tiep bang phu 1-n vao bang chinh trong NB01.
- Khong viet markdown dai truoc code. Theo feedback ngay 2026-07-18, markdown truoc code chi nen dan ngan gon; nhan xet/kien giai dat sau output.

## Doi chieu voi NB01 hien tai cua nhom

NB01 hien tai nhin chung da dung khung lon cua thay:

- Co bieu dat bai toan va target.
- Co ban do du lieu/cac bang.
- Co phan bang trung tam `application_train`.
- Co phan bang phu va quan he khoa.
- Co tu dien du lieu.
- Co thach thuc du lieu va tong ket.

Khi ra soat tiep, uu tien kiem tra ky:

- Phan min/median/max da chi ra du cac bat thuong quan trong chua.
- Phan logic nghiep vu co noi ro cac van de Home Credit thay vi vi du Sales/Rossmann chua.
- Phan khoa chinh/khoa ngoai da dan ro sang NB02/PostgreSQL va canh bao row explosion chua.
- Phan tong ket co tra loi du 4 cau hoi cot loi cua NB01 chua.

# Huong dan NB03 - Data Cleaning

> Tom tat phan checklist NB03 trong `docs/Task Checklist for Each Notebook.docx` (ban thay update 2026-07-22), kem cach ap dung cho bo Home Credit.
>
> Viet TRUOC khi lam NB03, dua tren file checklist chinh thuc chu khong dua vao tri nho. Khi lam xong NB03 nen quay lai bo sung phan "nhom da lam khac huong dan o dau va vi sao".

## Nguon

- File checklist: `docs/Task Checklist for Each Notebook.docx`, phan `NOTEBOOK 03: DATA CLEANING`.
- Dau vao thuc te: bang `application_flat` trong PostgreSQL do NB02 tao ra (307.511 dong x 148 cot).

## Vai tro cua NB03

Bien du lieu sau khi tich hop tu PostgreSQL thanh du lieu sach, nhat quan va san sang cho EDA.

Thay dinh nghia "sach" gom bon y: khong con thieu, khong con trung lap, khong co sai logic, du va ro nghia.

Pipeline thay dua ra:

```
Read SQL -> Missing Values -> Duplicate -> Outlier -> Logic Validation -> Save Clean Data -> Notebook 04 (EDA)
```

## Muc I. Gioi thieu

Neu ro muc tieu notebook, vai tro cua Data Cleaning trong quy trinh AI, va so do pipeline xu ly du lieu o tren.

## Muc II. Doc du lieu

- **Doc tu PostgreSQL bang `pd.read_sql()`, KHONG doc lai CSV.** Day la yeu cau ro rang, lap lai o ca cau hoi cot loi cua NB02.
- Kiem tra so dong, so cot, xem `head()`.

Ap dung cho Home Credit: doc bang `application_flat`, ky vong **307.511 dong x 148 cot**. Ket noi dung `psycopg2` + `.env` nhu Muc 8 cua NB02.

## Muc III. Lam sach du lieu

### 1. Xu ly Missing Values

Cac cach thay liet ke: Median, Mean, Mode, Unknown, xoa cot, xoa dong.

> **Quan trong nhat trong ca muc nay:** thay nhan manh *"can giai thich vi sao chon phuong phap do"* va *"them markdown giai thich lua chon"*. Diem nam o phan giai trinh, khong nam o dong code.

**Bay lon nhat voi Home Credit - doc ky truoc khi dien gia tri:**

Nhom cot `credit_card_*` co **220.606 dong `NULL` (71,7%)** vi chi 86.905 tren 307.511 khach tung co du lieu the tin dung. Day la **tin hieu that** (khach khong co the tin dung), KHONG phai du lieu bi mat. Dien median/mean vao day la bia ra mot lich su the tin dung khong ton tai, va lam mat luon mot dac trung co that.

Cac nhom cot summary khac cung co `NULL` vi ly do tuong tu, so lieu do o Muc 7.3 cua NB02:

| Nhom cot | So dong NULL | Ty le |
|---|---|---|
| `credit_card_*` | 220.606 | 71,7% |
| `bureau_*` | 44.020 | 14,3% |
| `pos_cash_*` | 18.067 | 5,9% |
| `previous_*` | 16.454 | 5,4% |
| `installments_*` | 15.868 | 5,2% |

Huong xu ly hop ly hon: voi cot dem (`*_count`) dien `0` vi khach that su co 0 khoan vay; voi cot tien/ngay can can nhac them mot cot co (flag) danh dau "khong co lich su" thay vi dien gia tri gia.

### 2. Xu ly Duplicate

- Xoa duplicate neu can.
- **Bao so luong ban ghi bi loai bo va con lai.**

Ap dung cho Home Credit: NB01 da kiem tra ca 6 bang phu deu co **0 dong trung**, va `application_flat` co khoa duy nhat tren `sk_id_curr` nen ve ly thuyet khong con trung. Van nen chay kiem tra de xac nhan thay vi gia dinh.

### 3. Xu ly Outlier

- Phat hien bang **IQR hoac Z-score**.
- **Truc quan Before va After.**
- Thay luu y ro: *"Khong phai Outlier nao cung nen xoa. Vi du doanh so cao ngay le thuong la du lieu dung."*

Ap dung cho Home Credit: cac cot tien lech phai rat nang, `AMT_CREDIT_SUM` co gia tri lon nhat gap khoang **4.661 lan trung vi**. Phan lon day la khach vay lon co that chu khong phai loi nhap lieu, nen huong xu ly nen la bien doi log hoac cap theo phan vi, khong xoa dong.

### 4. Xu ly du lieu sai logic (bat thuong)

Vi du thay dua ra: gia tri am vo ly, ngoai pham vi, khong hop le. Cach xu ly: xoa dong hoac dien lai gia tri hop ly tuy bai toan.

Ba truong hop da xac dinh duoc o Home Credit:

| Cot | Van de | Ghi nhan tai |
|---|---|---|
| `AMT_CREDIT_SUM_DEBT` | co gia tri am toi `-4.705.600`, du no khong the am | NB01 muc 7 |
| `DAYS_EMPLOYED` | gia tri `365243` tuong duong khoang 1000 nam, la ma dac biet | NB01 muc 4 |
| `CODE_GENDER` | co gia tri `XNA` khong hop le | NB01 muc 4 |

## Muc V. Danh gia sau Cleaning

> File goc nhay tu muc `III` sang `V`, khong co muc `IV`.

Kiem tra lai sau khi xu ly: Shape, Missing, Duplicate, Data Type, Memory Usage.

Thay yeu cau **bang tong hop truoc va sau lam sach** gom cac hang: Rows, Columns, Missing, Duplicate, Outlier, Invalid Values.

Day cung la cau tra loi cho cau hoi cot loi so 3 *"chat luong du lieu da thay doi nhu the nao"*, nen bang nay bat buoc phai co.

## Muc VI. Luu du lieu

- **Luu du lieu da lam sach vao PostgreSQL.**
- Dat ten bang ro rang, vi du thay dua ra la `sales_cleaned`.

Ap dung cho Home Credit: dat ten `application_flat_cleaned` cho dong bo voi `application_flat` cua NB02.

## Muc VII. Ket luan

Vi du thay dua ra: da xu ly Missing, da loai bo Duplicate, da xu ly Outlier, da kiem tra Logic, du lieu san sang cho Notebook 04.

## Neu Dataset co nhieu bang

Thay bo sung ba y cho dataset nhieu bang nhu Home Credit:

1. **Cleaning theo tung bang**, khong chi cleaning bang chinh.
2. **Kiem tra khoa Join sau Cleaning:** co mat Foreign Key khong, co lam sai quan he giua cac bang khong.
3. **Kiem tra tinh nhat quan:** cleaning xong thi join thu lai xem co mat du lieu khong.

**Cach ap dung cho du an nay - can ghi ro trong notebook:** NB02 da gom 5 bang phu ve muc khach hang va ghep thanh `application_flat`, nen NB03 lam sach mot bang phang duy nhat thay vi lam sach lai tung bang raw. Ba y tren van duoc dap ung nhung theo cach khac:

- Y 1: cac cot cua tung bang phu deu da nam trong `application_flat` duoi dang nhom cot `bureau_*`, `previous_*`... nen cleaning theo **nhom cot** chinh la cleaning theo tung bang.
- Y 2 va 3: phep join da lam xong o NB02 va da duoc kiem chung o Muc 7 (so dong giu nguyen 307.511, so khach rieng biet bang so dong, so `NULL` khop so ky vong). Viec con lai cua NB03 la kiem tra **sau khi cleaning van con dung 307.511 dong va `sk_id_curr` khong trung**.

Neu chon lam sach tung bang raw truoc roi moi join thi phai lam lai toan bo NB02, nen huong tren hop ly hon. Du chon huong nao cung phai giai thich trong notebook.

## Neu Dataset co qua nhieu cot

Voi 148 cot, ap dung phan nay cua thay la bat buoc. Thay khuyen khong xu ly tung cot thu cong ma chia nhom:

1. **Chia theo kieu du lieu:** Numeric, Category, Date, ID, Text.
2. **Chia theo muc do Missing:** duoi 5%, 5-30%, tren 30%.
3. **Xu ly theo nhom:** Numeric → Median, Category → Mode, Datetime → Forward Fill, Text → Unknown. *"Khong viet hang tram dong code cho tung cot."*
4. **Loai bo cot khong can thiet:** cot hang so (constant), cot trung lap, unique ratio qua cao (ID thuan tuy), missing qua lon va khong co gia tri phan tich. Thay luu y: *"Khong xoa chi vi thieu nhieu, ma can xem xet y nghia nghiep vu."*
5. **Ghi lai Cleaning Rule** duoi dang bang: nhom cot → phuong phap.

Ap dung cho Home Credit:

- Nhom `credit_card_*` thieu 71,7% nhung **khong duoc xoa** theo quy tac "missing > 30% thi bo" - day dung la truong hop thay canh bao, thieu vi khach khong co the chu khong phai du lieu hong.
- Cap `REGION_RATING_CLIENT` va `REGION_RATING_CLIENT_W_CITY` co tuong quan `+0,95`, gan nhu trung lap - ung vien cho y "duplicate column". Ghi nhan o NB01 muc 6.
- Bo du lieu **khong co cot ngay thang that**, moi cot `DAYS_*` la so nguyen am dem lui, nen nhom "Date" thuc chat xu ly nhu Numeric. Khong ap dung Forward Fill.
- Bang Cleaning Rule chinh la cau tra loi cho cau hoi cot loi so 2 *"xu ly bang phuong phap nao va vi sao"*.

## Data Cleaning Pipeline day du thay de xuat

```
PostgreSQL -> Read SQL -> Quality Assessment -> Missing -> Duplicate
-> Invalid Values -> Outlier -> Logic Validation -> Data Type Standardization
-> Save Clean Table -> Notebook 04
```

So voi pipeline rut gon o Muc I, ban day du them ba buoc: **Quality Assessment** o dau, **Invalid Values** tach rieng khoi Logic Validation, va **Data Type Standardization** truoc khi luu.

## Bon cau hoi cot loi NB03 phai tra loi

1. **Du lieu dang gap nhung van de gi?** - Missing, Duplicate, kieu du lieu, gia tri khong hop le, Outlier, loi nghiep vu.
2. **Nhom da xu ly tung van de bang phuong phap nao va vi sao chon phuong phap do?** - Khong chi co code ma can giai thich ngan gon.
3. **Chat luong du lieu da thay doi nhu the nao sau khi lam sach?** - Co so sanh Before/After bang bang hoac bieu do.
4. **Du lieu da san sang cho EDA va Feature Engineering chua?** - Sau notebook nay cac notebook tiep theo chi lam viec voi bang da lam sach.

## Bay ky thuat da tung lam hong NB03 - phai tranh lap lai

Ba diem duoi day lay tu `PROJECT_CONTEXT.md` muc 3, deu la loi that nhom da dinh:

1. **pandas 3 bat Copy-on-Write nen `df['cot'].replace(..., inplace=True)` KHONG ghi duoc vao DataFrame goc.** Ban NB03 cu tung that bai am tham o dung hai buoc `DAYS_EMPLOYED = 365243` va `CODE_GENDER = XNA`. Dung phep gan tuong minh thay cho chained inplace.
2. **Dung `warnings.filterwarnings("ignore")` toan cuc** - chinh no da nuot `ChainedAssignmentError` khien loi tren khong lo ra. Chi tat rieng loai canh bao on ao.
3. **Them `assert` sau moi buoc bien doi quan trong** de loi phai no ra thay vi troi qua, va nho **Restart & Run All truoc khi commit**, kiem tra `execution_count` lien mach.

## Hai loi danh so trong file checklist goc - nen hoi lai thay

- Phan NB03 nhay tu muc `III` sang muc `V`, khong co muc `IV`.
- Phan NB01 ket thuc bang `IV. Ket luan`, dang le la `IX`.

Rieng chu `aaa` trong tieu de `VI. Khao sat du lieu cua bang phu aaa` **khong phai loi go** - do la cho trong de dien ten bang phu.

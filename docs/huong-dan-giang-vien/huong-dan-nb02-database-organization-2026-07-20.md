# Huong dan NB02 - Database Organization

> Tom tat checklist NB02 theo cach Hung va nhom on lai ngay 2026-07-20, dua tren huong dan/demo cua giang vien ve PostgreSQL, import du lieu va quan he bang.
> Day la nguon tham khao de lam NB02 sau dot reset pipeline; neu co transcript/checklist chinh thuc hon thi can doi chieu va cap nhat lai.

## 1. Muc tieu cua NB02

NB02 dung de bao cao cho hoi dong biet nhom da to chuc du lieu tho Home Credit vao database nhu the nao.

Notebook nay can lam ro:

- Du lieu Home Credit ban dau gom nhieu file CSV roi rac.
- Moi file CSV duoc dua thanh mot bang raw trong PostgreSQL.
- Nhom xac dinh duoc bang trung tam, bang phu va cac khoa noi.
- Nhom biet dua vao dau de noi bang: mo ta dataset, ten cot trung nhau, ket qua NB01 va kiem chung bang SQL.
- Nhom nhan ra rui ro join bang 1-n truc tiep se lam nhan dong.

NB02 chua can lam sach du lieu sau, chua can feature engineering va chua can tao dataset modeling hoan chinh.

## 2. Khoi tao database va cau truc bang

Phan nay can huong dan hai cach:

- Cach 1: tao database bang giao dien pgAdmin.
- Cach 2: tao database bang cau lenh SQL/psql.

Sau khi co database, can tao cac bang raw tuong ung voi cac file CSV chinh:

- `application_train`
- `application_test`
- `bureau`
- `bureau_balance`
- `previous_application`
- `pos_cash_balance`
- `installments_payments`
- `credit_card_balance`

Can giai thich ngan gon:

- Moi file CSV duoc giu thanh mot bang rieng de bao toan du lieu goc.
- `application_train` va `application_test` la bang trung tam vi chua ho so vay hien tai.
- `application_train` co them cot `TARGET`, nen la bang chinh cho bai toan phan loai nhi phan.

Luu y ky thuat:

- `CREATE DATABASE` thuong nen chay rieng truoc khi ket noi vao database do.
- Cac lenh `CREATE TABLE` chay sau khi da ket noi dung database cua du an.

## 3. Nap du lieu tho vao database

Phan nay can huong dan hai cach import:

- Cach 1: chay file SQL import co san.
- Cach 2: copy cau lenh import vao Query Tool cua pgAdmin.

Can ghi ro:

- Duong dan file CSV can chinh theo may cua tung thanh vien.
- Neu dung `COPY FROM 'duong_dan_file'`, PostgreSQL server phai doc duoc file nen de gap loi quyen truy cap tren Windows.
- Neu dung `\copy`, lenh nay chay qua `psql`, khong phai Query Tool cua pgAdmin.
- Sau khi import, phai kiem tra so dong tung bang co khop voi ket qua NB01 khong.

Bang so dong chuan nen lay tu NB01/Data Understanding de doi chieu.

## 4. Xac dinh khoa lien ket va quan he giua cac bang

NB02 can noi lai ket qua NB01 ve khoa noi va kiem chung bang SQL.

Cac khoa chinh can giai thich:

- `SK_ID_CURR`: khoa noi bang chinh voi cac bang theo khach hang/ho so hien tai.
- `SK_ID_PREV`: khoa noi cac bang lien quan den khoan vay truoc do.
- `SK_ID_BUREAU`: khoa noi `bureau` voi `bureau_balance`.

Can giai thich dua vao dau biet cac khoa nay:

- Mo ta/tai lieu dataset Home Credit.
- Ten cot xuat hien lap lai o nhieu bang.
- Ket qua phan tich grain va khoa noi trong NB01.
- Kiem chung bang SQL: cot co ton tai o bang nao, so luong gia tri duy nhat, ty le match khi join thu.

Quan he du lieu can trinh bay:

- `application_train` / `application_test` la bang trung tam.
- `bureau` noi voi bang trung tam qua `SK_ID_CURR`.
- `bureau_balance` noi voi `bureau` qua `SK_ID_BUREAU`.
- `previous_application` noi voi bang trung tam qua `SK_ID_CURR`.
- `installments_payments`, `POS_CASH_balance`, `credit_card_balance` lien quan den khoan vay truoc qua `SK_ID_PREV`.

Nen chen ERD hoac so do quan he bang de hoi dong nhin nhanh duoc cau truc du lieu.

## 5. Kiem tra join thu

Phan nay khong can join toan bo de tao bang modeling. Muc tieu chi la chung minh logic noi bang dung.

Nen co mot so cau SQL kiem tra:

- Join `application_train` voi `bureau` qua `SK_ID_CURR`.
- Join `bureau` voi `bureau_balance` qua `SK_ID_BUREAU`.
- Join `previous_application` voi `installments_payments` qua `SK_ID_PREV`.
- Join `previous_application` voi `POS_CASH_balance` qua `SK_ID_PREV`.
- Join `previous_application` voi `credit_card_balance` qua `SK_ID_PREV`.

Sau moi join thu, can nhan xet:

- Khoa noi co match du lieu hay khong.
- Day la quan he 1-1, 1-n hay n-1.
- Join truc tiep co lam tang so dong bat thuong hay khong.
- Neu la bang 1-n, cac notebook sau can aggregate truoc khi noi ve bang chinh.

## 6. Validation cuoi notebook

Cuoi NB02 can co phan kiem tra de notebook khong chi la huong dan thao tac.

Can kiem tra:

- Da co du 8 bang raw trong database.
- So dong tung bang trong PostgreSQL khop voi so dong da ghi nhan o NB01.
- Cac cot khoa `SK_ID_CURR`, `SK_ID_PREV`, `SK_ID_BUREAU` ton tai o dung bang.
- Cac cau join thu chay duoc va cho ket qua co the giai thich.
- Cac bang phu 1-n da duoc danh dau la can aggregate o giai doan sau.

Neu dung `assert` trong notebook, loi du lieu se dung lai ngay thay vi de notebook chay het ma sai am tham.

## 7. Tong ket NB02

Phan tong ket can chot ro:

- Database da to chuc duoc du lieu tho tu cac file CSV roi rac.
- Nhom da xac dinh bang trung tam, bang phu va cac khoa lien ket chinh.
- Nhom da kiem chung quan he bang bang SQL.
- Nhom da nhan dien rui ro row explosion khi join bang 1-n truc tiep.
- Cac buoc cleaning, aggregation sau, feature engineering va modeling se duoc thuc hien o cac notebook tiep theo.

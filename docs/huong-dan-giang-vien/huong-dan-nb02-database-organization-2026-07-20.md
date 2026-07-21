# Huong dan NB02 - Database Organization

> **Cap nhat 2026-07-22:** file nay da duoc VIET LAI toan bo, bam theo phan checklist NB02 chinh thuc trong `docs/Task Checklist for Each Notebook.docx` (ban thay update ngay 2026-07-22).
>
> Ban cu (viet ngay 2026-07-20) dua tren ghi chu/demo cua thay khi CHUA co checklist NB02 chinh thuc, nen bi lech nang: thieu 5/10 muc va co 3 cau huong dan nguoc voi checklist. Xem muc "Sai lech cua ban cu" o cuoi file de biet chi tiet va tranh lap lai.

## Nguon

- File checklist: `docs/Task Checklist for Each Notebook.docx`, phan `NOTEBOOK 02: DATABASE ORGANIZATION`.
- Doi chieu thuc te: `notebooks/02_database_organization.ipynb` va `sql/01` - `sql/11` (da hoan thanh, PR #59).

## Vai tro cua NB02

NB02 la buoc bien du lieu tho nhieu bang thanh **mot bang phang, moi doi tuong hoc dung mot dong**, san sang cho Machine Learning.

Diem cot loi: sau NB02, cac notebook 03 den 07 **chi doc du lieu tu PostgreSQL**, khong quay lai doc CSV. Day la yeu cau ro rang cua thay, muc dich la quy trinh nhat quan va gan voi cach trien khai trong doanh nghiep.

## Muc I. Gioi thieu

Neu ro trong notebook:

- Muc tieu cua notebook.
- Pipeline du lieu se xay dung: `CSV -> Import PostgreSQL -> Join / Aggregation -> Flat Table -> Notebook 03`.

## Muc II. Tao Database va table

Thay ghi ro: thuc hien trong pgAdmin4, **ghi lenh trong notebook de bao cao**.

- Tao database, dat ten tuy y.
- Tao table bang `CREATE TABLE`.
- **Ten cac cot trong table phai dung thu tu cac cot trong file CSV, chinh xac kieu du lieu.**
- Co the dung file SQL rieng.

Luu y quan trong ve cau "dung thu tu cot": lenh `COPY` ghep du lieu **theo vi tri cot, khong theo ten cot**. Neu thu tu trong `CREATE TABLE` lech so voi CSV ma kieu du lieu van tuong thich thi du lieu se vao **nham cot** nhung import van bao thanh cong, khong co canh bao nao.

## Muc III. Import du lieu

- Thuc hien trong pgAdmin4, ghi lenh trong notebook de bao cao.
- Lam thu cong trong pgAdmin voi tung bang, hoac dung `COPY table_name FROM 'path/file/csv'`.
- **Kiem tra du lieu sau Import:** `COUNT(*)`...

Luu y ky thuat:

- `COPY` la lenh SQL, chay duoc trong Query Tool cua pgAdmin nhung server phai doc duoc file nen hay gap loi quyen truy cap tren Windows.
- `\copy` KHONG phai lenh SQL, chi chay duoc trong `psql`, dan vao Query Tool se bao loi cu phap.
- pgAdmin Query Tool **chi hien ket qua cua cau `SELECT` cuoi cung** khi chay nhieu cau mot luc. Vi vay moi phep kiem tra nen tach thanh file/cell rieng.

## Muc IV. Toi uu Database

- Tao Index: `CREATE INDEX ten_index ON ten_bang(ten_cot)`.
- **Tao quan he neu can.**

Chu "neu can" o day quan trong. Voi bo Home Credit, khoa ngoai **khong khai bao duoc** vi moi quan he deu co ban ghi mo coi (dataset Kaggle bi cat khi trich xuat). Truong hop nay phai ghi ro ly do trong notebook va dung index tren cac khoa noi de thay the.

## Muc V. Join du lieu

- Vi du cua thay: `Sales JOIN Store`.
- **Kiem tra so dong.**
- **Kiem tra mat du lieu.**

Hai gach dau dong nay la phan validation bat buoc, khong phai tuy chon.

## Muc VI. Tao Flat Table / View

Thay cho hai lua chon:

- `CREATE TABLE ten_bang AS SELECT ... LEFT JOIN ...`
- hoac `CREATE VIEW vw_ten AS SELECT ...`

Va noi ro cho dataset phuc tap: **"tao cac bang Summary roi ghep thanh mot bang cuoi cung co moi doi tuong hoc dung mot dong"**.

Day la muc quan trong nhat cua NB02. Voi dataset nhieu bang 1-n nhu Home Credit, join thang cac bang phu se lam **no so dong** theo cap so nhan, nen bat buoc phai gom tung bang phu ve mot dong moi khach hang truoc khi join.

## Muc VII. Ket noi database tu Python

- Cai thu vien: `psycopg2`, `SQLAlchemy`.
- Import thu vien vao notebook.
- Tao Connection, kiem tra ket noi thanh cong.
- Vi du: `SELECT version();`, `SELECT current_database();`

## Muc IX. Tong hop du lieu (Aggregation)

- Vi du cua thay: `GROUP BY Store`, `GROUP BY Month`, `GROUP BY Promo`.
- Muc tieu: tao du lieu tong hop, chuan bi Feature Engineering.
- Cac ham tong hop: `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`, `STD`, moi nhat, cu nhat.

Luu y ve thu tu: thay danh so muc nay sau muc VII, nhung ve ky thuat phai **aggregate TRUOC khi join** thi moi tranh duoc row explosion. Chinh checklist cua thay o muc VI cung viet "tao cac bang Summary **roi** ghep". Vi vay lam aggregation som hon thu tu danh so la dung, chi can ghi ro trong notebook.

## Muc IV. Kiem tra Performance (neu can)

Muc dich xem toc do ket noi. Thay ghi "neu can" nen co the bo qua neu khong them gia tri cho bai toan.

## Muc X. Ket luan

Vi du thay dua ra:

- Import thanh cong.
- Join thanh cong.
- Tao Flat Table.
- Chuan bi Notebook 03.

## Bon cau hoi cot loi NB02 phai tra loi

1. **Du lieu da duoc dua vao PostgreSQL dung chua?** - Import, kieu du lieu, khoa chinh, chi muc, kiem tra so dong.
2. **Lam the nao de tich hop du lieu tu nhieu bang?** - Join dung quan he, kiem tra mat du lieu, tranh nhan ban ban ghi.
3. **Du lieu nao se duoc dung cho Machine Learning?** - Tao Flat Table hoac View; voi dataset phuc tap thi tao cac bang Summary roi ghep thanh mot bang cuoi cung co moi doi tuong hoc dung mot dong.
4. **Pipeline du lieu da san sang cho Notebook 03 chua?** - Sau notebook nay, NB03 den NB07 chi nen doc du lieu tu PostgreSQL thay vi quay lai doc CSV.

## Nhom da lam khac huong dan o dau va vi sao

Theo nguyen tac trong `README.md` cua thu muc nay, lam khac thi phai ghi ro ly do:

| Diem khac | Ly do |
|---|---|
| Khong khai bao khoa ngoai | Moi quan he deu co ban ghi mo coi: `bureau` -> `application_train` thieu 42.320 khach (ho thuoc `application_test`); `installments`/`pos_cash`/`credit_card` -> `previous_application` mo coi 38.847/37.422/11.372 ma. PostgreSQL se tu choi tao khoa ngoai. Da dung index tren khoa noi thay the |
| Chi dung `psycopg2`, khong dung SQLAlchemy | `requirements.txt` cua nhom da ghi ro quyet dinh nay kem ly do: truyen connection `psycopg2` vao `pandas.read_sql` chi in canh bao, code van chay dung |
| Chi tao 5 bang summary, bo `bureau_balance` | `bureau_balance` khong co `sk_id_curr` nen phai noi vong qua `bureau`, lam code phuc tap. Checklist cua thay cung chi liet ke 4 bang summary. Se khai thac o NB05 neu can |
| Bo qua muc "Kiem tra Performance" | Thay ghi "neu can"; `EXPLAIN ANALYZE` khong them gia tri cho bai toan nay |
| Aggregation lam truoc join | Bat buoc ve ky thuat de tranh row explosion, xem giai thich o muc IX ben tren |

## Sai lech cua ban cu - ghi lai de khong lap lai

Ban 2026-07-20 duoc viet khi chua co checklist NB02 chinh thuc. No dan toi khung NB02 sai va phai lam lai. Ba loi nang nhat:

| Ban cu viet | Checklist thuc te |
|---|---|
| "chua can tao dataset modeling hoan chinh" | Muc VI: **phai tao Flat Table** |
| "khong can join toan bo de tao bang modeling" | Muc V + VI: join de tao flat table |
| "cac notebook **sau** can aggregate" | Muc IX: aggregation lam **ngay o NB02** |

Ngoai ra ban cu co hai muc **khong thuoc NB02**: "Xac dinh khoa lien ket va quan he giua cac bang" va "Kiem tra join thu" - ca hai thuoc NB01 (muc VII. Kiem tra quan he giua cac bang).

**Bai hoc:** khi ghi lai huong dan cua thay tu tri nho hoac tu demo, phai danh dau ro la ban tam va doi chieu lai ngay khi co file goc. Ban cu co ghi canh bao nay o dau file nhung khong ai doi chieu lai khi checklist duoc cap nhat.

## Hai loi danh so trong file checklist goc - nen hoi lai thay

- Phan NB01 co muc `VI. Khao sat du lieu cua bang phu aaa` - chu `aaa` o cuoi trong nhu go sot.
- Danh so La Ma bi trung/nhay: NB01 ket thuc bang `IV. Ket luan` (dang le `IX`); NB02 co `IX. Tong hop du lieu` roi moi toi `IV. Kiem tra Performance` roi `X. Ket luan`.

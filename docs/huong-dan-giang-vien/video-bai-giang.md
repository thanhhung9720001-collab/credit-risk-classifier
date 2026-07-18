# Tong Hop Video Bai Giang Va Clip Hoc Them

> Cac tom tat duoi day dua tren ghi chu/timestamp do Hưng cung cap. Neu sau nay co transcript chinh thuc, nen doi chieu lai va bo sung.

## Buoi 1 - Khoi dong va huong dan cau truc du an Lap trinh AI

- Link: [Du an 1 Lap trinh AI - Buoi 1](https://youtu.be/oqXf-G3TxQA?si=YEtP4lzIyIJmZw56)

### Y chinh

- Mon Du an 1 la mon tien quyet; neu truot se anh huong den viec lam khoa luan/do an tot nghiep.
- Mon hoc tong hop nhieu ky nang: Python, xac suat thong ke, tien xu ly du lieu, SQL, truc quan hoa, cau truc du lieu va giai thuat.
- Du an keo dai 18 buoi, co nhieu cot diem theo giai doan va co diem tai lieu chung cho nhom.
- Nhom nen co 3-5 thanh vien, ly tuong la 4 nguoi; can co nhom truong, group trao doi, ten de tai va dataset.
- Du lieu lon nen can cai extension Colab trong VS Code/lam viec tren moi truong phu hop, khong phu thuoc hoan toan vao Google Colab online.
- Cau truc du an mau gom `data/raw`, `data/processed`, `doc`, `model`, `notebook`, `report`, `SQL`, tracker va requirements.
- Notebook EDA ban dau nen co quy trinh: doc du lieu, xem `.head()`, `.info()`, `.describe().T`, missing, duplicate, cot phan loai, target.

### Diem thay nhan manh

- `02:27`: Nhac ve tinh chat tien quyet cua mon hoc.
- `09:53`: Dung `.style` va `.columns.tolist()` trong pandas de trinh bay bang du lieu dep hon khi bao cao.
- `14:08`: Moi nhom can tao them it nhat 10 cot/feature moi tu du lieu goc.

### Ghi chu ap dung cho du an Home Credit

- Day la template tot cho Notebook 01/Data Understanding va EDA ban dau.
- Can viet nhan xet Markdown ro rang sau cac bang/bieu do quan trong.
- Yeu cau tao feature moi rat phu hop Home Credit vi dataset co nhieu bang phu nhu bureau, previous application, installments, POS/CASH va credit card.

## Buoi 2 - Dang ky de tai, thiet lap cau truc du an va ung dung AI lam tro ly

- Link: [Du an 1 Lap trinh AI - Buoi 2](https://youtu.be/282E90Vw2FI?si=LucLSyadrFEh0C3M)

### Y chinh

- Lam viec nhom la ky nang bat buoc; thanh vien can chu dong hoi, hoc va ho tro nhau.
- Tat ca nhom can dua du lieu CSV lon vao PostgreSQL de quan ly va truy van.
- Can co tracker cong viec, co the dung Google Sheets hoac Trello, de hoi dong xem muc do dong gop.
- Cau truc du an duoc mo rong them `prompts`, `app`, `model`, `SQL`, `requirements.txt` va cac thu muc data con.
- Nhom 1 chon de tai Home Credit/default risk: du doan xac suat vo no/rui ro tin dung.
- Giang vien demo cach moi ngu canh cho AI: dua Assignment, hoi ve dataset, goi y ten de tai, dua cau truc folder/quy chuan notebook, lap de cuong notebook.
- Nen co mot AI chinh giu luong ngu canh du an va mot AI phu de hoi loi nho/giai thich code.
- Cac prompt quan trong can luu lai vi ngu canh AI co the mat.

### Diem thay nhan manh

- `03:35`: Bat buoc thuc hanh database/PostgreSQL; day la co hoi cuoi de lam viec voi database co su ho tro cua thay co truoc do an tot nghiep.
- `13:14`: Luu prompt quan trong vao file/thumuc rieng de co the khoi phuc ngu canh khi doi AI.
- `28:12`: Feature engineering la phan rat quan trong; cac cot moi co the la chia khoa tao y tuong ung dung.
- `39:45`: Loi vat khong nen hoi AI chinh dang giu luong project de tranh lam loang ngu canh.

### Ghi chu ap dung cho du an Home Credit

- Thu muc `prompts` nen duoc dung de luu prompt quan trong, dac biet prompt ve quy chuan notebook, cach viet bao cao va cach giai thich model.
- PostgreSQL khong chi la yeu cau ky thuat ma con giup xu ly du lieu lon va tao view/aggregation on dinh.
- Tracker nhom can duoc duy tri de phuc vu chuong Quan tri du an/bao cao dong gop.

## Buoi 3

- Trang thai: chua co video / chua duoc cung cap.

## Buoi 4 - Huong dan viet tai lieu du an va thiet lap kich ban kiem thu du lieu

- Link: [Du an 1 Lap trinh AI - Buoi 4](https://youtu.be/ziW1bQa7lvw?si=jSBBbu7S6wncM8Ok)

### Y chinh

- Buoi hoc tap trung vao cach viet tai lieu bao cao du an bang Microsoft Word theo huong khoa hoc va giong quy trinh doanh nghiep.
- Chuong 5/phan quan tri du an nen co phan vai ro rang: Project Manager, Data Engineer, Data Analyst, AI/Machine Learning Researcher.
- Khong nen be nguyen bang tracker 40 task vao Word; nen tom tat theo sprint/giai doan, dan link tracker chi tiet va co Gantt/Weekly Log neu can.
- Voi pham vi mon hoc, giang vien goi y Google Drive va quy uoc ten file notebook de tranh xung dot; rieng nhom nay dang dung Git/GitHub nghiem ngat hon theo quy dinh noi bo.
- Phan cot loi la Data Validation/Unit Test o cuoi Notebook 02 de kiem tra tinh toan ven du lieu sau clean/join/aggregation.

### Kich ban kiem thu du lieu mau

- Kiem tra so dong truoc/sau JOIN bang `SELECT COUNT(*)`.
- Kiem tra khong mat thuc the chinh va khong phat sinh duplicate bang `GROUP BY ... HAVING COUNT(*) > 1`.
- Kiem tra tong cac bien quan trong khong doi bat thuong sau pipeline.
- Kiem tra null moi phat sinh.
- Kiem tra khoa ngoai/quan he giua cac bang.
- In bang ket qua PASS/FAIL o cuoi notebook de hoi dong thay ro quy trinh validation.

### Diem thay nhan manh

- `01:24`: Bao cao nen tom tat sprint thay vi dua toan bo tracker chi tiet vao Word.
- `02:35`: Phai ghi nguon dataset, code tham khao; AI chi la cong cu ho tro, nhom phai hieu va chinh sua.
- `03:53`: Nen in ket qua Unit Test ro rang, vi du `Row Count PASS`, `ALL TESTS PASSED`.

### Ghi chu ap dung cho du an Home Credit

- Notebook 02/PostgreSQL pipeline can co phan validation ro rang cho view/aggregation.
- Voi Home Credit, can doi chieu cac khoa nhu `SK_ID_CURR`, `SK_ID_BUREAU`, `SK_ID_PREV` va kiem tra duplicate sau khi aggregate ve muc khach hang.
- Cac bien tai chinh quan trong nen co kiem tra logic/tong hop phu hop, khong nen chi kiem tra code chay thanh cong.

## Clip hoc xuong buoi toi 1 - Ky nang phan tich dataset va chien luoc xu ly du lieu lon

- Link: [Tim hieu bo du lieu - Thay Long Web](https://youtu.be/W6rMY9jRDIg?si=2bnVblmYzBXyfVva)

### Y chinh

- Truoc khi code, can giai toa tam ly bang cach bam vao viec hieu dataset: nghiep vu, target, quy mo va loai bai toan AI.
- Co the dung AI de hoi nhung cau hoi cot loi ve dataset: cot target la gi, nghiep vu nao duoc mo phong, quy mo du lieu ra sao.
- Sinh vien can biet bai toan thuoc dang nao trong cac nhom AI pho bien: regression, classification, clustering, recommender system, time series...
- Classification thuong de tiep can hon; regression/time series de sai logic thoi gian hon.
- Voi du lieu lon 3-8 trieu dong, `pd.read_csv` doc toan bo file vao RAM co the gay treo may.
- Nen dua CSV vao PostgreSQL truoc, sau do dung SQL de loc/lay mau/truy van theo dieu kien truoc khi dua sang Python.
- Voi du lieu nhieu bang, can tao flat table hoac view bang `LEFT JOIN`/aggregation truoc khi xu ly tiep.
- Khong xoa cot tuy tien; can phan loai cot theo muc dich: phuc vu model, phuc vu hien thi, hay it gia tri phan tich.

### Diem thay nhan manh

- `04:52`: Hoi dong co the hoi bai toan cua nhom thuoc loai nao trong cac dang bai toan AI.
- `06:32`: Target la cot muc tieu de mo hinh hoc quy luat va du bao.
- `26:14`: Hoi AI bang tung cau hoi ro rang, ngan gon; khong giao qua nhieu viec trong mot prompt.
- `29:35`: PostgreSQL xu ly vai trieu dong tot hon RAM/Python local.

### Ghi chu ap dung cho du an Home Credit

- De tai cua nhom la bai toan classification co giam sat: du doan xac suat khach hang gap kho khan tra no/default risk.
- Home Credit co nhieu bang lon, nen PostgreSQL/view/aggregation la cach dung hop ly truoc khi dua ve Python.
- Nen danh gia lai muc do huu ich cua tung nhom cot, tranh ket luan cam tinh la "vo dung". Trong bao cao nen viet la "cot it gia tri phan tich/mo hinh hoa" hoac "cot can danh gia lai muc do dong gop".
- Giam chieu du lieu va feature selection la buoc quan trong vi Home Credit co rat nhieu cot va nhieu bang phu.

## Clip hoc xuong buoi toi 2

- Trang thai: thay chua upload / chua duoc cung cap.

## Clip bo sung - Feature Engineering la gi

- Link: [Feature Engineering la gi](http://www.youtube.com/watch?v=ZprLK-wa7MM)

### Y chinh

- Feature Engineering la qua trinh bien doi, ket hop hoac tao moi feature tu du lieu tho ban dau dua tren hieu biet nghiep vu.
- Muc tieu la giup mo hinh Machine Learning de phat hien quy luat an va nang cao chat luong du doan.
- Trong ngu canh AI/ML, nen dung tu "feature" de chi dac trung/dac diem cua tung dong du lieu thay vi chi noi chung la cot/truong.
- Ky thuat pho bien gom:
  - Tach nhieu feature tu mot feature goc, vi du tu ngay tao ra thu, thang, quy, ngay le.
  - Ket hop nhieu feature thanh feature moi, vi du thu nhap chia cho so thanh vien gia dinh de ra thu nhap binh quan.
  - Chuan hoa du lieu bang Standard Scale hoac Min-Max.
  - Ma hoa bien phan loai bang Label Encoding, One-Hot Encoding, hoac bien doi anh/am thanh thanh vector.
- Feature tao ra phai xuat phat tu bai toan thuc te va co y nghia logic/nghiep vu cu the.

### Diem thay nhan manh

- `00:46`: Feature Engineering dung ngay truoc buoc huan luyen mo hinh va co the quyet dinh su thanh bai cua du an AI.
- `04:36`: Giai thich thuat ngu "feature" la dac trung/dac diem cua tung dong du lieu.
- `18:30`: Vi du One-Hot Encoding bien mau sac do/xanh/vang thanh cac cot so 0/1.
- `32:49`: Feature Engineering la qua trinh thu nghiem lien tuc, khong phai lam mot lan la xong.

### Ghi chu ap dung cho du an Home Credit

- Notebook 05 can giai thich ro vi sao moi nhom feature duoc tao ra co y nghia voi rui ro tin dung.
- Cac bien tai chinh/lich su tra no/cac nguon diem ngoai nhu `EXT_SOURCE_*` can duoc dien giai bang nghiep vu, khong chi dua vao code.
- Viec "bao che" du lieu tho thanh so la bat buoc truoc khi dua vao mo hinh.

## Clip bo sung - Quy trinh Feature Engineering trong du an Machine Learning

- Link: [Quy trinh Feature Engineering trong du an Machine Learning](https://youtu.be/NwV9LhjTnWQ?si=DmTgUpbOQiMh6RFb)

### Y chinh

- Khong co mot quy trinh Feature Engineering co dinh cho moi bai toan; moi linh vuc va muc tieu du doan can cach tao feature khac nhau.
- Vong lap co ban gom 5 buoc:
  - Hieu ro bai toan, muc tieu va thach thuc.
  - Kham pha du lieu bang EDA: hieu y nghia cot, moi quan he, missing/outlier va bieu do nhu box plot, histogram, scatter plot, heatmap.
  - Xay dung feature moi: tach ngay thang, ket hop cong thuc, chuyen doi don vi, ma hoa One-Hot...
  - Danh gia dong gop cua feature bang Feature Importance, SHAP value hoac cac phep do phu hop.
  - Tinh chinh va lap lai neu mo hinh chua dat ky vong hoac feature moi khong dong gop.
- Tao cot trong EDA va tao feature cho model la hai muc dich khac nhau: EDA de nhin insight, Feature Engineering de phuc vu huan luyen mo hinh.

### Diem thay nhan manh

- `11:42`: Can phan biet tao cot moi de truc quan hoa/tim insight voi tao feature moi de huan luyen mo hinh.
- `20:07`: Quy trinh khong phai duong thang; neu danh gia model co van de thi phai quay lai cac buoc truoc.

### Ghi chu ap dung cho du an Home Credit

- Co the dung AI de goi y y tuong feature ban dau, nhung nhom phai tu kiem tra bang truc quan hoa, tuong quan va ket qua model.
- Heatmap, feature importance va cac phep danh gia sau model nen duoc dung de chon feature co y nghia.
- Khi viet bao cao, nen nhan manh Feature Engineering la vong lap thuc nghiem, khong phai danh sach thao tac co dinh.

## Clip bo sung - Nhung nguyen tac vang trong Feature Engineering

- Link: [Nhung nguyen tac vang trong Feature Engineering](http://www.youtube.com/watch?v=07nQWhfHHk4)

### Y chinh

- Feature phai phuc vu bai toan cu the; khong tao feature theo cam tinh hoac rap khuon tu bai toan khac.
- Chat luong quan trong hon so luong; feature tot phai co thong tin co gia tri va co kha nang tac dong den bien muc tieu.
- Moi feature tao ra phai co y nghia. Neu feature khong dong gop hoac hieu qua thap thi can loai bo va rut kinh nghiem.
- Can tranh Data Leakage: khong duoc dua thong tin tuong lai hoac thong tin chi xuat hien sau thoi diem du doan vao training.
- Luon danh gia hieu qua feature bang SHAP value, Feature Importance, chi so danh gia phu hop va coi Feature Engineering la cong viec lien tuc.

### Diem thay nhan manh

- `00:23`: Feature phai phuc vu bai toan cu the.
- `01:38`: Chat luong feature quan trong hon so luong feature.
- `02:40`: Moi feature tao ra phai co y nghia.
- `03:39`: Data Leakage la loi nghiem trong khi mo hinh dung thong tin tuong lai de hoc.
- `05:40`: Vi du khong duoc dung trang thai khoan vay sau 6 thang de du doan khach hang moi nop ho so.
- `06:07`: Leakage co the lam ket qua test rat tot nhung that bai khi chay thuc te.
- `07:27`: Can danh gia hieu qua feature va lap lai lien tuc.
- `10:44`: Nhan manh Data Leakage la dieu bat buoc phai tranh khi lam trong doanh nghiep.

### Ghi chu ap dung cho du an Home Credit

- Home Credit la bai toan rui ro tin dung theo thoi diem nop ho so, nen moi feature phai tuong thich voi thong tin co san tai thoi diem du doan.
- Khi tong hop tu bang phu, can canh giac voi cac thong tin sau thoi diem vay hien tai neu co nguy co leakage.
- Khong nen tao feature chi de du so luong; moi feature quan trong can co ly do nghiep vu va/hoac bang chung dong gop tu model.


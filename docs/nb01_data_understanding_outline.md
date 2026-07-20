# Outline Notebook 01 - Data Understanding

> File này chốt mạch làm `notebooks/01_data_understanding.ipynb` trước khi viết notebook thật. Nội dung bám theo `docs/Data_Understanding.docx`, checklist NB01 của giảng viên và quy ước notebook trong `PROJECT_CONTEXT.md`.

## Mục tiêu

- Hiểu bài toán dự báo rủi ro khách hàng vay vốn.
- Hiểu bộ dữ liệu Home Credit gồm bảng chính, bảng phụ, grain và khóa nối.
- Đánh giá chất lượng dữ liệu ban đầu: missing, duplicate, giá trị bất thường, mất cân bằng `TARGET`.
- Dùng biểu đồ ở những chỗ cần thiết để người đọc dễ hiểu dữ liệu hơn.
- Tính tương quan ban đầu với `TARGET` để định hướng cho EDA, Feature Engineering và Modeling.
- Không cleaning, không modeling và không join trực tiếp bảng phụ 1-n trong notebook này.

## Cell mở đầu

Cell đầu tiên là Markdown theo quy ước nhóm:

```markdown
# Xây dựng Mô hình Phân loại và Dự báo Rủi ro Khách hàng Vay vốn

**Notebook 01/07 - Data Understanding (Tìm hiểu dữ liệu)**

---

**Mục tiêu:** Hiểu bài toán, bộ dữ liệu Home Credit, bảng chính/bảng phụ, chất lượng dữ liệu ban đầu và các vấn đề cần chuyển sang bước sau.

**Input:** `data/raw/*.csv`

**Output:** Nhận xét ban đầu về cấu trúc, chất lượng, khóa nối, biểu đồ cơ bản và tín hiệu tương quan với `TARGET`.

**Pipeline:** Business Understanding -> **Data Understanding** -> PostgreSQL Pipeline / Data Cleaning
```

## 1. Mục tiêu notebook

Loại cell:
- Markdown.

Nội dung:
- Notebook này dùng để hiểu dữ liệu trước khi xử lý.
- Không làm sạch dữ liệu trong NB01.
- Không huấn luyện mô hình trong NB01.
- Kết quả cần có là danh sách phát hiện ban đầu và vấn đề cần chuyển sang các notebook sau.

## 2. Bài toán và biến mục tiêu

Loại cell:
- Markdown.
- Có thể thêm bảng nhỏ giải thích `TARGET`.

Nội dung:
- Bài toán: dự đoán rủi ro khách hàng vay vốn.
- Loại bài toán: phân loại nhị phân có giám sát.
- `TARGET = 0`: khách hàng không gặp khó khăn trong thanh toán.
- `TARGET = 1`: khách hàng gặp khó khăn trong thanh toán.
- Nhấn mạnh dữ liệu bị mất cân bằng có thể ảnh hưởng tới cách đánh giá mô hình sau này.

## 3. Bản đồ dataset Home Credit

Loại cell:
- Markdown dẫn ngắn.
- Code kiểm tra file.
- Code tạo bảng overview.
- Markdown nhận xét sau output.
- Markdown/ảnh ERD.

Code cần có:
- Kiểm tra thư mục `data/raw`.
- Kiểm tra các file CSV bắt buộc có tồn tại không.
- Tạo bảng overview gồm:
  - tên bảng,
  - số dòng,
  - số cột,
  - dung lượng RAM ước tính,
  - tỷ lệ missing tổng quan.

Ảnh dùng:
- `reports/images/home_credit_erd.png`

Nhận xét cần chốt:
- `application_train` và `application_test` là bảng trung tâm.
- Các bảng còn lại là lịch sử tín dụng, lịch sử vay và hành vi thanh toán.
- Bảng phụ thường có quan hệ 1-n nên cần aggregate trước khi join.

## 4. Khảo sát bảng chính application_train

Loại cell:
- Markdown dẫn ngắn.
- Code đọc `application_train.csv`.
- Code `head()`.
- Code shape/memory/dtype.
- Code thống kê mô tả chọn lọc.
- Markdown nhận xét sau output.

Code cần có:
- Đọc `application_train.csv`.
- Hiển thị `head()`.
- In số dòng, số cột, memory usage.
- Tóm tắt dtype.
- Nhóm cột theo vai trò:
  - ID/target,
  - nhân khẩu,
  - tài chính,
  - biến ngày `DAYS_*`,
  - điểm ngoài `EXT_SOURCE_*`,
  - biến phân loại.
- `describe()` cho nhóm numeric quan trọng:
  - `AMT_INCOME_TOTAL`,
  - `AMT_CREDIT`,
  - `AMT_ANNUITY`,
  - `DAYS_BIRTH`,
  - `DAYS_EMPLOYED`,
  - `EXT_SOURCE_1`,
  - `EXT_SOURCE_2`,
  - `EXT_SOURCE_3`.

Nhận xét cần chốt:
- Không phân tích máy móc toàn bộ 122 cột.
- Ưu tiên các nhóm cột có ý nghĩa với rủi ro tín dụng.
- Ghi nhận các điểm bất thường để chuyển sang NB03.

## 5. Chất lượng dữ liệu ban đầu

Loại cell:
- Markdown dẫn ngắn.
- Code missing values.
- Code duplicate.
- Code bất thường.
- Code/biểu đồ phân bố `TARGET`.
- Markdown nhận xét sau output.

Code cần có:
- Top missing values.
- Bar chart top missing values.
- Duplicate toàn dòng.
- Duplicate theo `SK_ID_CURR`.
- Kiểm tra `DAYS_EMPLOYED = 365243`.
- Kiểm tra `CODE_GENDER = XNA`.
- Kiểm tra min/median/max cho các biến tiền tệ chính.
- Phân bố `TARGET` bằng bảng và bar chart.

Nhận xét cần chốt:
- Dữ liệu có missing và cần chiến lược xử lý ở NB03.
- `TARGET` bị mất cân bằng nên sau này không nên chỉ nhìn accuracy.
- Một số giá trị bất thường chỉ được phát hiện tại NB01, chưa xử lý tại đây.

## 6. Bảng phụ, khóa nối và rủi ro row explosion

Loại cell:
- Markdown dẫn ngắn.
- Code đọc metadata/tóm tắt bảng phụ.
- Code kiểm tra khóa.
- Markdown nhận xét sau output.

Code cần có:
- Với từng bảng phụ, kiểm tra:
  - số dòng,
  - số cột,
  - số lượng `SK_ID_CURR` unique nếu có,
  - số lượng `SK_ID_PREV` unique nếu có,
  - số lượng `SK_ID_BUREAU` unique nếu có.
- Tạo bảng quan hệ gồm:
  - bảng,
  - khóa có trong bảng,
  - grain,
  - quan hệ với bảng chính.

Nhận xét cần chốt:
- `SK_ID_CURR` nối dữ liệu về cấp khách hàng/hồ sơ hiện tại.
- `SK_ID_PREV` nối các khoản vay trước tại Home Credit.
- `SK_ID_BUREAU` nối `bureau` với `bureau_balance`.
- `bureau_balance` không có `SK_ID_CURR`, phải đi qua `bureau`.
- Không join trực tiếp bảng 1-n vào `application_train`; cần aggregate về `SK_ID_CURR`.

## 7. Biểu đồ và tương quan ban đầu với TARGET

Loại cell:
- Markdown dẫn ngắn.
- Code biểu đồ numeric.
- Code biểu đồ category.
- Code correlation.
- Markdown nhận xét sau output.

Biểu đồ numeric:
- Histogram hoặc boxplot cho:
  - `AMT_INCOME_TOTAL`,
  - `AMT_CREDIT`,
  - `AMT_ANNUITY`,
  - tuổi suy ra từ `DAYS_BIRTH`,
  - `DAYS_EMPLOYED`.

Biểu đồ category:
- Bar chart cho:
  - `CODE_GENDER`,
  - `NAME_CONTRACT_TYPE`,
  - `NAME_EDUCATION_TYPE`,
  - `NAME_FAMILY_STATUS`,
  - `OCCUPATION_TYPE`.

Correlation:
- Tính correlation giữa các biến numeric và `TARGET`.
- Lấy top 15-20 biến theo `abs(correlation)`.
- Vẽ bar chart top correlation.
- Có thể vẽ heatmap nhỏ cho nhóm top correlation nếu biểu đồ không làm notebook quá dài.

Nhận xét cần chốt:
- Correlation chỉ là tín hiệu ban đầu.
- Không kết luận nhân quả.
- Không kết luận biến vô dụng chỉ vì correlation thấp.
- Kết quả này dùng để định hướng NB04, NB05 và NB06.

## 8. Tổng kết

Loại cell:
- Markdown.
- Có thể dùng bảng handoff.

Nội dung cần trả lời:
- Dữ liệu đang có là gì?
- Dữ liệu có đáng tin không?
- Dữ liệu được tổ chức và liên kết như thế nào?
- Cần chuẩn bị gì cho các bước tiếp theo?

Bảng handoff đề xuất:

| Phát hiện từ NB01 | Chuyển sang notebook | Việc cần làm |
|---|---|---|
| Dữ liệu gồm nhiều bảng và quan hệ 1-n | NB02 / NB05 | Aggregate bảng phụ về `SK_ID_CURR` trước khi join |
| Missing values xuất hiện ở nhiều cột | NB03 | Chọn chiến lược xử lý missing có giải thích |
| Có giá trị bất thường như `DAYS_EMPLOYED = 365243` | NB03 | Kiểm tra và xử lý bằng quy tắc rõ ràng |
| `TARGET` bị mất cân bằng | NB06 | Dùng metric phù hợp, không chỉ dùng accuracy |
| Một số biến numeric có tương quan ban đầu với `TARGET` | NB04 / NB05 | Phân tích sâu và cân nhắc feature engineering |

## Quy tắc khi viết notebook

- Markdown trước code chỉ dẫn ngắn.
- Output quan trọng phải có cell `**Nhận xét:**` ngay sau.
- Không dùng icon/emoji trong heading.
- Không cleaning trong NB01.
- Không modeling trong NB01.
- Không join bảng phụ 1-n trực tiếp.
- Không phân tích máy móc toàn bộ 122 cột.
- Không kết luận cột vô dụng quá sớm.
- Correlation chỉ dùng để định hướng.

## Tiêu chí hoàn thành NB01

NB01 đạt yêu cầu khi người đọc trả lời được:

- Dữ liệu Home Credit gồm những bảng nào?
- Bảng chính và bảng phụ là gì?
- Mỗi dòng trong từng bảng đại diện cho điều gì?
- `TARGET` nằm ở đâu và phân bố ra sao?
- Dữ liệu có missing, duplicate, bất thường hoặc mất cân bằng lớp không?
- Các bảng nối nhau bằng khóa nào?
- Vì sao bảng phụ 1-n phải aggregate trước khi join?
- Biểu đồ nào giúp hiểu dữ liệu tốt hơn?
- Tương quan với `TARGET` gợi ý gì cho các bước sau?

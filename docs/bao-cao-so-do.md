# Bộ sơ đồ dùng cho báo cáo CRM Mini

File này dùng cú pháp Mermaid. Có thể dán từng khối vào Markdown, Notion, GitHub, Mermaid Live Editor hoặc xuất thành ảnh để đưa vào Word.

## 1. Sơ đồ kiến trúc hệ thống

```mermaid
flowchart LR
  User["Người dùng\nAdmin / Staff"] --> Browser["Trình duyệt\nReact + Vite"]
  Browser -->|HTTP/JSON API| Backend["Backend API\nNode.js + Express"]
  Backend -->|Prisma ORM| Database["Database\nRailway PostgreSQL / Local SQLite"]
  Backend --> Auth["JWT Authentication"]
  Backend --> Modules["Modules\nCustomers, Staff, Orders,\nProducts, Care History, Reports"]

  subgraph Client["Client Layer"]
    Browser
  end

  subgraph Server["Server Layer"]
    Backend
    Auth
    Modules
  end

  subgraph Data["Data Layer"]
    Database
  end
```

## 2. Sơ đồ triển khai đồng bộ dữ liệu

```mermaid
flowchart TB
  A["Máy người dùng 1\nstart-crm-mini-synced.bat"] -->|API URL chung| R["Railway Backend\nExpress API"]
  B["Máy người dùng 2\nstart-crm-mini-synced.bat"] -->|API URL chung| R
  C["Máy người dùng 3\nstart-crm-mini-synced.bat"] -->|API URL chung| R
  R --> P["Railway PostgreSQL\nDatabase chung"]

  A -.->|"Chỉ chạy frontend"| FA["React Frontend"]
  B -.->|"Chỉ chạy frontend"| FB["React Frontend"]
  C -.->|"Chỉ chạy frontend"| FC["React Frontend"]
```

## 3. Sơ đồ Use Case tổng quan

```mermaid
flowchart LR
  subgraph Left[" "]
    direction TB
    Admin((Admin))
  end

  subgraph System["CRM Mini System"]
    direction TB

    subgraph AdminOnly["Chức năng Admin"]
      direction TB
      StaffMgmt["Quản lý tài khoản nhân viên"]
      Permission["Phân quyền khách hàng"]
      Product["Quản lý sản phẩm / dịch vụ"]
      Report["Xem báo cáo thống kê"]
    end

    subgraph Common["Chức năng chung"]
      direction TB
      Auth["Đăng nhập / Đăng xuất"]
      Dashboard["Xem Dashboard"]
      Customer["Quản lý khách hàng"]
      Order["Quản lý đơn hàng"]
      Care["Ghi nhận chăm sóc khách hàng"]
      Profile["Quản lý hồ sơ cá nhân"]
    end
  end

  subgraph Right[" "]
    direction TB
    Staff((Staff))
  end

  Admin --> Auth
  Admin --> Dashboard
  Admin --> Customer
  Admin --> Order
  Admin --> Care
  Admin --> Profile
  Admin --> StaffMgmt
  Admin --> Permission
  Admin --> Product
  Admin --> Report

  Staff --> Auth
  Staff --> Dashboard
  Staff --> Customer
  Staff --> Order
  Staff --> Care
  Staff --> Profile
```

## 4. Sơ đồ phân quyền Admin và Staff

```mermaid
flowchart TB
  Login["Đăng nhập hệ thống"] --> CheckRole{"Vai trò tài khoản?"}

  CheckRole -->|ADMIN| Admin["Admin"]
  CheckRole -->|STAFF| Staff["Staff"]

  Admin --> A1["Xem toàn bộ Dashboard"]
  Admin --> A2["CRUD khách hàng"]
  Admin --> A3["CRUD nhân viên"]
  Admin --> A4["Phân quyền khách hàng cho Staff"]
  Admin --> A5["CRUD đơn hàng"]
  Admin --> A6["CRUD sản phẩm"]
  Admin --> A7["Xem toàn bộ lịch sử chăm sóc"]
  Admin --> A8["Xem báo cáo"]

  Staff --> S1["Xem Dashboard cá nhân"]
  Staff --> S2["Xem khách hàng được phân quyền"]
  Staff --> S3["Tạo/sửa khách hàng được phép quản lý"]
  Staff --> S4["Tạo/sửa đơn hàng liên quan"]
  Staff --> S5["Thêm lịch sử chăm sóc"]
  Staff --> S6["Cập nhật hồ sơ cá nhân"]
```

## 5. Sơ đồ ERD cơ sở dữ liệu

```mermaid
erDiagram
  USER {
    int id PK
    string username UK
    string name
    string email UK
    string password
    string role
    string phone
    string title
    string status
    datetime createdAt
    datetime updatedAt
  }

  CUSTOMER {
    int id PK
    string name
    string company
    string email UK
    string phone
    string address
    string customerType
    string source
    string status
    string note
    int createdById FK
    datetime createdAt
    datetime updatedAt
  }

  CUSTOMER_MANAGER {
    int id PK
    int userId FK
    int customerId FK
    datetime createdAt
  }

  PRODUCT {
    int id PK
    string name
    string sku UK
    string category
    int price
    string status
    string description
    datetime createdAt
    datetime updatedAt
  }

  ORDER {
    int id PK
    string code UK
    int customerId FK
    int productId FK
    int staffId FK
    int quantity
    int total
    string paymentStatus
    string status
    string note
    datetime createdAt
    datetime updatedAt
  }

  ORDER_DETAIL {
    int id PK
    int orderId FK
    int productId FK
    int quantity
    int unitPrice
    int totalPrice
    datetime createdAt
    datetime updatedAt
  }

  CARE_HISTORY {
    int id PK
    int customerId FK
    int staffId FK
    string type
    string summary
    string result
    string nextAction
    datetime nextSchedule
    datetime careDate
    datetime createdAt
    datetime updatedAt
  }

  DEAL {
    int id PK
    string title
    int value
    string stage
    datetime expectedAt
    int customerId FK
    datetime createdAt
    datetime updatedAt
  }

  TICKET {
    int id PK
    string subject
    string priority
    string status
    string description
    int customerId FK
    datetime createdAt
    datetime updatedAt
  }

  USER ||--o{ CUSTOMER : creates
  USER ||--o{ CUSTOMER_MANAGER : manages
  CUSTOMER ||--o{ CUSTOMER_MANAGER : assigned_to
  CUSTOMER ||--o{ ORDER : has
  USER ||--o{ ORDER : handles
  PRODUCT ||--o{ ORDER : selected_in
  ORDER ||--o{ ORDER_DETAIL : contains
  PRODUCT ||--o{ ORDER_DETAIL : included_in
  CUSTOMER ||--o{ CARE_HISTORY : has
  USER ||--o{ CARE_HISTORY : writes
  CUSTOMER ||--o{ DEAL : has
  CUSTOMER ||--o{ TICKET : has
```

## 6. Sơ đồ luồng đăng nhập

```mermaid
sequenceDiagram
  actor User as Người dùng
  participant UI as React Login Page
  participant API as Express Auth API
  participant DB as Database

  User->>UI: Nhập email/username và mật khẩu
  UI->>API: POST /api/auth/login
  API->>DB: Tìm User theo email hoặc username
  DB-->>API: Trả về thông tin User
  API->>API: Kiểm tra trạng thái ACTIVE
  API->>API: So sánh mật khẩu bcrypt
  API->>API: Tạo JWT token
  API-->>UI: Trả về token và thông tin user
  UI->>UI: Lưu token vào localStorage
  UI-->>User: Chuyển đến Dashboard
```

## 7. Sơ đồ luồng quản lý khách hàng

```mermaid
sequenceDiagram
  actor User as Admin/Staff
  participant UI as Customers Page
  participant API as Customers API
  participant Access as Access Control
  participant DB as Database

  User->>UI: Mở danh sách khách hàng
  UI->>API: GET /api/customers
  API->>Access: Kiểm tra quyền theo role
  Access-->>API: Admin xem tất cả / Staff xem khách được gán
  API->>DB: Truy vấn Customers
  DB-->>API: Danh sách khách hàng
  API-->>UI: Trả dữ liệu

  User->>UI: Thêm/Sửa khách hàng
  UI->>API: POST/PUT /api/customers
  API->>Access: Kiểm tra quyền
  API->>DB: Lưu thông tin khách hàng
  DB-->>API: Dữ liệu đã lưu
  API-->>UI: Thông báo thành công
  UI->>UI: Làm mới danh sách và Dashboard
```

## 8. Sơ đồ luồng phân quyền Staff quản lý khách hàng

```mermaid
sequenceDiagram
  actor Admin
  participant UI as Staff Accounts Page
  participant API as Users API
  participant DB as Database

  Admin->>UI: Chọn tài khoản Staff
  UI->>API: GET /api/users
  API->>DB: Lấy Staff kèm danh sách khách được quản lý
  DB-->>API: Staff + managedCustomers
  API-->>UI: Hiển thị thông tin Staff

  Admin->>UI: Tích chọn khách hàng được quản lý
  Admin->>UI: Bấm Save Account
  UI->>API: PUT /api/users/:id với managedCustomerIds
  API->>DB: Xóa phân quyền cũ của Staff
  API->>DB: Tạo lại CustomerManager theo danh sách mới
  DB-->>API: Lưu thành công
  API-->>UI: Trả về Staff đã cập nhật
  UI-->>Admin: Hiển thị thông báo thành công
```

## 9. Sơ đồ luồng tạo đơn hàng

```mermaid
sequenceDiagram
  actor User as Admin/Staff
  participant UI as Orders Page
  participant API as Orders API
  participant DB as Database

  User->>UI: Chọn Customer, Product, Quantity
  UI->>UI: Tính total từ giá sản phẩm x số lượng
  User->>UI: Bấm Save Order
  UI->>API: POST /api/orders
  API->>DB: Kiểm tra Customer/Product/Staff
  API->>DB: Tạo Order
  API->>DB: Tạo OrderDetail
  DB-->>API: Order đã tạo
  API-->>UI: Trả về đơn hàng
  UI->>UI: Làm mới danh sách đơn hàng và Dashboard
```

## 10. Sơ đồ Activity: Quy trình chăm sóc khách hàng

```mermaid
flowchart TD
  Start([Bắt đầu]) --> Login["Đăng nhập"]
  Login --> Role{"Vai trò?"}
  Role -->|Admin| ViewAll["Xem toàn bộ khách hàng"]
  Role -->|Staff| ViewAssigned["Xem khách hàng được phân quyền"]
  ViewAll --> SelectCustomer["Chọn khách hàng"]
  ViewAssigned --> SelectCustomer
  SelectCustomer --> AddCare["Thêm ghi chú chăm sóc\nCall / Email / Meeting / Consultation"]
  AddCare --> SaveCare["Lưu lịch sử chăm sóc"]
  SaveCare --> NextAction{"Có hành động tiếp theo?"}
  NextAction -->|Có| Schedule["Ghi nextAction / nextSchedule"]
  NextAction -->|Không| Done["Hoàn tất chăm sóc"]
  Schedule --> Done
  Done --> UpdateDashboard["Dashboard / Reports cập nhật"]
  UpdateDashboard --> End([Kết thúc])
```

## 11. Sơ đồ Activity: Quy trình vận hành tổng quan

```mermaid
flowchart TD
  Start([Mở ứng dụng]) --> Auth{"Đã đăng nhập?"}
  Auth -->|Chưa| Login["Đăng nhập"]
  Auth -->|Rồi| Dashboard["Xem Dashboard"]
  Login --> Dashboard

  Dashboard --> Choose{"Chọn chức năng"}
  Choose --> Customers["Quản lý khách hàng"]
  Choose --> Staff["Quản lý nhân viên"]
  Choose --> Orders["Quản lý đơn hàng"]
  Choose --> Products["Quản lý sản phẩm"]
  Choose --> Care["Lịch sử chăm sóc"]
  Choose --> Reports["Báo cáo thống kê"]

  Customers --> Save["Thêm / Sửa / Xóa / Tìm kiếm"]
  Staff --> Permission["Tạo Staff / Phân quyền / Đổi mật khẩu"]
  Orders --> OrderSave["Tạo / Cập nhật đơn hàng"]
  Products --> ProductSave["Tạo / Cập nhật sản phẩm"]
  Care --> CareSave["Thêm ghi chú chăm sóc"]
  Reports --> ViewStats["Xem thống kê"]

  Save --> Refresh["Cập nhật dữ liệu"]
  Permission --> Refresh
  OrderSave --> Refresh
  ProductSave --> Refresh
  CareSave --> Refresh
  ViewStats --> End([Kết thúc])
  Refresh --> Dashboard
```

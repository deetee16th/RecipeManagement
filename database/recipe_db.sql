-- Tạo Database
CREATE DATABASE RecipeDB;
GO

USE RecipeDB;
GO

-- Bảng Users (Người dùng)
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(100) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    role NVARCHAR(20) NOT NULL DEFAULT 'user', -- 'admin' hoặc 'user'
    created_date DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- Bảng Categories (Danh mục công thức)
CREATE TABLE Categories (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    created_date DATETIME DEFAULT GETDATE()
);

-- Bảng Recipes (Công thức nấu ăn)
CREATE TABLE Recipes (
    recipe_id INT PRIMARY KEY IDENTITY(1,1),
    recipe_name NVARCHAR(200) NOT NULL,
    description NVARCHAR(1000),
    ingredients NVARCHAR(MAX) NOT NULL, -- Nguyên liệu
    instructions NVARCHAR(MAX) NOT NULL, -- Các bước thực hiện
    cooking_time INT, -- Thời gian nấu (phút)
    servings INT, -- Số người ăn
    difficulty NVARCHAR(20), -- 'Dễ', 'Trung Bình', 'Khó'
    image_url NVARCHAR(500),
    category_id INT,
    created_by INT,
    created_date DATETIME DEFAULT GETDATE(),
    updated_date DATETIME,
    is_active BIT DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (created_by) REFERENCES Users(user_id)
);

-- Insert dữ liệu mẫu

-- Insert Users
INSERT INTO Users (username, password, full_name, email, role) VALUES
('admin', 'admin123', N'Đặng Việt Thắng', 'admin@gmail.com', 'admin'),
('anguyen', 'anguyen123', N'Nguyễn Văn A', 'NguyenA@gmail.com', 'user'),
('bdao', 'bdao123', N'Đào Thị B', 'DaoB@gmail.com', 'user');

-- Insert Categories
INSERT INTO Categories (category_name, description) VALUES
(N'Món Chính', N'Các món ăn chính trong bữa ăn'),
(N'Món Khai Vị', N'Các món ăn khai vị'),
(N'Món Tráng Miệng', N'Các món tráng miệng, bánh ngọt'),
(N'Món Soup', N'Các loại soup, canh'),
(N'Đồ Uống', N'Các loại đồ uống, nước ép'),
(N'Salad', N'Các món salad rau củ');

-- Insert Recipes
INSERT INTO Recipes (recipe_name, description, ingredients, instructions, cooking_time, servings, difficulty, image_url, category_id, created_by) VALUES
(N'Phở Bò Hà Nội', 
 N'Món phở bò truyền thống của Hà Nội với nước dùng thơm ngon', 
 N'500g bánh phở tươi, 500g thịt bò, 2 củ hành tây, 3 quả hồi, 2 thanh quế, gừng, hành lá, rau thơm',
 N'Bước 1: Hầm xương bò 3-4 tiếng\nBước 2: Rang gia vị (hồi, quế, gừng) cho thơm\nBước 3: Cho gia vị vào nước dùng\nBước 4: Trụng bánh phở\nBước 5: Bày thịt bò và chan nước dùng nóng\nBước 6: Thêm hành, rau thơm',
 240, 4, N'Trung Bình', 'pho-bo.jpg', 1, 1),

(N'Gỏi Cuốn Tôm Thịt',
 N'Món khai vị nhẹ nhàng, tươi mát với tôm và thịt',
 N'200g tôm, 200g thịt ba chỉ, bánh tráng, bún tươi, rau sống, đồ chua',
 N'Bước 1: Luộc tôm và thịt\nBước 2: Chuẩn bị rau sống và bún\nBước 3: Nhúng bánh tráng vào nước\nBước 4: Cuốn tất cả nguyên liệu\nBước 5: Ăn kèm với nước chấm',
 30, 4, N'Dễ', 'goi-cuon.jpg', 2, 1),

(N'Bánh Flan Caramen',
 N'Món tráng miệng mát lạnh, ngọt dịu',
 N'4 quả trứng, 500ml sữa tươi, 150g đường, 1 gói vani',
 N'Bước 1: Đun caramen\nBước 2: Đánh trứng với sữa và đường\nBước 3: Lọc hỗn hợp qua rây\nBước 4: Đổ vào khuôn đã có caramen\nBước 5: Hấp cách thủy 30-40 phút\nBước 6: Để nguội và cho vào tủ lạnh',
 60, 6, N'Dễ', 'flan.jpg', 3, 2),

(N'Canh Chua Cá',
 N'Món canh chua truyền thống miền Nam',
 N'500g cá lóc, 2 quả cà chua, me, đậu bắp, giá đỗ, thơm, bạc hà',
 N'Bước 1: Nấu nước me\nBước 2: Cho cà chua, thơm vào nấu\nBước 3: Cho cá vào nấu\nBước 4: Thêm rau và gia vị\nBước 5: Nêm nếm và tắt bếp',
 30, 4, N'Dễ', 'canh-chua.jpg', 4, 2),

(N'Sinh Tố Bơ',
 N'Thức uống bổ dưỡng từ bơ',
 N'2 quả bơ chín, 500ml sữa tươi, đường, đá viên',
 N'Bước 1: Bóc vỏ bơ và loại hạt\nBước 2: Cho bơ, sữa, đường vào máy xay\nBước 3: Xay nhuyễn\nBước 4: Thêm đá và xay thêm lần nữa\nBước 5: Rót ra ly và thưởng thức',
 10, 2, N'Dễ', 'sinh-to-bo.jpg', 5, 3),

(N'Salad Rau Trộn',
 N'Món salad rau củ tươi ngon, bổ dưỡng',
 N'Xà lách, cà chua, dưa chuột, cà rốt, hành tây, sốt salad',
 N'Bước 1: Rửa sạch rau củ\nBước 2: Thái nhỏ các loại rau\nBước 3: Trộn đều\nBước 4: Thêm sốt salad\nBước 5: Trộn đều và bày ra đĩa',
 15, 2, N'Dễ', 'salad.jpg', 6, 3);

GO



CREATE DATABASE RAPPHIM;
GO

USE RAPPHIM;
GO

/* SELECT name FROM sys.tables;
GO
*/

-- 3. Tạo các bảng --

-- Tài Khoản
CREATE TABLE TAIKHOAN (
    Idx INT IDENTITY(1,1),
    MaTaiKhoan AS CAST(RIGHT('0000000000' + CAST(Idx AS VARCHAR(10)), 10) AS VARCHAR(10)) PERSISTED PRIMARY KEY, 
    TenDangNhap VARCHAR(50) UNIQUE NOT NULL, 
    Email VARCHAR(100) UNIQUE NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,

    ---Ràng buộc tên đăng nhập: có độ dài lớn hơn 5 ký tự
    CONSTRAINT CK_TenDangNhap
        CHECK (LEN(TenDangNhap) > 5),
    -- Ràng buộc mật khẩu: độ dài lớn hơn 8 ký tự, bao gồm ít nhất 1 chữ số, 1 chữ hoa, 1 chữ thường và 1 ký tự đặc biệt
    CONSTRAINT CK_MatKhau
        CHECK (
            LEN(MatKhau) > 8 
            AND PATINDEX('%[0-9]%', MatKhau) > 0
            AND PATINDEX('%[a-z]%', MatKhau COLLATE Latin1_General_CS_AS) > 0
            AND PATINDEX('%[A-Z]%', MatKhau COLLATE Latin1_General_CS_AS) > 0
            AND PATINDEX('%[^a-zA-Z0-9]%', MatKhau) > 0
        ),
    -- Ràng buộc định dạng email cơ bản user@gmail.com
    CONSTRAINT CK_Email
        CHECK (Email LIKE '%_@__%.__%')
);
GO

-- Khách hàng thành viên
CREATE TABLE KHACHHANGTHANHVIEN (
    MaTaiKhoan VARCHAR(10) PRIMARY KEY,
    Ho NVARCHAR(50) NOT NULL,
    Ten NVARCHAR(50) NOT NULL,
    GioiTinh BIT, -- Quy ước: Nam 0 Nữ 1
    NgaySinh DATE,
    SoDienThoai VARCHAR(10) UNIQUE,
    LoaiThanhVien NVARCHAR(50) NOT NULL DEFAULT N'Thường', -- Bạc, Vàng, Kim cương
    TheThanhVien VARCHAR(20),
    DiemTichLuy INT DEFAULT 0,
    TongDiemTichLuy INT DEFAULT 0,
    
    -- Tạo khoá ngoại tham chiếu đến bảng TAIKHOAN
    CONSTRAINT FK_KhachHang_TaiKhoan
        FOREIGN KEY (MaTaiKhoan)
        REFERENCES TAIKHOAN(MaTaiKhoan)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Ràng buộc số điện thoại: bắt đầu bằng số 0 và có đúng 10 chữ số
    CONSTRAINT CK_SoDienThoaiKhachHang
        CHECK (SoDienThoai IS NULL OR (LEN(SoDienThoai) = 10 AND SoDienThoai LIKE '0%' AND PATINDEX('%[^0-9]%', SoDienThoai) = 0)),
    -- Ràng buộc ngày sinh: không được lớn hơn ngày hiện tại
    CONSTRAINT CK_NgaySinh
        CHECK (NgaySinh <= GETDATE() OR NgaySinh IS NULL),
    -- Ràng buộc loại thành viên
    CONSTRAINT CK_LoaiThanhVien
        CHECK (LoaiThanhVien IN (N'Thường', N'Bạc', N'Vàng', N'Kim cương')),
    -- Ràng buộc điểm tích lũy và tổng điểm tích lũy không âm
    CONSTRAINT CK_DiemTichLuyKhachHang
        CHECK (DiemTichLuy >= 0),
    CONSTRAINT CK_TongDiemTichLuy
        CHECK (TongDiemTichLuy >= 0)
    
);
GO


-- Giao dịch (Ví dụ: Mua vé xem phim, mua bắp nước) được tạo khi khách hàng xác nhận đặt vé và trước khi thanh toán.
-- Giao dịch
CREATE TABLE GIAODICH (
    Idx INT IDENTITY(1,1),
    MaGiaoDich AS CAST('GD' + RIGHT('00000000' + CAST(Idx AS VARCHAR(10)), 8) AS VARCHAR(10)) PERSISTED PRIMARY KEY, --- Mã giao dịch cần sinh tự động, có dạng GDXXXXXXXX (với X là chữ số)
    HinhThucThanhToan NVARCHAR(50),
    HinhThuc BIT NOT NULL, -- Hình thức giao dịch - 0: Trực tuyến 1: Trực tiếp 
    NgayGiaoDich DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    GioGiaoDich TIME NOT NULL DEFAULT CAST(GETDATE() AS TIME),
    -- Thêm 
    TrangThai BIT NOT NULL DEFAULT 0, -- Tình trạng giao dịch - 0: Hủy/Chưa hoàn tất 1: Hoàn tất
    TongTienBanDau DECIMAL(18, 0) DEFAULT 0,
    TienGiam DECIMAL(18, 0) DEFAULT 0,
    TongTienThanhToan DECIMAL(18, 0) DEFAULT 0,

    -- Ràng buộc hình thức thanh toán
    CONSTRAINT CK_HinhThucThanhToan
        CHECK (HinhThucThanhToan IN (N'Tiền mặt', N'Thẻ tín dụng', N'Ví điện tử', N'Chuyển khoản')),
    -- Ràng buộc giờ giao dịch không được lớn hơn giờ hiện tại nếu ngày giao dịch là ngày hiện tại
    CONSTRAINT CK_ThoiGianGiaoDich
        CHECK (NgayGiaoDich < CAST(GETDATE() AS DATE) OR GioGiaoDich <= CAST(GETDATE() AS TIME))
);
GO

-- Giao dịch trực tuyến 
CREATE TABLE GIAODICHTRUCTUYEN (
    MaGiaoDich VARCHAR(10) PRIMARY KEY,
    MaTaiKhoanKhachHang VARCHAR(10),
    DiemTichLuy INT,
    DanhGia TINYINT, -- (1-5 sao)
    
    -- Tạo khoá ngoại tham chiếu đến bảng GIAODICH
    CONSTRAINT FK_TrucTuyen_GiaoDich
        FOREIGN KEY (MaGiaoDich)
        REFERENCES GIAODICH(MaGiaoDich)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
        
    -- Tạo khoá ngoại tham chiếu đến bảng TAIKHOAN
    CONSTRAINT FK_TrucTuyen_KhachHang
        FOREIGN KEY (MaTaiKhoanKhachHang)
        REFERENCES KHACHHANGTHANHVIEN(MaTaiKhoan)
        ON DELETE SET NULL -- Xóa mtk giao dịch vẫn giữ
        ON UPDATE CASCADE,
    CONSTRAINT CK_DiemTichLuyTrucTuyen
        CHECK (DiemTichLuy >= 0 OR DiemTichLuy IS NULL),
    CONSTRAINT CK_GDTrucTuyen_DanhGia
        CHECK (DanhGia IS NULL OR (DanhGia >= 1 AND DanhGia <= 5)),
);
GO



-- Giao dịch trực tiếp
CREATE TABLE GIAODICHTRUCTIEP (
    MaGiaoDich VARCHAR(10) PRIMARY KEY,
    MaTaiKhoanKhachHang VARCHAR(10), /* Khách vãng lai dùng null */
    DiemTichLuy INT,
    DanhGia TINYINT, -- (1-5 sao)
    MaRap VARCHAR(10) NOT NULL,
    SoQuay INT NOT NULL,
    
    -- Tạo khoá ngoại tham chiếu đến bảng GIAODICH
    CONSTRAINT FK_TrucTiep_GiaoDich
        FOREIGN KEY (MaGiaoDich)
        REFERENCES GIAODICH(MaGiaoDich)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng TAIKHOAN
    CONSTRAINT FK_TrucTiep_KhachHang
        FOREIGN KEY (MaTaiKhoanKhachHang)
        REFERENCES KHACHHANGTHANHVIEN(MaTaiKhoan)
        -- ON DELETE SET NULL -- Xóa mtk giao dịch vẫn giữ
        -- ON UPDATE CASCADE,
        ON DELETE NO ACTION -- Xóa mtk giao dịch vẫn giữ
        ON UPDATE NO ACTION,

    CONSTRAINT CK_DiemTichLuyTrucTiep
        CHECK (DiemTichLuy >= 0 OR DiemTichLuy IS NULL),
    CONSTRAINT CK_GDTrucTiep_DanhGia
        CHECK (DanhGia IS NULL OR (DanhGia >= 1 AND DanhGia <= 5))
    
);
GO

-- Voucher
CREATE TABLE VOUCHER (
    Idx INT IDENTITY(1,1),
    MaVoucher AS CAST('VC' + RIGHT('00000000' + CAST(Idx AS VARCHAR(10)), 8) AS VARCHAR(10)) PERSISTED PRIMARY KEY,
    SoLuong INT NOT NULL,
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    PhamViApDung NVARCHAR(255) NOT NULL DEFAULT N'TOANBO', 
    /*
    N'TOANBO': Áp dụng cho toàn bộ đơn hàng.
    N'PHIM:P001': Chỉ áp dụng cho phim có mã P001.
    N'RAP:R01': Chỉ áp dụng khi đặt vé ở rạp R01.
    N'LOAIGHE:VIP': Chỉ áp dụng khi trong đơn hàng có ghế loại VIP.
    N'SANPHAM:SP002': Chỉ áp dụng cho sản phẩm (bắp/nước) có mã SP002.
    N'NGAY:T2,T3,T4': Chỉ áp dụng vào các ngày Thứ 2, 3, 4.
    */
    GiaTriGiamToiDa DECIMAL(18, 0), 
    PhanTram TINYINT, 
    GiaTri DECIMAL(18, 0), 
    QuaTang NVARCHAR(100),
    GioiHanMoiNguoi INT DEFAULT 1, -- Thêm
    ChiDanhChoThanhVien BIT DEFAULT 0,  -- Thêm

    -- Đảm bảo ít nhất 1 trong 3 cột này phải có giá trị
    CONSTRAINT Voucher_CoGiaTri
        CHECK (PhanTram IS NOT NULL OR GiaTri IS NOT NULL OR QuaTang IS NOT NULL),
    -- Số lượng phải lớn hơn 0
    CONSTRAINT CK_SoLuongVoucher
        CHECK (SoLuong >= 0),
    -- Ràng buộc ngày kết thúc phải sau ngày bắt đầu
    CONSTRAINT CK_NgayKetThuc
        CHECK (NgayKetThuc > NgayBatDau)

);
GO

-- Áp dụng 
CREATE TABLE APDUNG (
    MaGiaoDich VARCHAR(10),
    MaVoucher VARCHAR(10),
    
    PRIMARY KEY (MaGiaoDich, MaVoucher),

    -- Tạo khoá ngoại tham chiếu đến bảng GIAODICH
    CONSTRAINT FK_ApDung_GiaoDich
        FOREIGN KEY (MaGiaoDich)
        REFERENCES GIAODICH(MaGiaoDich)
        ON DELETE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng VOUCHER
    CONSTRAINT FK_ApDung_Voucher
        FOREIGN KEY (MaVoucher)
        REFERENCES VOUCHER(MaVoucher)
        ON DELETE NO ACTION -- RESTRICT
);
GO

-- Sản phẩm kèm
CREATE TABLE SANPHAMKEM (
    Idx INT IDENTITY(1,1),
    MaSanPham AS CAST('SPK' + RIGHT('0000000' + CAST(Idx AS VARCHAR(10)), 7) AS VARCHAR(10)) PERSISTED PRIMARY KEY,
    TenSanPham NVARCHAR(100) NOT NULL,
    LoaiSanPham NVARCHAR(50), 
    MoTa NVARCHAR(255),
    DonGia DECIMAL(18, 0) NOT NULL
);
GO

-- Mua kèm 
CREATE TABLE MUAKEM (
    MaGiaoDich VARCHAR(10),
    MaSanPham VARCHAR(10),
    SoLuong INT NOT NULL DEFAULT 1, 
    
    PRIMARY KEY (MaGiaoDich, MaSanPham),
    
    -- Tạo khoá ngoại tham chiếu đến bảng GIAODICH
    CONSTRAINT FK_MuaKem_GiaoDich
        FOREIGN KEY (MaGiaoDich)
        REFERENCES GIAODICH(MaGiaoDich)
        ON DELETE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng SANPHAMKEM
    CONSTRAINT FK_MuaKem_SanPham
        FOREIGN KEY (MaSanPham)
        REFERENCES SANPHAMKEM(MaSanPham)
        ON DELETE NO ACTION 
);
GO

-- Rạp
CREATE TABLE RAP (
    Idx INT IDENTITY(1,1),
    MaRap AS CAST('RAP' + RIGHT('0000000' + CAST(Idx AS VARCHAR(10)), 7) AS VARCHAR(10)) PERSISTED PRIMARY KEY,
    TenRap NVARCHAR(100) NOT NULL,
    DiaDiem NVARCHAR(255) NOT NULL,
    SoLuongPhongChieu INT NOT NULL,
    TinhTrang NVARCHAR(50) NOT NULL DEFAULT N'Hoạt động', -- Hoạt động/ Bảo trì

    -- Ràng buộc SỐ LƯỢNG PHÒNG CHIẾU PHẢI LỚN HƠN 0
    CONSTRAINT CK_SoLuongPhongChieu
        CHECK (SoLuongPhongChieu > 0),
    -- Ràng buộc TÌNH TRẠNG RẠP
    CONSTRAINT CK_TinhTrangRap
        CHECK (TinhTrang IN (N'Hoạt động', N'Bảo trì'))
);
GO

-- Phim
CREATE TABLE PHIM (
    Idx INT IDENTITY(1,1),
    MaPhim AS CAST('P' + RIGHT('000000000' + CAST(Idx AS VARCHAR(10)), 9) AS VARCHAR(10)) PERSISTED PRIMARY KEY,
    TenPhim NVARCHAR(255) NOT NULL,
    Poster NVARCHAR(MAX), /* Lưu link ảnh */
    Trailer NVARCHAR(MAX), /* Lưu link video */
    DoTuoiQuyDinh NVARCHAR(10) NOT NULL, /* Ví dụ: 'T18', 'P' */
    DaoDien NVARCHAR(255),
    NgayKhoiChieu DATE,
    NgayNgungChieu DATE,
    ThoiLuong INT, /* Thời lượng (phút) */
    QuocGiaSanXuat NVARCHAR(100),
    NamSanXuat INT,
    TinhTrang NVARCHAR(100), /* Sắp chiếu, Đang chiếu */
    MoTa NVARCHAR(MAX),
    -- Ràng buộc ĐỘ TUỔI QUY ĐỊNH
    CONSTRAINT CK_DoTuoiQuyDinh
        CHECK (DoTuoiQuyDinh IN (N'P', N'K',N'TP', N'T13', N'T16', N'T18', N'C')),
    -- Ràng buộc NGÀY NGHỈ CHIẾU PHẢI LỚN HƠN NGÀY KHỞI CHIẾU
    CONSTRAINT CK_NgayNgungChieu
        CHECK (NgayNgungChieu > NgayKhoiChieu OR NgayNgungChieu IS NULL),
    -- Ràng buộc NĂM SẢN XUẤT KHÔNG ĐƯỢC LỚN HƠN NĂM HIỆN TẠI
    CONSTRAINT CK_NamSanXuat
        CHECK (NamSanXuat <= YEAR(GETDATE())),
    -- Ràng buộc TÌNH TRẠNG PHIM
    CONSTRAINT CK_TinhTrangPhim
        CHECK (TinhTrang IN (N'Sắp chiếu', N'Đang chiếu', N'Ngừng chiếu'))
);
GO

-- Diễn viên
CREATE TABLE DIENVIEN (
    MaPhim VARCHAR(10),
    DienVien NVARCHAR(100),

    PRIMARY KEY (MaPhim, DienVien),

    -- Tạo khoá ngoại tham chiếu đến bảng PHIM
    CONSTRAINT FK_DienVien_Phim
        FOREIGN KEY (MaPhim) 
        REFERENCES PHIM(MaPhim)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);
GO

-- Thể loại
CREATE TABLE THELOAI (
    MaPhim VARCHAR(10),
    TheLoai NVARCHAR(100),

    PRIMARY KEY (MaPhim, TheLoai),

    -- Tạo khoá ngoại tham chiếu đến bảng PHIM
    CONSTRAINT FK_TheLoai_Phim
        FOREIGN KEY (MaPhim) 
        REFERENCES PHIM(MaPhim)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);
GO

-- Quầy
CREATE TABLE QUAY (
    MaRap VARCHAR(10),
    SoQuay INT,

    PRIMARY KEY (MaRap, SoQuay),

    -- Tạo khoá ngoại tham chiếu đến bảng RAP
    CONSTRAINT FK_Quay_Rap
        FOREIGN KEY (MaRap) 
        REFERENCES RAP(MaRap)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
);
GO

-- Phòng chiếu
CREATE TABLE PHONGCHIEU (
    MaRap VARCHAR(10),
    SoThuTuPhong INT,
    LoaiPhong NVARCHAR(50) NOT NULL, /* 2D, 3D, IMAX */
    SucChua INT,
    TrangThai NVARCHAR(50), /* Sẵn sàng, Bảo trì */

    PRIMARY KEY (MaRap, SoThuTuPhong),

    -- Tạo khoá ngoại tham chiếu đến bảng RAP
    CONSTRAINT FK_PhongChieu_Rap
        FOREIGN KEY (MaRap) 
        REFERENCES RAP(MaRap)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    CONSTRAINT CK_SoThuTuPhong
        CHECK (SoThuTuPhong > 0),
    CONSTRAINT CK_SucChua
        CHECK (SucChua > 0),
    CONSTRAINT CK_LoaiPhong
        CHECK (LoaiPhong IN (N'2D', N'3D', N'IMAX',N'4DX')),
    CONSTRAINT CK_TrangThaiPhong
        CHECK (TrangThai IN (N'Sẵn sàng', N'Bảo trì'))
);
GO

-- Suất chiếu
CREATE TABLE SUATCHIEU (
    MaPhim VARCHAR(10),
    MaRap VARCHAR(10),
    SoThuTuPhong INT,
    NgayChieu DATE,
    ThoiGianBatDau TIME NOT NULL,
    ThoiGianKetThuc TIME ,
    DinhDangChieu NVARCHAR(50), --- 2D, 3D, IMAX
    TrangThai NVARCHAR(50) NOT NULL,
    NgonNguPhuDe NVARCHAR(50),

    PRIMARY KEY (MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau),

    -- Tạo khoá ngoại tham chiếu đến bảng PHONGCHIEU
    CONSTRAINT FK_SuatChieu_PhongChieu
        FOREIGN KEY (MaRap, SoThuTuPhong) 
        REFERENCES PHONGCHIEU(MaRap, SoThuTuPhong)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng PHIM
    CONSTRAINT FK_SuatChieu_Phim
        FOREIGN KEY (MaPhim) 
        REFERENCES PHIM(MaPhim)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    CONSTRAINT CK_ThoiGianKetThuc
        CHECK (ThoiGianKetThuc > ThoiGianBatDau AND ThoiGianKetThuc < '22:00:00'),
    CONSTRAINT CK_ThoiGianBatDau
        CHECK (ThoiGianBatDau >= '08:00:00'),
    CONSTRAINT CK_TrangThaiSuatChieu
        CHECK (TrangThai IN (N'Chưa chiếu', N'Đang chiếu', N'Kết thúc')),
    CONSTRAINT CK_NgonNguPhuDe
        CHECK (NgonNguPhuDe IN (N'Phụ đề', N'Lồng tiếng', N'Không'))
);
GO

-- Chỗ ngồi
CREATE TABLE CHONGOI (
    MaRap VARCHAR(10),
    SoThuTuPhong INT,
    SoThuTuCho INT,
    Da_y VARCHAR(5), -- A, B, C, ... 
    LoaiGhe NVARCHAR(50), -- Thường, VIP, Đôi
    TrangThai NVARCHAR(50), -- Sẵn sàng, Đang hỏng
    -- MaVe VARCHAR(10) UNIQUE, 

    PRIMARY KEY (MaRap, SoThuTuPhong, SoThuTuCho, Da_y),

    -- Tạo khoá ngoại tham chiếu đến bảng PHONGCHIEU
    CONSTRAINT FK_ChoNgoi_PhongChieu
        FOREIGN KEY (MaRap, SoThuTuPhong) 
        REFERENCES PHONGCHIEU(MaRap, SoThuTuPhong)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng VE
    -- CONSTRAINT FK_ChoNgoi_Ve
    --     FOREIGN KEY (MaVe) 
    --     REFERENCES VE(MaVe)
    --     ON DELETE SET NULL 
    --     ON UPDATE CASCADE
    CONSTRAINT CK_SoThuTuCho
        CHECK (SoThuTuCho > 0),
    CONSTRAINT CK_Da_y
        CHECK (Da_y LIKE '[A-Z]%'),
    CONSTRAINT CK_LoaiGhe
        CHECK (LoaiGhe IN (N'Thường', N'VIP', N'Đôi')),
    CONSTRAINT CK_TrangThaiGhe
        CHECK (TrangThai IN (N'Sẵn sàng', N'Đang hỏng'))
);
GO

-- Vé
CREATE TABLE VE (
    Idx INT IDENTITY(1,1),
    MaVe AS CAST('VE' + RIGHT('00000000' + CAST(Idx AS VARCHAR(10)), 8) AS VARCHAR(10)) PERSISTED PRIMARY KEY,
    LoaiVe NVARCHAR(50),
    TrangThai NVARCHAR(50),
    Gia DECIMAL(18, 0),
    -- Thông tin giao dịch
    MaGiaoDich VARCHAR(10),
    -- Thông tin suất chiếu
    MaPhim VARCHAR(10),
    MaRap VARCHAR(10),
    SoThuTuPhong INT,
    NgayChieu DATE,
    ThoiGianBatDau TIME NOT NULL,
    -- Thông tin chỗ ngồi
    MaRap_ChoNgoi VARCHAR(10),
    SoThuTuPhong_ChoNgoi INT,
    SoThuTuCho INT,
    Da_y VARCHAR(5),

    -- Tạo khoá ngoại tham chiếu đến bảng SUATCHIEU
    CONSTRAINT FK_Ve_SuatChieu
        FOREIGN KEY (MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau) 
        REFERENCES SUATCHIEU(MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau)
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION, /* Không cho xóa suất chiếu nếu đã có vé */
    
    -- Tạo khoá ngoại tham chiếu đến bảng GIAODICH
    CONSTRAINT FK_Ve_GiaoDich
        FOREIGN KEY (MaGiaoDich) 
        REFERENCES GIAODICH(MaGiaoDich)
        ON DELETE SET NULL 
        ON UPDATE CASCADE, /* Xóa giao dịch thì vé vẫn còn nhưng không rõ GĐ nào */

    -- Tạo khoá ngoại tham chiếu đến bảng CHONGOI
    CONSTRAINT FK_Ve_ChoNgoi
        FOREIGN KEY (MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y)
        REFERENCES CHONGOI(MaRap, SoThuTuPhong, SoThuTuCho, Da_y)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    
    CONSTRAINT CK_VE_GiaVe_LonHonKhong
        CHECK (Gia > 0),
    
    CONSTRAINT CK_TrangThai
        CHECK (TrangThai IN (N'Trống', N'Đang chọn', N'Đã chọn')),

    -- CONSTRAINT CK_LoaiVe
    --     CHECK (LoaiVe IN (N'VIP', N'Thường', N'Đôi'))
);
GO



-- Đánh giá phim
CREATE TABLE DANHGIAPHIM (
    MaTaiKhoan VARCHAR(10),
    MaPhim VARCHAR(10),
    Diem INT NOT NULL, 
    NoiDungDanhGia NVARCHAR(MAX),
    ThoiGianDanhGia DATETIME NOT NULL DEFAULT GETDATE(),

    PRIMARY KEY (MaTaiKhoan, MaPhim),

    -- Tạo khoá ngoại tham chiếu đến bảng KHACHHANG
    CONSTRAINT FK_DanhGia_KhachHang
        FOREIGN KEY (MaTaiKhoan) 
        REFERENCES KHACHHANGTHANHVIEN(MaTaiKhoan)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng PHIM
    CONSTRAINT FK_DanhGia_Phim
        FOREIGN KEY (MaPhim) 
        REFERENCES PHIM(MaPhim)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);
GO

-- Được chiếu tại
CREATE TABLE DUOCCHIEUTAI (              
    MaPhim VARCHAR(10),
    MaRap VARCHAR(10),

    PRIMARY KEY (MaPhim, MaRap),

    -- Tạo khoá ngoại tham chiếu đến bảng PHIM
    CONSTRAINT FK_DuocChieuTai_Phim
        FOREIGN KEY (MaPhim)
        REFERENCES PHIM(MaPhim)
        ON DELETE CASCADE, 

    -- Tạo khoá ngoại tham chiếu đến bảng RAP
    CONSTRAINT FK_DuocChieuTai_Rap
        FOREIGN KEY (MaRap)
        REFERENCES RAP(MaRap)
        ON DELETE CASCADE 
);
GO

-- Nhân sự
CREATE TABLE NHANSU (
    MaTaiKhoan VARCHAR(10) PRIMARY KEY,
    CCCD VARCHAR(12) UNIQUE NOT NULL,
    Ho NVARCHAR(50) NOT NULL,
    Ten NVARCHAR(50) NOT NULL,
    GioiTinh BIT, -- 0: Nam 1: Nữ
    SoDienThoai VARCHAR(10) NOT NULL,
    DiaChiLienLac NVARCHAR(255) NOT NULL,
    VaiTro NVARCHAR(50) NOT NULL, /* Quản lý, Thu ngân, Soát vé */
    NgayBatDauCongViec DATE NOT NULL,
    TrangThaiLamViec NVARCHAR(50) NOT NULL,
    MaTaiKhoanQuanLy VARCHAR(10) , 
    MaRap VARCHAR(10) NOT NULL,

    -- Tạo khoá ngoại tham chiếu đến bảng TAIKHOAN
    CONSTRAINT FK_NhanSu_TaiKhoan
        FOREIGN KEY (MaTaiKhoan) 
        REFERENCES TAIKHOAN(MaTaiKhoan)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    -- Tạo khoá ngoại tham chiếu đến bảng RAP
    CONSTRAINT FK_NhanSu_Rap
        FOREIGN KEY (MaRap) 
        REFERENCES RAP(MaRap)
        ON DELETE NO ACTION -- Rạp có nhân sự không xóa
        ON UPDATE CASCADE,

    -- Tạo khoá ngoại tham chiếu đến bảng NHANSU (Quản lý)

    
    CONSTRAINT CK_SoDienThoaiNhanSu
        CHECK (LEN(SoDienThoai) = 10 AND SoDienThoai LIKE '0%' AND PATINDEX('%[^0-9]%', SoDienThoai) = 0),
    CONSTRAINT CK_VaiTro
        CHECK (VaiTro IN (N'Quản lý', N'Thu ngân', N'Soát vé')),
    CONSTRAINT CK_TrangThaiLamViec
        CHECK (TrangThaiLamViec IN (N'Đang làm việc', N'Đã nghỉ việc')),
    CONSTRAINT CK_NgayBatDauCongViec
        CHECK (NgayBatDauCongViec <= GETDATE())
);
GO

-- Ca trực
CREATE TABLE CATRUC (
    MaTaiKhoan VARCHAR(10),
    NgayTruc DATE,
    BuoiTruc NVARCHAR(50), -- Sáng, chiều, tối

    PRIMARY KEY (MaTaiKhoan, NgayTruc, BuoiTruc),

    -- Tạo khoá ngoại tham chiếu đến bảng NHANSU
    CONSTRAINT FK_CaTruc_NhanSu
        FOREIGN KEY (MaTaiKhoan) 
        REFERENCES NHANSU(MaTaiKhoan)
        ON DELETE CASCADE 
        ON UPDATE CASCADE
);
GO

-- Thu ngân
CREATE TABLE THUNGAN (
    MaTaiKhoan VARCHAR(10) PRIMARY KEY,
    MaRap VARCHAR(10),
    SoQuay INT,

    -- Tạo khoá ngoại tham chiếu đến bảng NHANSU 
    CONSTRAINT FK_ThuNgan_NhanSu
        FOREIGN KEY (MaTaiKhoan) 
        REFERENCES NHANSU(MaTaiKhoan)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng QUAY
    CONSTRAINT FK_ThuNgan_Quay
        FOREIGN KEY (MaRap, SoQuay) 
        REFERENCES QUAY(MaRap, SoQuay)
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION
);
GO

-- Soát vé
CREATE TABLE SOATVE (
    MaTaiKhoan VARCHAR(10) PRIMARY KEY,
    MaRap VARCHAR(10),
    SoThuTuPhong INT,

    -- Tạo khoá ngoại tham chiếu đến bảng NHANSU 
    CONSTRAINT FK_SoatVe_NhanSu
        FOREIGN KEY (MaTaiKhoan) 
        REFERENCES NHANSU(MaTaiKhoan)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Tạo khoá ngoại tham chiếu đến bảng PHONGCHIEU
    CONSTRAINT FK_SoatVe_PhongChieu
        FOREIGN KEY (MaRap, SoThuTuPhong) 
        REFERENCES PHONGCHIEU(MaRap, SoThuTuPhong)
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION
);
GO

-- Quản lý
CREATE TABLE QUANLY (
    MaTaiKhoan VARCHAR(10) PRIMARY KEY,
    MaRap VARCHAR(10),

    -- Tạo khoá ngoại tham chiếu đến bảng NHANSU 
    CONSTRAINT FK_QuanLy_NhanSu
        FOREIGN KEY (MaTaiKhoan) 
        REFERENCES NHANSU(MaTaiKhoan)
        ON DELETE CASCADE 
        ON UPDATE CASCADE,

    -- Tạo khoá ngoại tham chiếu đến bảng RAP
    CONSTRAINT FK_QuanLy_Rap
        FOREIGN KEY (MaRap) 
        REFERENCES RAP(MaRap)
        ON DELETE NO ACTION 
        ON UPDATE NO ACTION
);
GO

-- Tạo khoá ngoại tham chiếu từ GIAODICHTRUCTIEP đến bảng QUAY
ALTER TABLE GIAODICHTRUCTIEP
ADD CONSTRAINT FK_TrucTiep_Quay
    FOREIGN KEY (MaRap, SoQuay) 
    REFERENCES QUAY(MaRap, SoQuay)
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;
GO

-- Tạo khoá ngoại tham chiếu từ NHANSU đến bảng QUANLY
ALTER TABLE NHANSU
ADD CONSTRAINT FK_NhanSu_QuanLy
    FOREIGN KEY (MaTaiKhoanQuanLy) 
    REFERENCES QUANLY(MaTaiKhoan)
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION;
GO

-- USE master;
-- GO

-- DROP DATABASE IF EXISTS RAPPHIM;
-- GO

-- USE master;
-- GO

-- -- 1. Đặt database về chế độ 1 người dùng và "đá" tất cả kết nối khác ra
-- ALTER DATABASE RAPPHIM SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
-- GO

-- -- 2. Ngay lập tức xóa nó
-- DROP DATABASE RAPPHIM;
-- GO

-- CÔNG VINH SỬA: TẤT CẢ BÊN DƯỚI 
-- ALTER TABLE GIAODICH
-- ADD 
--    TongTienBanDau DECIMAL(18, 0) DEFAULT 0 WITH VALUES,
--    TienGiam DECIMAL(18, 0) DEFAULT 0 WITH VALUES,
--    TongTienThanhToan DECIMAL(18, 0) DEFAULT 0 WITH VALUES;
-- GO

-- ALTER TABLE VOUCHER
-- ADD GioiHanMoiNguoi INT DEFAULT 1 WITH VALUES;
-- GO



CREATE TABLE BANGGIAVE (
    Idx INT IDENTITY(1,1),
    MaBangGia AS CAST('BG' + RIGHT('0000' + CAST(Idx AS VARCHAR(5)), 4) AS VARCHAR(10)) PERSISTED PRIMARY KEY,
    DinhDangChieu NVARCHAR(50) NOT NULL, -- Ví dụ: 2D, 3D, IMAX
    LoaiGhe NVARCHAR(50) NOT NULL,       -- Ví dụ: Thường, VIP, Đôi
    GiaTien DECIMAL(18, 0) NOT NULL CHECK (GiaTien >= 0),
    
    -- Đảm bảo không có 2 dòng trùng nhau về định dạng và loại ghế
    CONSTRAINT UQ_BangGia UNIQUE (DinhDangChieu, LoaiGhe)
);
GO



-- ALTER TABLE VOUCHER
-- ADD ChiDanhChoThanhVien BIT DEFAULT 0 WITH VALUES; -- 0: Public (Ai cũng dùng đc), 1: Chỉ thành viên
-- GO

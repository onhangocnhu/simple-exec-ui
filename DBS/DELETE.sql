USE RAPPHIM;
GO

/* 1. XÓA CÁC BẢNG PHỤ THUỘC NHIỀU NHẤT (LEAF) */

-- Vé phụ thuộc GIAODICH, SUATCHIEU, CHONGOI
DELETE FROM VE;

-- Đánh giá phim phụ thuộc KHACHHANGTHANHVIEN, PHIM
DELETE FROM DANHGIAPHIM;

-- Được chiếu tại phụ thuộc PHIM, RAP
DELETE FROM DUOCCHIEUTAI;

-- Diễn viên, thể loại phụ thuộc PHIM
DELETE FROM DIENVIEN;
DELETE FROM THELOAI;

-- Áp dụng voucher & mua kèm phụ thuộc GIAODICH, VOUCHER, SANPHAMKEM
DELETE FROM APDUNG;
DELETE FROM MUAKEM;

-- Ca trực, thu ngân, soát vé phụ thuộc NHANSU / QUAY / PHONGCHIEU
DELETE FROM CATRUC;
DELETE FROM THUNGAN;
DELETE FROM SOATVE;

-- Chỗ ngồi & suất chiếu phụ thuộc PHONGCHIEU, PHIM
DELETE FROM CHONGOI;
DELETE FROM SUATCHIEU;

/* 2. XÓA CÁC BẢNG TRUNG GIAN */

-- Giao dịch con (trực tuyến / trực tiếp) phụ thuộc GIAODICH
DELETE FROM GIAODICHTRUCTUYEN;
DELETE FROM GIAODICHTRUCTIEP;

-- Phòng chiếu & quầy phụ thuộc RAP
DELETE FROM PHONGCHIEU;
DELETE FROM QUAY;

/* 3. XÓA CÁC BẢNG GỐC HƠN */

-- Giao dịch (cha của rất nhiều bảng)
DELETE FROM GIAODICH;

-- Sản phẩm kèm, voucher, bảng giá
DELETE FROM SANPHAMKEM;
DELETE FROM VOUCHER;
DELETE FROM BANGGIAVE;

-- Nhân sự, khách hàng, quản lý phụ thuộc TAIKHOAN / RAP
DELETE FROM NHANSU;
DELETE FROM KHACHHANGTHANHVIEN;
DELETE FROM QUANLY;

-- Rạp & phim
DELETE FROM RAP;
DELETE FROM PHIM;

-- Cuối cùng: tài khoản
DELETE FROM TAIKHOAN;
GO

/* 4. RESEED LẠI CÁC BẢNG CÓ IDENTITY(Idx) */

-- Tài khoản
DBCC CHECKIDENT ('TAIKHOAN', RESEED, 0);
-- Giao dịch
DBCC CHECKIDENT ('GIAODICH', RESEED, 0);
-- Voucher
DBCC CHECKIDENT ('VOUCHER', RESEED, 0);
-- Sản phẩm kèm
DBCC CHECKIDENT ('SANPHAMKEM', RESEED, 0);
-- Rạp
DBCC CHECKIDENT ('RAP', RESEED, 0);
-- Phim
DBCC CHECKIDENT ('PHIM', RESEED, 0);
-- Vé
DBCC CHECKIDENT ('VE', RESEED, 0);
-- Bảng giá vé
DBCC CHECKIDENT ('BANGGIAVE', RESEED, 0);
GO

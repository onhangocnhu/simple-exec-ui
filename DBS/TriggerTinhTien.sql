USE RAPPHIM;
GO

CREATE OR ALTER TRIGGER trg_TinhTienVe
ON VE
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Cập nhật giá cho từng vé (Chỉ chạy khi Insert/Update)
    IF EXISTS (SELECT * FROM INSERTED)
    BEGIN
        UPDATE V
        SET V.Gia = ISNULL(BGV.GiaTien, 1) 
        FROM VE V
        JOIN INSERTED I ON V.MaVe = I.MaVe
        JOIN SUATCHIEU SC ON V.MaPhim = SC.MaPhim 
                          AND V.MaRap = SC.MaRap 
                          AND V.SoThuTuPhong = SC.SoThuTuPhong 
                          AND V.NgayChieu = SC.NgayChieu 
                          AND V.ThoiGianBatDau = SC.ThoiGianBatDau
        -- JOIN VÀO BẢNG GIÁ ĐỂ LẤY TIỀN
        LEFT JOIN BANGGIAVE BGV ON SC.DinhDangChieu = BGV.DinhDangChieu 
                                AND V.LoaiVe = BGV.LoaiGhe;
    END

    -- 2. Tính toán lại Tổng Tiền Giao Dịch
    DECLARE @DanhSachGiaoDich TABLE (MaGD VARCHAR(10));
    INSERT INTO @DanhSachGiaoDich
    SELECT MaGiaoDich FROM INSERTED UNION SELECT MaGiaoDich FROM DELETED;
    --DELETE FROM APDUNG WHERE MaGiaoDich IN (SELECT MaGD FROM @DanhSachGiaoDich);
    UPDATE GD
    SET 
        -- Tổng Tiền Ban Đầu = Tổng Vé
        GD.TongTienBanDau = ISNULL(Total.TienVe, 0),
        
        -- Reset Voucher về 0 (Logic tuần tự: Sửa vé -> Hủy bước thanh toán cũ)
        GD.TienGiam = 0,
        GD.TongTienThanhToan = ISNULL(Total.TienVe, 0)
    FROM GIAODICH GD
    JOIN @DanhSachGiaoDich D ON GD.MaGiaoDich = D.MaGD
    CROSS APPLY (SELECT SUM(Gia) AS TienVe FROM VE WHERE MaGiaoDich = GD.MaGiaoDich) AS Total;
END;
GO

CREATE OR ALTER TRIGGER trg_TinhTienDoAn
ON MUAKEM
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DanhSachGiaoDich TABLE (MaGD VARCHAR(10));
    INSERT INTO @DanhSachGiaoDich
    SELECT MaGiaoDich FROM INSERTED UNION SELECT MaGiaoDich FROM DELETED;

    UPDATE GD
    SET 
        GD.TongTienBanDau = ISNULL(Total.TienVe, 0) + ISNULL(Total.TienBap, 0),
        
        -- Reset Voucher về 0
        GD.TienGiam = 0,
        GD.TongTienThanhToan = ISNULL(Total.TienVe, 0) + ISNULL(Total.TienBap, 0)
    FROM GIAODICH GD
    JOIN @DanhSachGiaoDich D ON GD.MaGiaoDich = D.MaGD
    CROSS APPLY (
        SELECT 
            (SELECT SUM(Gia) FROM VE WHERE MaGiaoDich = GD.MaGiaoDich) AS TienVe,
            (SELECT SUM(MK.SoLuong * SP.DonGia) FROM MUAKEM MK JOIN SANPHAMKEM SP ON MK.MaSanPham = SP.MaSanPham WHERE MK.MaGiaoDich = GD.MaGiaoDich) AS TienBap
    ) AS Total;
END;
GO


CREATE OR ALTER TRIGGER trg_KiemTraDieuKienVoucher
ON APDUNG
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    SET LANGUAGE us_english;

    DECLARE @MaGD VARCHAR(10), @MaVoucher VARCHAR(10);
    DECLARE @PhamVi NVARCHAR(255), @NgayBD DATE, @NgayKT DATE, @SoLuongCon INT;
    DECLARE @GioiHanMoiNguoi INT; 
    DECLARE @ChiDanhChoThanhVien BIT;
    DECLARE @NgayGD DATE;
    
    -- Biến thông tin khách hàng
    DECLARE @NguoiDung_MaTK VARCHAR(10);

    -- Biến kiểm tra phạm vi
    DECLARE @GiaTriThamChieu NVARCHAR(50);
    DECLARE @ThuTrongTuan VARCHAR(5), @ThuTiengAnh NVARCHAR(20);

    SELECT @MaGD = MaGiaoDich, @MaVoucher = MaVoucher FROM INSERTED;
    
    -- 0. KIỂM TRA ĐÃ ÁP DỤNG CHƯA
    IF EXISTS (SELECT 1 FROM APDUNG WHERE MaGiaoDich = @MaGD AND MaVoucher = @MaVoucher)
    BEGIN
        RAISERROR(N'Voucher này đã được áp dụng cho giao dịch này rồi, không thể áp dụng lại!', 16, 1);
        RETURN; 
    END

    -- 1. LẤY THÔNG TIN VOUCHER
    SELECT @PhamVi = PhamViApDung, 
           @NgayBD = NgayBatDau, 
           @NgayKT = NgayKetThuc, 
           @SoLuongCon = SoLuong,
           @GioiHanMoiNguoi = GioiHanMoiNguoi,     -- Số lượt tối đa 1 người (NULL = Ko giới hạn)
           @ChiDanhChoThanhVien = ChiDanhChoThanhVien -- 0: Public, 1: Member Only
    FROM VOUCHER WHERE MaVoucher = @MaVoucher;

    -- 2. LẤY THÔNG TIN NGƯỜI DÙNG TỪ GIAO DỊCH
    -- Join cả 2 bảng Trực tuyến và Trực tiếp để lấy mã khách hàng
    SELECT 
        @NgayGD = GD.NgayGiaoDich,
        @NguoiDung_MaTK = COALESCE(GDT.MaTaiKhoanKhachHang, GDTT.MaTaiKhoanKhachHang)
    FROM GIAODICH GD
    LEFT JOIN GIAODICHTRUCTUYEN GDT ON GD.MaGiaoDich = GDT.MaGiaoDich
    LEFT JOIN GIAODICHTRUCTIEP GDTT ON GD.MaGiaoDich = GDTT.MaGiaoDich
    WHERE GD.MaGiaoDich = @MaGD;

    -- 3. KIỂM TRA CƠ BẢN (TỔNG SỐ LƯỢNG & THỜI GIAN)
    IF @SoLuongCon <= 0
    BEGIN
        RAISERROR(N'Voucher này đã hết tổng số lượng phát hành!', 16, 1);
        RETURN;
    END

    IF @NgayGD < @NgayBD OR @NgayGD > @NgayKT
    BEGIN
        RAISERROR(N'Voucher chưa đến ngày hoặc đã hết hạn sử dụng!', 16, 1);
        RETURN;
    END

    -- 4. PHÂN LOẠI KHÁCH HÀNG & KIỂM TRA ĐIỀU KIỆN 

    -- TRƯỜNG HỢP 1: KHÁCH VÃNG LAI (MÃ TÀI KHOẢN LÀ NULL)
    IF @NguoiDung_MaTK IS NULL
    BEGIN
        -- Điều kiện 1: Nếu Voucher là Member Only -> CHẶN
        IF @ChiDanhChoThanhVien = 1
        BEGIN
            RAISERROR(N'Voucher này chỉ dành cho khách hàng thành viên. Khách vãng lai không thể sử dụng!', 16, 1);
            RETURN;
        END

        -- Điều kiện 2: Nếu Voucher có GIỚI HẠN SỐ LƯỢNG (Giới hạn lượt dùng/người) -> CHẶN
        IF @GioiHanMoiNguoi IS NOT NULL
        BEGIN
            RAISERROR(N'Khách vãng lai chỉ được dùng Voucher Public (không giới hạn lượt dùng). Vui lòng đăng ký thành viên để dùng Voucher này!', 16, 1);
            RETURN;
        END

    END

    -- TRƯỜNG HỢP 2: KHÁCH HÀNG THÀNH VIÊN (MÃ TÀI KHOẢN KHÁC NULL)
    ELSE 
    BEGIN
        -- Thành viên được dùng MemberOnly và Public, nên chỉ cần kiểm tra số lượt dùng
        IF @GioiHanMoiNguoi IS NOT NULL
        BEGIN
            DECLARE @SoLanDaDung INT = 0;
            
            -- Đếm số lần khách hàng này (dựa trên MaTaiKhoan) đã dùng mã này
            SELECT @SoLanDaDung = COUNT(*)
            FROM APDUNG AD
            JOIN GIAODICH GD ON AD.MaGiaoDich = GD.MaGiaoDich
            LEFT JOIN GIAODICHTRUCTUYEN GDT ON GD.MaGiaoDich = GDT.MaGiaoDich
            LEFT JOIN GIAODICHTRUCTIEP GDTT ON GD.MaGiaoDich = GDTT.MaGiaoDich
            WHERE AD.MaVoucher = @MaVoucher
              AND (GDT.MaTaiKhoanKhachHang = @NguoiDung_MaTK OR GDTT.MaTaiKhoanKhachHang = @NguoiDung_MaTK);

            IF @SoLanDaDung >= @GioiHanMoiNguoi
            BEGIN
                RAISERROR(N'Bạn đã vượt quá số lần sử dụng cho phép của Voucher này!', 16, 1);
                RETURN;
            END
        END
    END



    -- 5. KIỂM TRA PHẠM VI ÁP DỤNG (PHIM, RẠP, SUẤT CHIẾU...)
    DECLARE @HopLe BIT = 0;

    IF @PhamVi = N'TOANBO' SET @HopLe = 1;
    ELSE IF @PhamVi LIKE 'PHIM:%' BEGIN
        SET @GiaTriThamChieu = SUBSTRING(@PhamVi, 6, LEN(@PhamVi));
        IF EXISTS (SELECT 1 FROM VE WHERE MaGiaoDich = @MaGD AND MaPhim = @GiaTriThamChieu) SET @HopLe = 1;
    END
    ELSE IF @PhamVi LIKE 'RAP:%' BEGIN
        SET @GiaTriThamChieu = SUBSTRING(@PhamVi, 5, LEN(@PhamVi));
        IF EXISTS (SELECT 1 FROM VE WHERE MaGiaoDich = @MaGD AND MaRap = @GiaTriThamChieu) 
            OR EXISTS (SELECT 1 FROM GIAODICHTRUCTIEP WHERE MaGiaoDich = @MaGD AND MaRap = @GiaTriThamChieu) SET @HopLe = 1;
    END
    ELSE IF @PhamVi LIKE 'LOAIGHE:%' BEGIN
    SET @GiaTriThamChieu = SUBSTRING(@PhamVi, 9, LEN(@PhamVi));
    IF EXISTS (SELECT 1 FROM VE WHERE MaGiaoDich = @MaGD AND LoaiVe = @GiaTriThamChieu) SET @HopLe = 1; 
    END
    ELSE IF @PhamVi LIKE 'SANPHAM:%' BEGIN
        SET @GiaTriThamChieu = SUBSTRING(@PhamVi, 9, LEN(@PhamVi));
        IF EXISTS (SELECT 1 FROM MUAKEM WHERE MaGiaoDich = @MaGD AND MaSanPham = @GiaTriThamChieu) SET @HopLe = 1;
    END
    ELSE IF @PhamVi LIKE 'NGAY:%' BEGIN
        SET @GiaTriThamChieu = SUBSTRING(@PhamVi, 6, LEN(@PhamVi));
        SET @ThuTiengAnh = DATENAME(WEEKDAY, @NgayGD); 
        SET @ThuTrongTuan = CASE 
            WHEN @ThuTiengAnh = 'Monday' THEN 'T2'
            WHEN @ThuTiengAnh = 'Tuesday' THEN 'T3'
            WHEN @ThuTiengAnh = 'Wednesday' THEN 'T4'
            WHEN @ThuTiengAnh = 'Thursday' THEN 'T5'
            WHEN @ThuTiengAnh = 'Friday' THEN 'T6'
            WHEN @ThuTiengAnh = 'Saturday' THEN 'T7'
            WHEN @ThuTiengAnh = 'Sunday' THEN 'CN'
        END;
        IF CHARINDEX(@ThuTrongTuan, @GiaTriThamChieu) > 0 SET @HopLe = 1;
    END

    -- 6. KIỂM TRA ĐỦ ĐIỂM TÍCH LŨY ĐỂ ĐỔI VOUCHER 
    DECLARE @SoDiemQuyDoi INT;

    SELECT @SoDiemQuyDoi = SoDiemQuyDoi
    FROM VOUCHER
    WHERE MaVoucher = @MaVoucher;
    -- Chi chay neu nhu la voucher doi diem tich luy
    IF @SoDiemQuyDoi IS NOT NULL AND @SoDiemQuyDoi > 0
    BEGIN
    -- Khach vang lai khong duoc xai voucher doi diem
        IF @NguoiDung_MaTK IS NULL SET @HopLe = 0;

        IF EXISTS (
            SELECT 1
            FROM KHACHHANGTHANHVIEN
            WHERE MaTaiKhoan = @NguoiDung_MaTK
            AND DiemTichLuy < @SoDiemQuyDoi
        ) SET @HopLe = 0;      
    END;


    -- 7. CHỐT KẾT QUẢ
    IF @HopLe = 1
    BEGIN
        INSERT INTO APDUNG (MaGiaoDich, MaVoucher) VALUES (@MaGD, @MaVoucher);
        
        -- Cập nhật số lượng voucher còn lại
        UPDATE VOUCHER SET SoLuong = SoLuong - 1 WHERE MaVoucher = @MaVoucher AND SoLuong > 0;
        
        IF @@ROWCOUNT = 0
        BEGIN
             DELETE FROM APDUNG WHERE MaGiaoDich = @MaGD AND MaVoucher = @MaVoucher;
             RAISERROR(N'Rất tiếc, Voucher vừa hết số lượng tổng!', 16, 1);
        END
    END
    ELSE
    BEGIN
        RAISERROR(N'Giao dịch không thỏa mãn điều kiện phạm vi áp dụng (Phim/Rạp/Ngày...)!', 16, 1);
    END
END;
GO

CREATE OR ALTER TRIGGER trg_TinhTienSauVoucher
ON APDUNG
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- 0. Nếu có hàng bị xóa khỏi APDUNG, cập nhật lại số lượng VOUCHER
    IF EXISTS (SELECT * FROM DELETED)
    BEGIN
        UPDATE V
        SET V.SoLuong = V.SoLuong + 1
        FROM VOUCHER V
        JOIN DELETED D ON V.MaVoucher = D.MaVoucher;
    END

    DECLARE @DanhSachGiaoDich TABLE (MaGD VARCHAR(10));
    INSERT INTO @DanhSachGiaoDich
    SELECT MaGiaoDich FROM INSERTED UNION SELECT MaGiaoDich FROM DELETED;

    UPDATE GD
    SET 
        -- 1. Tiền Giảm
        GD.TienGiam = ISNULL(VoucherInfo.TongGiam, 0),

        -- 2. Tổng Thanh Toán
        GD.TongTienThanhToan = CASE 
            WHEN (GD.TongTienBanDau - ISNULL(VoucherInfo.TongGiam, 0)) < 0 THEN 0
            ELSE (GD.TongTienBanDau - ISNULL(VoucherInfo.TongGiam, 0))
        END
    FROM GIAODICH GD
    JOIN @DanhSachGiaoDich D ON GD.MaGiaoDich = D.MaGD
    CROSS APPLY (
        SELECT SUM(
            CASE 
                WHEN V.QuaTang IS NOT NULL THEN 0
                WHEN V.GiaTri IS NOT NULL THEN V.GiaTri
                WHEN V.PhanTram IS NOT NULL THEN 
                    CASE 
                        WHEN (G2.TongTienBanDau * V.PhanTram / 100) > ISNULL(V.GiaTriGiamToiDa, 999999999) 
                        THEN V.GiaTriGiamToiDa
                        ELSE (G2.TongTienBanDau * V.PhanTram / 100)
                    END
                ELSE 0
            END
        ) AS TongGiam
        FROM APDUNG AD 
        JOIN VOUCHER V ON AD.MaVoucher = V.MaVoucher
        JOIN GIAODICH G2 ON AD.MaGiaoDich = G2.MaGiaoDich 
        WHERE AD.MaGiaoDich = GD.MaGiaoDich
    ) AS VoucherInfo;
END;
GO

USE RAPPHIM;
GO
CREATE OR ALTER PROCEDURE proc_QuayLaiBuocChonDoAn
    @MaGiaoDich VARCHAR(10)
AS
BEGIN
    DELETE FROM dbo.APDUNG WHERE MaGiaoDich = @MaGiaoDich;
END;
GO


CREATE OR ALTER PROCEDURE proc_QuayLaiBuocChonVe
    @MaGiaoDich VARCHAR(10)
AS
BEGIN
    DELETE FROM APDUNG WHERE MaGiaoDich = @MaGiaoDich;
    DELETE FROM MUAKEM WHERE MaGiaoDich = @MaGiaoDich;
END;
GO



CREATE OR ALTER PROCEDURE proc_HuyGiaoDich
    @MaGiaoDich VARCHAR(10)
AS
BEGIN
    -- Xóa theo thứ tự ràng buộc khóa ngoại
    DELETE FROM APDUNG WHERE MaGiaoDich = @MaGiaoDich;
    DELETE FROM MUAKEM WHERE MaGiaoDich = @MaGiaoDich;
    
    DELETE FROM VE WHERE MaGiaoDich = @MaGiaoDich;
    DELETE FROM GIAODICH WHERE MaGiaoDich = @MaGiaoDich;
END;
GO



CREATE OR ALTER PROCEDURE proc_CapNhatThanhVienChoGiaoDich
    @MaGiaoDich VARCHAR(10),
    @MaKhachHangMoi VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Kiểm tra xem mã khách hàng nhân viên nhập có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM KHACHHANGTHANHVIEN WHERE MaTaiKhoan = @MaKhachHangMoi)
    BEGIN
        RAISERROR(N'Mã khách hàng không tồn tại!', 16, 1);
        RETURN;
    END

    -- 2. Kiểm tra giao dịch có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM GIAODICHTRUCTIEP WHERE MaGiaoDich = @MaGiaoDich)
    BEGIN
        RAISERROR(N'Giao dịch không tồn tại!', 16, 1);
        RETURN;
    END

    -- 3. Thực hiện cập nhật
    UPDATE GIAODICHTRUCTIEP
    SET MaTaiKhoanKhachHang = @MaKhachHangMoi
    WHERE MaGiaoDich = @MaGiaoDich;

    PRINT N'Đã cập nhật thông tin khách hàng thành công!';
END;
GO


INSERT INTO VOUCHER (SoLuong, NgayBatDau, NgayKetThuc, PhamViApDung, GiaTriGiamToiDa, PhanTram, GiaTri, QuaTang, GioiHanMoiNguoi, ChiDanhChoThanhVien, SoDiemQuyDoi) VALUES
(100, '2025-01-01', '2025-12-31', N'TOANBO', 50000, 10, NULL, NULL,  NULL, 0, 0), 
(100, '2025-01-01', '2025-12-31', N'TOANBO', NULL, NULL, 30000, NULL,  NULL, 0, 0), 
(1,   '2025-01-01', '2025-12-31', N'TOANBO', NULL, NULL, 30000, NULL,  NULL, 0, 0), 
(50, '2025-11-01', '2025-12-30', N'RAP:RAP0000001', 50000, 20, NULL, NULL, 1, 1, 0), 
(20, '2025-01-01', '2026-12-01', N'LOAIGHE:VIP',   NULL, NULL, 40000, NULL, 2, 1, 0), 
(200,'2025-03-01', '2025-12-01', N'PHIM:P000000002',NULL,NULL,40000,NULL,2, 1, 0), 
(500,'2025-01-01', '2025-12-31', N'SANPHAM:SPK0000001',NULL,NULL,40000,NULL,2,1,0);

INSERT INTO VOUCHER (SoLuong, NgayBatDau, NgayKetThuc, PhamViApDung, GiaTriGiamToiDa, PhanTram, GiaTri, QuaTang, GioiHanMoiNguoi, ChiDanhChoThanhVien, SoDiemQuyDoi) VALUES
(200,'2025-03-01','2025-11-20',N'LOAIGHE:VIP',NULL,NULL,40000,NULL,NULL,0,0), 
(500,'2025-01-01','2025-12-31',N'LOAIGHE:Thường',NULL,NULL,40000,NULL,NULL,0,0);

INSERT INTO VOUCHER (SoLuong, NgayBatDau, NgayKetThuc, PhamViApDung, GiaTriGiamToiDa, PhanTram, GiaTri, QuaTang, GioiHanMoiNguoi, ChiDanhChoThanhVien, SoDiemQuyDoi) VALUES
( 50, '2025-11-01', '2025-12-30', N'NGAY:T7', 50000, 5, NULL, NULL, 1, 1, 0), 
( 500, '2025-01-01', '2025-12-31', N'NGAY:T6', NULL, NULL, 20000, NULL, 2, 1, 0);

-- Voucher đổi điểm
INSERT INTO VOUCHER 
(SoLuong, NgayBatDau, NgayKetThuc, PhamViApDung,
 GiaTriGiamToiDa, PhanTram, GiaTri, QuaTang,
 GioiHanMoiNguoi, ChiDanhChoThanhVien, SoDiemQuyDoi)
VALUES
-- Đổi 100 điểm để giảm 20,000 cho toàn bộ đơn
(200, '2025-01-01','2025-12-31', N'TOANBO', NULL, NULL, 20000, NULL, 1, 1, 100),
-- Đổi 300 điểm để giảm 50,000 cho vé VIP
(100, '2025-01-01','2025-12-31', N'LOAIGHE:VIP', NULL, NULL, 50000, NULL, 1, 1, 300),
-- Đổi 500 điểm để giảm 10% tối đa 80,000 cho phim cụ thể
(50,  '2025-01-01','2025-12-31', N'PHIM:P000000002', 80000, 10, NULL, NULL, 1, 1, 500);


INSERT INTO CHONGOI (MaRap, SoThuTuPhong, SoThuTuCho, Da_y, LoaiGhe, TrangThai) VALUES
-- 1. Phòng R03 - P1 (Phòng 2D): Hàng A ghế VIP
('RAP0000003', 1, 1, 'A', N'VIP', N'Sẵn sàng'),
('RAP0000003', 1, 2, 'A', N'VIP', N'Sẵn sàng'),
('RAP0000003', 1, 3, 'A', N'VIP', N'Sẵn sàng');

INSERT INTO CHONGOI (MaRap, SoThuTuPhong, SoThuTuCho, Da_y, LoaiGhe, TrangThai) VALUES
-- 1. Phòng R03 - P1 (Phòng 2D): Hàng A ghế VIP
('RAP0000003', 1, 4, 'A', N'VIP', N'Sẵn sàng'),
('RAP0000003', 1, 5, 'A', N'VIP', N'Sẵn sàng'),
('RAP0000003', 1, 6, 'A', N'VIP', N'Sẵn sàng');
INSERT INTO CHONGOI (MaRap, SoThuTuPhong, SoThuTuCho, Da_y, LoaiGhe, TrangThai) VALUES
-- 1. Phòng R03 - P1 (Phòng 2D): Hàng A ghế VIP
('RAP0000003', 1, 1, 'B', N'Đôi', N'Sẵn sàng'),
('RAP0000003', 1, 2, 'B', N'Đôi', N'Sẵn sàng');

UPDATE VOUCHER
SET SoLuong = 1
WHERE MaVoucher = 'VC00000017';

--SELECT * FROM BANGGIAVE;
--SELECT * FROM GIAODICH;
--SELECT * FROM GIAODICHTRUCTIEP;
--SELECT * FROM GIAODICHTRUCTUYEN;
--SELECT * FROM TAIKHOAN;
--SELECT * FROM VOUCHER;
--SELECT * FROM VE;
--SELECT * FROM MUAKEM;
--SELECT * FROM PHIM;
--SELECT * FROM SUATCHIEU;
--SELECT * FROM CHONGOI;
--SELECT * FROM QUAY;
--SELECT * FROM NHANSU;
--SELECT * FROM SANPHAMKEM;

--INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
--(N'Ví điện tử', 0, '2025-11-29', '14:40:37'); 
--INSERT INTO GIAODICHTRUCTUYEN ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES 
--('GD00000014', '0000000010', NULL, NULL);

--INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
--(N'Thường', N'Đã chọn', NULL, 'GD00000014', 'P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', 'RAP0000001', 1, 1, 'A'),
--(N'Thường', N'Đã chọn', NULL, 'GD00000014', 'P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', 'RAP0000001', 1, 2, 'A'),
--(N'Thường', N'Đã chọn', NULL, 'GD00000014', 'P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', 'RAP0000001', 1, 3, 'A');

--INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
--VALUES ('GD00000014', 'SPK0000001', 1);

---- Check voucher condition and user permission to use voucher (GUEST)
--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000012'); 

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000001'); 



--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000013'); 

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000014'); 



--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000015'); 



--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000016'); 

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000017'); 

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000018'); 

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000019'); 

--SELECT * FROM GIAODICH WHERE MaGiaoDich = 'GD00000014';

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000014', 'VC00000020'); 
 
--EXEC proc_QuayLaiBuocChonDoAn @MaGiaoDich = 'GD00000014';

--EXEC proc_QuayLaiBuocChonVe @MaGiaoDich = 'GD00000014';

--EXEC proc_HuyGiaoDich @MaGiaoDich = 'GD00000014';
--SELECT * FROM GIAODICH;

--INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
--(N'Ví điện tử', 1, '2025-11-20', '14:23:37'); 
--INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
--('GD00000013', '0000000008', NULL, NULL, 'RAP0000003', 1);

--INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
--(N'VIP', N'Đã chọn', 90000, 'GD00000013', 'P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', 'RAP0000003', 1, 1, 'A'),
--(N'VIP', N'Đã chọn', 90000, 'GD00000013', 'P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', 'RAP0000003', 1, 2, 'A'),
--(N'VIP', N'Đã chọn', 90000, 'GD00000013', 'P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', 'RAP0000003', 1, 3, 'A');

--INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
--VALUES ('GD00000013', 'SPK0000002', 2);

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000013', 'VC00000018'); 

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000013', 'VC00000020'); 

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000013', 'VC00000021'); 

--INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
--(N'Ví điện tử', 1, '2025-11-20', '14:25:37'); 
--INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
--('GD00000012', NULL, NULL, NULL, 'RAP0000003', 2);

--INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
--(N'Đôi', N'Đã chọn', 90000, 'GD00000012', 'P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', 'RAP0000003', 1, 1, 'B'),
--(N'Đôi', N'Đã chọn', 90000, 'GD00000012', 'P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', 'RAP0000003', 1, 2, 'B');

--INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
--VALUES ('GD00000012', 'SPK0000002', 2);

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000011', 'VC00000011'); 
--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000011', 'VC00000012');

--SELECT * FROM GIAODICH;
--SELECT * FROM VOUCHER;
--EXEC proc_HuyGiaoDich @MaGiaoDich = 'GD00000014';
--EXEC proc_HuyGiaoDich @MaGiaoDich = 'GD00000014';


--SELECT * FROM VOUCHER;
--SELECT * FROM GIAODICH;
--INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
--(N'Ví điện tử', 1, '2025-11-20', '14:25:37'); 
--INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
--('GD00000016', '0000000036', NULL, NULL, 'RAP0000003', 2);

--INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
--(N'VIP', N'Đã chọn', 90000, 'GD00000016', 'P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', 'RAP0000003', 1, 4, 'A'),
--(N'VIP', N'Đã chọn', 90000, 'GD00000016', 'P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', 'RAP0000003', 1, 5, 'A');

--INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
--VALUES ('GD00000016', 'SPK0000002', 2);

--INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
--VALUES ('GD00000015', 'VC00000018'); 


--EXEC proc_CapNhatThanhVienChoGiaoDich 
--    @MaGiaoDich = 'GD00001015',      -- Mã giao dịch cần sửa
--    @MaKhachHangMoi = '0000000007';  -- Mã thẻ thành viên khách vừa đọc



--SELECT * FROM GIAODICHTRUCTIEP;

--EXEC proc_CapNhatThanhVienChoGiaoDich 
--    @MaGiaoDich = 'GD00000013',     
--    @MaKhachHangMoi = '0000000007'; 

--SELECT * FROM GIAODICHTRUCTIEP;

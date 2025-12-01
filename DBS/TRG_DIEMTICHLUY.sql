-----------------------------------------------------------
-- TRIGGER CAP NHAT HANG THANH VIEN THEO TONG DIEM TICH LUY
-----------------------------------------------------------
CREATE OR ALTER TRIGGER TRG_NangCapHangThanhVien
ON KHACHHANGTHANHVIEN
AFTER UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON;
    -- Chỉ chạy khi điểm tích lũy thay đổi 
    IF NOT EXISTS (
        SELECT 1
        FROM inserted I
        JOIN deleted D ON I.MaTaiKhoan = D.MaTaiKhoan
        WHERE D.MaTaiKhoan IS NULL OR I.TongDiemTichLuy <> D.TongDiemTichLuy
    )
        RETURN;

    ;WITH HangTVMoi AS (
        SELECT 
            MaTaiKhoan,
            CASE 
                WHEN TongDiemTichLuy >= 10000 THEN N'Kim cương'
                WHEN TongDiemTichLuy >= 5000 THEN N'Vàng'
                WHEN TongDiemTichLuy >= 1000 THEN N'Bạc'
                ELSE N'Thường'
            END AS HangMoi
        FROM inserted
    )
    UPDATE KH
    SET KH.LoaiThanhVien = NR.HangMoi
    FROM KHACHHANGTHANHVIEN KH
    JOIN HangTVMoi NR ON KH.MaTaiKhoan = NR.MaTaiKhoan
    WHERE KH.LoaiThanhVien <> NR.HangMoi; -- Update khi có thay đổi 
END;
GO


------------------------------------------
-- TRIGGER TRU DIEM TICH LUY KHI AP VOUCHER
------------------------------------------

CREATE OR ALTER TRIGGER TRG_XuLyDiem_SauThanhToan
ON GIAODICH
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Chỉ chạy khi Giao dịch chuyển trạng thái 0 -> 1 (Hoàn tất)
    IF NOT EXISTS (
        SELECT 1 
        FROM inserted I 
        JOIN deleted D ON I.MaGiaoDich = D.MaGiaoDich 
        WHERE D.TrangThai = 0 AND I.TrangThai = 1
    ) RETURN;

    DECLARE @BienDongDiem TABLE (
        MaTaiKhoan VARCHAR(10) PRIMARY KEY,
        DiemCong INT DEFAULT 0,
        DiemTru INT DEFAULT 0
    );

    -- 2. Tính Điểm Cộng (Dựa trên Tổng tiền thanh toán / 1000)
    INSERT INTO @BienDongDiem (MaTaiKhoan, DiemCong)
    SELECT 
        COALESCE(GDT.MaTaiKhoanKhachHang, GDTT.MaTaiKhoanKhachHang),
        SUM(CAST(I.TongTienThanhToan AS DECIMAL(18,0)) / 1000)
    FROM inserted I
    LEFT JOIN GIAODICHTRUCTUYEN GDT ON I.MaGiaoDich = GDT.MaGiaoDich
    LEFT JOIN GIAODICHTRUCTIEP GDTT ON I.MaGiaoDich = GDTT.MaGiaoDich
    WHERE I.TrangThai = 1 
      AND COALESCE(GDT.MaTaiKhoanKhachHang, GDTT.MaTaiKhoanKhachHang) IS NOT NULL
    GROUP BY COALESCE(GDT.MaTaiKhoanKhachHang, GDTT.MaTaiKhoanKhachHang);

    -- 3. Tính Điểm Trừ (Dựa trên Voucher đổi điểm đã áp dụng)
    MERGE INTO @BienDongDiem AS Target
    USING (
        SELECT 
            COALESCE(GDT.MaTaiKhoanKhachHang, GDTT.MaTaiKhoanKhachHang) AS MaTaiKhoan,
            SUM(ISNULL(V.SoDiemQuyDoi, 0)) AS TongDiemTru
        FROM APDUNG AD
        JOIN VOUCHER V ON AD.MaVoucher = V.MaVoucher
        JOIN inserted I ON AD.MaGiaoDich = I.MaGiaoDich
        LEFT JOIN GIAODICHTRUCTUYEN GDT ON I.MaGiaoDich = GDT.MaGiaoDich
        LEFT JOIN GIAODICHTRUCTIEP GDTT ON I.MaGiaoDich = GDTT.MaGiaoDich
        WHERE V.SoDiemQuyDoi > 0 AND I.TrangThai = 1
        GROUP BY COALESCE(GDT.MaTaiKhoanKhachHang, GDTT.MaTaiKhoanKhachHang)
    ) AS Source ON Target.MaTaiKhoan = Source.MaTaiKhoan
    WHEN MATCHED THEN 
        UPDATE SET Target.DiemTru = Source.TongDiemTru
    WHEN NOT MATCHED THEN
        INSERT (MaTaiKhoan, DiemCong, DiemTru) VALUES (Source.MaTaiKhoan, 0, Source.TongDiemTru);

    -- 4. Thực hiện Update
    -- Logic: Điểm hiện tại + Điểm kiếm được đơn này - Điểm quy đổi đơn này
    UPDATE KH
    SET 
        KH.DiemTichLuy = KH.DiemTichLuy + BD.DiemCong - BD.DiemTru,
        KH.TongDiemTichLuy = KH.TongDiemTichLuy + BD.DiemCong
    FROM KHACHHANGTHANHVIEN KH
    JOIN @BienDongDiem BD ON KH.MaTaiKhoan = BD.MaTaiKhoan;
END;
GO
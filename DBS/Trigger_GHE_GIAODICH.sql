CREATE OR ALTER TRIGGER trg_CapNhatTrangThaiGiaoDich
ON GIAODICH
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE GD
    SET GD.TrangThai = 1
    FROM GIAODICH GD
    JOIN INSERTED I ON GD.MaGiaoDich = I.MaGiaoDich;
END;
GO

-- Kiểm tra ghế trùng với giao dịch đã hoàn tất
CREATE OR ALTER TRIGGER trg_KiemTraTrungGhe
ON VE
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 
        FROM INSERTED I
        JOIN VE V ON 
               I.MaRap_ChoNgoi = V.MaRap_ChoNgoi
           AND I.SoThuTuPhong_ChoNgoi = V.SoThuTuPhong_ChoNgoi
           AND I.SoThuTuCho = V.SoThuTuCho
           AND I.Da_y = V.Da_y
           AND I.MaPhim = V.MaPhim
           AND I.NgayChieu = V.NgayChieu
           AND I.ThoiGianBatDau = V.ThoiGianBatDau
        JOIN GIAODICH GD ON GD.MaGiaoDich = V.MaGiaoDich
        WHERE GD.TrangThai = 1
    )

    BEGIN
        RAISERROR(N'Ghế này đã được đặt bởi giao dịch trước đó và không thể chọn lại!', 16, 1);
        RETURN;
    END

    INSERT INTO VE (
        LoaiVe, TrangThai, Gia, MaGiaoDich,
        MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau,
        MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y
    )
    SELECT 
        LoaiVe, TrangThai, Gia, MaGiaoDich,
        MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau,
        MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y
    FROM INSERTED;

END;
GO

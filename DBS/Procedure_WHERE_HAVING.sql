USE RAPPHIM
GO

CREATE OR ALTER PROCEDURE sp_TraCuuLichChieu
    @p_TenPhim NVARCHAR(255),
    @p_NgayChieu DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.TenPhim,
        R.TenRap,
        PC.LoaiPhong,
        SC.ThoiGianBatDau,
        SC.ThoiGianKetThuc,
        SC.DinhDangChieu, 
        SC.TrangThai
    FROM PHIM P
    JOIN SUATCHIEU SC ON P.MaPhim = SC.MaPhim
    JOIN RAP R ON SC.MaRap = R.MaRap
    JOIN PHONGCHIEU PC ON SC.MaRap = PC.MaRap AND SC.SoThuTuPhong = PC.SoThuTuPhong
    WHERE 
        P.TenPhim LIKE N'%' + @p_TenPhim + N'%'  -- Tìm kiếm gần đúng tên phim
        AND SC.NgayChieu = @p_NgayChieu     
    ORDER BY 
        SC.ThoiGianBatDau ASC;                  
END;
GO


/*
    HƯỚNG DẪN SỬ DỤNG @p_KieuLoc:
    1: Lấy Doanh thu >= Mốc (Tìm rạp hiệu quả)
    2: Lấy Doanh thu < Mốc  (Tìm rạp yếu kém để cắt giảm/hỗ trợ)
    0: Lấy tất cả (Bỏ qua điều kiện lọc tiền)
*/
CREATE OR ALTER PROCEDURE sp_BaoCaoDoanhThuRap_ThucTe
    @p_TuNgay DATE,
    @p_DenNgay DATE,
    @p_DoanhThuMoc DECIMAL(18,0) = 0, 
    @p_KieuLoc INT = 1 -- Mặc định là 1 (Lấy >=)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        R.MaRap,
        R.TenRap,
        COUNT(DISTINCT GD.MaGiaoDich) AS TongSoGiaoDich, 
        SUM(GD.TongTienThanhToan) AS TongDoanhThu
    FROM RAP R
    JOIN (
        SELECT DISTINCT MaRap, MaGiaoDich 
        FROM VE 
        WHERE MaGiaoDich IS NOT NULL
    ) Link_Rap_GD ON R.MaRap = Link_Rap_GD.MaRap
    JOIN GIAODICH GD ON Link_Rap_GD.MaGiaoDich = GD.MaGiaoDich
    WHERE GD.NgayGiaoDich BETWEEN @p_TuNgay AND @p_DenNgay
    GROUP BY R.MaRap, R.TenRap
    HAVING 
        -- Trường hợp 0: Lấy tất cả
        (@p_KieuLoc = 0)
        OR
        -- Trường hợp 1: Lấy Lớn hơn hoặc Bằng
        (@p_KieuLoc = 1 AND SUM(GD.TongTienThanhToan) >= @p_DoanhThuMoc)
        OR
        -- Trường hợp 2: Lấy Nhỏ hơn
        (@p_KieuLoc = 2 AND SUM(GD.TongTienThanhToan) < @p_DoanhThuMoc)

    ORDER BY TongDoanhThu DESC;
END;
GO



EXEC sp_TraCuuLichChieu
    @p_TenPhim = N'TỬ CHIẾN TRÊN KHÔNG',
    @p_NgayChieu = '2025-11-20';
SELECT * FROM PHIM;
SELECT * FROM SUATCHIEU;

SELECT * FROM GIAODICH;
EXEC sp_BaoCaoDoanhThuRap_ThucTe
    @p_TuNgay = '2025-11-17',
    @p_DenNgay = '2025-11-23',
    @p_DoanhThuMoc = 300000,
    @p_KieuLoc = 2;
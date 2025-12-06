USE RAPPHIM
GO

CREATE OR ALTER PROCEDURE sp_TraCuuLichChieu
    @p_TenPhim   NVARCHAR(255),
    @p_NgayChieu DATE
AS
BEGIN
    SET NOCOUNT ON;

    ------------------------------------------------------------
    -- 1) Có phim + có suất đúng ngày @p_NgayChieu ?
    ------------------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM PHIM P
        JOIN SUATCHIEU SC ON P.MaPhim = SC.MaPhim
        WHERE 
            P.TenPhim LIKE N'%' + @p_TenPhim + N'%'
            AND SC.NgayChieu = @p_NgayChieu
    )
    BEGIN
        -- Trường hợp 1: Phim đó có suất đúng ngày → trả về đúng ngày đó
        SELECT 
            P.MaPhim,
            P.TenPhim,
            R.TenRap,
            PC.LoaiPhong,
            SC.NgayChieu,
            SC.ThoiGianBatDau,
            SC.ThoiGianKetThuc,
            SC.DinhDangChieu, 
            SC.TrangThai
        FROM PHIM P
        JOIN SUATCHIEU SC ON P.MaPhim = SC.MaPhim
        JOIN RAP R ON SC.MaRap = R.MaRap
        JOIN PHONGCHIEU PC ON SC.MaRap = PC.MaRap AND SC.SoThuTuPhong = PC.SoThuTuPhong
        WHERE 
            P.TenPhim LIKE N'%' + @p_TenPhim + N'%'
            AND SC.NgayChieu = @p_NgayChieu
        ORDER BY 
            SC.ThoiGianBatDau ASC;
    END
    ELSE IF EXISTS (
        --------------------------------------------------------
        -- 2) Tên phim có tồn tại, nhưng KHÔNG có suất đúng ngày
        --------------------------------------------------------
        SELECT 1
        FROM PHIM P
        JOIN SUATCHIEU SC ON P.MaPhim = SC.MaPhim
        WHERE 
            P.TenPhim LIKE N'%' + @p_TenPhim + N'%'
    )
    BEGIN
        -- Trường hợp 2: Phim có trong hệ thống → trả về tất cả ngày chiếu của phim đó
        SELECT 
            P.MaPhim,
            P.TenPhim,
            R.TenRap,
            PC.LoaiPhong,
            SC.NgayChieu,
            SC.ThoiGianBatDau,
            SC.ThoiGianKetThuc,
            SC.DinhDangChieu, 
            SC.TrangThai
        FROM PHIM P
        JOIN SUATCHIEU SC ON P.MaPhim = SC.MaPhim
        JOIN RAP R ON SC.MaRap = R.MaRap
        JOIN PHONGCHIEU PC ON SC.MaRap = PC.MaRap AND SC.SoThuTuPhong = PC.SoThuTuPhong
        WHERE 
            P.TenPhim LIKE N'%' + @p_TenPhim + N'%'
        ORDER BY 
            SC.NgayChieu ASC,
            SC.ThoiGianBatDau ASC;
    END
    ELSE IF EXISTS (
        --------------------------------------------------------
        -- 3) Tên phim không tồn tại, nhưng ngày chiếu có suất
        --------------------------------------------------------
        SELECT 1
        FROM SUATCHIEU SC
        WHERE SC.NgayChieu = @p_NgayChieu
    )
    BEGIN
        -- Trường hợp 3: Không tìm thấy phim, nhưng ngày đó có suất
        -- → trả về tất cả phim chiếu trong ngày đó
        SELECT 
            P.MaPhim,
            P.TenPhim,
            R.TenRap,
            PC.LoaiPhong,
            SC.NgayChieu,
            SC.ThoiGianBatDau,
            SC.ThoiGianKetThuc,
            SC.DinhDangChieu, 
            SC.TrangThai
        FROM PHIM P
        JOIN SUATCHIEU SC ON P.MaPhim = SC.MaPhim
        JOIN RAP R ON SC.MaRap = R.MaRap
        JOIN PHONGCHIEU PC ON SC.MaRap = PC.MaRap AND SC.SoThuTuPhong = PC.SoThuTuPhong
        WHERE 
            SC.NgayChieu = @p_NgayChieu
        ORDER BY 
            P.TenPhim ASC,
            SC.ThoiGianBatDau ASC;
    END
    ELSE
    BEGIN
        --------------------------------------------------------
        -- 4) Tên phim không tồn tại, ngày đó cũng không có suất
        -- → trả về TẤT CẢ lịch chiếu
        --------------------------------------------------------
        SELECT 
            P.MaPhim,
            P.TenPhim,
            R.TenRap,
            PC.LoaiPhong,
            SC.NgayChieu,
            SC.ThoiGianBatDau,
            SC.ThoiGianKetThuc,
            SC.DinhDangChieu, 
            SC.TrangThai
        FROM PHIM P
        JOIN SUATCHIEU SC ON P.MaPhim = SC.MaPhim
        JOIN RAP R ON SC.MaRap = R.MaRap
        JOIN PHONGCHIEU PC ON SC.MaRap = PC.MaRap AND SC.SoThuTuPhong = PC.SoThuTuPhong
        ORDER BY 
            SC.NgayChieu ASC,
            SC.ThoiGianBatDau ASC,
            P.TenPhim ASC;
    END
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

EXEC sp_TraCuuLichChieu
    @p_TenPhim = N'TỬ CHIẾN TRÊN KHÔNG',
    @p_NgayChieu = null;

EXEC sp_TraCuuLichChieu
    @p_TenPhim = null,
    @p_NgayChieu = '2025-11-20';

EXEC sp_TraCuuLichChieu
    @p_TenPhim = null,
    @p_NgayChieu = null;

EXEC sp_BaoCaoDoanhThuRap_ThucTe
    @p_TuNgay = '2025-11-17',
    @p_DenNgay = '2025-11-30',
    @p_DoanhThuMoc = 400000,
    @p_KieuLoc = 1;
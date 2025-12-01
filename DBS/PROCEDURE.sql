-- Xem lịch sử mua hàng của 1 tài khoản xác định 
CREATE OR ALTER PROCEDURE proc_LichSuMuaHang
    @MaTaiKhoan VARCHAR(10),
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        GD.MaGiaoDich,
        GD.NgayGiaoDich,
        GD.TongTienThanhToan,      
        CASE 
            WHEN GDT.MaGiaoDich IS NOT NULL THEN N'Trực tuyến'
            WHEN GDTi.MaGiaoDich IS NOT NULL THEN N'Trực tiếp'
            ELSE N'Không xác định'
        END AS HinhThuc,

        -- Đếm số vé
        (SELECT COUNT(MaVe) FROM VE WHERE MaGiaoDich = GD.MaGiaoDich) AS SoVe,

        -- Tính tiền đồ ăn
        ISNULL((
            SELECT SUM(MK.SoLuong * SP.DonGia)
            FROM MUAKEM MK
            JOIN SANPHAMKEM SP ON MK.MaSanPham = SP.MaSanPham
            WHERE MK.MaGiaoDich = GD.MaGiaoDich
        ), 0) AS TienDoAn

    FROM GIAODICH GD
    LEFT JOIN GIAODICHTRUCTUYEN GDT ON GD.MaGiaoDich = GDT.MaGiaoDich
    LEFT JOIN GIAODICHTRUCTIEP GDTi ON GD.MaGiaoDich = GDTi.MaGiaoDich
    
    WHERE 
        (GDT.MaTaiKhoanKhachHang = @MaTaiKhoan OR GDTi.MaTaiKhoanKhachHang = @MaTaiKhoan)
        AND (@TuNgay IS NULL OR GD.NgayGiaoDich >= @TuNgay)
        AND (@DenNgay IS NULL OR GD.NgayGiaoDich <= @DenNgay)
    
    ORDER BY GD.NgayGiaoDich DESC;
END;
GO


-- Tìm Top chi tiêu trong 1 khoảng thời gian 
-- @TopN: số lượng cần hiển thị (top 5, top 10...)
CREATE OR ALTER PROCEDURE proc_TopChiTieu
    @TopN INT,
    @TuNgay DATE = NULL,
    @DenNgay DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH AllGD AS (
        -- Lấy giao dịch Online
        SELECT 
            GDT.MaTaiKhoanKhachHang AS MaTaiKhoan,
            GD.TongTienThanhToan,
            GD.MaGiaoDich
        FROM GIAODICH GD
        JOIN GIAODICHTRUCTUYEN GDT ON GD.MaGiaoDich = GDT.MaGiaoDich
        WHERE GD.TrangThai = 1 
            AND (@TuNgay IS NULL OR GD.NgayGiaoDich >= @TuNgay) 
            AND (@DenNgay IS NULL OR GD.NgayGiaoDich <= @DenNgay)
        UNION ALL

        -- Lấy giao dịch Trực tiếp (Chỉ những GD có mã thành viên)
        SELECT 
            GDTi.MaTaiKhoanKhachHang AS MaTaiKhoan,
            GD.TongTienThanhToan,
            GD.MaGiaoDich
        FROM GIAODICH GD
        JOIN GIAODICHTRUCTIEP GDTi ON GD.MaGiaoDich = GDTi.MaGiaoDich
        WHERE GD.TrangThai = 1
          AND GDTi.MaTaiKhoanKhachHang IS NOT NULL 
          AND (@TuNgay IS NULL OR GD.NgayGiaoDich >= @TuNgay) 
          AND (@DenNgay IS NULL OR GD.NgayGiaoDich <= @DenNgay)
    )
    SELECT TOP (@TopN)
        KH.MaTaiKhoan,
        KH.Ho + ' ' + KH.Ten AS HoTen,
        KH.LoaiThanhVien AS HangThanhVien,
        SUM(T.TongTienThanhToan) AS TongChiTieu,
        COUNT(T.MaGiaoDich) AS SoLanMua     
    FROM AllGD T
    JOIN KHACHHANGTHANHVIEN KH ON T.MaTaiKhoan = KH.MaTaiKhoan
    GROUP BY KH.MaTaiKhoan, KH.Ho, KH.Ten, KH.LoaiThanhVien
    HAVING SUM(T.TongTienThanhToan) > 0
    ORDER BY TongChiTieu DESC;
END;
GO


EXEC proc_LichSuMuaHang 
    @MaTaiKhoan = '0000000001',
    @TuNgay = '2025-01-01',
    @DenNgay = '2025-12-31';

EXEC proc_TopChiTieu @TopN = 10;  
EXEC proc_TopChiTieu @TopN = 5, @TuNgay = '2025-01-01', @DenNgay = '2025-12-31';
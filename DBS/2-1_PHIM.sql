-- USE RAPPHIM
-- State các lỗi:
    -- Lỗi trùng lặp: 1
    -- Lỗi dữ liệu trống: 2
    -- Lỗi dữ liệu <= 0: 3
    -- Lỗi thời gian không hợp lệ: 4
    -- Lỗi định dạng dữ liệu: 5
    -- Lỗi dữ liệu không tồn tại: 6

SET NOCOUNT ON;

/*================================ INSERT ======================================== */

CREATE OR ALTER PROCEDURE sp_validate_insert_PHIM (
	@p_TenPhim NVARCHAR(255),
    @p_Poster NVARCHAR(MAX), /* Lưu link ảnh */
    @p_Trailer NVARCHAR(MAX), /* Lưu link video */
    @p_DoTuoiQuyDinh NVARCHAR(10), /* Ví dụ: 'T18', 'P' */
    @p_DaoDien NVARCHAR(255),
    @p_NgayKhoiChieu DATE,
    @p_NgayNgungChieu DATE,
    @p_ThoiLuong INT, /* Thời lượng (phút) */
    @p_QuocGiaSanXuat NVARCHAR(100),
    @p_NamSanXuat INT,
    @p_TinhTrang NVARCHAR(100), /* Sắp chiếu, Đang chiếu */
    @p_MoTa NVARCHAR(MAX)
)  
AS
BEGIN
   -- Kiểm tra tên phim không trống
    IF @p_TenPhim IS NULL OR LTRIM(RTRIM(@p_TenPhim)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Tên phim không được để trống!', 11, 2);
        RETURN;
    END

    -- Kiểm tra độ tuổi quy định
    IF @p_DoTuoiQuyDinh NOT IN ('P', 'K', 'T13', 'T16', 'T18', 'C')
    BEGIN
        RAISERROR(
            N'Lỗi định dạng dữ liệu: Độ tuổi quy định không hợp lệ! Chỉ chấp nhận: P, K, T13, T16, T18, C.',
            11, 5
        );
        RETURN;
    END

    -- Kiểm tra thời lượng
    IF @p_ThoiLuong <= 0
    BEGIN
        RAISERROR (N'Lỗi dữ liệu <= 0: Thời lượng phim phải lớn hơn 0 phút!', 11, 3);
        RETURN;
    END

    -- Kiểm tra ngày chiếu
    IF @p_NgayNgungChieu < @p_NgayKhoiChieu
    BEGIN
        RAISERROR(N'Lỗi thời gian không hợp lệ: Ngày ngừng chiếu phải sau hoặc bằng ngày khởi chiếu!', 11, 4);
        RETURN;
    END

    -- Kiểm tra năm sản xuất
    DECLARE @current_year INT;
    SET @current_year = YEAR(GETDATE());
    IF @p_NamSanXuat > @current_year
    BEGIN
        RAISERROR (
            N'Lỗi thời gian không hợp lệ: Năm sản xuất (%d) không được lớn hơn năm hiện tại (%d)!', 
            11, 
            4,
            @p_NamSanXuat,
            @current_year
        );
        RETURN;
    END

    -- Kiểm tra tình trạng hợp lệ
    IF @p_TinhTrang NOT IN (N'Sắp chiếu', N'Đang chiếu')
    BEGIN
        RAISERROR(N'Lỗi cú pháp: Tình trạng chỉ được là "Sắp chiếu" hoặc "Đang chiếu".', 11, 5);
        RETURN;
    END

    -- Insert dữ liệu
    INSERT INTO PHIM (
        TenPhim, Poster, Trailer, DoTuoiQuyDinh, DaoDien,
        NgayKhoiChieu, NgayNgungChieu, ThoiLuong, QuocGiaSanXuat,
        NamSanXuat, TinhTrang, MoTa
    )
    VALUES (
        @p_TenPhim, @p_Poster, @p_Trailer, @p_DoTuoiQuyDinh, @p_DaoDien,
        @p_NgayKhoiChieu, @p_NgayNgungChieu, @p_ThoiLuong, @p_QuocGiaSanXuat,
        @p_NamSanXuat, @p_TinhTrang, @p_MoTa
    );

    PRINT N'Thêm phim thành công!';
END
GO

-- Thực thi thủ tục
EXEC sp_validate_insert_PHIM 
    @p_TenPhim = N'Sư thầy gặp sư lầy',
    @p_Poster = 'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/w/y/wymm_kv_1810_up.jpg',
    @p_Trailer = 'https://youtu.be/ny6xpuuotKE',
    @p_DoTuoiQuyDinh = 'T16',
    @p_DaoDien = N'Weeravat Chayochaikon, Ongart Cheamcharoenpornkul, Voravuth Thawinwisitwat',
    @p_NgayKhoiChieu = '2025-11-14',
    @p_NgayNgungChieu = '2025-11-27',
    @p_ThoiLuong = 90,
    @p_QuocGiaSanXuat = N'Thái Lan',
    @p_NamSanXuat = 2025, 
    @p_TinhTrang = N'Đang chiếu',
    @p_MoTa = N'Chuyến đi Nhật tưởng chừng đơn giản của nhà sư nghiêm khắc Luang Phi Pae bỗng rẽ sang hướng khó tin: vị hôn phu của em gái ông lại chính là một nhà sư Nhật Bản với quá khứ bí ẩn. Từ đó, những tình huống oái oăm, dở khóc dở cười nối tiếp nhau, tạo nên hành trình vừa hài hước vừa cảm động.'
GO

/*================================ UPDATE ======================================== */

CREATE OR ALTER PROCEDURE sp_validate_update_PHIM (
	@p_MaPhim VARCHAR(10),
	@p_TenPhim NVARCHAR(255),
    @p_Poster NVARCHAR(MAX), /* Lưu link ảnh */
    @p_Trailer NVARCHAR(MAX), /* Lưu link video */
    @p_DoTuoiQuyDinh NVARCHAR(10), /* Ví dụ: 'T18', 'P' */
    @p_DaoDien NVARCHAR(255),
    @p_NgayKhoiChieu DATE,
    @p_NgayNgungChieu DATE,
    @p_ThoiLuong INT, /* Thời lượng (phút) */
    @p_QuocGiaSanXuat NVARCHAR(100),
    @p_NamSanXuat INT,
    @p_TinhTrang NVARCHAR(100), /* Sắp chiếu, Đang chiếu */
    @p_MoTa NVARCHAR(MAX)
)  
AS
BEGIN
    -- Kiểm tra tồn tại mã phim
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.PHIM P
        WHERE @p_MaPhim = P.MaPhim
    )
    BEGIN
        RAISERROR (
            N'Lỗi dữ liệu không tồn tại: Mã phim %s không tồn tại!', -- Nội dung tin nhắn lỗi
            11, -- Severity: 11-16 là user-defined error
            6, -- State: phân biệt các loại lỗi
            @p_MaPhim -- Tên tham số
        );
        RETURN;
    END

    -- Kiểm tra tên phim không trống
    IF @p_TenPhim IS NULL OR LTRIM(RTRIM(@p_TenPhim)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Tên phim không được để trống!', 11, 2);
        RETURN;
    END

    -- Kiểm tra độ tuổi quy định
    IF @p_DoTuoiQuyDinh NOT IN ('P', 'K', 'T13', 'T16', 'T18', 'C')
    BEGIN
        RAISERROR(
            N'Lỗi định dạng dữ liệu: Độ tuổi quy định không hợp lệ! Chỉ chấp nhận: P, K, T13, T16, T18, C.',
            11, 5
        );
        RETURN;
    END

    -- Kiểm tra thời lượng
    IF @p_ThoiLuong <= 0
    BEGIN
        RAISERROR (N'Lỗi dữ liệu <= 0: Thời lượng phim phải lớn hơn 0 phút!', 11, 3);
        RETURN;
    END

    -- Kiểm tra ngày chiếu
    IF @p_NgayNgungChieu < @p_NgayKhoiChieu
    BEGIN
        RAISERROR(N'Lỗi thời gian không hợp lệ: Ngày ngừng chiếu phải sau hoặc bằng ngày khởi chiếu!', 11, 4);
        RETURN;
    END

    -- Kiểm tra năm sản xuất
    DECLARE @current_year INT;
    SET @current_year = YEAR(GETDATE());
    IF @p_NamSanXuat > @current_year
    BEGIN
        RAISERROR (
            N'Lỗi thời gian không hợp lệ: Năm sản xuất (%d) không được lớn hơn năm hiện tại (%d)!', 
            11, 
            4,
            @p_NamSanXuat,
            @current_year
        );
        RETURN;
    END

    -- Kiểm tra tình trạng hợp lệ
    IF @p_TinhTrang NOT IN (N'Sắp chiếu', N'Đang chiếu')
    BEGIN
        RAISERROR(N'Lỗi cú pháp: Tình trạng chỉ được là "Sắp chiếu" hoặc "Đang chiếu".', 11, 5);
        RETURN;
    END

    -- Update dữ liệu
    UPDATE dbo.PHIM
    SET 
        TenPhim = @p_TenPhim,
        Poster = @p_Poster,
        Trailer = @p_Trailer,
        DoTuoiQuyDinh = @p_DoTuoiQuyDinh,
        DaoDien = @p_DaoDien,
        NgayKhoiChieu = @p_NgayKhoiChieu,
        NgayNgungChieu = @p_NgayNgungChieu,
        ThoiLuong = @p_ThoiLuong,
        QuocGiaSanXuat = @p_QuocGiaSanXuat,
        NamSanXuat = @p_NamSanXuat,
        TinhTrang = @p_TinhTrang,
        MoTa = @p_MoTa
    WHERE 
        MaPhim = @p_MaPhim;

    PRINT N'Cập nhật phim thành công!';
END
GO

EXEC sp_validate_update_PHIM 
    @p_MaPhim = 'P000000001', -- Mã phim phải tồn tại
    @p_TenPhim = N'Sư thầy gặp sư lầy (Bản đã cập nhật)', -- Tên mới
    @p_Poster = 'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/w/y/wymm_kv_1810_up.jpg',
    @p_Trailer = 'https://youtu.be/ny6xpuuotKE',
    @p_DoTuoiQuyDinh = 'T16',
    @p_DaoDien = N'Weeravat Chayochaikon, Ongart Cheamcharoenpornkul, Voravuth Thawinwisitwat',
    @p_NgayKhoiChieu = '2025-11-14',
    @p_NgayNgungChieu = '2025-11-28', -- Cập nhật ngày ngừng chiếu
    @p_ThoiLuong = 95, -- Cập nhật thời lượng
    @p_QuocGiaSanXuat = N'Thái Lan',
    @p_NamSanXuat = 2025, 
    @p_TinhTrang = N'Đang chiếu',
    @p_MoTa = N'Mô tả đã được cập nhật. Chuyến đi Nhật tưởng chừng đơn giản...' -- Cập nhật mô tả
GO

SELECT *
FROM dbo.PHIM
GO

/*================================ DELETE ======================================== */

CREATE OR ALTER PROCEDURE sp_validate_delete_PHIM
    @p_MaPhim VARCHAR(10)
AS
BEGIN
    DECLARE @v_count INT;

    SELECT @v_count = COUNT(*)
    FROM dbo.PHIM P
    WHERE @p_MaPhim = P.MaPhim;

    IF @v_count != 1
    BEGIN
        RAISERROR (N'Lỗi dữ liệu không tồn tại: Mã phim %s không tồn tại trong hệ thống!', 11, 6, @p_MaPhim);
        RETURN;
    END
    
    DELETE FROM dbo.PHIM
    WHERE @p_MaPhim = MaPhim;

    PRINT(N'Xóa phim thành công!')
END
GO

EXEC sp_validate_delete_PHIM 'P000000001'
GO

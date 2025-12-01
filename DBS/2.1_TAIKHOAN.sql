-- USE RAPPHIM
-- State các lỗi:
    -- Lỗi trùng lặp: 1
    -- Lỗi dữ liệu trống: 2
    -- Lỗi dữ liệu <= 0: 3
    -- Lỗi thời gian không hợp lệ: 4
    -- Lỗi định dạng dữ liệu: 5

SET NOCOUNT ON;

/*================================ INSERT ======================================== */

CREATE OR ALTER PROCEDURE sp_validate_insert_TAIKHOAN
    @p_TenDangNhap VARCHAR(50),
    @p_Email VARCHAR(100),
    @p_MatKhau VARCHAR(255)
AS
BEGIN
    -- Kiểm tra NULL
    IF @p_TenDangNhap IS NULL OR LTRIM(RTRIM(@p_TenDangNhap)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Không được để trống tên đăng nhập!', 11, 2);
        RETURN;
    END

    IF LEN(@p_TenDangNhap) <= 5
    BEGIN
        RAISERROR (N'Lỗi định dạng dữ liệu: Tên đăng nhập cần nhiều hơn 5 ký tự!', 11, 5)
        RETURN;
    END

    -- Kiểm tra tên đăng nhập trùng
    IF EXISTS (
        SELECT 1
        FROM dbo.TAIKHOAN TK
        WHERE @p_TenDangNhap = TK.TenDangNhap
    )
    BEGIN
        RAISERROR (
            N'Lỗi trùng lặp: Tên đăng nhập %s đã tồn tại!', -- Nội dung tin nhắn lỗi
            11, -- Severity: 11-16 là user-defined error
            1, -- State: phân biệt các loại lỗi
            @p_TenDangNhap -- Tên tham số
        );
        RETURN;
    END

    IF @p_Email IS NULL OR LTRIM(RTRIM(@p_Email)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Không được để trống email!', 11, 2);
        RETURN;
    END

    -- Kiểm tra định dạng email
    IF @p_Email NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR (N'Lỗi định dạng dữ liệu: Email không hợp lệ!', 11, 5);
        RETURN;
    END

    -- Kiểm tra email trùng
    IF EXISTS (
        SELECT 1
        FROM dbo.TAIKHOAN TK
        WHERE @p_Email = TK.Email
    )
    BEGIN
        RAISERROR (
            N'Lỗi trùng lặp: Email %s đã tồn tại!', -- Nội dung tin nhắn lỗi
            11, -- Severity: 11-16 là user-defined error
            1, -- State: phân biệt các loại lỗi
            @p_Email-- Tên tham số
        );
        RETURN;
    END

    IF @p_MatKhau IS NULL OR LTRIM(RTRIM(@p_MatKhau)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Không được để trống mật khẩu!', 11, 2);
        RETURN;
    END

     -- Kiểm tra mật khẩu mạnh
    IF NOT (
            LEN(@p_MatKhau) > 8
            AND PATINDEX('%[0-9]%', @p_MatKhau) > 0
            AND PATINDEX('%[a-z]%', @p_MatKhau COLLATE Latin1_General_CS_AS) > 0
            AND PATINDEX('%[A-Z]%', @p_MatKhau COLLATE Latin1_General_CS_AS) > 0
            AND PATINDEX('%[^a-zA-Z0-9]%', @p_MatKhau) > 0
        )
    BEGIN
        RAISERROR (N'Lỗi định dạng dữ liệu: Mật khẩu phải trên 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt!', 11, 6);
        RETURN;
    END

    INSERT INTO TAIKHOAN (TenDangNhap, Email, MatKhau)
    VALUES (@p_TenDangNhap, @p_Email, @p_MatKhau);
    PRINT N'Thêm tài khoản thành công!';
END
GO

-- Thực thi thủ tục 
EXEC sp_validate_insert_TAIKHOAN
    @p_TenDangNhap = 'ohngocnhu4',
    @p_Email = 'ohngocnhu23@gmail.com',
    @p_MatKhau = 'Nhu123456*'
GO

SELECT *
FROM TAIKHOAN

/*================================ UPDATE ======================================== */

CREATE OR ALTER PROCEDURE sp_validate_update_TAIKHOAN
	@p_MaTaiKhoan VARCHAR(10),
    @p_TenDangNhap VARCHAR(50),
    @p_Email VARCHAR(100),
    @p_MatKhau VARCHAR(255)
AS
BEGIN
    -- Kiểm tra NULL
    IF @p_MaTaiKhoan IS NULL OR LTRIM(RTRIM(@p_MaTaiKhoan)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Không được để trống mã tài khoản!', 11, 2);
        RETURN;
    END

    -- Kiểm tra mã tài khoản không tồn tại
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.TAIKHOAN TK
        WHERE @p_MaTaiKhoan = TK.MaTaiKhoan
    )
    BEGIN
        RAISERROR (
            N'Lỗi trùng lặp: Mã tài khoản %s không tồn tại!', -- Nội dung tin nhắn lỗi
            11, -- Severity: 11-16 là user-defined error
            1, -- State: phân biệt các loại lỗi
            @p_MaTaiKhoan -- Tên tham số
        );
        RETURN;
    END

    -- Kiểm tra NULL
    IF @p_TenDangNhap IS NULL OR LTRIM(RTRIM(@p_TenDangNhap)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Không được để trống tên đăng nhập!', 11, 2);
        RETURN;
    END

    IF LEN(@p_TenDangNhap) <= 5
    BEGIN
        RAISERROR (N'Lỗi định dạng dữ liệu: Tên đăng nhập cần nhiều hơn 5 ký tự!', 11, 5)
        RETURN;
    END

    -- Kiểm tra tên đăng nhập trùng
    IF EXISTS (
        SELECT 1
        FROM dbo.TAIKHOAN TK
        WHERE @p_TenDangNhap = TK.TenDangNhap
    )
    BEGIN
        RAISERROR (
            N'Lỗi trùng lặp: Tên đăng nhập %s đã tồn tại!', -- Nội dung tin nhắn lỗi
            11, -- Severity: 11-16 là user-defined error
            1, -- State: phân biệt các loại lỗi
            @p_TenDangNhap -- Tên tham số
        );
        RETURN;
    END

    IF @p_Email IS NULL OR LTRIM(RTRIM(@p_Email)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Không được để trống email!', 11, 2);
        RETURN;
    END

    -- Kiểm tra định dạng email
    IF @p_Email NOT LIKE '%_@__%.__%'
    BEGIN
        RAISERROR (N'Lỗi định dạng dữ liệu: Email không hợp lệ!', 11, 5);
        RETURN;
    END

    -- Kiểm tra email trùng
    IF EXISTS (
        SELECT 1
        FROM dbo.TAIKHOAN TK
        WHERE @p_Email = TK.Email
    )
    BEGIN
        RAISERROR (
            N'Lỗi trùng lặp: Email %s đã tồn tại!', -- Nội dung tin nhắn lỗi
            11, -- Severity: 11-16 là user-defined error
            1, -- State: phân biệt các loại lỗi
            @p_Email-- Tên tham số
        );
        RETURN;
    END

    IF @p_MatKhau IS NULL OR LTRIM(RTRIM(@p_MatKhau)) = ''
    BEGIN
        RAISERROR (N'Lỗi dữ liệu trống: Không được để trống mật khẩu!', 11, 2);
        RETURN;
    END

     -- Kiểm tra mật khẩu mạnh
    IF NOT (
            LEN(@p_MatKhau) > 8
            AND PATINDEX('%[0-9]%', @p_MatKhau) > 0
            AND PATINDEX('%[a-z]%', @p_MatKhau COLLATE Latin1_General_CS_AS) > 0
            AND PATINDEX('%[A-Z]%', @p_MatKhau COLLATE Latin1_General_CS_AS) > 0
            AND PATINDEX('%[^a-zA-Z0-9]%', @p_MatKhau) > 0
        )
    BEGIN
        RAISERROR (N'Lỗi định dạng dữ liệu: Mật khẩu phải trên 8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt!', 11, 6);
        RETURN;
    END

    UPDATE TAIKHOAN 
    SET 
        TenDangNhap = @p_TenDangNhap,
        Email = @p_Email,
        MatKhau = @p_MatKhau
    WHERE 
        MaTaiKhoan = @p_MaTaiKhoan

    PRINT N'Cập nhật tài khoản thành công!';
END
GO

/*================================ DELETE ======================================== */

CREATE OR ALTER PROCEDURE sp_validate_delete_TAIKHOAN
    @p_MaTaiKhoan VARCHAR(10)
AS
BEGIN
    DECLARE @v_count INT;

    SELECT @v_count = COUNT(*)
    FROM dbo.TAIKHOAN P
    WHERE @p_MaTaiKhoan = P.MaTaiKhoan;

    IF @v_count != 1
    BEGIN
        RAISERROR (N'Lỗi dữ liệu không tồn tại: Mã tài khoản không tồn tại trong hệ thống!', 11, 6);
        RETURN;
    END
    
    DELETE FROM dbo.TAIKHOAN
    WHERE @p_MaTaiKhoan = MaTaiKhoan;

    PRINT(N'Xóa tài khoản thành công!')
END
GO

-- Xem dữ liệu vừa thêm
SELECT * 
FROM dbo.TAIKHOAN
GO

EXEC sp_validate_delete_TAIKHOAN '0000000003'
GO
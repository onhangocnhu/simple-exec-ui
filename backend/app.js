import express from "express";
import sql from "mssql";
import cors from "cors";
import { config } from "./dbconfig.js";

const app = express();
app.use(express.json());
app.use(cors());

// POST /execute: gọi stored procedure và trả kết quả
app.post("/execute", async (req, res) => {
  const { procName, params, table } = req.body;

  try {
    const pool = await sql.connect(config);
    const request = pool.request();

    // Gán tham số: @p_X → input("p_X")
    for (const key of Object.keys(params)) {
      const cleanName = key.replace("@", "");
      const value = params[key];
      const fixedValue = (value === "" || value === undefined) ? null : value;

      request.input(cleanName, fixedValue);
    }

    // Gọi PROCEDURE
    const execResult = await request.execute(procName);

    // // Nếu procedure không lỗi → lấy danh sách bảng
    // const tableResult = await pool
    //   .request()
    //   .query(`SELECT * FROM ${table}`);

    res.json({
      success: true,
      message: "Thực thi stored procedure thành công",
      execResult: execResult.recordset ?? null,
      // data: tableResult.recordset
    });

  } catch (err) {
    res.json({
      success: false,
      message:
        err.originalError?.info?.message ||
        err.message ||
        "Lỗi không xác định"
    });
  }
});

app.post("/check-profile", async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.json({ success: false, message: "Vui lòng nhập đầy đủ thông tin" });
    }

    try {
        const pool = await sql.connect(config);
        
        // Lấy thông tin tài khoản + thông tin thành viên
        const result = await pool.request()
            .input("inputUser", sql.VarChar, username)
            .query(`
                SELECT 
                    TK.MaTaiKhoan, 
                    TK.TenDangNhap, 
                    TK.MatKhau, 
                    TK.Email,
                    -- Lấy thông tin bảng Khách Hàng
                    KHTV.MaTaiKhoan AS LaThanhVien, 
                    KHTV.Ho, 
                    KHTV.Ten, 
                    KHTV.SoDienThoai, 
                    KHTV.LoaiThanhVien, 
                    KHTV.TheThanhVien, 
                    KHTV.DiemTichLuy, 
                    KHTV.TongDiemTichLuy,
                    TK.TenDangNhap,
                    KHTV.GioiTinh,
                    KHTV.NgaySinh
                FROM TAIKHOAN AS TK
                -- LEFT JOIN để tìm user trước, sau đó mới check có phải thành viên ko
                JOIN KHACHHANGTHANHVIEN AS KHTV ON TK.MaTaiKhoan = KHTV.MaTaiKhoan
                WHERE TK.TenDangNhap = @inputUser 
                   OR TK.Email = @inputUser 
                   OR KHTV.SoDienThoai = @inputUser
            `);

        const user = result.recordset[0];

        //  Tài khoản có tồn tại?
        if (result.recordset.length === 0 || !user.LaThanhVien) {
            return res.json({ success: false, message: "Tài khoản khách hàng không tồn tại" });
        }

        

        // Sai mật khẩu?
        if (user.MatKhau !== password) {
            return res.json({ success: false, message: "Mật khẩu không chính xác" });
        }

        //Tính tổng chi tiêu 
        const spendingResult = await pool.request()
            .input("maKH", sql.VarChar, user.MaTaiKhoan)
            .query(`SELECT dbo.fnc_TongChiTieu(@maKH) AS TongChiTieu`);

        const tongChiTieu = spendingResult.recordset[0]?.TongChiTieu || 0;

        res.json({
            success: true,
            message: "Lấy thông tin thành công",
            data: {
                id: user.MaTaiKhoan,
                fullName: user.Ho + " " + user.Ten,
                email: user.Email,
                phone: user.SoDienThoai || "Chưa cập nhật",
                rank: user.LoaiThanhVien || "Thường",
                memberCard: user.TheThanhVien || "Chưa tạo thẻ",
                cgvPoint: user.DiemTichLuy || 0,
                totalSpending: tongChiTieu,
                birth: user.NgaySinh 
                    ? new Date(user.NgaySinh).toLocaleDateString("en-GB") 
                    : "Chưa cập nhật",
                username: user.TenDangNhap,
                gender: user.GioiTinh || "Chưa cập nhật"
            }
        });

    } catch (err) {
        console.error("Lỗi Server:", err);
        res.status(500).json({ success: false, message: "Lỗi hệ thống: " + err.message });
    }
});


// Chạy server
app.listen(3001, () =>
  console.log("Backend is running on port 3001")
);

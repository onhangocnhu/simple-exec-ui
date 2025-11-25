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
      // Nếu FE gửi "", tức là user muốn bỏ qua field → NULL
      const fixedValue = (value === "" || value === undefined) ? null : value;

      request.input(cleanName, fixedValue);
    }

    // Gọi PROCEDURE
    const execResult = await request.execute(procName);

    // Nếu procedure không lỗi → lấy danh sách bảng
    const tableResult = await pool
      .request()
      .query(`SELECT * FROM ${table}`);

    res.json({
      success: true,
      message: "Thực thi stored procedure thành công",
      execResult: execResult.recordset ?? null,
      data: tableResult.recordset
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

// Chạy server
app.listen(3001, () =>
  console.log("Backend is running on port 3001")
);

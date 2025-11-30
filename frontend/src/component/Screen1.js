import { useState, useEffect } from "react";
import "../styles/Screen1.css";

// export const Screen1 = () => {
export const Screen1 = (
  { initialAction = "insert", initialTable = "PHIM", initialInputValues = {} } = {}
) => {
  // --- 1. KHAI BÁO CẤU HÌNH DỮ LIỆU (CONFIG) ---

  // Danh sách tham số cơ bản của PHIM (dùng cho Insert)
  const PHIM_PARAMS = [
    { name: "@p_TenPhim", placeholder: "Sư thầy gặp sư lầy" },
    { name: "@p_Poster", placeholder: "https://..." },
    { name: "@p_Trailer", placeholder: "https://youtu.be..." },
    { name: "@p_DoTuoiQuyDinh", placeholder: "T16" },
    { name: "@p_DaoDien", placeholder: "Tên đạo diễn..." },
    { name: "@p_NgayKhoiChieu", placeholder: "2025-11-14" },
    { name: "@p_NgayNgungChieu", placeholder: "2025-11-27" },
    { name: "@p_ThoiLuong", placeholder: "90" },
    { name: "@p_QuocGiaSanXuat", placeholder: "Thái Lan" },
    { name: "@p_NamSanXuat", placeholder: "2025" },
    { name: "@p_TinhTrang", placeholder: "Đang chiếu" },
    { name: "@p_MoTa", placeholder: "Mô tả phim..." },
  ];

  // Danh sách tham số cơ bản của TAIKHOAN (dùng cho Insert)
  const TAIKHOAN_PARAMS = [
    { name: "@p_TenDangNhap", placeholder: "hello" },
    { name: "@p_Email", placeholder: "hello@gmail.com" },
    { name: "@p_MatKhau", placeholder: "12341234*" },
  ];

  // --- 2. STATE MANAGEMENT ---
  // const [action, setAction] = useState("insert"); // insert, update, delete
  // const [table, setTable] = useState("PHIM"); // PHIM, TAIKHOAN
  // const [inputValues, setInputValues] = useState({}); // Lưu giá trị người dùng nhập
  const [queryResult, setQueryResult] = useState(null);
  const [showInputs, setShowInputs] = useState(false);

  const [action, setAction] = useState(initialAction); // insert, update, delete
  const [table, setTable] = useState(initialTable);   // PHIM, TAIKHOAN
  const [inputValues, setInputValues] = useState(() =>
    initialInputValues && Object.keys(initialInputValues).length > 0
      ? initialInputValues
      : {}
  );
  // Reset input khi đổi bảng hoặc đổi hành động
  // useEffect(() => {
  //   setInputValues({});
  // }, [action, table]);

  // Reset input khi đổi bảng hoặc đổi hành động
  // Reset input khi người dùng tự đổi bảng hoặc hành động
  useEffect(() => {
    // Chỉ reset khi action/table khác với giá trị ban đầu
    if (action !== initialAction || table !== initialTable) {
      setInputValues({});
    }
  }, [action, table, initialAction, initialTable]);


  // --- 3. LOGIC XỬ LÝ ---

  // Hàm lấy tên Stored Procedure
  const getStoredProcName = () => {
    return `sp_validate_${action}_${table}`;
  };

  // Hàm lấy danh sách tham số cần hiển thị dựa trên Logic bạn yêu cầu
  const getCurrentParams = () => {
    let params = [];

    // A. Xử lý bảng PHIM
    if (table === "PHIM") {
      if (action === "delete") {
        // Delete: Chỉ cần MaPhim
        params = [{ name: "@p_MaPhim", placeholder: "Nhập mã phim để xóa..." }];
      } else if (action === "update") {
        // Update: MaPhim + Các trường còn lại
        params = [
          { name: "@p_MaPhim", placeholder: "Nhập mã phim cần sửa..." },
          ...PHIM_PARAMS,
        ];
      } else {
        // Insert: Các trường còn lại (không có MaPhim)
        params = [...PHIM_PARAMS];
      }
    }
    // B. Xử lý bảng TAIKHOAN
    else if (table === "TAIKHOAN") {
      if (action === "delete") {
        params = [
          { name: "@p_MaTaiKhoan", placeholder: "Nhập mã TK để xóa..." },
        ];
      } else if (action === "update") {
        params = [
          { name: "@p_MaTaiKhoan", placeholder: "Nhập mã TK cần sửa..." },
          ...TAIKHOAN_PARAMS,
        ];
      } else {
        params = [...TAIKHOAN_PARAMS];
      }
    }

    return params;
  };

  const handleRun = async () => {
    const procName = getStoredProcName();
    const tableName = table;

    const fullParams = {};
    activeParams.forEach((p) => {
      fullParams[p.name] = inputValues[p.name] ?? "";
    });

    try {
      const response = await fetch("http://localhost:3001/execute", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          procName,
          params: fullParams,
          table: tableName
        }),
      });

      const result = await response.json();

      if (!result.success) {
        alert("❌ Lỗi: " + result.message);
        return;
      }

      alert("✔ Thành công!");

      // Hiển thị kết quả SELECT * FROM TABLE
      console.log("Dữ liệu trả về:", result.data);

      setQueryResult(result.data);
    } catch (err) {
      alert("❌ Lỗi FE: " + err.message);
    }
  };



  // Hàm xử lý khi người dùng nhập liệu vào input
  const handleInputChange = (paramName, value) => {
    setInputValues((prev) => ({
      ...prev,
      [paramName]: value,
    }));
  };

  const activeParams = getCurrentParams();

  return (
    <div className={`screen-container ${queryResult ? "with-result" : ""}`}>
      {/* LEFT PANEL */}
      <div className="left-panel">
        <div className="control-panel">
          <div className="control-group">
            <label>Hành động:</label>
            <select value={action} onChange={(e) => setAction(e.target.value)}>
              <option value="insert">Thêm (INSERT)</option>
              <option value="update">Sửa (UPDATE)</option>
              <option value="delete">Xóa (DELETE)</option>
            </select>
          </div>

          <div className="control-group">
            <label>Bảng dữ liệu:</label>
            <select value={table} onChange={(e) => setTable(e.target.value)}>
              <option value="PHIM">Bảng PHIM</option>
              <option value="TAIKHOAN">Bảng TAIKHOAN</option>
            </select>
          </div>
        </div>

        <div className="toggle-bar">
          <button className="btn-toggle" onClick={() => setShowInputs(!showInputs)}>
            {showInputs ? "Ẩn khu vực nhập lệnh" : "Hiện khu vực nhập lệnh"}
          </button>
        </div>

        {showInputs && (
          <>
            <div className="code-editor">
              <div className="sql-keyword line">
                <span className="keyword">EXEC</span>{" "}
                <span className="proc-name">{getStoredProcName()}</span>
              </div>

              {activeParams.map((param, index) => {
                const isLast = index === activeParams.length - 1;
                return (
                  <div key={param.name} className="param-line line">
                    <span className="param-name">{param.name}</span>
                    <span className="operator"> = </span>
                    <input
                      type={param.name.includes("Ngay") ? "date" : "text"}
                      className="sql-input"
                      placeholder={param.placeholder}
                      value={inputValues[param.name] || ""}
                      onChange={(e) => handleInputChange(param.name, e.target.value)}
                    />
                    {!isLast && <span className="comma">,</span>}
                  </div>
                );
              })}
            </div>

            <button className="btn-run" onClick={handleRun}>▶ CHẠY THỦ TỤC</button>
          </>
        )}
      </div>

      {/* RIGHT PANEL (TABLE) */}
      {/* {queryResult && (
        <div className="right-panel">
          <div className="table-container">
            <table className="result">
              <thead>
                <tr>
                  {Object.keys(queryResult[0]).map((col) => (
                    <th key={col}>{col}</th>
                  ))}
                </tr>
              </thead>

              <tbody>
                {queryResult.map((row, idx) => (
                  <tr key={idx}>
                    {Object.values(row).map((val, i) => (
                      <td key={i}>{String(val)}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )} */}
    </div>
  );
};

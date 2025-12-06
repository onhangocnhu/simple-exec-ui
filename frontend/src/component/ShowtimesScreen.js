import { useState } from "react";
import { Screen1 } from "./Screen1";
import "../styles/ShowtimesScreen.css";

const formatDate = (value) => {
  if (!value) return "";
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return value; // nếu không parse được thì trả lại string raw
  return d.toLocaleDateString("vi-VN");
};

const formatTime = (value) => {
  if (!value) return "";
  const d = new Date(value);
  if (Number.isNaN(d.getTime())) return value;
  return d.toLocaleTimeString("vi-VN", {
    hour: "2-digit",
    minute: "2-digit",
  }); // 09:00
};

export const ShowtimesScreen = () => {
  // ---------- STATE CHO TRA CỨU LỊCH CHIẾU ----------
  const [tenPhim, setTenPhim] = useState("");
  const [ngayChieu, setNgayChieu] = useState("");
  const [showtimes, setShowtimes] = useState([]);
  const [searchText, setSearchText] = useState("");
  const [sortKey, setSortKey] = useState("");
  const [sortDir, setSortDir] = useState("asc");
  const [loadingShowtimes, setLoadingShowtimes] = useState(false);

  const [selectedRow, setSelectedRow] = useState(null);
  const [selectedMaPhim, setSelectedMaPhim] = useState("");
  const [showUpdateModal, setShowUpdateModal] = useState(false);
  const [showDeleteModal, setShowDeleteModal] = useState(false);

  // ---------- STATE CHO BÁO CÁO DOANH THU ----------
  const [tuNgay, setTuNgay] = useState("");
  const [denNgay, setDenNgay] = useState("");
  const [doanhThuMoc, setDoanhThuMoc] = useState("");
  const [kieuLoc, setKieuLoc] = useState("1");
  const [reports, setReports] = useState([]);
  const [loadingReport, setLoadingReport] = useState(false);

  const [errorMsg, setErrorMsg] = useState("");

  // ----------- GỌI sp_TraCuuLichChieu -----------
  const handleSearchShowtimes = async () => {
    setLoadingShowtimes(true);
    setErrorMsg("");

    try {
      const res = await fetch("http://localhost:3001/execute", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          procName: "sp_TraCuuLichChieu",
          params: {
            "@p_TenPhim": tenPhim || "",
            "@p_NgayChieu": ngayChieu || null,
          },
          table: "PHIM",
        }),
      });

      const json = await res.json();

      if (!json.success) {
        setErrorMsg(json.message || "Lỗi khi tra cứu lịch chiếu");
        setShowtimes([]);
        setSelectedRow(null);
        setSelectedMaPhim("");
      } else {
        const rows = json.execResult || json.data || [];
        setShowtimes(rows);
        setSelectedRow(null);
        setSelectedMaPhim("");
      }
    } catch (err) {
      setErrorMsg(err.message);
      setShowtimes([]);
      setSelectedRow(null);
      setSelectedMaPhim("");
    } finally {
      setLoadingShowtimes(false);
    }
  };

  // ----------- GỌI sp_BaoCaoDoanhThuRap_ThucTe -----------
  const handleSearchReport = async () => {
    setLoadingReport(true);
    setErrorMsg("");

    try {
      const res = await fetch("http://localhost:3001/execute", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          procName: "sp_BaoCaoDoanhThuRap_ThucTe",
          params: {
            "@p_TuNgay": tuNgay || null,
            "@p_DenNgay": denNgay || null,
            "@p_DoanhThuMoc": doanhThuMoc ? Number(doanhThuMoc) : null,
            "@p_KieuLoc": kieuLoc ? Number(kieuLoc) : null,
          },
          table: "PHIM",
        }),
      });

      const json = await res.json();

      if (!json.success) {
        setErrorMsg(json.message || "Lỗi khi tra cứu báo cáo doanh thu");
        setReports([]);
      } else {
        const rows = json.execResult || json.data || [];
        setReports(rows);
      }
    } catch (err) {
      setErrorMsg(err.message);
      setReports([]);
    } finally {
      setLoadingReport(false);
    }
  };

  // ----------- XỬ LÝ SEARCH + SORT SUẤT CHIẾU -----------
  const getProcessedShowtimes = () => {
    let rows = [...showtimes];

    // search text (lọc chung trên mọi cột)
    if (searchText.trim() !== "") {
      const lower = searchText.toLowerCase();
      rows = rows.filter((row) =>
        Object.values(row).some((val) =>
          String(val).toLowerCase().includes(lower)
        )
      );
    }

    // sort
    if (sortKey) {
      rows.sort((a, b) => {
        const va = a[sortKey];
        const vb = b[sortKey];

        if (va == null && vb == null) return 0;
        if (va == null) return sortDir === "asc" ? -1 : 1;
        if (vb == null) return sortDir === "asc" ? 1 : -1;

        // so sánh dạng string cho đơn giản
        const sa = String(va);
        const sb = String(vb);
        if (sa < sb) return sortDir === "asc" ? -1 : 1;
        if (sa > sb) return sortDir === "asc" ? 1 : -1;
        return 0;
      });
    }

    return rows;
  };

  const processedShowtimes = getProcessedShowtimes();
  const showtimeColumns =
    processedShowtimes.length > 0 ? Object.keys(processedShowtimes[0]) : [];

  const reportColumns =
    reports.length > 0 ? Object.keys(reports[0]) : [];

  // ----------- CHỌN DÒNG SUẤT CHIẾU -----------
  const handleSelectRow = (row) => {
    setSelectedRow(row);
    const maPhim = row.MaPhim || row.MaPhimChieu || row.MAPHIM || "";
    setSelectedMaPhim(maPhim);
  };

  const handleUpdateFilm = () => {
    if (!selectedMaPhim) {
      alert("Hãy chọn 1 dòng SUẤT CHIẾU trước.");
      return;
    }
    setShowUpdateModal(true);
  };

  const handleDeleteFilm = () => {
    if (!selectedMaPhim) {
      alert("Hãy chọn 1 dòng SUẤT CHIẾU trước.");
      return;
    }
    setShowDeleteModal(true);
  };

  return (
    <div
      className={`showtimes-screen ${processedShowtimes.length || reports.length ? "with-result" : ""
        }`}
    >
      {/* LEFT PANEL: FORM FILTER + BUTTONS */}
      <div className="showtimes-left-panel">
        <h2>Tra cứu lịch chiếu</h2>

        <div className="control-panel1">
          <div className="control-group1">
            <label>Tên phim:</label>
            <input
              type="text"
              value={tenPhim}
              onChange={(e) => setTenPhim(e.target.value)}
              placeholder="Nhập tên phim..."
            />
          </div>

          <div className="control-group1">
            <label>Ngày chiếu:</label>
            <input
              type="date"
              value={ngayChieu}
              onChange={(e) => setNgayChieu(e.target.value)}
            />
          </div>

          <button className="btn-run" onClick={handleSearchShowtimes}>
            {loadingShowtimes ? "Đang tra cứu..." : "▶ Tra cứu lịch chiếu"}
          </button>
        </div>

        <hr />

        <h2>Báo cáo doanh thu rạp</h2>

        <div className="control-panel1">
          <div className="control-group1">
            <label>Từ ngày:</label>
            <input
              type="date"
              value={tuNgay}
              onChange={(e) => setTuNgay(e.target.value)}
            />
          </div>

          <div className="control-group1">
            <label>Đến ngày:</label>
            <input
              type="date"
              value={denNgay}
              onChange={(e) => setDenNgay(e.target.value)}
            />
          </div>

          <div className="control-group1">
            <label>Doanh thu mốc:</label>
            <input
              type="number"
              value={doanhThuMoc}
              onChange={(e) => setDoanhThuMoc(e.target.value)}
              placeholder="300000"
            />
          </div>

          <div className="control-group1">
            <label>Kiểu lọc (1,2,...):</label>
            <input
              type="number"
              value={kieuLoc}
              onChange={(e) => setKieuLoc(e.target.value)}
            />
          </div>

          <button className="btn-run" onClick={handleSearchReport}>
            {loadingReport ? "Đang tạo báo cáo..." : "▶ Xem báo cáo doanh thu"}
          </button>
        </div>

        <hr />

        <h3>Thao tác khác</h3>
        <div className="control-panel1">
          <button onClick={handleUpdateFilm}>
            Cập nhật thông tin PHIM (từ dòng đã chọn)
          </button>
          <button onClick={handleDeleteFilm}>
            Xóa PHIM (từ dòng đã chọn)
          </button>
        </div>

        {errorMsg && (
          <div style={{ color: "red", marginTop: "8px" }}>
            Lỗi: {errorMsg}
          </div>
        )}
      </div>

      {/* RIGHT PANEL: BẢNG KẾT QUẢ */}
      <div className="showtimes-right-panel">
        {/* BẢNG SUẤT CHIẾU */}
        <h3>Danh sách SUẤT CHIẾU</h3>

        {showtimes.length > 0 ? (
          <>
            <div className="control-panel1">
              <div className="control-group1">
                <label>Search trong bảng:</label>
                <input
                  type="text"
                  value={searchText}
                  onChange={(e) => setSearchText(e.target.value)}
                  placeholder="Nhập text để lọc..."
                />
              </div>

              <div className="control-group1">
                <label>Sắp xếp theo cột:</label>
                <select
                  value={sortKey}
                  onChange={(e) => setSortKey(e.target.value)}
                >
                  <option value="">-- Không sắp xếp --</option>
                  {showtimeColumns.map((col) => (
                    <option key={col} value={col}>
                      {col}
                    </option>
                  ))}
                </select>
              </div>

              <div className="control-group11">
                <label>Chiều:</label>
                <select
                  value={sortDir}
                  onChange={(e) => setSortDir(e.target.value)}
                >
                  <option value="asc">Tăng dần</option>
                  <option value="desc">Giảm dần</option>
                </select>
              </div>
            </div>

            <div className="table-container1">
              <table className="result1">
                <thead>
                  <tr>
                    {showtimeColumns.map((col) => (
                      <th key={col}>{col}</th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {processedShowtimes.length > 0 ? (
                    processedShowtimes.map((row, idx) => {
                      const isSelected = selectedRow === row;
                      return (
                        <tr
                          key={idx}
                          onClick={() => handleSelectRow(row)}
                          className={isSelected ? "row-selected" : ""}
                        >
                          {showtimeColumns.map((col) => (
                            <td key={col}>
                              {col === "NgayChieu"
                                ? formatDate(row[col])
                                : ["ThoiGianBatDau", "ThoiGianKetThuc"].includes(col)
                                  ? formatTime(row[col])
                                  : row[col]}
                            </td>
                          ))}
                        </tr>
                      );
                    })
                  ) : (
                    <tr>
                      <td colSpan={showtimeColumns.length} style={{ textAlign: "center", fontStyle: "italic" }}>
                        Không có dòng nào khớp với từ khóa tìm kiếm.
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </>
        ) : (
          <p>
            Chưa có dữ liệu suất chiếu. Hãy nhập điều kiện và bấm "Tra cứu lịch
            chiếu".
          </p>
        )}

        {/* BẢNG BÁO CÁO DOANH THU */}
        <h3 className="section-title">Báo cáo doanh thu rạp</h3>
        {reports.length > 0 ? (
          <div className="table-container1">
            <table className="result1">
              <thead>
                <tr>
                  {reportColumns.map((col) => (
                    <th key={col}>{col}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {reports.map((row, idx) => (
                  <tr key={idx}>
                    {reportColumns.map((col) => (
                      <td key={col}>{String(row[col])}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <p>
            Chưa có dữ liệu báo cáo. Hãy nhập khoảng ngày & điều kiện và bấm
            "Xem báo cáo doanh thu".
          </p>
        )}
      </div>

      {/* MODAL UPDATE PHIM */}
      {showUpdateModal && (
        <div className="showtimes-modal-backdrop">
          <div className="showtimes-modal">
            <div className="showtimes-modal-header">
              <h3>Cập nhật thông tin PHIM</h3>
              <button onClick={() => setShowUpdateModal(false)}>✕</button>
            </div>
            <div className="showtimes-modal-body">
              <p>
                Đang cập nhật <strong>MaPhim: {selectedMaPhim}</strong>
              </p>
              <Screen1
                initialAction="update"
                initialTable="PHIM"
                initialInputValues={{ "@p_MaPhim": selectedMaPhim }}
              />
            </div>
          </div>
        </div>
      )}

      {/* MODAL DELETE PHIM */}
      {showDeleteModal && (
        <div className="showtimes-modal-backdrop">
          <div className="showtimes-modal">
            <div className="showtimes-modal-header">
              <h3>Xóa PHIM</h3>
              <button onClick={() => setShowDeleteModal(false)}>✕</button>
            </div>
            <div className="showtimes-modal-body">
              <p>
                Đang xóa <strong>MaPhim: {selectedMaPhim}</strong>
              </p>
              <Screen1
                initialAction="delete"
                initialTable="PHIM"
                initialInputValues={{ "@p_MaPhim": selectedMaPhim }}
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

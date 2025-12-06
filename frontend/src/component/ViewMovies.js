import { useEffect, useState } from "react";
import "../ProfileSearch/style.css";

export default function ViewMovies() {
  const [movies, setMovies] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchMovies = async () => {
      setLoading(true);
      setError("");

      try {
        const res = await fetch("http://localhost:3001/movies");
        if (!res.ok) {
          throw new Error(`HTTP status ${res.status}`);
        }

        const data = await res.json();
        const list = Array.isArray(data) ? data : data.data || [];
        setMovies(list);
      } catch (err) {
        setError("Lỗi khi tải danh sách phim: " + err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchMovies();
  }, []);

  const formatDate = (value) => {
    if (!value) return "";
    const d = new Date(value);
    if (Number.isNaN(d.getTime())) return value; // nếu không parse được thì trả lại string raw
    return d.toLocaleDateString("vi-VN");
  };

  return (
    <div className="movies-container">
      <h2 className="movies-title">
        DANH SÁCH PHIM Ở RẠP CINEMARS
      </h2>

      {loading && (
        <p className="movies-message">Đang tải dữ liệu phim...</p>
      )}

      {error && (
        <p className="movies-message movies-error">{error}</p>
      )}

      {!loading && !error && movies.length === 0 && (
        <p className="movies-message">
          Hiện chưa có phim nào trong hệ thống.
        </p>
      )}

      {!loading && !error && movies.length > 0 && (
        <div className="movies-table-wrapper">
          <table className="movies-table">
            <thead>
              <tr>
                <th>Mã phim</th>
                <th>Tên phim</th>
                <th>Độ tuổi</th>
                <th>Đạo diễn</th>
                <th>Ngày khởi chiếu</th>
                <th>Ngày ngừng chiếu</th>
                <th>Thời lượng (phút)</th>
                <th>Quốc gia</th>
                <th>Năm SX</th>
                <th>Tình trạng</th>
              </tr>
            </thead>
            <tbody>
              {movies.map((m) => (
                <tr key={m.MaPhim}>
                  <td>{m.MaPhim}</td>
                  <td>{m.TenPhim}</td>
                  <td>{m.DoTuoiQuyDinh}</td>
                  <td>{m.DaoDien}</td>
                  <td>{formatDate(m.NgayKhoiChieu)}</td>
                  <td>{formatDate(m.NgayNgungChieu)}</td>
                  <td>{m.ThoiLuong}</td>
                  <td>{m.QuocGiaSanXuat}</td>
                  <td>{m.NamSanXuat}</td>
                  <td>{m.TinhTrang}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

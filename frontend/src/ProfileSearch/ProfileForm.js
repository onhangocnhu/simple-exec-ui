import React, { useState } from 'react';
import './style.css'; 

export default function ProfileSearch() {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [profileData, setProfileData] = useState(null);

  const handleSearch = async (e) => {
    e.preventDefault();
    setError("");
    setIsLoading(true);

    try {
      const res = await fetch("http://localhost:3001/check-profile", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username, password }) 
      });

      const data = await res.json();
      
      if (data.success) {
        setProfileData(data.data);
      } else {
        setError(data.message || "Tài khoản hoặc mật khẩu không đúng");
      }
    } catch (err) {
      setError("Lỗi kết nối server: " + err.message);
    } finally {
      setIsLoading(false);
    }
  };

  const formatCurrency = (amount) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(amount);
  };

  // --- TRƯỜNG HỢP 1: HIỂN THỊ PROFILE (DASHBOARD) ---
  if (profileData) {
    return (
      <div className="profile-container-large">
        
        {/* Header của Dashboard */}
        <div className="dashboard-header">
            <h2 className="header-title">THÔNG TIN CHUNG</h2>
            <button className="btn-logout" onClick={() => setProfileData(null)}>
                ↻ Tra cứu tài khoản khác
            </button>
        </div>

        {/* Phần 1: Avatar + Thông tin chi tiết (Nằm ngang) */}
        <div className="user-intro-card">
            <div className="intro-left">
                <div className="avatar-circle-large">👤</div>
            </div>
            
            <div className="intro-right">
                <h3 className="section-title">THÔNG TIN TÀI KHOẢN</h3>
                <div className="info-grid">
                    <div className="info-item">
                        <span className="info-label">Tên đăng nhập</span>
                        <span className="info-value">{profileData.username}</span>
                    </div>
                    <div className="info-item">
                        <span className="info-label">Họ và tên</span>
                        <span className="info-value">{profileData.fullName}</span>
                    </div>
                    <div className="info-item">
                        <span className="info-label">Email</span>
                        <span className="info-value">{profileData.email}</span>
                    </div>
                    <div className="info-item">
                        <span className="info-label">Số điện thoại</span>
                        <span className="info-value">{profileData.phone}</span>
                    </div>
                    <div className="info-item">
                        <span className="info-label">Giới tính</span>
                        <span className="info-value">{profileData.gender}</span>
                    </div>
                    <div className="info-item">
                        <span className="info-label">Ngày sinh</span>
                        <span className="info-value">{profileData.birth}</span>
                    </div>

                </div>
            </div>
        </div>

        {/* Phần 2: Các chỉ số thống kê (Stats) */}
        <div className="stats-grid-container">
           {/* Cột 1: Loại thẻ */}
           <div className="stat-card">
              <div className="stat-content">
                  <span className="stat-label">Cấp độ thẻ</span>
                  <div className="rank-badge">{profileData.rank}</div>
              </div>
           </div>

           {/* Cột 2: Tổng chi tiêu */}
           <div className="stat-card">
              <div className="stat-content">
                  <span className="stat-label">Tổng Chi Tiêu</span>
                  <span className="stat-value highlight-red">{formatCurrency(profileData.totalSpending)}</span>
              </div>
           </div>

           {/* Cột 3: Điểm tích lũy */}
           <div className="stat-card">
              <div className="stat-content">
                  <span className="stat-label">Điểm tích lũy</span>
                  <span className="stat-value">{profileData.cgvPoint} P</span>
              </div>
           </div>

           {/* Cột 4: Thẻ thành viên */}
           <div className="stat-card">
              <div className="stat-content">
                        <span className="stat-label">Thẻ thành viên</span>
                        <span className="info-value card-code">{profileData.memberCard}</span>
              </div>
           </div>
        </div>

      </div>
    );
  }

  // --- TRƯỜNG HỢP 2: FORM ĐĂNG NHẬP ---
  return (
    <div className="login-wrapper">
      <div className="login-tabs">
        <div className="tab-item active">TRA CỨU THÔNG TIN KHÁCH HÀNG THÀNH VIÊN</div>
      </div>

      <div className="login-form-container">
        <form onSubmit={handleSearch}>
          <div className="form-group">
            <label className="form-label">Tên đăng nhập, email hoặc số điện thoại</label>
            <input
              className="form-input"
              type="text"
              placeholder="Nhập tên đăng nhập, Email hoặc SĐT"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
            />
          </div>

          <div className="form-group">
            <label className="form-label">Mật khẩu</label>
            <input
              className="form-input"
              type="password"
              placeholder="Nhập mật khẩu"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
            />
          </div>

          <button type="submit" className="btn-submit" disabled={isLoading}>
            {isLoading ? "ĐANG KIỂM TRA..." : "TÌM KIẾM"}
          </button>

          {error && <p className="error-message" style={{color: 'red', textAlign: 'center', marginTop: '15px'}}>{error}</p>}
        </form>
      </div>
    </div>
  );
}
import { useState } from "react";
import { Screen1 } from "./Screen1";
import { ShowtimesScreen } from "./ShowtimesScreen";
import ProfileSearch from "../ProfileSearch/ProfileForm";
import '../styles/Header.css';

export const Header = () => {
  const [activeScreen, setActiveScreen] = useState(null);
  const [viewProfileForm, setViewProfileForm] = useState(false);

  return (
    <div className="header-wrapper">
      <div className="app-title">
        RẠP CHIẾU PHIM
      </div>

      <div className="header-container">
        <div className="button-container">
          <button
            className="btn"
            onClick={() => {
              setActiveScreen("crud");
              setViewProfileForm(false);
            }}
          >
            <span>Thủ tục thêm, xóa, sửa</span>
          </button>

          <button
            className="btn"
            onClick={() => {
              setActiveScreen("showtimes");
              setViewProfileForm(false);
            }}
          >
            <span>Tra cứu suất chiếu &amp; báo cáo</span>
          </button>

          <button
            className="btn"
            onClick={() => {
              setViewProfileForm(true);
              setActiveScreen(null);
            }}
          >
            <span>Xem thông tin khách hàng</span>
          </button>
        </div>

        {activeScreen === "crud" && <Screen1 />}
        {activeScreen === "showtimes" && <ShowtimesScreen />}
        {viewProfileForm ? <ProfileSearch /> : null}
      </div>
    </div>
  );
};

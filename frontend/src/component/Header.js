// import { useState } from "react";
// import { Screen1 } from "./Screen1";

// export const Header = () => {
//   const [canShowScreen, setCanShowScreen] = useState(false);

//   return (
//     <div className="header-container">
//       <div className="button-container">
//         <button className="btn" onClick={() => setCanShowScreen(true)}>
//           <span>Thủ tục thêm, xóa, sửa</span>
//         </button>
//         <button className="btn" onClick={() => setCanShowScreen(true)}>
//           <span>Thủ tục hiển thị dữ liệu</span>
//         </button>
//       </div>
//       {canShowScreen ? <Screen1 /> : null}
//     </div>
//   );
// };


import { useState } from "react";
import { Screen1 } from "./Screen1";
import { ShowtimesScreen } from "./ShowtimesScreen"; // thêm dòng này
import ProfileSearch from '../ProfileSearch/ProfileForm';

export const Header = () => {
  const [activeScreen, setActiveScreen] = useState(null);
  const [viewProfileForm, setViewProfileForm] = useState(false);

  return (
    <div className="header-container">
      <div className="button-container">
        <button className="btn" onClick={() => {
          setActiveScreen("crud")
          setViewProfileForm(false)
        }}>
          <span>Thủ tục thêm, xóa, sửa</span>
        </button>
        <button className="btn" onClick={() => {
          setActiveScreen("showtimes")
          setViewProfileForm(false)
        }}>
          <span>Tra cứu suất chiếu & báo cáo</span>
        </button>
        <button className="btn" onClick={() => {
          setViewProfileForm(true)
          setActiveScreen(null)
        }}>
          <span>Xem thông tin khách hàng</span>
        </button>
      </div>

      {activeScreen === "crud" && <Screen1 />}
      {activeScreen === "showtimes" && <ShowtimesScreen />}
      {viewProfileForm ? <ProfileSearch /> : null}
    </div>
  );
};

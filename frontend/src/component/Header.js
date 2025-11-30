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

export const Header = () => {
  const [activeScreen, setActiveScreen] = useState(null); // "crud" | "showtimes" | null

  return (
    <div className="header-container">
      <div className="button-container">
        <button className="btn" onClick={() => setActiveScreen("crud")}>
          <span>Thủ tục thêm, xóa, sửa</span>
        </button>
        <button className="btn" onClick={() => setActiveScreen("showtimes")}>
          <span>Tra cứu suất chiếu & báo cáo</span>
        </button>
      </div>

      {activeScreen === "crud" && <Screen1 />}
      {activeScreen === "showtimes" && <ShowtimesScreen />}
    </div>
  );
};

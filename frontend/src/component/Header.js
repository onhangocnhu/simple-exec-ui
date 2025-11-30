import { useState } from "react";
import { Screen1 } from "./Screen1";
import ProfileSearch from '../ProfileSearch/ProfileForm';

export const Header = () => {
  const [canShowScreen, setCanShowScreen] = useState(false);
  const [viewProfileForm, setViewProfileForm] = useState (false);

  return (
    <div className="header-container">
      <div className="button-container">
        <button className="btn" onClick={() =>  
          {
            setViewProfileForm(false)
            setCanShowScreen(true) 
          }}>
          <span>Thủ tục thêm, xóa, sửa</span>
        </button>
        <button className="btn" onClick={() =>   
          {
            setViewProfileForm(false)
            setCanShowScreen(true) 
          }}>
          <span>Thủ tục hiển thị dữ liệu</span>
        </button>
        <button className="btn" onClick={() => 
          {
            setViewProfileForm(true)
            setCanShowScreen(false) // set false các nút khác ở đây
          }}>
          <span>Xem thông tin khách hàng</span>
        </button>
      </div>
      {canShowScreen ? <Screen1 /> : null}
      {viewProfileForm ? <ProfileSearch/> : null}
    </div>
  );
};

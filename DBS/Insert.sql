USE RAPPHIM;
GO

-- TÀI KHOẢN 
INSERT INTO TAIKHOAN (TenDangNhap, Email, MatKhau) VALUES
('user01', 'user1@gmail.com', 'Pass@1234'), ('user02', 'user2@gmail.com', 'Pass@1234'),
('user03', 'user3@gmail.com', 'Pass@1234'), ('user04', 'user4@gmail.com', 'Pass@1234'),
('user05', 'user5@gmail.com', 'Pass@1234'), ('user06', 'user6@gmail.com', 'Pass@1234'),
('user07', 'user7@gmail.com', 'Pass@1234'), ('user08', 'user8@gmail.com', 'Pass@1234'),
('user09', 'user9@gmail.com', 'Pass@1234'), ('user10', 'user10@gmail.com', 'Pass@1234'),
('staff01', 'staff1@cgv.vn', 'Staff@1234'), ('staff02', 'staff2@cgv.vn', 'Staff@1234'),
('staff03', 'staff3@cgv.vn', 'Staff@1234'), ('staff04', 'staff4@cgv.vn', 'Staff@1234'),
('staff05', 'staff5@cgv.vn', 'Staff@1234'), ('staff06', 'staff6@cgv.vn', 'Staff@1234'),
('staff07', 'staff7@cgv.vn', 'Staff@1234'), ('staff08', 'staff8@cgv.vn', 'Staff@1234'),
('staff09', 'staff9@cgv.vn', 'Staff@1234'), ('staff10', 'staff10@cgv.vn', 'Staff@1234'),
('staff11', 'staff11@cgv.vn', 'Staff@1234'), ('staff12', 'staff12@cgv.vn', 'Staff@1234'),
('staff13', 'staff13@cgv.vn', 'Staff@1234'), ('staff14', 'staff14@cgv.vn', 'Staff@1234'),
('staff15', 'staff15@cgv.vn', 'Staff@1234'), ('staff16', 'staff16@cgv.vn', 'Staff@1234'), 
('staff17', 'staff17@cgv.vn', 'Staff@1234'), ('staff18', 'staff18@cgv.vn', 'Staff@1234'), 
('staff19', 'staff19@cgv.vn', 'Staff@1234'), ('staff20', 'staff20@cgv.vn', 'Staff@1234'),
('staff21', 'staff21@cgv.vn', 'Staff@1234'), ('staff22', 'staff22@cgv.vn', 'Staff@1234'),
('staff23', 'staff23@cgv.vn', 'Staff@1234'), ('staff24', 'staff24@cgv.vn', 'Staff@1234'),
('staff25', 'staff25@cgv.vn', 'Staff@1234');
GO

-- -- KHÁCH HÀNG 
-- -- Quy ước: 0 - Nam, 1 - Nữ
INSERT INTO KHACHHANGTHANHVIEN (MaTaiKhoan, Ho, Ten, GioiTinh, NgaySinh, SoDienThoai, LoaiThanhVien, TheThanhVien) VALUES
('0000000001', N'Nguyễn', N'Văn A', 0, '1995-01-01', '0900000001', N'Vàng', 'TV001'),
('0000000002', N'Trần', N'Thị B', 1, '1996-02-02', '0900000002', N'Thường', 'TV002'),
('0000000003', N'Lê', N'Văn C', 0, '1997-03-03', NULL, N'Bạc', 'TV003'),
('0000000004', N'Phạm', N'Thị D', 1, NULL, '0900000004', N'Kim cương', 'TV004'),
('0000000005', N'Hoàng', N'Văn E', NULL, '1999-05-05', '0900000005', N'Thường', 'TV005'),
('0000000006', N'Võ', N'Thị F', 1, '2000-06-06', '0900000006', N'Vàng', 'TV006'),
('0000000007', N'Đặng', N'Văn G', 0, '2001-07-07', '0900000007', N'Bạc', NULL),
('0000000008', N'Bùi', N'Thị H', 1, '2002-08-08', '0900000008', N'Thường', 'TV008'),
('0000000009', N'Ngô', N'Văn I', 0, '2003-09-09', '0900000009', N'Thường', NULL),
('0000000010', N'Dương', N'Thị K', 1, '2004-10-10', '0900000010', N'Kim cương', 'TV010');
GO
-- -- -- RẠP PHIM 
INSERT INTO RAP (TenRap, DiaDiem, SoLuongPhongChieu, TinhTrang) VALUES
(N'CineMars Vincom Đồng Khởi', N'Q1, HCM', 3, N'Hoạt động'),
(N'CineMars Sư Vạn Hạnh', N'Q10, HCM', 2, N'Hoạt động'),
(N'CineMars Aeon Bình Tân', N'Bình Tân, HCM', 2, N'Hoạt động'),
(N'CineMars Hùng Vương Plaza', N'Q5, HCM', 1, N'Hoạt động'),
(N'CineMars VivoCity', N'Q7, HCM', 2, N'Hoạt động');
GO

-- NHÂN SỰ
INSERT INTO NHANSU (MaTaiKhoan, CCCD, Ho, Ten, GioiTinh, SoDienThoai, DiaChiLienLac, VaiTro, NgayBatDauCongViec, TrangThaiLamViec, MaTaiKhoanQuanLy, MaRap) VALUES
('0000000011', '079001', N'Hồ', N'Văn Khởi', 0, '0911111111', N'HCM', N'Quản lý', '2020-01-01', N'Đang làm việc', NULL, 'RAP0000001'),
('0000000012', '079002', N'Lê', N'Thanh Tùng', 1, '0911111112', N'HCM', N'Quản lý', '2021-01-01', N'Đang làm việc', NULL, 'RAP0000002'),
('0000000013', '079003', N'Hoàng', N'Minh Khải', 1, '0911111113', N'HCM', N'Quản lý', '2021-01-01', N'Đang làm việc', NULL, 'RAP0000003'),
('0000000014', '079004', N'Trần', N'Văn Bánh', 0, '0911111114', N'HCM', N'Quản lý', '2021-01-01', N'Đang làm việc', NULL, 'RAP0000004'),
('0000000015', '079005', N'Lý', N'Minh Quản', 1, '0911111115', N'HCM', N'Quản lý', '2021-01-01', N'Đang làm việc', NULL, 'RAP0000005');
-- Thêm QUẢN LÝ cho các RẠP
INSERT INTO QUANLY VALUES 
('0000000011', 'RAP0000001'), ('0000000012', 'RAP0000002'), ('0000000013', 'RAP0000003'), ('0000000014', 'RAP0000004'), ('0000000015', 'RAP0000005');
GO
-- Thêm THU NGÂN và SOÁT VÉ cho các RẠP
INSERT INTO NHANSU (MaTaiKhoan, CCCD, Ho, Ten, GioiTinh, SoDienThoai, DiaChiLienLac, VaiTro, NgayBatDauCongViec, TrangThaiLamViec, MaTaiKhoanQuanLy, MaRap) VALUES
-- THU NGÂN (RAP 1, 2, 3, 4, 5)
('0000000016', '079006', N'Trần', N'Thị Bích Ngọc', 0, '0911111116', N'HCM', N'Thu ngân', '2022-01-01', N'Đang làm việc', '0000000011', 'RAP0000001'), -- Nữ
('0000000017', '079007', N'Lê', N'Minh Tuấn', 1, '0911111117', N'HCM', N'Thu ngân', '2022-01-01', N'Đang làm việc', '0000000011', 'RAP0000001'), -- Nam
('0000000018', '079008', N'Trịnh', N'Phương Thảo', 0, '0911111118', N'HCM', N'Thu ngân', '2022-01-01', N'Đang làm việc', '0000000011', 'RAP0000001'), -- Nữ
('0000000019', '079009', N'Phạm', N'Quốc Hưng', 1, '0911111119', N'HCM', N'Thu ngân', '2022-02-01', N'Đang làm việc', '0000000012', 'RAP0000002'), -- Nam
('0000000020', '079010', N'Trần', N'Văn Đức', 1, '0911111120', N'HCM', N'Thu ngân', '2022-02-01', N'Đang làm việc', '0000000012', 'RAP0000002'), -- Nam
('0000000021', '079011', N'Hoàng', N'Thị Lan Anh', 0, '0911111121', N'HCM', N'Thu ngân', '2022-03-01', N'Đang làm việc', '0000000013', 'RAP0000003'), -- Nữ
('0000000022', '079012', N'Mai', N'Thanh Tùng', 1, '0911111122', N'HCM', N'Thu ngân', '2022-03-01', N'Đang làm việc', '0000000013', 'RAP0000003'), -- Nam
('0000000023', '079013', N'Nguyễn', N'Thị Thu Hằng', 0, '0911111123', N'HCM', N'Thu ngân', '2022-02-01', N'Đang làm việc', '0000000014', 'RAP0000004'), -- Nữ
('0000000024', '079014', N'Hoàng', N'Gia Huy', 1, '0911111124', N'HCM', N'Thu ngân', '2022-03-01', N'Đang làm việc', '0000000015', 'RAP0000005'), -- Nam
('0000000025', '079015', N'Hồ', N'Quang Hiếu', 1, '0911111125', N'HCM', N'Thu ngân', '2022-03-01', N'Đang làm việc', '0000000015', 'RAP0000005'), -- Nam

-- SOÁT VÉ (RAP 1, 2, 3, 4, 5)
('0000000026', '079016', N'Nguyễn', N'Thành Đạt', 1, '0911111126', N'HCM', N'Soát vé', '2023-01-01', N'Đang làm việc', '0000000011', 'RAP0000001'), -- Nam
('0000000027', '079017', N'Võ', N'Minh Khang', 1, '0911111127', N'HCM', N'Soát vé', '2023-01-01', N'Đang làm việc', '0000000011', 'RAP0000001'), -- Nam
('0000000028', '079018', N'Lâm', N'Chấn Huy', 1, '0911111128', N'HCM', N'Soát vé', '2023-01-01', N'Đang làm việc', '0000000011', 'RAP0000001'), -- Nam
('0000000029', '079019', N'Đặng', N'Thùy Dương', 0, '0911111129', N'HCM', N'Soát vé', '2023-02-01', N'Đang làm việc', '0000000012', 'RAP0000002'), -- Nữ
('0000000030', '079020', N'Hồ', N'Ngọc Hà', 0, '0911111130', N'HCM', N'Soát vé', '2023-02-01', N'Đang làm việc', '0000000012', 'RAP0000002'), -- Nữ
('0000000031', '079021', N'Bùi', N'Tiến Dũng', 1, '0911111131', N'HCM', N'Soát vé', '2023-03-01', N'Đang làm việc', '0000000013', 'RAP0000003'), -- Nam
('0000000032', '079022', N'Trịnh', N'Văn Sơn', 1, '0911111132', N'HCM', N'Soát vé', '2023-03-01', N'Đang làm việc', '0000000013', 'RAP0000003'), -- Nam
('0000000033', '079023', N'Ngô', N'Bảo Châu', 0, '0911111133', N'HCM', N'Soát vé', '2023-04-01', N'Đang làm việc', '0000000014', 'RAP0000004'), -- Nữ
('0000000034', '079024', N'Dương', N'Đình Bảo', 1, '0911111134', N'HCM', N'Soát vé', '2023-05-01', N'Đã nghỉ việc', '0000000015', 'RAP0000005'), -- Nam
('0000000035', '079025', N'Trương', N'Thế Vinh', 1, '0911111135', N'HCM', N'Soát vé', '2023-05-01', N'Đã nghỉ việc', '0000000015', 'RAP0000005'); -- Nam
INSERT INTO PHONGCHIEU (MaRap, SoThuTuPhong, LoaiPhong, SucChua, TrangThai) VALUES
('RAP0000001', 1, N'2D', 100, N'Sẵn sàng'), ('RAP0000001', 2, N'3D', 80, N'Sẵn sàng'), ('RAP0000001', 3, N'IMAX', 150, N'Sẵn sàng'),
('RAP0000002', 1, N'2D', 90, N'Sẵn sàng'), ('RAP0000002', 2, N'3D', 60, N'Bảo trì'),
('RAP0000003', 1, N'2D', 100, N'Sẵn sàng'), ('RAP0000003', 2, N'2D', 40, N'Sẵn sàng'),
('RAP0000004', 1, N'2D', 80, N'Sẵn sàng'), 
('RAP0000005', 1, N'IMAX', 30, N'Sẵn sàng'), ('RAP0000005', 2, N'IMAX', 200, N'Sẵn sàng');
GO
INSERT INTO QUAY (MaRap, SoQuay) VALUES 
('RAP0000001', 1), ('RAP0000001', 2), ('RAP0000001', 3), 
('RAP0000002', 1), ('RAP0000002', 2), ('RAP0000002', 3), ('RAP0000002', 4),
('RAP0000003', 1), ('RAP0000003', 2), 
('RAP0000004', 1), 
('RAP0000005', 1), ('RAP0000005', 2);
GO
INSERT INTO THUNGAN (MaTaiKhoan, MaRap, SoQuay) VALUES
('0000000016', 'RAP0000001', 1), ('0000000017', 'RAP0000001', 2), ('0000000018', 'RAP0000001', 3), 
('0000000019', 'RAP0000002', 1), ('0000000020', 'RAP0000002', 2), 
('0000000021', 'RAP0000003', 1),('0000000022', 'RAP0000003', 2),
('0000000023', 'RAP0000004', 1),
('0000000024', 'RAP0000005', 1), ('0000000025', 'RAP0000005', 2);
GO 

INSERT INTO SOATVE (MaTaiKhoan, MaRap, SoThuTuPhong) VALUES 
('0000000026', 'RAP0000001', 1), ('0000000027', 'RAP0000001', 2), ('0000000028', 'RAP0000001', 3), 
('0000000029', 'RAP0000002', 1), ('0000000030', 'RAP0000002', 2), 
('0000000031', 'RAP0000003', 1),('0000000032', 'RAP0000003', 2),
('0000000033', 'RAP0000004', 1),
('0000000034', 'RAP0000005', 1), ('0000000035', 'RAP0000005', 2);
GO

INSERT INTO CATRUC (MaTaiKhoan, NgayTruc, BuoiTruc) VALUES
-- Rạp R01 (NV06, NV07, NV08 - Thu ngân | NV16, NV17, NV18 - Soát vé)
('0000000016', '2025-11-20', N'Sáng'), ('0000000026', '2025-11-20', N'Sáng'),
('0000000017', '2025-11-20', N'Chiều'), ('0000000027', '2025-11-20', N'Chiều'),
('0000000018', '2025-11-20', N'Tối'),   ('0000000028', '2025-11-20', N'Tối'),

-- Rạp R02 (NV09, NV10 - Thu ngân | NV19, NV20 - Soát vé)
('0000000019', '2025-11-20', N'Sáng'), ('0000000029', '2025-11-20', N'Sáng'),
('0000000020', '2025-11-20', N'Chiều'), ('0000000030', '2025-11-20', N'Chiều'),
('0000000020', '2025-11-20', N'Tối'), ('0000000030', '2025-11-20', N'Tối'),

-- Rạp R03 (NV11, NV12 - Thu ngân | NV21, NV22 - Soát vé)
('0000000021', '2025-11-20', N'Sáng'), ('0000000031', '2025-11-20', N'Sáng'),
('0000000021', '2025-11-20', N'Chiều'), ('0000000031', '2025-11-20', N'Chiều'),
('0000000022', '2025-11-20', N'Tối'),  ('0000000032', '2025-11-20', N'Tối'),

-- Rạp R04 (NV13 - Thu ngân | NV23 - Soát vé)
('0000000023', '2025-11-20', N'Sáng'), ('0000000033', '2025-11-20', N'Sáng'),
('0000000023', '2025-11-20', N'Chiều'), ('0000000033', '2025-11-20', N'Chiều'),
('0000000023', '2025-11-20', N'Tối'), ('0000000033', '2025-11-20', N'Tối'),

-- Rạp R05 (NV14, NV15 - Thu ngân | NV24, NV25 - Soát vé)
('0000000024', '2025-11-20', N'Sáng'), ('0000000034', '2025-11-20', N'Sáng'),
('0000000025', '2025-11-20', N'Chiều'),  ('0000000035', '2025-11-20', N'Chiều'),
('0000000025', '2025-11-20', N'Tối'),  ('0000000035', '2025-11-20', N'Tối');
GO


-- Phim 1 (Đang chiếu)
INSERT INTO PHIM (TenPhim, Poster, Trailer, DoTuoiQuyDinh, DaoDien, NgayKhoiChieu, NgayNgungChieu, ThoiLuong, QuocGiaSanXuat, NamSanXuat, TinhTrang, MoTa)
VALUES 
(
    N'TỬ CHIẾN TRÊN KHÔNG', 
    N'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/m/a/main_tctk_social.jpg', 
    N'https://youtu.be/h4O-GbuwwlM', 
    N'T16', 
    N'Hàm Trần', 
    '2025-09-19', 
    '2025-11-28', 
    118, 
    N'Việt Nam', 
    2024, 
    N'Ngừng chiếu', 
    N'Tử Chiến Trên Không là phim điện ảnh hành động - kịch tính, được lấy cảm hứng từ vụ cướp máy bay có thật tại Việt Nam sau năm 1975. Đón xem hành động Việt Nam kịch tính nhất tháng 9 này!'
    
),
(
    N'TRUY TÌM LONG DIÊN HƯƠNG', 
    N'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/t/r/truy_t_m_long_di_n_h_ng_-_payoff_poster_kc_14112025.jpg', 
    N'https://youtu.be/-q1FYNMQBeU', 
    N'T16', 
    N'Dương Minh Chiến', 
    '2025-11-14',
    NULL,
    103, 
    N'Việt Nam', 
    2024, 
    N'Đang chiếu', 
    N'Báu vật làng biển Long Diên Hương bị đánh cắp, mở ra cuộc hành trình truy tìm đầy kịch tính. Không chỉ có võ thuật mãn nhãn, bộ phim còn mang đến tiếng cười, sự gắn kết và những giá trị nhân văn của con người làng chài.'
    
),
(
    N'GIÓ VẪN THỔI', 
    N'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/p/o/poster_gio_van_thoi_1.jpg', 
    N'https://youtu.be/rp9VsYzVltw', 
    N'P', 
    N'Hayao Miyazaki', 
    '2025-10-17', 
    NULL, 
    127, 
    N'Nhật Bản', 
    2024, 
    N'Đang chiếu', 
    N'Lấy bối cảnh Nhật Bản trong thời kỳ Taishō và Shōwa, The Wind Rises kể về Jirō Horikoshi, chàng trai mang ước mơ bay lượn giữa bầu trời, dù đôi mắt cận không cho phép. Trong những giấc mơ, anh được nhà thiết kế máy bay Caproni truyền cảm hứng, và ngoài đời, Jirō trở thành kỹ sư hàng không tài năng. Sau trận đại động đất Kantō, anh gặp Nahoko – cô gái dịu dàng và lạc quan. Tình yêu chớm nở giữa khung cảnh bình yên của Karuizawa, rồi kết trái bằng một cuộc hôn nhân đầy hy vọng. Nhưng bệnh lao phổi của Nahoko ngày cảng trở nặng ... Trong khi đất nước dấn sâu vào chiến tranh, Jirō lao vào thiết kế mẫu tiêm kích thử nghiệm với tất cả đam mê, giằng xé giữa lý tưởng bay cao và hiện thực cay nghiệt của thời đại.'
    
),
(

    N'AVATAR 3: LỬA VÀ TRO TÀN', 
    N'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/a/v/avatar3_teaser_poster_vietnam.jpg', 
    N'https://youtu.be/rZXmSgjxpdQ', 
    N'T16', 
    N'James Cameron', 
    '2025-12-19', 
    NULL, 
    195, 
    N'Mỹ', 
    2024, 
    N'Sắp chiếu', 
    N'Avatar: Lửa Và Tro Tàn, dự kiến ra rạp ngày 19.12.2025. Một hành trình mới khởi đầu từ tro tàn, cùng đón chờ những cuộc phiêu lưu kỳ thú trên Pandora!'
    
),
(
    N'QUÁI THÚ VÔ HÌNH: VÙNG ĐẤT CHẾT CHÓC', 
    N'https://www.cgv.vn/media/catalog/product/cache/1/image/c5f0a1eff4c394a251036189ccddaacd/c/g/cgv_pd_up.jpg', 
    N'https://youtu.be/4ORg9D6zNn4', 
    N'T16', 
    N'Dan Trachtenberg', 
    '2025-11-07', 
    NULL, 
    107, 
    N'Mỹ', 
    2024, 
    N'Đang chiếu', 
    N'Trong tương lai, tại một hành tinh hẻo lánh, một Predator non nớt - kẻ bị chính tộc của mình ruồng bỏ - tìm thấy một đồng minh không ngờ tới là Thia và bắt đầu hành trình sinh tử nhằm truy tìm kẻ thù tối thượng. Bộ phim do Dan Trachtenberg - đạo diễn của Prey chỉ đạo và nằm trong chuỗi thương hiệu Quái Thú Vô Hình Predator.'
   
);
GO

INSERT INTO dbo.DIENVIEN (MaPhim,DienVien)
VALUES
('P000000001',N'Thái Hòa'), ('P000000001',N'Kaity Nguyễn'), ('P000000001',N'Thanh Sơn'),
('P000000002',N'Quang Tuấn'), ('P000000002',N'Ma Ran Đô'), ('P000000002',N'Nguyên Thảo'),
('P000000004',N'Giovanni Ribisi'), ('P000000004',N'Kate Winslet'), ('P000000004',N'Zoe Saldaña'),
('P000000005',N'Elle Fanning'), ('P000000005',N'Dimitrius Schuster-Koloamatangi');
GO

INSERT INTO dbo.THELOAI (MaPhim, TheLoai)
VALUES
('P000000001',N'Hành động'), ('P000000001',N'Hồi hộp'),
('P000000002',N'Hài'),
('P000000003',N'Hoạt hình'),
('P000000004',N'Khoa học viễn tưởng'), ('P000000004',N'Phiêu lưu'),
('P000000005',N'Hành động'), ('P000000005',N'Phiêu Lưu');
GO

INSERT INTO DUOCCHIEUTAI (MaPhim, MaRap) VALUES
('P000000001', 'RAP0000001'), ('P000000001', 'RAP0000002'), ('P000000001', 'RAP0000003'),('P000000001', 'RAP0000004'), ('P000000001', 'RAP0000005'),
('P000000002', 'RAP0000003'), 
('P000000003', 'RAP0000002'), ('P000000003', 'RAP0000003'), ('P000000003', 'RAP0000004'), 
('P000000004', 'RAP0000004'), ('P000000004', 'RAP0000005'), 
('P000000005', 'RAP0000001'), ('P000000005', 'RAP0000002'), ('P000000005', 'RAP0000004'), ('P000000005', 'RAP0000005');
GO

-- SUẤT CHIẾU 
INSERT INTO SUATCHIEU (MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, ThoiGianKetThuc, DinhDangChieu, TrangThai, NgonNguPhuDe) VALUES

('P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', '10:58:00', N'2D', N'Kết thúc', N'Lồng tiếng'),
('P000000001', 'RAP0000001', 1, '2025-11-20', '12:00:00', '13:58:00', N'2D', N'Đang chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', '16:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000002', 1, '2025-11-20', '12:00:00', '13:40:00', N'2D', N'Đang chiếu', N'Lồng tiếng'),

('P000000002', 'RAP0000003', 1, '2025-11-20', '14:00:00', '15:43:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000002', 'RAP0000003', 1, '2025-11-20', '17:00:00', '18:43:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'), 


('P000000003', 'RAP0000002', 1, '2025-11-20', '10:00:00', '12:07:00', N'2D', N'Kết thúc', N'Phụ đề'),
('P000000003', 'RAP0000003', 1, '2025-11-21', '10:00:00', '12:07:00', N'2D', N'Chưa chiếu', N'Phụ đề'),


('P000000005', 'RAP0000001', 1, '2025-11-22', '17:00:00', '19:14:00', N'2D', N'Chưa chiếu', N'Lồng tiếng');

GO

INSERT INTO SUATCHIEU (MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, ThoiGianKetThuc, DinhDangChieu, TrangThai, NgonNguPhuDe) VALUES

('P000000001', 'RAP0000001', 1, '2025-11-21', '09:00:00', '11:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000001', 1, '2025-11-21', '12:00:00', '14:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000001', 1, '2025-11-22', '15:00:00', '17:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000002', 1, '2025-11-21', '12:00:00', '14:40:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000002', 1, '2025-11-21', '09:00:00', '11:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000002', 1, '2025-11-22', '12:00:00', '14:40:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000001', 'RAP0000002', 1, '2025-11-22', '09:00:00', '11:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),


('P000000002', 'RAP0000001', 2, '2025-11-21', '09:30:00', '11:13:00', N'3D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000002', 'RAP0000001', 2, '2025-11-21', '12:30:00', '14:13:00', N'3D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000002', 'RAP0000001', 2, '2025-11-22', '15:00:00', '16:43:00', N'3D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000002', 'RAP0000002', 2, '2025-11-21', '12:00:00', '13:43:00', N'3D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000002', 'RAP0000002', 2, '2025-11-21', '09:00:00', '10:43:00', N'3D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000002', 'RAP0000003', 2, '2025-11-22', '12:00:00', '13:43:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000002', 'RAP0000003', 2, '2025-11-22', '09:00:00', '10:43:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),


('P000000003', 'RAP0000001', 1, '2025-11-21', '15:30:00', '17:37:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000003', 'RAP0000001', 1, '2025-11-21', '19:30:00', '21:37:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000003', 'RAP0000002', 2, '2025-11-21', '15:00:00', '17:37:00', N'3D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000003', 'RAP0000003', 1, '2025-11-22', '13:00:00', '15:37:00', N'2D', N'Chưa chiếu', N'Phụ đề'),
('P000000003', 'RAP0000003', 1, '2025-11-22', '19:00:00', '21:37:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),


('P000000004', 'RAP0000002', 1, '2025-11-21', '15:00:00', '18:15:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000004', 'RAP0000002', 1, '2025-11-21', '18:30:00', '21:45:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000004', 'RAP0000003', 1, '2025-11-21', '13:00:00', '16:15:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000004', 'RAP0000003', 1, '2025-11-22', '09:00:00', '12:15:00', N'2D', N'Chưa chiếu', N'Phụ đề'),
('P000000004', 'RAP0000003', 1, '2025-11-22', '13:00:00', '16:15:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),

('P000000005', 'RAP0000001', 1, '2025-11-22', '19:00:00', '20:47:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000005', 'RAP0000002', 1, '2025-11-22', '15:00:00', '16:47:00', N'2D', N'Chưa chiếu', N'Phụ đề'),
('P000000005', 'RAP0000002', 1, '2025-11-22', '17:00:00', '18:47:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
('P000000005', 'RAP0000003', 2, '2025-11-22', '15:00:00', '16:47:00', N'2D', N'Chưa chiếu', N'Phụ đề'),
('P000000005', 'RAP0000003', 2, '2025-11-22', '17:00:00', '18:47:00', N'2D', N'Chưa chiếu', N'Lồng tiếng');

GO

INSERT INTO VOUCHER (SoLuong, NgayBatDau, NgayKetThuc, PhamViApDung, GiaTriGiamToiDa, PhanTram, GiaTri, QuaTang, SoDiemQuyDoi) VALUES
(100, '2025-01-01', '2025-12-31', N'TOANBO', 50000, 10, NULL, NULL, 0),
(50,  '2025-11-01', '2025-11-30', N'RAP:RAP0000001', NULL, NULL, 20000, NULL, 0),
(20,  '2025-01-01', '2026-01-01', N'LOAIGHE:VIP', NULL, NULL, NULL, N'Bắp', 0),
(200, '2024-03-01', '2025-06-01', N'PHIM:P000000002', 30000, 15, NULL, NULL, 0),
(500, '2025-01-01', '2025-12-31', N'SANPHAM:SPK0000001', NULL, NULL, 15000, NULL, 0),
(1000,'2025-01-01', '2026-01-01', N'NGAY:T3', 50000, 50, NULL, NULL, 0),
(50,  '2025-12-20', '2025-12-31', N'TOANBO', NULL, NULL, 50000, NULL, 0),
(100, '2025-01-01', '2025-12-31', N'LOAIGHE:Đôi', 100000, 20, NULL, NULL, 0),
(10,  '2025-12-24', '2025-12-25', N'TOANBO', NULL, NULL, NULL, N'Gấu', 0),
(300, '2025-01-01', '2025-06-30', N'RAP:RAP0000003', NULL, NULL, 30000, NULL, 0),
-- VOUCHER ĐỔI ĐIỂM (DÙNG CHO TRIGGER)
(200, '2025-01-01','2025-12-31', N'TOANBO', NULL, NULL, 20000, NULL, 100),
(100, '2025-01-01','2025-12-31', N'LOAIGHE:VIP', NULL, NULL, 20000, NULL, 150),
(50,  '2025-01-01','2025-12-31', N'PHIM:P000000002', 80000, 10, NULL, NULL, 200);
GO


INSERT INTO SANPHAMKEM (TenSanPham, LoaiSanPham, MoTa, DonGia) VALUES
( N'Bắp Ngọt', N'Bắp', N'Size L', 60000), ( N'Coca', N'Nước', N'Size L', 35000),
( N'Combo 1', N'Combo', NULL, 80000), -- Mô tả NULL
( N'Combo 2', N'Combo', N'2 Nước 1 Bắp', 100000),
( N'Snack', N'Ăn vặt', N'Khoai tây', 25000), ( N'Bắp Phô mai', N'Bắp', N'Size L', 70000),
( N'Pepsi', N'Nước', N'Size M', 30000), ( N'Nước suối', N'Nước', NULL, 15000),
( N'Hotdog', N'Đồ nóng', N'Xúc xích', 40000), ( N'Ly Phim', N'Qùa', N'Ly chủ đề', 150000);
GO

INSERT INTO CHONGOI (MaRap, SoThuTuPhong, SoThuTuCho, Da_y, LoaiGhe, TrangThai) VALUES
-- 1. Phòng R01 - P1 (Phòng 2D): Hàng A ghế Thường
('RAP0000001', 1, 1, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 2, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 6, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 3, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 4, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 5, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 7, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 8, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 9, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 10, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 11, 'A', N'Thường', N'Sẵn sàng'),
('RAP0000001', 1, 12, 'A', N'Thường', N'Sẵn sàng'),

-- 2. Phòng R01 - P1 (Phòng 2D): Hàng E ghế VIP
('RAP0000001', 1, 5, 'E', N'VIP', N'Sẵn sàng'),
('RAP0000001', 1, 6, 'E', N'VIP', N'Sẵn sàng'),
('RAP0000001', 1, 7, 'E', N'VIP', N'Sẵn sàng'),

-- 3. Phòng R03 - P1 : Ghế Đôi
('RAP0000003', 1, 1, 'F', N'Đôi', N'Sẵn sàng'),
('RAP0000003', 1, 2, 'F', N'Đôi', N'Sẵn sàng'),
('RAP0000003', 1, 3, 'F', N'Đôi', N'Sẵn sàng'),

-- 4. Phòng R05 - P1 : Toàn bộ là VIP
('RAP0000005', 1, 1, 'A', N'VIP', N'Sẵn sàng'),
('RAP0000005', 1, 2, 'A', N'VIP', N'Sẵn sàng'),
('RAP0000005', 1, 3, 'A', N'VIP', N'Sẵn sàng'),

-- 5. Phòng R01 - P3 (IMAX): Ghế VIP trung tâm
('RAP0000001', 3, 10, 'H', N'VIP', N'Sẵn sàng'),
('RAP0000001', 3, 11, 'H', N'VIP', N'Sẵn sàng'),
('RAP0000001', 3, 12, 'H', N'VIP', N'Sẵn sàng'),

-- 6. Một trường hợp ghế đang bị hỏng (để test logic bảo trì)
('RAP0000002', 1, 8, 'C', N'Thường', N'Đang hỏng'),

-- 7. Ghế thường lẻ loi ở góc
('RAP0000004', 1, 1, 'A', N'Thường', N'Sẵn sàng');
GO

-- ĐÁNH GIÁ PHIM
INSERT INTO DANHGIAPHIM (MaTaiKhoan, MaPhim, Diem, NoiDungDanhGia, ThoiGianDanhGia) VALUES
('0000000001', 'P000000001', 5, N'Xem xong nhưng chưa kịp hoàn hồn vì mọi thứ ập tới, rồi cuồn cuộn hết lớp này đến lớp khác. Phim có cốt truyện mạch lạc, thông điệp rõ ràng, dễ xem, dễ hiểu với khán giả.', '2025-11-20 11:00:00'),
('0000000002', 'P000000001', 5, N'Phim ĐỈNH nha mấy bè ơiii. Nó hồi hộp, kịch tính, mà gay gấn zãiiiiiii. Có cảnh máo hơi nhiều như phải nói là nghẹt thở khi xem luôn đó. Anh Thái Hoà diễn đỉnhhhhhhh, từ ánh mắt, thần thái ta nói nổi da gà ớ, mỗi nhân vật theo tui là đều tròn vai nhen.', '2025-11-20 11:15:00'),
('0000000003', 'P000000001', 3, N'Đối với mình, phim này chỉ ở mức tạm ổn. Được lấy từ một sự kiện có thật, còn do Điện Ảnh Công An Nhân Dân sản xuất nên về mặt logic của sự kiện khá trơn tru, hói tiếc có một số sạn. Nhìn chung tổng quan bộ phim khá oki, ổn, nhân văn.', '2025-11-19 14:30:00'),
('0000000001', 'P000000003', 5, N'Rất thích phim hoạt hình này! Dù đã coi đi coi lại nhiều lần nhưng đến khi xem ngoài rạp mình vẫn trọn vẹn cảm xúc như coi lần đầu, dù hơi ít xuất phim nhưng mình vẫn cố gắng dành thời gian để coi.', '2025-10-15 09:00:00'),
('0000000004', 'P000000003', 4, N'Một bộ phim rất hay đến từ nhà ghibili với nhiều cung bậc cảm xúc khác nhau được thể hiện qua bộ phim. Đồng thời nhạc phim rất hay và cảm động. Kết hơi buồn xíu TT.', '2025-11-17 10:30:00'),
('0000000002', 'P000000003', 4, N'Phim rất hay và ý nghĩa, hình ảnh đẹp, âm nhạc tuyệt vời. Tuy nhiên mình thấy phim có phần hơi dài và chậm so với nhịp phim hiện đại ngày nay.', '2025-11-18 16:45:00'),
('0000000003', 'P000000003', 5, N'Phim hoạt hình xuất sắc của Ghibli. Câu chuyện cảm động, hình ảnh đẹp mắt, âm nhạc tuyệt vời. Rất đáng xem!', '2025-11-19 13:20:00'),
('0000000005', 'P000000001', 4, N'Phim rất hay và kịch tính, diễn xuất của các diễn viên rất tốt. Tuy nhiên, mình nghĩ rằng một số cảnh hành động có thể được làm tốt hơn.', '2025-11-15 18:00:00');
GO


-- Công Vinh sửa: INSERT BANGGIAVE
-- 1. ĐỊNH DẠNG IMAX
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('IMAX', N'Đôi', 500000);
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('IMAX', N'VIP', 250000);
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('IMAX', N'Thường', 230000); -- Logic cũ: ELSE 230000

-- 2. ĐỊNH DẠNG 3D
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('3D', N'Đôi', 400000);
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('3D', N'VIP', 200000);
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('3D', N'Thường', 180000); -- Logic cũ: ELSE 180000

-- 3. ĐỊNH DẠNG 2D
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('2D', N'Đôi', 240000);
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('2D', N'VIP', 120000);
INSERT INTO BANGGIAVE (DinhDangChieu, LoaiGhe, GiaTien) VALUES ('2D', N'Thường', 100000); -- Logic cũ: ELSE 100000

---GIAO DỊCH: quy trình mua vé hoàn chỉnh (Tạo giao dịch -> Chọn vé -> Mua kèm -> Áp mã -> Thanh toán).

-- GD01
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Ví điện tử', 0, '2025-11-20', '10:00:00'); 
INSERT INTO GIAODICHTRUCTUYEN ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES 
('GD00000001', '0000000001', NULL, NULL);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Thường', N'Đã chọn', NULL, 'GD00000001', 'P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', 'RAP0000001', 1, 1, 'A'),
(N'Thường', N'Đã chọn', NULL, 'GD00000001', 'P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', 'RAP0000001', 1, 2, 'A'),
(N'Thường', N'Đã chọn', NULL, 'GD00000001', 'P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', 'RAP0000001', 1, 3, 'A');
INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
VALUES ('GD00000001', 'SPK0000001', 1);
INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
VALUES ('GD00000001', 'VC00000007'); 

-- GD khác có vé ghế trùng với GD01
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Ví điện tử', 0, '2025-11-22', '10:00:00'); 
INSERT INTO GIAODICHTRUCTUYEN ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES 
('GD00000002', '0000000001', NULL, NULL);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Thường', N'Đã chọn', NULL, 'GD00000002', 'P000000001', 'RAP0000001', 1, '2025-11-20', '09:00:00', 'RAP0000001', 1, 1, 'A');
--

UPDATE GIAODICH SET 
    HinhThucThanhToan = N'Ví điện tử',
    NgayGiaoDich = '2025-11-20',
    GioGiaoDich = '10:00:00'
WHERE MaGiaoDich = 'GD00000001';
UPDATE GIAODICHTRUCTUYEN SET 
    DiemTichLuy = 10, 
    DanhGia = 2
WHERE MaGiaoDich = 'GD00000001';

--GD02
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Ví điện tử', 0, '2025-11-19', '16:00:00'); 
INSERT INTO GIAODICHTRUCTUYEN ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES 
('GD00000003', '0000000003', 10, 5);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Thường', N'Đã chọn', NULL, 'GD00000003', 'P000000001', 'RAP0000001', 1, '2025-11-20', '12:00:00', 'RAP0000001', 1, 4, 'A'),
(N'Thường', N'Đã chọn', NULL, 'GD00000003', 'P000000001', 'RAP0000001', 1, '2025-11-20', '12:00:00', 'RAP0000001', 1, 5, 'A'),
(N'Thường', N'Đã chọn', NULL, 'GD00000003', 'P000000001', 'RAP0000001', 1, '2025-11-20', '12:00:00', 'RAP0000001', 1, 6, 'A');
INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
VALUES ('GD00000003', 'SPK0000001', 1);
INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
VALUES ('GD00000003', 'VC00000007'); 

--GD03
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Ví điện tử', 0, '2025-11-18', '23:49:26'); 
INSERT INTO GIAODICHTRUCTUYEN ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES 
('GD00000004', '0000000003', 10, 4);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Đôi', N'Đã chọn', NULL, 'GD00000004', 'P000000003', 'RAP0000003', 1, '2025-11-21', '10:00:00', 'RAP0000003', 1, 3, 'F');

INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
VALUES ('GD00000004', 'SPK0000001', 1);
INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
VALUES ('GD00000004', 'VC00000001'); 

--GD04
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Tiền mặt', 1, '2025-11-20', '14:23:37'); 
INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
('GD00000005', NULL, NULL, NULL, 'RAP0000001', 1);
-- ('P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', '16:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
-- ('RAP0000001', 1, 5, 'E', N'VIP', N'Sẵn sàng'),
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'VIP', N'Đã chọn', NULL, 'GD00000005', 'P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', 'RAP0000001', 1, 5, 'E');

INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
VALUES ('GD00000005', 'SPK0000001', 1);
INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
VALUES ('GD00000005', 'VC00000001'); 

--GD05
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Ví điện tử', 1, '2025-11-20', '14:23:37'); 
INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
('GD00000006', '0000000004', 10, 4, 'RAP0000001', 1);
-- ('P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', '16:58:00', N'2D', N'Chưa chiếu', N'Lồng tiếng'),
-- ('RAP0000001', 1, 5, 'E', N'VIP', N'Sẵn sàng'),
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Thường', N'Đã chọn', NULL, 'GD00000006', 'P000000001', 'RAP0000001', 1, '2025-11-20', '12:00:00', 'RAP0000001', 1, 4, 'A');

INSERT INTO MUAKEM (MaGiaoDich, MaSanPham, SoLuong)
VALUES ('GD00000006', 'SPK0000001', 1);
INSERT INTO APDUNG (MaGiaoDich, MaVoucher) 
VALUES ('GD00000006', 'VC00000001'); 

--GD06
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Tiền mặt', 1, '2025-11-20', '14:23:37'); 
INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
('GD00000007', NULL, NULL, NULL, 'RAP0000001', 1);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Thường', N'Đã chọn', NULL, 'GD00000007', 'P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', 'RAP0000001', 1, 7, 'A');

--GD07
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Tiền mặt', 1, '2025-11-20', '14:23:37'); 
INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
('GD00000008', NULL, NULL, NULL, 'RAP0000003', 1);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Đôi', N'Đã chọn', NULL, 'GD00000008', 'P000000003', 'RAP0000003', 1, '2025-11-21', '10:00:00', 'RAP0000003', 1, 2, 'F');

--GD08
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Tiền mặt', 1, '2025-11-20', '14:23:37'); 
INSERT INTO GIAODICHTRUCTIEP ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia, MaRap, SoQuay) VALUES 
('GD00000009', NULL, NULL, NULL, 'RAP0000001', 1);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'VIP', N'Đã chọn', NULL, 'GD00000009', 'P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', 'RAP0000001', 1, 6, 'E');

--GD09
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Ví điện tử', 0, '2025-11-18', '23:49:26'); 
INSERT INTO GIAODICHTRUCTUYEN ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES 
('GD00000010', '0000000006', 10, NULL);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Thường', N'Đã chọn', NULL, 'GD00000010', 'P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', 'RAP0000001', 1, 8, 'A');

--GD10
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES 
(N'Ví điện tử', 0, '2025-11-18', '23:49:26'); 
INSERT INTO GIAODICHTRUCTUYEN ( MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES 
('GD00000011', '0000000007', 10, NULL);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y) VALUES 
(N'Thường', N'Đã chọn', NULL, 'GD00000011', 'P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', 'RAP0000001', 1, 9, 'A');

-- GD11
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES (N'Ví điện tử', 0, '2025-12-02', '11:00:00');
INSERT INTO GIAODICHTRUCTUYEN (MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES ('GD00000012', '0000000001', NULL, NULL);
INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y)
VALUES (N'VIP', N'Đã chọn', NULL, 'GD00000012', 'P000000001', 'RAP0000001', 1, '2025-11-20', '15:00:00', 'RAP0000001', 1, 10, 'A');
INSERT INTO APDUNG (MaGiaoDich, MaVoucher) VALUES ('GD00000012', 'VC00000011');

--GD12
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich)
VALUES (N'Ví điện tử', 0, '2025-12-02', '11:00:00');
INSERT INTO GIAODICHTRUCTUYEN (MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia)
VALUES ('GD00000013', '0000000001', NULL, NULL);

INSERT INTO VE (LoaiVe, TrangThai, Gia, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y)
VALUES (N'VIP', N'Đã chọn', NULL, 'GD00000013', 'P000000001', 'RAP0000001', 1, '2025-11-21', '9:00:00', 'RAP0000001', 1, 11, 'A');

INSERT INTO APDUNG (MaGiaoDich, MaVoucher) VALUES ('GD00000013', 'VC00000012');

--GD13
INSERT INTO GIAODICH (HinhThucThanhToan, HinhThuc, NgayGiaoDich, GioGiaoDich) VALUES (N'Ví điện tử', 0, '2025-12-03', '12:00:00');
INSERT INTO GIAODICHTRUCTUYEN (MaGiaoDich, MaTaiKhoanKhachHang, DiemTichLuy, DanhGia) VALUES ('GD00000014', '0000000001', NULL, NULL);
INSERT INTO VE (LoaiVe, TrangThai, MaGiaoDich, MaPhim, MaRap, SoThuTuPhong, NgayChieu, ThoiGianBatDau, MaRap_ChoNgoi, SoThuTuPhong_ChoNgoi, SoThuTuCho, Da_y)
VALUES (N'VIP', N'Đã chọn', 'GD00000014', 'P000000001', 'RAP0000001', 1, '2025-11-21', '12:00:00', 'RAP0000001', 1, 12, 'A');
INSERT INTO APDUNG (MaGiaoDich, MaVoucher) VALUES ('GD00000014', 'VC00000013');
/* 
SELECT * FROM TAIKHOAN;
SELECT * FROM KHACHHANGTHANHVIEN;
SELECT * FROM RAP;
SELECT * FROM PHIM;
SELECT * FROM THELOAI;
SELECT * FROM DIENVIEN;

PRINT N'=== 2. CƠ SỞ VẬT CHẤT & NHÂN SỰ ===';
SELECT * FROM PHONGCHIEU;
SELECT * FROM QUAY;
SELECT * FROM NHANSU;
SELECT * FROM QUANLY;
SELECT * FROM THUNGAN;
SELECT * FROM SOATVE;
SELECT * FROM CATRUC;
SELECT * FROM DUOCCHIEUTAI; -- Phim nào chiếu rạp nào

PRINT N'=== 3. LỊCH CHIẾU & SẢN PHẨM ===';
SELECT * FROM SUATCHIEU;
SELECT * FROM VOUCHER;
SELECT * FROM SANPHAMKEM;

PRINT N'=== 4. GIAO DỊCH & VÉ (QUAN TRỌNG) ===';
SELECT * FROM GIAODICH;
SELECT * FROM GIAODICHTRUCTUYEN;
SELECT * FROM GIAODICHTRUCTIEP;
SELECT * FROM VE;
SELECT * FROM CHONGOI; -- Ghế ngồi
SELECT * FROM MUAKEM;  -- Bắp nước
SELECT * FROM APDUNG;  -- Voucher áp dụng
SELECT * FROM DANHGIAPHIM;
*/
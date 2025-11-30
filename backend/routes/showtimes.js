const express = require('express');
const router = express.Router();
const { sql, getPool } = require('../db/mssql');

// GET /api/showtimes
router.get('/showtimes', async (req, res) => {
  try {
    const pool = await getPool();
    // Gọi stored-proc tra cứu không có tham số (nếu sp hỗ trợ) hoặc chạy query demo
    // Thay đổi theo schema thực tế
    const result = await pool.request()
      // nếu muốn, truyền param rỗng để sp trả về toàn bộ
      .input('p_TenPhim', sql.NVarChar(200), '')
      .input('p_NgayChieu', sql.VarChar(10), '')
      .execute('sp_TraCuuLichChieu');
    return res.json(result.recordset || []);
  } catch (err) {
    console.error('GET /api/showtimes error', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

// POST /api/sp/TraCuuLichChieu
router.post('/sp/TraCuuLichChieu', async (req, res) => {
  const { p_TenPhim = '', p_NgayChieu = '' } = req.body || {};
  try {
    const pool = await getPool();
    const request = pool.request();
    request.input('p_TenPhim', sql.NVarChar(200), p_TenPhim);
    // p_NgayChieu có thể là '' hoặc 'YYYY-MM-DD'
    request.input('p_NgayChieu', sql.VarChar(10), p_NgayChieu);
    const result = await request.execute('sp_TraCuuLichChieu');
    return res.json(result.recordset || []);
  } catch (err) {
    console.error('POST /api/sp/TraCuuLichChieu error', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

// POST /api/sp/BaoCaoDoanhThuRap_ThucTe
router.post('/sp/BaoCaoDoanhThuRap_ThucTe', async (req, res) => {
  const { p_TuNgay, p_DenNgay, p_DoanhThuMoc, p_KieuLoc } = req.body || {};
  try {
    const pool = await getPool();
    const request = pool.request();
    request.input('p_TuNgay', sql.VarChar(10), p_TuNgay || null);
    request.input('p_DenNgay', sql.VarChar(10), p_DenNgay || null);
    request.input('p_DoanhThuMoc', sql.BigInt, p_DoanhThuMoc || 0);
    request.input('p_KieuLoc', sql.Int, p_KieuLoc || 0);
    const result = await request.execute('sp_BaoCaoDoanhThuRap_ThucTe');
    return res.json(result.recordset || []);
  } catch (err) {
    console.error('POST /api/sp/BaoCaoDoanhThuRap_ThucTe error', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

// DELETE /api/movies/:id
router.delete('/movies/:id', async (req, res) => {
  const id = req.params.id;
  try {
    const pool = await getPool();
    // Nếu có stored-proc xóa phim thì gọi sp, ở đây dùng query mẫu
    const result = await pool.request()
      .input('id', sql.Int, id)
      .query('DELETE FROM Movies WHERE id = @id; SELECT @@ROWCOUNT AS affected;');
    const affected = result.recordset && result.recordset[0] ? result.recordset[0].affected : 0;
    return res.json({ success: true, affected });
  } catch (err) {
    console.error('DELETE /api/movies/:id error', err);
    return res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;

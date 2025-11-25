export const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASS,
  server: process.env.DB_SERVER,
  port: 1433,
  database: 'RAPPHIM',
  options: {
    encrypt: false,
    trustServerCertificate: true
  }
};

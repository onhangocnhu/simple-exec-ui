export const config = {
  user: process.env.DB_USER || 'myuser',
  password: process.env.DB_PASSWORD || '12341234',
  server: process.env.DB_HOST || '192.168.1.8',
  port: Number(process.env.DB_PORT) || 1433,
  database: process.env.DB_NAME || 'RAPPHIM',
  options: {
    encrypt: false,
    trustServerCertificate: true
  }
};
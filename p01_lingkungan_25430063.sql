-- Modul 1: Lingkungan Kerja MariaDB dan Git
-- NIM: 063

CREATE DATABASE IF NOT EXISTS kopma_063 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_063'@'localhost' IDENTIFIED BY 'PasswordKerja';

GRANT ALL PRIVILEGES ON kopma_063.* TO 'mhs_063'@'localhost';

FLUSH PRIVILEGES;


CREATE USER IF NOT EXISTS 'tamu_063'@'localhost' IDENTIFIED BY 'PasswordKerja';

GRANT ALL PRIVILEGES ON kopma_063.* TO 'tamu_063'@'localhost';

FLUSH PRIVILEGES;
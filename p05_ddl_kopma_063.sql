-- Berkas: p05_ddl_kopma_063.sql
-- Praktikum Basis Data Modul 5

USE kopma_063;

-- =========================================================
-- DROP TABLE: Dihapus dari tabel anak (transaksi) ke tabel induk (master)
-- =========================================================
DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS petugas;

-- =========================================================
-- CREATE TABLE: Dibuat dari tabel induk (master) terlebih dahulu
-- =========================================================

-- 1. Tabel petugas
CREATE TABLE petugas (
  id_petugas SMALLINT NOT NULL AUTO_INCREMENT,
  kode_petugas CHAR(3) NOT NULL,
  nama_petugas VARCHAR(100) NOT NULL,
  peran_petugas ENUM('kasir', 'gudang', 'ketua') NOT NULL,
  PRIMARY KEY (id_petugas),
  UNIQUE KEY uq_petugas_kode (kode_petugas)
) ENGINE=InnoDB;

-- 2. Tabel barang
CREATE TABLE barang (
  id_barang INT NOT NULL AUTO_INCREMENT,
  kode_barang VARCHAR(10) NOT NULL,
  nama_barang VARCHAR(100) NOT NULL,
  kategori_barang ENUM('ATK', 'makanan', 'minuman') NOT NULL,
  harga_jual_barang DECIMAL(12,2) NOT NULL,
  stok_barang INT NOT NULL DEFAULT 0,
  stok_min_barang INT NOT NULL DEFAULT 5,
  PRIMARY KEY (id_barang),
  UNIQUE KEY uq_barang_kode (kode_barang),
  CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0),
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0),
  CONSTRAINT ck_barang_stok_min CHECK (stok_min_barang >= 0) -- Jawaban Latihan 1
) ENGINE=InnoDB;

-- 3. Tabel anggota
CREATE TABLE anggota (
  id_anggota INT NOT NULL AUTO_INCREMENT,
  no_anggota VARCHAR(10) NOT NULL,
  nim_anggota CHAR(10) NOT NULL,
  nama_anggota VARCHAR(100) NOT NULL,
  status_anggota ENUM('aktif', 'tidak_aktif') NOT NULL,
  tgl_daftar_anggota DATE NOT NULL,
  prodi_anggota VARCHAR(100) NOT NULL,
  no_hp_anggota VARCHAR(20) NULL,
  PRIMARY KEY (id_anggota),
  UNIQUE KEY uq_anggota_no (no_anggota),
  UNIQUE KEY uq_anggota_nim (nim_anggota)
) ENGINE=InnoDB;

-- 4. Tabel pemasok
CREATE TABLE pemasok (
  id_pemasok INT NOT NULL AUTO_INCREMENT,
  nama_pemasok VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(20) NOT NULL,
  alamat_pemasok TEXT NOT NULL,
  PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- =========================================================
-- TABEL TRANSAKSI (Dengan Kunci Tamu)
-- =========================================================

-- 5. Tabel penjualan (Kepala Transaksi Penjualan)
CREATE TABLE penjualan (
  id_penjualan INT NOT NULL AUTO_INCREMENT,
  no_nota_penjualan CHAR(12) NOT NULL,
  tgl_penjualan DATETIME NOT NULL,
  id_petugas SMALLINT NOT NULL,
  id_anggota INT NULL,
  bayar_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan),
  UNIQUE KEY uq_penjualan_nota (no_nota_penjualan),
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  -- Jawaban Latihan 2: diubah menjadi ON DELETE SET NULL
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota) REFERENCES anggota (id_anggota) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6. Tabel detail_penjualan (Detail Transaksi Penjualan)
CREATE TABLE detail_penjualan (
  id_penjualan INT NOT NULL,
  id_barang INT NOT NULL,
  qty_detail_penjualan SMALLINT NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan) REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_qty CHECK (qty_detail_penjualan > 0)
) ENGINE=InnoDB;

-- 7. Tabel pembelian (Kepala Transaksi Pembelian)
CREATE TABLE pembelian (
  id_pembelian INT NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(50) NOT NULL,
  tgl_pembelian DATE NOT NULL,
  status_pembelian ENUM('dipesan', 'diterima') NOT NULL,
  id_petugas SMALLINT NOT NULL,
  id_pemasok INT NOT NULL,
  PRIMARY KEY (id_pembelian),
  CONSTRAINT fk_pembelian_petugas FOREIGN KEY (id_petugas) REFERENCES petugas (id_petugas),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

-- 8. Tabel detail_pembelian (Detail Transaksi Pembelian)
CREATE TABLE detail_pembelian (
  id_pembelian INT NOT NULL,
  id_barang INT NOT NULL,
  qty_detail_pembelian SMALLINT NOT NULL,
  harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_detail_beli_pembelian FOREIGN KEY (id_pembelian) REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
  CONSTRAINT fk_detail_beli_barang FOREIGN KEY (id_barang) REFERENCES barang (id_barang),
  CONSTRAINT ck_detail_beli_qty CHECK (qty_detail_pembelian > 0)
) ENGINE=InnoDB;
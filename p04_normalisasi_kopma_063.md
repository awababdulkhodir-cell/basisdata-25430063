# Normalisasi Basis Data Kopma
**NIM:** 25430063  
**Nama:** Awab Abdul Khodir  

---

## D.1 Dari UNF ke 1NF

**1. Bentuk Tidak Normal (UNF)**
Satu nota menyimpan grup berulang (repeating group) untuk barang-barang yang dibeli:
`NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, { kode_barang, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan }, jumlah_penjualan, diskon_penjualan, total_penjualan)`

**2. Bentuk Normal Pertama (1NF)**
Grup berulang dihilangkan sehingga setiap baris hanya berisi nilai atomik. Kunci primer menjadi komposit yaitu gabungan antara `no_nota_penjualan` dan `kode_barang`:
`NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas, nama_petugas, no_anggota, nama_anggota, nama_barang, qty_detail_penjualan, harga_satuan_detail_penjualan, subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan, total_penjualan)`

---

## D.2 Menuliskan Dependensi Fungsional

Dependensi fungsional diturunkan langsung dari aturan bisnis Kopma:
* **FD1:** `no_nota_penjualan` -> `tgl_penjualan`, `kode_petugas`, `no_anggota` (Sesuai AB-01: Satu nota hanya punya satu tanggal, satu petugas, dan maksimal satu anggota)
* **FD2:** `kode_petugas` -> `nama_petugas`
* **FD3:** `no_anggota` -> `nama_anggota` (Sesuai AB-05)
* **FD4:** `kode_barang` -> `nama_barang`
* **FD5:** (`no_nota_penjualan`, `kode_barang`) -> `qty_detail_penjualan`, `harga_satuan_detail_penjualan` (Sesuai AB-04: Harga di nota dapat berbeda dari harga barang saat ini)
* **FD6:** `qty_detail_penjualan`, `harga_satuan_detail_penjualan` -> `subtotal_detail_penjualan` (Atribut turunan)

---

## D.3 Menuju 2NF dan 3NF

**4. Bentuk Normal Kedua (2NF)**
Berdasarkan 1NF, FD1 dan FD4 hanya bergantung pada sebagian dari kunci komposit. Maka, relasi dipisah menjadi tabel mandiri:
* `penjualan` (dengan kunci `no_nota_penjualan`)
* `barang` (dengan kunci `kode_barang`)
* Sisa atribut yang bergantung pada kunci komposit secara utuh dipisah menjadi `detail_penjualan`.

**5. Bentuk Normal Ketiga (3NF)**
Di dalam relasi penjualan yang baru, masih ada dependensi transitif (rantai):
* `no_nota_penjualan` -> `kode_petugas` -> `nama_petugas`
* `no_nota_penjualan` -> `no_anggota` -> `nama_anggota`
Maka, `petugas` dan `anggota` dipisahkan menjadi relasi mandiri.

**6. Nilai Turunan**
Atribut turunan seperti `subtotal_detail_penjualan`, `jumlah_penjualan`, dan `total_penjualan` **tidak disimpan** di tabel operasional agar terhindar dari anomali ketidakkonsistenan data.

**Hasil Akhir Skema Relasional (3NF):**
* `PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*, bayar_penjualan)`
* `DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan, harga_satuan_detail_penjualan)`
* `BARANG (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)`
* `PETUGAS (kode_petugas, nama_petugas, peran_petugas)`
* `ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)`

*(Keterangan: Garis bawah mewakili Primary Key, tanda bintang `*` mewakili Foreign Key).*

---

## D.4 Pemeriksaan BCNF (Boyce-Codd Normal Form)

Mengecek apakah ada penentu (determinan) yang BUKAN kunci kandidat pada skema kanonik hasil akhir:
1. **Tabel Petugas**: Kunci utamanya adalah `id_petugas` dan `kode_petugas` (kunci unik). Keduanya menentukan nama dan peran. Tidak ada determinan lain. **(Memenuhi BCNF)**
2. **Tabel Anggota**: Kunci utama `id_anggota`, kunci unik `no_anggota` & `nim_anggota`. Semua kunci tersebut menentukan atribut anggota lainnya. Tidak ada determinan lain. **(Memenuhi BCNF)**
3. **Tabel Barang**: Kunci penentu adalah `id_barang` / `kode_barang`. Keduanya adalah kunci kandidat. **(Memenuhi BCNF)**
4. **Tabel Penjualan**: Determinan adalah `id_penjualan` atau `no_nota_penjualan`. Keduanya adalah kunci kandidat yang secara utuh menentukan tanggal, petugas, anggota, dan pembayaran. **(Memenuhi BCNF)**
5. **Tabel Detail Penjualan**: Determinannya bersifat komposit `(id_penjualan, id_barang)`. Keduanya mutlak menjadi kunci kandidat untuk menentukan qty dan harga satuan. **(Memenuhi BCNF)**

**Kesimpulan:** Seluruh tabel dalam rancangan Kopma sudah terbebas dari anomali data operasional dan telah memenuhi tahap BCNF karena setiap penentu di tabel-tabel tersebut adalah kunci kandidat.
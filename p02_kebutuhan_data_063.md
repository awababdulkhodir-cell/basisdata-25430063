# Dokumen Kebutuhan Data - Toko Wabe Mandiri 063

## 1. Latar belakang dan aktivitas organisasi
Toko Wabe Mandiri 063 adalah organisasi fiktif yang bergerak di bidang perdagangan daring (e-commerce) untuk menyediakan produk kebutuhan sehari-hari secara digital. Aktivitas organisasi meliputi pendaftaran pelanggan, pengelolaan katalog produk oleh admin, proses pemesanan (*checkout*) oleh pelanggan, validasi pembayaran, dan pengiriman barang menggunakan jasa kurir[cite: 22].

## 2. Aktor dan proses bisnis
Terdapat tiga aktor utama: Pelanggan, Admin, dan Kurir[cite: 20].

| Kode | Proses Bisnis | Aktor | Pemicu |
| :--- | :--- | :--- | :--- |
| PB-01 | Mendaftarkan akun pelanggan | Pelanggan | Pengunjung ingin bisa berbelanja |
| PB-02 | Mengelola katalog produk (tambah/ubah stok) | Admin | Ada barang baru atau restok |
| PB-03 | Membuat pesanan (checkout) | Pelanggan | Pelanggan selesai memilih barang |
| PB-04 | Mengonfirmasi pembayaran | Admin | Pelanggan mengunggah bukti bayar |
| PB-05 | Memproses pengiriman barang | Kurir / Admin | Pembayaran telah diverifikasi |
| PB-06 | Menyusun laporan penjualan | Admin | Evaluasi akhir bulan |

## 3. Dokumen sumber yang dianalisis
Kebutuhan data dianalisis dari perancangan dokumen sumber fiktif berikut[cite: 21, 22]:
1. **Halaman Pesanan (Invoice Digital):** Berisi No Pesanan, Tanggal, Nama Pelanggan, Alamat Pengiriman, Ongkos Kirim, Daftar Barang, Qty, Harga Satuan, dan Total[cite: 22].
2. **Bukti Pembayaran:** Berisi No Rekening, Nominal, dan Tanggal Transfer.
3. **Resi Pengiriman:** Berisi No Resi, Kurir Ekspedisi, dan Status Pengiriman[cite: 22].

## 4. Entitas kandidat dan elemen data
Terdapat 6 entitas kandidat utama[cite: 21]:

| Entitas kandidat | Elemen data utama | Sumber |
| :--- | :--- | :--- |
| Pelanggan | id_pelanggan, nama, email, no_hp, password, alamat_utama | Form daftar |
| Produk | id_produk, nama_produk, kategori, harga_master, stok, berat | Katalog |
| Pesanan | id_pesanan, tgl_pesan, pelanggan, status, alamat_pengiriman, ongkos_kirim | Halaman pesanan |
| Detail_Pesanan | id_pesanan, produk, qty, harga_saat_pesan | Halaman pesanan |
| Pembayaran | id_pembayaran, id_pesanan, metode, jumlah_bayar, tgl_bayar | Bukti bayar |
| Pengiriman | id_pengiriman, id_pesanan, kurir, no_resi, status_kirim | Resi pengiriman |

## 5. Aturan bisnis
Aturan operasional toko daring Wabe Mandiri 063[cite: 21, 22]:

| Kode | Aturan bisnis |
| :--- | :--- |
| AB-01 | Pelanggan wajib mendaftar dan login ke dalam sistem untuk dapat melakukan pemesanan. |
| AB-02 | Stok produk tidak boleh negatif; pesanan otomatis ditolak jika kuantitas (qty) melebihi stok yang tersedia. |
| AB-03 | **[Aturan Data Historis]** Harga barang disimpan mati per baris di entitas `Detail_Pesanan` (`harga_saat_pesan`) agar tagihan pesanan lama tidak berubah jika `harga_master` produk naik[cite: 22, 23]. |
| AB-04 | **[Aturan Data Historis]** Alamat pengiriman dan ongkos kirim disimpan per `Pesanan`, tidak hanya bergantung pada alamat profil pelanggan, karena pelanggan bisa mengirim barang ke alamat yang berbeda-beda[cite: 22, 23]. |
| AB-05 | **[Aturan Parameter P]** Batas maksimal variasi item produk dalam satu kali transaksi pesanan dibatasi maksimal **3 item**[cite: 22]. |
| AB-06 | **[Aturan Parameter P]** Pelanggan setia mendapatkan potongan diskon sebesar **1%** dari total belanja[cite: 22]. |
| AB-07 | Pesanan akan otomatis dibatalkan jika pelanggan tidak mengonfirmasi pembayaran dalam waktu 24 jam. |
| AB-08 | Setiap pesanan yang pembayarannya telah divalidasi akan diterbitkan satu nomor resi pengiriman yang unik. |

## 6. Kebutuhan informasi
Laporan yang wajib bisa dihasilkan oleh sistem[cite: 21]:

| Kode | Kebutuhan informasi | Data yang diperlukan |
| :--- | :--- | :--- |
| KI-01 | Laporan total pendapatan (omzet) harian dan bulanan | Pesanan, Pembayaran |
| KI-02 | Lima produk paling banyak terjual bulan ini | Detail_Pesanan, Produk |
| KI-03 | Daftar pesanan yang pembayarannya belum dikonfirmasi | Pesanan, Pembayaran |
| KI-04 | Laporan status pengiriman barang (pending, dikirim, selesai) | Pesanan, Pengiriman |
| KI-05 | Daftar produk yang stoknya habis (stok = 0) | Produk |

## 7. Matriks CRUD
Pemeriksaan entitas terhadap proses bisnis (tidak ada entitas yatim)[cite: 21, 23]:

| Proses Bisnis | Pelanggan | Produk | Pesanan | Detail_Pesanan | Pembayaran | Pengiriman |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| PB-01 Daftar akun | **C** | | | | | |
| PB-02 Kelola katalog | | **C, R, U, D**| | | | |
| PB-03 Membuat pesanan | **R** | **R, U** | **C** | **C** | | |
| PB-04 Konfirmasi bayar| | | **R, U** | | **C** | |
| PB-05 Proses kirim | | | **R, U** | | | **C, U** |
| PB-06 Laporan | **R** | **R** | **R** | **R** | **R** | **R** |
*(Catatan: Stok produk berkurang (U) saat PB-03, dan status pesanan diperbarui (U) pada PB-04 dan PB-05)*

## 8. Kamus data awal
Mendokumentasikan 20 elemen data utama beserta penanggung jawabnya (*data steward*)[cite: 15, 21]:

| Nama Elemen Data | Entitas | Penanggung Jawab | Keterangan / Aturan |
| :--- | :--- | :--- | :--- |
| 1. `id_pelanggan` | Pelanggan | Admin | Unik (Auto Increment/UUID). |
| 2. `nama_pelanggan` | Pelanggan | Admin | Nama lengkap sesuai KTP/pendaftaran. |
| 3. `email` | Pelanggan | Admin | Digunakan untuk login dan notifikasi. |
| 4. `no_hp` | Pelanggan | Admin | Untuk kontak pengiriman. |
| 5. `alamat_utama` | Pelanggan | Admin | Alamat domisili bawaan. |
| 6. `id_produk` | Produk | Admin | Kode unik identitas barang. |
| 7. `nama_produk` | Produk | Admin | Nama barang yang ditampilkan di etalase. |
| 8. `harga_master` | Produk | Admin | Harga jual terkini, bisa berubah sewaktu-waktu. |
| 9. `stok` | Produk | Admin | Tidak boleh negatif (AB-02). |
| 10. `id_pesanan` | Pesanan | Sistem | Nomor invoice (unik). |
| 11. `tgl_pesan` | Pesanan | Sistem | Tanggal dan jam checkout dilakukan. |
| 12. `alamat_pengiriman` | Pesanan | Pelanggan | Dicatat spesifik per transaksi (AB-04)[cite: 22]. |
| 13. `ongkos_kirim` | Pesanan | Sistem | Tarif ongkir ke alamat tujuan[cite: 22]. |
| 14. `status_pesanan` | Pesanan | Admin | cth: Menunggu Bayar, Dikemas, Dikirim. |
| 15. `qty` | Detail_Pesanan| Pelanggan | Jumlah barang yang dibeli per item. |
| 16. `harga_saat_pesan`| Detail_Pesanan| Sistem | Mengunci harga master saat checkout (AB-03)[cite: 22]. |
| 17. `id_pembayaran` | Pembayaran | Admin | Kode unik pencatatan transaksi masuk. |
| 18. `jumlah_bayar` | Pembayaran | Admin | Nominal yang ditransfer pelanggan. |
| 19. `no_resi` | Pengiriman | Kurir / Admin | Nomor pelacakan dari pihak ekspedisi. |
| 20. `kurir_ekspedisi` | Pengiriman | Admin | Nama layanan (misal: JNE, J&T, Gosend). |

## 9. Kebutuhan non-fungsional data
*   **Perhitungan Parameter Personal (P):**
    *   NIM: 25430063 -> 2 digit terakhir = 63.
    *   P = (63 mod 9) + 1 = 0 + 1 = **1**[cite: 22].
    *   Batas maksimal item per transaksi = P + 2 = **3** item[cite: 22].
    *   Persentase diskon = **1%**[cite: 22].
    *   Volume transaksi harian = 40 + (5 × 1) = **45** transaksi/hari[cite: 22].
*   **Retensi Data:** Data pesanan dan pembayaran harus disimpan minimal 3 tahun untuk audit keuangan.
*   **Privasi Data:** Data bersifat **pribadi** meliputi `nama_pelanggan`, `email`, `no_hp`, dan `alamat_pengiriman`[cite: 21]. Data ini **hanya boleh diakses** oleh Admin untuk keperluan operasional dan Kurir (khusus nama, no_hp, dan alamat pada saat pengiriman fisik)[cite: 21]. Password pelanggan wajib dienkripsi dan tidak boleh dilihat oleh siapa pun.

## 10. Isu kualitas data yang diantisipasi
1.  **Data tagihan masa lalu berubah saat harga barang naik:** Diantisipasi dengan memisahkan `harga_master` di tabel Produk dan `harga_saat_pesan` di tabel Detail_Pesanan (AB-03)[cite: 22, 23].
2.  **Barang terkirim ke alamat lama karena pengguna pindah rumah:** Diantisipasi dengan mencatat `alamat_pengiriman` secara mandiri pada tabel Pesanan saat *checkout*, tidak di-relasi-kan langsung ke alamat utama di profil pelanggan (AB-04)[cite: 22, 23].
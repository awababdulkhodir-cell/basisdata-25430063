# Laporan Praktikum Basis Data
**Nama:** Awab Abdul Khodir
**NIM:** 25430063
**Kelas:** C

## 1. Tujuan Praktikum
Praktikum ini bertujuan agar mahasiswa dapat menjalankan layanan MariaDB melalui XAMPP, menghubungkan klien melalui CLI maupun phpMyAdmin, mengamankan akun root dan membatasi hak akses akun kerja, serta mencatat progres awal basis data proyek ke repositori GitHub.

## 2. Ringkasan Dasar Teori
Basis data adalah sekumpulan data terorganisasi yang dikelola oleh Sistem Manajemen Basis Data (DBMS) seperti MariaDB. MariaDB memakai arsitektur klien-server di mana *server* berjalan di latar belakang (pada port 3306), dan pengguna berinteraksi melalui *klien* seperti *Command Prompt* atau aplikasi web phpMyAdmin. Dalam penggunaannya, diterapkan prinsip keamanan *least privilege* (hak akses minimum), di mana akun kerja hanya diberikan akses pada basis data yang dimilikinya saja, bukan akses penuh seperti *root*. Selain itu, riwayat seluruh pekerjaan dicatat secara bertahap menggunakan *version control system* Git.

## 3. Hasil Langkah Percobaan
*(Catatan: Gambar disimpan di folder `laporan/img/`)*

*   **Verifikasi Versi MariaDB:**
    ![Cek Versi dan Akun](img/p01_versi_dan_mode.png)
    *Keterangan:* Hasil eksekusi `SELECT VERSION(), CURRENT_USER();` dan `SELECT @@sql_mode;` untuk memastikan server berjalan pada mode ketat.
*   **Akses Database sebagai `mhs_063`:**
    ![Show Databases](img/p01_show_db_mhs.png)
    *Keterangan:* Eksekusi `SHOW DATABASES;` menggunakan akun `mhs_063` yang hanya menampilkan basis data `kopma_063` dan `information_schema`.
*   **Login phpMyAdmin (Mode Cookie):**
    ![Login phpMyAdmin](img/p01_phpmyadmin_cookie.png)
    *Keterangan:* Tampilan halaman login phpMyAdmin setelah konfigurasi `auth_type` diubah menjadi `cookie`.
*   **Push Git Pertama:**
    ![Git Push](img/p01_git_push.png)
    *Keterangan:* Repositori lokal berhasil dikirim (*push*) ke GitHub untuk pertama kalinya.

## 4. Jawaban Titik Analisis
*   **Titik Analisis 1:** Karena MariaDB merupakan *fork* dari MySQL, dokumentasi lama MySQL masih relevan untuk mencari panduan sintaks dasar SQL. Namun, untuk fitur-fitur yang lebih baru, pengaturan mode ketat (*strict mode*), serta penanganan kode galat spesifik, kita harus merujuk pada dokumentasi resmi MariaDB agar mendapatkan solusi yang akurat.
*   **Titik Analisis 2:** Jika mencoba masuk menggunakan perintah `mysql -u root` tanpa opsi `-p` padahal akun tersebut sudah diberi *password*, server akan memunculkan `ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)`. Bagian yang memberitahu bahwa klien tidak mengirimkan password adalah keterangan `(using password: NO)` di akhir pesan tersebut.
*   **Titik Analisis 3:** Akun `mhs_063` tetap bisa melihat `information_schema` karena itu adalah database sistem bawaan yang berisi metadata dan bebas dibaca secara *read-only* oleh siapa saja. Sementara itu, akses ke database `mysql` ditolak dengan `ERROR 1044` karena menyimpan kredensial server. Beda galatnya: 1044 berarti pengguna sukses *login* namun tidak berhak membuka *database* terkait, sedangkan 1045 berarti otentikasi saat *login* memang gagal akibat *password* salah atau kosong.
*   **Titik Analisis 4:** Mode `cookie` jauh lebih aman karena memaksa pengguna mengetik *username* dan *password* setiap kali sesi baru dimulai. Pada mode `config`, *password* *root* ditulis dalam bentuk teks biasa di dalam file `config.inc.php`, sehingga siapa pun yang bisa mengakses file tersebut atau masuk ke tautan web phpMyAdmin akan otomatis memiliki akses penuh tanpa penjagaan.

## 5. Hasil Latihan dan Modifikasi
*   **Latihan 1: Membuat Akun Tamu**
    ![Galat 1142 Akun Tamu](img/p01_galat_1142.png)
    *Keterangan:* Pembuatan tabel dengan `CREATE TABLE uji (id INT);` menggunakan akun `tamu_063` memunculkan `ERROR 1142 (42000): CREATE command denied`. Hal ini terjadi karena akun tamu sebelumnya hanya diberikan hak `SELECT` (baca), sehingga secara keamanan ditolak saat mencoba mengubah struktur *database*.
*   **Latihan 2: Menjalankan Skrip Berulang**
    Skrip `p01_lingkungan_063.sql` telah dimodifikasi dengan penambahan klausa `IF NOT EXISTS` pada perintah `CREATE DATABASE` dan `CREATE USER`. Setelah diuji dengan dipanggil dua kali di CMD, tidak muncul lagi `ERROR 1050 Table already exists`.

## 6. Tugas Mandiri: Milestone Proyek 1
*   **Tema Proyek:** Toko Daring (berdasarkan pembagian tema dari 2 digit akhir NIM 63).
*   **Kesiapan Lingkungan Proyek:** Basis data `toko_063` dan akun pengembang `dev_063` telah sukses dibuat.
*   **Bukti Pembatasan Akses Akun Proyek:**
    ![Galat 1044 Akun Dev](img/p01_show_db_dev_dan_galat1044.png)
    *Keterangan:* Muncul `ERROR 1044` saat akun `dev_063` diuji untuk mengakses `kopma_063`, membuktikan hak aksesnya sudah dibatasi.
*   File `README.md` telah disunting untuk memuat Identitas Proyek (Toko Wabe Mandiri 063) dan penjelasan layanannya.
*   File `.gitignore` telah dibuat untuk mengecualikan direktori seperti `.env` dan `kredensial*.txt`.

## 7. Pembahasan dan Kendala
Selama praktikum, saya mengalami beberapa kendala. Pertama, *typo* pada penulisan `SHOW DATABASE;` yang memunculkan `ERROR 1064 (42000)` *syntax error*. Ini diselesaikan dengan mengubahnya menjadi bentuk jamak `SHOW DATABASES;`. 

Kedua, saya mendapati pesan `ERROR 2002 (HY000): Can't connect to MySQL server` di Command Prompt, dan pesan merah `Error: MySQL shutdown unexpectedly` di XAMPP Control Panel. Berdasarkan pengecekan file `mysql_error.log`, masalah tersebut diakibatkan oleh *crash* pada server sehingga urutan data (`log sequence number`) sempat tidak sinkron, namun mesin InnoDB berhasil melakukan pemulihan otomatis (*recovery*). Solusinya, saya menekan tombol *Start* ulang di XAMPP dan *login* kembali setelah statusnya hijau.

## 8. Kesimpulan
Melalui praktikum modul pertama ini, saya menyimpulkan bahwa pengelolaan keamanan basis data sangat penting dilakukan sejak awal, terutama dengan pembatasan hak akses (*least privilege*) antar pengguna. Selain itu, kendala *server crash* di lapangan membuktikan urgensi pencatatan versi menggunakan Git, karena memungkinkan basis data dipulihkan kapan saja menggunakan skrip SQL yang telah disimpan.

## 9. Pernyataan Penggunaan AI
Dalam menyusun laporan ini, saya menggunakan asisten AI Google Gemini. Bantuan yang diberikan berupa identifikasi penyebab `ERROR 2002` berdasarkan pembacaan `mysql_error.log`, analisis perbedaan kode galat 1044/1142, penyuntingan format Markdown, serta koreksi *typo* sintaks, sementara keseluruhan eksekusi skrip, pembuatan *database*, dan pengambilan tangkapan layar dikerjakan sepenuhnya secara mandiri.

## 10. Bukti Git
*   **Tautan Repositori:** `https://github.com/awababdulkhoir-cell/basisdata-25430063` 
*   **Hash Commit:** `b3bd9c2`

## Checklist
- [x] Identitas (Nama, NIM, kelas, pertemuan ke-N, tanggal pelaksanaan, nama asisten/dosen)
- [x] Tujuan Praktikum ditulis ulang dengan bahasa sendiri
- [x] Ringkasan Dasar Teori menggunakan pemahaman sendiri
- [x] Tangkapan layar hasil langkah percobaan
- [x] Semua Titik Analisis dijawab lengkap dengan alasan
- [x] Skrip/dokumen hasil latihan beserta bukti berjalan
- [x] Tugas Mandiri (Milestone proyek pertemuan ini)
- [x] Pembahasan dan kendala
- [x] Kesimpulan
- [x] Pernyataan Penggunaan AI
- [x] Bukti Git
- [x] Keaslian (Tangkapan layar memperlihatkan akun ber-NIM)
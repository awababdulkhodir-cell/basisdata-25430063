# Laporan Praktikum Basis Data
**Nama:** Awab Abdul Khodir
**NIM:** 25430063
**Kelas:** Basis Data (NIM Berakhiran 63)
**Tanggal:** 12 Oktober 2026

## 1. Tujuan Praktikum
Praktikum ini bertujuan agar mahasiswa mampu melakukan analisis kebutuhan sebelum merancang basis data. Fokus utamanya adalah mengidentifikasi aktor dan proses bisnis dari dokumen sumber, merumuskan entitas kandidat dan aturan bisnis, menyusun matriks CRUD serta kamus data, dan menuliskan pernyataan kebutuhan data secara spesifik dan dapat diuji.

## 2. Ringkasan Dasar Teori
Perancangan basis data yang baik harus selalu diawali dengan analisis kebutuhan, karena kesalahan yang terjadi di tahap ini sangat mahal untuk diperbaiki jika baru disadari pada tahap desain fisik[cite: 15]. Dalam analisis ini, data dipandang sebagai sebuah aset organisasi yang lahir dari proses bisnis dan memiliki penanggung jawab (*data steward*)[cite: 15]. Kebutuhan ini digali dari dokumen sumber seperti nota dan formulir, lalu dipetakan menggunakan Matriks CRUD (Create, Read, Update, Delete) untuk memastikan tidak ada data yang terabaikan atau proses yang terlewat[cite: 16]. Seluruh hasil analisis ini didokumentasikan dalam Pernyataan Kebutuhan yang harus bersifat spesifik, terukur, dan dapat diuji kebenarannya[cite: 16].

## 3. Hasil Langkah Percobaan
*(Catatan: Langkah percobaan modul ini sepenuhnya berupa kerja analisis pada dokumen `p02_kebutuhan_data_kopma_063.md` yang telah di-commit ke repositori).*

## 4. Jawaban Titik Analisis
*   **Titik Analisis 1:** Harga saat transaksi wajib disimpan secara terpisah (di-rekam mati pada nota) untuk menjaga akurasi **data historis**. Sesuai keluhan ketua koperasi, jika harga master suatu barang naik di kemudian hari, harga pada nota-nota lama tidak boleh ikut berubah[cite: 19, 23]. Menyimpannya di nota memastikan rekam jejak keuangan masa lalu tetap valid sesuai harga riil saat transaksi tersebut terjadi.
*   **Titik Analisis 2:** 
    *   *Alasan tidak disimpan:* Subtotal dan total adalah nilai turunan (hasil kali qty dengan harga). Tidak menyimpannya dapat mencegah redundansi (data ganda) dan inkonsistensi, karena nilai tersebut selalu bisa dihitung ulang secara dinamis (*on-the-fly*)[cite: 19].
    *   *Alasan tetap disimpan:* Jika volume transaksi sudah sangat besar (jutaan baris), menghitung ulang total setiap kali sistem ingin menampilkan laporan bulanan akan sangat membebani kinerja server. Menyimpannya dapat mempercepat proses kueri laporan.
*   **Titik Analisis 3:** Pemeriksaan "entitas yatim" adalah proses mengecek matriks CRUD untuk memastikan setiap entitas minimal memiliki proses bisnis yang membuatnya (memiliki huruf **C** / *Create*). Jika ada entitas yatim (tanpa huruf C), cara memperbaikinya adalah dengan menambahkan proses pemeliharaan data ke daftar proses bisnis (misalnya: "Mengelola data pemasok"), atau dengan menghapus entitas tersebut jika memang ternyata tidak diperlukan oleh sistem.

## 5. Hasil Latihan dan Modifikasi
**Latihan E.1 (Poin Loyalitas):**
Modifikasi ini telah diimplementasikan ke dalam dokumen Kopma dengan menambahkan atribut `poin_loyalitas` pada entitas Anggota, merumuskan AB-07 dan AB-08, menambahkan kebutuhan informasi KI-05, serta menambahkan hak akses U (*Update*) pada matriks CRUD Anggota untuk proses penjualan[cite: 21].

**Latihan E.2 (Memperbaiki Pernyataan Kabur):**[cite: 21]
Berikut adalah perbaikan pernyataan kabur menjadi pernyataan yang dapat diuji:
1.  *(Kabur: "data anggota harus aman")* -> **Dapat Diuji:** Data pribadi anggota (Nomor HP dan NIM) hanya dapat diakses dengan mode *Read-Only* oleh peran Kasir dan Ketua Koperasi.
2.  *(Kabur: "sistem harus cepat mencari barang")* -> **Dapat Diuji:** Sistem kasir mendukung pencarian barang menggunakan kode *barcode* atau nama barang, dan mampu menampilkan hasil pencarian ke layar dalam waktu maksimal 2 detik.
3.  *(Kabur: "laporan stok harus akurat")* -> **Dapat Diuji:** Kuantitas stok barang pada sistem akan berkurang secara otomatis seketika saat kasir mencetak nota penjualan, dan sistem otomatis menolak transaksi jika *qty* barang yang dibeli melebihi jumlah stok yang tercatat.

## 6. Tugas Mandiri: Milestone Proyek 2
Milestone Proyek 2 (Toko Wabe Mandiri 063) telah disusun pada berkas `p02_kebutuhan_data_063.md` dengan memenuhi parameter minimum modul (4 PB, 6 entitas, 8 aturan bisnis, matriks CRUD lengkap, dan kamus data 20 elemen)[cite: 21]. 

*   **Perhitungan Parameter Personal (P):**
    *   NIM: 25430063 (2 digit akhir: 63)
    *   **P** = (63 mod 9) + 1 = 0 + 1 = **1**
    *   Batas item per transaksi: 1 + 2 = **3 item**
    *   Persentase diskon: **1%**
    *   Perkiraan volume harian: 40 + (5 × 1) = **45 transaksi/hari**[cite: 22]

**Tangkapan Layar Dokumen Proyek dari GitHub:**
*(Silakan ganti tulisan ini dengan screenshot/tangkapan layar dari browser GitHub Anda yang menampilkan tabel PB, AB, KI, Matriks CRUD, dan Kamus Data dari file proyek)*[cite: 23]
*   ![Tabel PB dan AB](img/p02_pb_ab.png)
*   ![Tabel KI dan Matriks CRUD](img/p02_ki_crud.png)
*   ![Kamus Data](img/p02_kamus_data.png)

## 7. Pembahasan dan Kendala
Kendala yang paling utama pada praktikum kali ini adalah kebingungan dalam menentukan entitas detail transaksi. Pada awalnya saya berniat menaruh semua data pesanan (termasuk daftar barang yang dibeli) dalam satu entitas `Pesanan`. Namun, setelah mempelajari Masalah 3 tentang data historis dan Aturan Bisnis 04, saya menyadari bahwa tagihan harus disimpan secara spesifik per baris barang yang dibeli. Solusinya adalah memecah entitas tersebut menjadi `Pesanan` (sebagai *header*) dan `Detail_Pesanan` (sebagai penyimpan riwayat jumlah dan harga mati)[cite: 22, 23].

## 8. Kesimpulan
Tahap analisis kebutuhan sangat krusial dalam perancangan basis data. Penggunaan instrumen seperti Peta Proses Bisnis, Matriks CRUD, dan Kamus Data membantu pengembang memastikan bahwa tidak ada entitas yang tumpang tindih atau kehilangan proses (yatim). Selain itu, aturan bisnis wajib dirumuskan dengan pernyataan yang spesifik, terukur, dan dapat diuji agar sistem yang dibangun terhindar dari permasalahan kualitas data (seperti kebocoran riwayat data historis).

## 9. Pernyataan Penggunaan AI
Dalam menyusun laporan ini, saya menggunakan Google Gemini sebagai asisten. Gemini membantu saya memvalidasi cara perhitungan parameter P berdasarkan rumus modul, memeriksa keberadaan "entitas yatim" pada draf matriks CRUD saya, serta memberikan contoh perbandingan dalam merangkai kalimat pernyataan kebutuhan yang kabur menjadi spesifik dan dapat diuji pada bagian latihan. Seluruh analisis entitas dan pencatatan aturan bisnis dilakukan menggunakan logika dan analisis mandiri.

## 10. Bukti Git
*   **Tautan Repositori:** `https://github.com/awababdulkhodir-cell/basisdata-25430063`
*   **Hash Commit Terakhir:** `MASUKKAN_HASH_COMMIT_ANDA_DI_SINI`

## Checklist
- [x] Berkas wajib: `p02_kebutuhan_data_kopma_063.md` dan `p02_kebutuhan_data_063.md`
- [x] Tangkapan layar proyek dari GitHub
- [x] Jawaban Titik Analisis 1-3
- [x] Perhitungan Parameter P
- [x] Perbaikan 3 pernyataan kebutuhan kabur
- [x] Penjelasan asal usul aturan bisnis pada pembahasan
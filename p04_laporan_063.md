# Laporan Praktikum Basis Data
**Nama:** Awab Abdul Khodir
**NIM:** 25430063
**Kelas:** Basis Data (NIM Berakhiran 63)
**Tanggal:** 14 Oktober 2026

## 1. Tujuan Praktikum
Praktikum ini bertujuan agar mahasiswa mampu mengidentifikasi anomali ubah, sisip, dan hapus pada data yang belum dinormalisasi; menuliskan dependensi fungsional dari aturan bisnis; menormalisasi relasi hingga bentuk normal ketiga (3NF) dan memeriksa BCNF; serta memutuskan penyimpanan nilai turunan dan mendokumentasikan skema relasional akhir.

## 2. Ringkasan Dasar Teori
Data yang belum dinormalisasi (UNF) dapat menimbulkan anomali saat dilakukan pembaruan (ubah, sisip, hapus) karena adanya duplikasi data. Normalisasi adalah proses bertahap untuk menghilangkan anomali tersebut menggunakan konsep Dependensi Fungsional (FD)[cite: 17, 18]. Tahapan normalisasi dimulai dari 1NF (menghilangkan grup berulang), 2NF (menghilangkan ketergantungan parsial pada kunci komposit), hingga 3NF (menghilangkan ketergantungan transitif)[cite: 17]. Pemeriksaan akhir dilakukan dengan BCNF untuk memastikan setiap penentu adalah kunci kandidat[cite: 18].

## 3. Hasil Langkah Percobaan
Langkah percobaan dilakukan dengan menormalisasi *spreadsheet* lama Kopma. Grup berulang dihilangkan menjadi 1NF, kemudian dipisah berdasarkan dependensi fungsional parsial menjadi 2NF (`penjualan`, `barang`, `detail_penjualan`), dan terakhir dipisah dari dependensi transitif menjadi 3NF (memisahkan `petugas` dan `anggota`). Nilai turunan seperti total tidak disimpan untuk menghindari inkonsistensi[cite: 19].

## 4. Jawaban Titik Analisis
*   **Titik Analisis 1:** Harga satuan ditempatkan pada `(no_nota_penjualan, kode_barang)` karena merujuk pada "harga saat transaksi tersebut terjadi" (AB-04). Jika atribut ini dipindah ke tabel `barang`, maka jika sewaktu-waktu harga barang naik, sistem akan menghitung ulang seluruh nota lama dengan harga baru. Hal ini akan merusak laporan omzet masa lalu karena potret historisnya hilang[cite: 18].
*   **Titik Analisis 2:** Pada tabel operasional, data masih aktif dan detailnya bisa berubah (misal: ada pengembalian barang atau ubah *qty*). Menyimpan "total" di tabel operasional berisiko menimbulkan inkonsistensi jika lupa diperbarui. Sebaliknya, tabel arsip berisi potret historis yang **tidak boleh/tidak akan pernah berubah lagi**. Menyimpan "total" di tabel arsip aman dan sangat menguntungkan untuk mempercepat perhitungan laporan data historis dalam jumlah besar[cite: 19].
*   **Titik Analisis 3:** Informasi "barang dipasok oleh siapa" kini direkam melalui relasi tabel `pembelian` dan `detail_pembelian`[cite: 20]. Keuntungannya: Satu jenis barang bisa dipasok oleh banyak pemasok berbeda di waktu yang berbeda. Jika disimpan di tabel `barang`, satu barang hanya akan terpaku pada satu pemasok selamanya (tidak realistis).

## 5. Hasil Latihan dan Modifikasi
*   **Latihan E.1 (Banyak Nomor Telepon):** 
    Jika pemasok memiliki banyak nomor telepon, atribut telepon menjadi muti-nilai (*multivalued*). Normalisasinya adalah dengan memisahkan nomor telepon ke tabel baru.
    `TELEPON_PEMASOK (id_pemasok*, nomor_telepon)`
    *(Primary key adalah komposit dari id_pemasok dan nomor_telepon).*
*   **Latihan E.2 (Anomali Ubah 3NF):**
    Jika `nama_anggota` disimpan di tabel `penjualan`, terjadi pelanggaran 3NF karena `no_nota -> no_anggota -> nama_anggota`[cite: 19, 20]. 
    **Contoh pelanggaran (Anomali Ubah):** Anggota bernama "Budi S." ingin mengubah namanya menjadi "Budi Santoso". Kuerinya:
    `UPDATE penjualan SET nama_anggota = 'Budi Santoso' WHERE no_anggota = '123' AND no_nota = 'PJ-0142';`
    Jika Budi memiliki 50 transaksi lain, kita harus memastikan 50 baris tersebut ikut di-*update*. Jika ada yang terlewat, nama Budi akan berbeda-beda di sistem (inkonsisten)[cite: 20].

## 6. Tugas Mandiri: Milestone Proyek 4
Proses normalisasi untuk dokumen pesanan Toko Wabe Mandiri 063 telah dilakukan dari bentuk UNF, 1NF, 2NF, hingga 3NF dan telah terbukti memenuhi syarat BCNF.

**Bukti Tangkapan Layar Normalisasi:**
![Normalisasi Wabe Mandiri](img/p04_normalisasi_063.png)

**Daftar Dependensi Fungsional Proyek:**
1.  `id_pesanan -> tgl_pesan, id_pelanggan, alamat_pengiriman, ongkos_kirim` (AB-04)
2.  `id_pelanggan -> nama_pelanggan`
3.  `id_produk -> nama_produk`
4.  `(id_pesanan, id_produk) -> qty, harga_saat_pesan` (AB-03)

**Keputusan Nilai Turunan:**
Nilai `subtotal_item` dan `total_bayar` diputuskan untuk **tidak disimpan** di tabel operasional. Keduanya dapat dihitung secara dinamis dari `qty * harga_saat_pesan + ongkos_kirim`. Hal ini dilakukan untuk menghindari anomali inkonsistensi jika data operasional diubah (misalnya `qty` pesanan dikurangi).

## 7. Pembahasan dan Kendala
Kendala yang sempat dialami adalah memastikan bahwa dependensi fungsional benar-benar diturunkan dari aturan bisnis (AB), bukan ditebak dari contoh datanya. Misalnya, untuk harga barang, kita tidak boleh berpatokan pada `kode_barang -> harga_satuan`, melainkan pada `(id_pesanan, id_produk) -> harga_saat_pesan` sesuai kebutuhan data historis (AB-03)[cite: 21, 22].

## 8. Kesimpulan
Normalisasi sangat penting untuk mencegah terjadinya anomali saat data dimanipulasi (insert, update, delete). Setiap tahapan normalisasi (1NF, 2NF, 3NF) memiliki tujuan spesifik untuk memecah tabel berdasarkan ketergantungan kuncinya[cite: 17, 18]. Skema yang sudah mencapai 3NF dan BCNF memastikan setiap atribut non-kunci sepenuhnya bergantung pada primary key tanpa adanya ketergantungan parsial maupun transitif.

## 9. Pernyataan Penggunaan AI
Dalam pengerjaan laporan ini, saya menggunakan Google Gemini sebagai *thought partner* untuk merumuskan penjelasan logis pada Titik Analisis mengenai nilai turunan pada tabel arsip, serta menyusun struktur contoh kueri SQL untuk mendemonstrasikan pelanggaran 3NF pada Latihan E. Seluruh tahapan normalisasi proyek mandiri didasarkan pada dokumen kebutuhan awal saya.

## 10. Bukti Git
*   **Tautan Repositori:** `https://github.com/awababdulkhodir-cell/basisdata-25430063`
*   **Hash Commit Terakhir:** `997bbb7`

## Checklist
- [x] Berkas wajib: `p04_normalisasi_063.md` (proyek)
- [x] Bukti tangkapan layar: Tabel tahapan UNF -> 1NF -> 2NF -> 3NF
- [x] Analisis wajib: Daftar dependensi fungsional; keputusan menyimpan/menghitung nilai turunan beserta alasannya
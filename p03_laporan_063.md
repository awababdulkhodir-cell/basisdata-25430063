# Laporan Praktikum Basis Data
**Nama:** Awab Abdul Khodir
**NIM:** 25430063
**Kelas:** Basis Data (NIM Berakhiran 63)
**Tanggal:** 13 Oktober 2026

## 1. Tujuan Praktikum
Praktikum ini bertujuan agar mahasiswa mampu mengidentifikasi entitas, atribut, dan kunci dari dokumen kebutuhan data; menentukan relasi beserta kardinalitas dan partisipasinya dengan alasan dari aturan bisnis; memecah relasi banyak-ke-banyak menjadi entitas asosiatif; serta menggambar ERD dengan notasi Crow's Foot dan memvalidasinya terhadap Kebutuhan Informasi (KI).

## 2. Ringkasan Dasar Teori
Entity-Relationship Diagram (ERD) adalah hasil tahap desain konseptual yang memodelkan data sebagai entitas (benda/kejadian), atribut (sifat), dan relasi (hubungan antarentitas). Dalam ERD, kardinalitas menjawab "berapa banyak" (maksimum), dan partisipasi menjawab "wajib atau opsional" (minimum), yang digambarkan menggunakan notasi Crow's Foot. Relasi banyak-ke-banyak (M:N) tidak dapat disimpan langsung dalam tabel relasional sehingga harus dipecah menjadi entitas asosiatif yang menghubungkan kedua entitas asalnya secara satu-ke-banyak (1:N).

## 3. Hasil Langkah Percobaan
Praktikum ini berfokus pada pembuatan diagram. File ERD konseptual Kopma telah digambar menggunakan draw.io dengan notasi Crow's Foot dan diekspor menjadi `p03_erd_kopma_063.drawio` (file sumber) serta `p03_erd_kopma_063.png` (file gambar).

## 4. Jawaban Titik Analisis
*   **Titik Analisis 1:** Penggunaan `id_anggota` (*surrogate key*) sebagai kunci primer lebih disarankan daripada `nim_anggota` (*natural key*) karena nilai `id_anggota` diciptakan murni oleh sistem dan tidak akan pernah berubah. Risiko menggunakan NIM adalah kemungkinan terjadinya salah ketik saat mendaftar atau perubahan NIM (misalnya mahasiswa pindah prodi). Jika NIM digunakan sebagai Primary Key, perubahannya akan berisiko merusak relasi (*Foreign Key*) di semua tabel transaksi masa lalu.
*   **Titik Analisis 2:** Aturan bisnis yang memaksa relasi bernilai "satu atau banyak" dari sisi pesanan ke detail adalah **AB-01** (setiap nota minimal memiliki satu baris barang). Aturan "minimal satu" ini tidak dapat dicegah sepenuhnya hanya melalui struktur pembuatan tabel. Sesuai catatan buku, hal ini memerlukan kontrol aplikasi melalui logika **transaksi** agar header nota dan detail barang tersimpan secara bersamaan.
*   **Titik Analisis 3:** ERD Kopma saat ini (Gambar 3.2) **belum dapat menjawab** pertanyaan "petugas gudang mana yang menerima barang", karena tidak ada garis relasi dari tabel `petugas` ke tabel `pembelian`. Solusinya adalah menambahkan relasi dari entitas `petugas` ke `pembelian` (menyisipkan `id_petugas` sebagai FK di pembelian), dan mencatat aturan bisnis baru: *"Setiap penerimaan barang dari pemasok harus dicatat dan dipertanggungjawabkan oleh tepat satu petugas."*

## 5. Hasil Latihan dan Modifikasi
*   **Latihan E.1 (Poin Loyalitas):** Jika poin loyalitas hanya dilihat sebagai "total saldo poin saat ini", maka cukup dijadikan sebagai **atribut** pada entitas `anggota`. Namun, jika organisasi ingin menampilkan laporan riwayat kapan poin itu didapatkan dan kapan ditukarkan, maka diperlukan **entitas baru** (misal: `riwayat_poin`) yang berelasi dengan `anggota`.
*   **Latihan E.2 (Relasi Banyak-ke-Banyak Langsung):** Jika entitas asosiatif `detail_penjualan` dihapus dan entitas `penjualan` dihubungkan langsung secara banyak-ke-banyak dengan `barang`, maka kita akan **kehilangan data atribut** `qty` dan `harga_saat_transaksi`. Kedua data tersebut bukanlah sifat permanen dari barang maupun nota, melainkan sifat dari "kejadian bertemunya" barang tersebut di nota yang spesifik.

## 6. Tugas Mandiri: Milestone Proyek 3
Berikut adalah hasil perancangan ERD untuk Toko Daring "Wabe Mandiri 063":

**Gambar ERD Proyek:**
![ERD Wabe Mandiri 063](p03_erd_kopma_063)

**Tabel Relasi dan Kardinalitas Proyek:**
| Relasi | Sisi kiri | Sisi kanan | Dasar Aturan Bisnis |
| :--- | :--- | :--- | :--- |
| pelanggan **melakukan** pesanan | tepat satu pelanggan | nol atau banyak pesanan | AB-01 (Wajib mendaftar akun) |
| pesanan **berisi** detail_pesanan | tepat satu pesanan | satu atau banyak detail | AB-05 (Pesanan minimal 1 item) |
| produk **tercantum di** detail_pesanan | tepat satu produk | nol atau banyak detail | AB-03 (Harga disimpan per transaksi) |
| pesanan **memiliki** pembayaran | tepat satu pesanan | nol atau satu pembayaran | AB-07 (Bisa belum bayar / batal) |
| pesanan **memiliki** pengiriman | tepat satu pesanan | nol atau satu pengiriman | AB-08 (Dikirim jika validasi sukses) |

**Tabel Penelusuran Kebutuhan Informasi (KI):**
| Kode KI | Kebutuhan Informasi | Jalur ERD yang Menjawab |
| :--- | :--- | :--- |
| KI-01 | Omzet harian dan bulanan | `pembayaran` -> `pesanan` |
| KI-02 | Lima produk terlaris | `produk` -> `detail_pesanan` |
| KI-03 | Pesanan belum dibayar | `pesanan` -> `pembayaran` |
| KI-04 | Status pengiriman | `pesanan` -> `pengiriman` |
| KI-05 | Produk dengan stok habis | `produk` |

**Catatan Tinjauan Klien (Umpan Balik Fiktif):**
1.  *Umpan balik 1:* "Tambahkan keterangan metode pembayaran apa saja yang diterima." -> **Keputusan:** Diterima. Telah ditambahkan atribut `metode` pada entitas `pembayaran`.
2.  *Umpan balik 2:* "Kurir ekspedisi pengirim barang belum dicatat." -> **Keputusan:** Diterima. Telah ditambahkan atribut `kurir_ekspedisi` pada entitas `pengiriman`.

## 7. Pembahasan dan Kendala
Kendala utama yang dialami saat praktikum adalah memahami cara membaca arah kardinalitas *Crow's Foot*. Sering kali terjadi kesalahan dalam menempatkan simbol "banyak" pada entitas. Sesuai panduan *troubleshooting* Modul 3, solusinya adalah dengan membaca kardinalitas dari sisi entitas di seberangnya (misal: "satu pesanan memiliki *berapa* detail?"). Selain itu, memecah relasi *many-to-many* menjadi entitas asosiatif `detail_pesanan` sangat membantu untuk menyimpan atribut operasional seperti harga mati saat *checkout*.

## 8. Kesimpulan
ERD sangat penting untuk memvisualisasikan dokumen kebutuhan data yang sebelumnya berupa teks menjadi diagram konseptual. ERD membantu pengembang memastikan tidak ada entitas yang tidak terhubung secara logis, dan memvalidasi bahwa semua Kebutuhan Informasi (KI) benar-benar memiliki jalur data yang dapat ditelusuri antarentitas sebelum diimplementasikan menjadi tabel basis data.

## 9. Pernyataan Penggunaan AI
Dalam pengerjaan Modul 3 ini, saya menggunakan asisten AI (Google Gemini) untuk membantu menyusun kerangka tabel penelusuran Kebutuhan Informasi (KI), memberikan logika penjelasan perbandingan *surrogate key* vs *natural key*, serta memberikan kerangka ERD tekstual awal untuk proyek mandiri agar saya lebih mudah merangkai relasi kotaknya di draw.io.

## 10. Bukti Git
*   **Tautan Repositori:** `https://github.com/awababdulkhodir-cell/basisdata-25430063`
*   **Hash Commit Terakhir:** `50ac0b2`

## Checklist
- [x] Berkas wajib: `p03_erd_kopma_063` dan `p03_erd_063` (gambar + berkas sumber draw.io)
- [x] Bukti tangkapan layar: Gambar ERD diletakkan di dalam laporan
- [x] Analisis wajib: Pemetaan PB/KI, Jawaban Titik Analisis 1-3, dan alasan relasi kardinalitas
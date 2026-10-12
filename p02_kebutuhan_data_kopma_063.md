# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar belakang dan aktivitas organisasi
Koperasi Mahasiswa Sejahtera (Kopma) adalah organisasi yang bergerak dalam penjualan alat tulis, makanan ringan, dan minuman di lingkungan kampus[cite: 17]. Pembeli dapat berasal dari kalangan umum maupun mahasiswa yang mendaftar sebagai anggota aktif[cite: 17]. Aktivitas harian organisasi bertumpu pada pencatatan transaksi penjualan di kasir, manajemen stok dan pemesanan barang ke pemasok oleh petugas gudang, serta evaluasi kinerja melalui laporan bulanan untuk ketua koperasi[cite: 17].

## 2. Aktor dan proses bisnis
Berikut adalah aktor dan proses bisnis utama yang berjalan di Kopma[cite: 18]:

| Kode  | Proses Bisnis | Aktor | Pemicu |
| :--- | :--- | :--- | :--- |
| PB-01 | Mendaftarkan anggota | Kasir | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan & poin loyalitas | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |

## 3. Dokumen sumber yang dianalisis
Kebutuhan data ini digali dan dianalisis dari beberapa dokumen sumber[cite: 16, 17, 18, 19]:
1. Formulir pendaftaran anggota
2. Nota penjualan (bukti transaksi)
3. Faktur pemasok (bukti penerimaan barang)
4. Buku catatan stok manual

## 4. Entitas kandidat dan elemen data
Berdasarkan dokumen sumber dan modifikasi Latihan E.1, didapatkan entitas kandidat berikut[cite: 19, 20, 21]:

| Entitas kandidat | Elemen data utama | Sumber |
| :--- | :--- | :--- |
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif, **poin loyalitas** | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar, **poin didapat, poin ditukar** | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian & detail | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

## 5. Aturan bisnis
Aturan bisnis operasional Kopma adalah sebagai berikut[cite: 20, 21]:

| Kode | Aturan bisnis |
| :--- | :--- |
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| **AB-07** | **Setiap kelipatan Rp10.000 belanja (setelah diskon), anggota memperoleh 1 poin loyalitas.** *(Modifikasi E.1)* |
| **AB-08** | **Anggota dapat menukarkan kelipatan 50 poin dengan potongan harga sebesar Rp5.000 pada saat transaksi.** *(Modifikasi E.1)* |

## 6. Kebutuhan informasi
Laporan dan informasi yang harus bisa dijawab oleh sistem[cite: 20, 21]:

| Kode | Kebutuhan informasi | Data yang diperlukan |
| :--- | :--- | :--- |
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| **KI-05** | **Total poin loyalitas yang belum ditukarkan oleh tiap anggota aktif** | **Anggota** *(Modifikasi E.1)* |

## 7. Matriks CRUD
Pemetaan proses bisnis terhadap manipulasi entitas (Create, Read, Update, Delete)[cite: 16, 20, 21]:

| Proses Bisnis | Anggota | Barang | Penjualan | Detail Penjualan | Pemasok | Pembelian | Petugas |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| PB-01 Daftar anggota | **C** | | | | | | |
| PB-02 Mencatat penjualan | **R, U*** | **R, U** | **C** | **C** | | | **R** |
| PB-03 Memesan barang | | **R** | | | **R** | | **R** |
| PB-04 Menerima barang | | **R, U** | | | **R** | **C** | **R** |
| PB-05 Laporan bulanan | **R** | **R** | **R** | **R** | | **R** | **R** |

*(Catatan Modifikasi E.1: PB-02 sekarang memiliki aksi **U (Update)** pada entitas Anggota karena sistem harus menambahkan saldo poin loyalitas atau menguranginya jika poin ditukarkan)*[cite: 16, 21].

## 8. Kamus data awal
Mendokumentasikan elemen data penting dan penanggung jawabnya (*data steward*)[cite: 15, 16]:

| Nama Elemen Data | Tipe/Contoh Nilai | Penanggung Jawab | Keterangan / Aturan |
| :--- | :--- | :--- | :--- |
| `nomor_anggota` | A-0457 | Kasir | Dibuat saat pendaftaran, berformat A-xxxx. |
| `NIM` | 25430063 | Kasir | Bersifat unik, digunakan sebagai alternatif pencarian anggota. |
| `poin_loyalitas` | 150 | Kasir | Bertambah via AB-07, berkurang via AB-08. |
| `stok_barang` | 25 | Petugas Gudang | Tidak boleh negatif (AB-03). Diperbarui saat PB-02 dan PB-04. |
| `batas_minimum` | 10 | Petugas Gudang | Menjadi pemicu pemesanan barang ke pemasok (AB-06). |
| `harga_saat_transaksi`| 4.000 | Kasir | Disimpan mati per baris di nota (AB-04) agar kebal dari perubahan harga master. |

## 9. Kebutuhan non-fungsional data
Batasan operasional dan pengamanan privasi data[cite: 16, 21]:
*   **Volume dan Retensi:** Rata-rata transaksi mencapai ±150 nota per hari. Data penjualan harus disimpan minimal selama 5 tahun untuk keperluan audit[cite: 16].
*   **Privasi Data:** Data anggota seperti Nomor HP dan NIM bersifat pribadi. Akses pembacaan data ini dibatasi hanya untuk Kasir (saat validasi identitas) dan Ketua Koperasi[cite: 16, 21].

## 10. Isu kualitas data yang diantisipasi
Berdasarkan wawancara, ada beberapa isu kualitas data yang sering terjadi dan harus ditangani sistem[cite: 15, 17, 21]:
1.  **Harga nota lama hilang:** Diantisipasi dengan AB-04, yaitu menyimpan `harga_saat_transaksi` secara terpisah di detail nota agar data riwayat tidak rusak saat terjadi kenaikan harga[cite: 15, 19].
2.  **Stok buku catatan manual minus:** Diantisipasi dengan validasi sistem sesuai AB-03, di mana sistem akan menolak penyelesaian transaksi jika kuantitas barang melebihi stok yang ada[cite: 17, 20].
3.  **Anggota lupa membawa kartu:** Diantisipasi dengan AB-05, di mana fitur pencarian anggota pada mesin kasir didesain tidak hanya menerima nomor anggota, tetapi juga bisa mencari menggunakan NIM[cite: 17, 20].
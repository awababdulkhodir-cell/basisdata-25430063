# Normalisasi Dokumen Toko Wabe Mandiri 063
**Dokumen Sumber:** Halaman Pesanan (Invoice Digital)[cite: 20]

## 1. Unnormalized Form (UNF)
Satu nota pesanan menyimpan grup berulang untuk daftar barang yang dibeli:
`PESANAN_UNF (id_pesanan, tgl_pesan, id_pelanggan, nama_pelanggan, alamat_pengiriman, ongkos_kirim, { id_produk, nama_produk, qty, harga_saat_pesan, subtotal_item }, total_bayar)`

## 2. First Normal Form (1NF)
Menghilangkan grup berulang dengan membuat satu baris untuk setiap barang di setiap nota. Kunci primer menjadi komposit `(id_pesanan, id_produk)`[cite: 18].
`PESANAN_1NF (id_pesanan, id_produk, tgl_pesan, id_pelanggan, nama_pelanggan, alamat_pengiriman, ongkos_kirim, nama_produk, qty, harga_saat_pesan, subtotal_item, total_bayar)`

## 3. Dependensi Fungsional (FD)
Diturunkan dari Aturan Bisnis (AB) Pertemuan 2[cite: 18, 20]:
*   **FD1:** `id_pesanan -> tgl_pesan, id_pelanggan, alamat_pengiriman, ongkos_kirim` (Berdasarkan AB-04: Alamat & ongkir spesifik per pesanan)
*   **FD2:** `id_pelanggan -> nama_pelanggan` (Data profil pelanggan)
*   **FD3:** `id_produk -> nama_produk` (Katalog master produk)
*   **FD4:** `(id_pesanan, id_produk) -> qty, harga_saat_pesan` (Berdasarkan AB-03: Harga dikunci per baris transaksi)[cite: 20]
*   **FD5 (Turunan):** `(qty, harga_saat_pesan) -> subtotal_item`
*   **FD6 (Turunan):** `(subtotal_item, ongkos_kirim) -> total_bayar`

## 4. Second Normal Form (2NF)
FD1 dan FD3 hanya bergantung pada sebagian kunci komposit (ketergantungan parsial), sehingga harus dipisah menjadi relasi tersendiri[cite: 19].
*   `PESANAN_2NF (id_pesanan, tgl_pesan, id_pelanggan, nama_pelanggan, alamat_pengiriman, ongkos_kirim)`
*   `PRODUK (id_produk, nama_produk)`
*   `DETAIL_PESANAN (id_pesanan, id_produk, qty, harga_saat_pesan)`

## 5. Third Normal Form (3NF)
Pada `PESANAN_2NF` terdapat rantai ketergantungan transitif `id_pesanan -> id_pelanggan -> nama_pelanggan` (FD2). Entitas pelanggan harus dipisah[cite: 19].
*   `PESANAN (id_pesanan, tgl_pesan, id_pelanggan*, alamat_pengiriman, ongkos_kirim)`
*   `PELANGGAN (id_pelanggan, nama_pelanggan)`
*   `PRODUK (id_produk, nama_produk)`
*   `DETAIL_PESANAN (id_pesanan*, id_produk*, qty, harga_saat_pesan)`

*(Keterangan: Tanda bintang `*` adalah Foreign Key).*

## 6. Pemeriksaan BCNF (Boyce-Codd Normal Form)
Pemeriksaan: Adakah penentu (*determinant*) yang bukan kunci kandidat?[cite: 20]
*   Tabel PESANAN: Penentu adalah `id_pesanan` (Kunci Kandidat).
*   Tabel PELANGGAN: Penentu adalah `id_pelanggan` (Kunci Kandidat).
*   Tabel PRODUK: Penentu adalah `id_produk` (Kunci Kandidat).
*   Tabel DETAIL_PESANAN: Penentu adalah `(id_pesanan, id_produk)` (Kunci Kandidat).
**Kesimpulan:** Semua tabel sudah memenuhi BCNF[cite: 20].

## 7. Keputusan Nilai Turunan
Nilai `subtotal_item` dan `total_bayar` **tidak disimpan** secara permanen di dalam tabel operasional[cite: 19, 20]. 
**Alasan:** Nilai tersebut dapat selalu dihitung (*calculated on-the-fly*) dari perkalian `qty` dan `harga_saat_pesan` ditambah `ongkos_kirim`. Jika disimpan di tabel, akan menimbulkan risiko inkonsistensi data apabila sewaktu-waktu terjadi pembaruan pada kolom `qty` atau `ongkos_kirim`[cite: 19].
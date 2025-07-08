# Aplikasi Dashboard Interaktif: Analisis Data Statistik Negara ASEAN

![Versi Aplikasi](https://img.shields.io/badge/Versi-1.0.0-blue.svg)
![Lisensi](https://img.shields.io/badge/License-MIT-green.svg)

![Demo Aplikasi](https://via.placeholder.com/800x450.png?text=Tempatkan+Screenshot+atau+GIF+Demo+Aplikasi+di+Sini)

---

### Daftar Isi
1.  [Pendahuluan](#-pendahuluan)
2.  [Tim Penyusun](#-tim-penyusun)
3.  [Fitur Utama](#-fitur-utama)
4.  [Arsitektur & Teknologi](#-arsitektur--teknologi)
5.  [Struktur Proyek](#-struktur-proyek)
6.  [Panduan Instalasi & Penggunaan Lokal](#-panduan-instalasi--penggunaan-lokal)
7.  [Sumber Data](#-sumber-data)
8.  [Lisensi](#-lisensi)

---

## 📖 Pendahuluan

Aplikasi _dashboard_ interaktif ini merupakan proyek tugas akhir untuk mata kuliah **Komputasi Statistik**. Proyek ini bertujuan untuk mengembangkan sebuah alat bantu visualisasi berbasis web yang memungkinkan pengguna untuk melakukan analisis eksplorasi data terhadap berbagai indikator statistik dari negara-negara anggota ASEAN. Dengan antarmuka yang dinamis dan responsif, pengguna dapat dengan mudah membandingkan, menganalisis tren, dan memahami hubungan antar variabel ekonomi, sosial, dan demografis di kawasan Asia Tenggara.

---

## 👥 Tim Penyusun

Proyek ini merupakan hasil kolaborasi dari tim yang beranggotakan:

Proyek ini merupakan hasil kolaborasi dari tim dengan pembagian tugas sebagai berikut:

* **Annisa Raihana Musdzakir (222312986)** - *Pengolahan Data*
    * Bertanggung jawab dalam pengumpulan dan pra-pemrosesan data.
    * Membersihkan dan menggabungkan dataset dari berbagai sumber.
    * Membantu eksplorasi data awal (visualisasi dasar menggunakan `ggplot2`).
    * Menyusun dokumentasi proses pengolahan data.

* **Padil Muhammad Zaki (222313311)** - *Analisis Statistik*
    * Bertanggung jawab dalam analisis statistik inti.
    * Melakukan analisis korelasi, regresi linier, dan uji ANOVA.
    * Menginterpretasikan hasil analisis untuk mendapatkan wawasan.
    * Menulis bagian analisis dan interpretasi hasil.

* **Taura Davin Santosa (222313401)** - *Pengembangan Dashboard Shiny*
    * Mendesain *layout* antarmuka pengguna (UI) dan logika *server-side* menggunakan R-Shiny.
    * Mengintegrasikan visualisasi data interaktif (peta, plot) ke dalam dashboard.
    * Melakukan uji coba fungsionalitas dan penyempurnaan dashboard.

---

## ✨ Fitur Utama

Aplikasi ini dilengkapi dengan berbagai fitur untuk memfasilitasi analisis data yang komprehensif:

* **🗺️ Analisis Geospasial Interaktif:** Visualisasi data regional menggunakan peta koroplet (choropleth map) yang memungkinkan pengguna melihat distribusi spasial dari suatu indikator di seluruh negara ASEAN.
* **📊 Plot Data Dinamis:** Berbagai jenis grafik (plot garis, plot batang, plot sebar) yang dapat disesuaikan secara dinamis oleh pengguna melalui widget input seperti _slider_ tahun, _dropdown_ negara, dan pilihan indikator.
* **📈 Analisis Tren Waktu:** Kemampuan untuk memvisualisasikan data deret waktu (time-series) untuk melihat tren pertumbuhan atau penurunan suatu indikator selama periode waktu tertentu untuk satu atau beberapa negara.
* **📋 Tabel Data Responsif:** Penyajian data mentah dalam format tabel interaktif yang mendukung fitur pencarian, pengurutan (sorting), dan paginasi untuk memudahkan eksplorasi data tabular.
* **🔎 Perbandingan Antar Negara:** Fitur untuk memilih beberapa negara sekaligus guna melakukan analisis komparatif secara langsung pada grafik dan tabel.

---

## 🛠️ Arsitektur & Teknologi

Aplikasi ini dibangun sepenuhnya menggunakan bahasa pemrograman **R** dengan memanfaatkan ekosistem paket yang kaya untuk pengembangan web dan analisis data.

### Pustaka (Library) & Paket Utama yang Digunakan:

Aplikasi ini dibangun sepenuhnya menggunakan bahasa pemrograman **R** dengan memanfaatkan ekosistem paket yang kaya untuk pengembangan web dan analisis data.

| Paket            | Deskripsi Penggunaan dalam Proyek                                                                    |
| ---------------- | ---------------------------------------------------------------------------------------------------- |
| **shiny** | Kerangka kerja utama untuk membangun struktur aplikasi web interaktif (UI & Server).                 |
| **shinydashboard**| Digunakan untuk membuat tata letak _dashboard_ yang profesional.                                     |
| **shinyjs** | Menjalankan kode JavaScript kustom di dalam Shiny untuk interaktivitas tambahan.                     |
| **dplyr** & **tidyr** | Pustaka inti untuk manipulasi dan perapian data (membersihkan, memfilter, mentransformasi).       |
| **ggplot2** | Mesin utama untuk pembuatan visualisasi data yang estetis dan informatif.                           |
| **plotly** | Mengubah plot `ggplot2` menjadi interaktif dengan fitur _hover-text_, _zoom_, dan _pan_.            |
| **leaflet** & **sf** | Pustaka untuk membuat peta interaktif dan bekerja dengan data geospasial.                        |
| **DT** | Mengimplementasikan tabel data JavaScript yang interaktif di dalam aplikasi Shiny.                  |
| **haven** | Diperlukan untuk membaca dan mengimpor data dari format file statistik SPSS (`.sav`).                |
| **fontawesome** | Menyediakan akses mudah ke ikon dari Font Awesome untuk digunakan di UI.                         |
| **scales** | Mengatur skala dan format label pada sumbu grafik dan legenda agar mudah dibaca.                 |
| **GGally** | Ekstensi dari `ggplot2` untuk membuat plot matriks atau plot pasangan (pairs plot) dengan mudah.     |
| **car** | Menyediakan fungsi untuk analisis regresi dan diagnostik model statistik.                         |
| **cluster** & **factoextra**| Digunakan untuk melakukan analisis pengelompokan (cluster analysis) dan visualisasi hasilnya. |

---

## 📁 Struktur Proyek

Struktur direktori proyek diatur sebagai berikut untuk memastikan modularitas dan kemudahan pengelolaan:
` ` `
/Struktur Proyek
📦NEW1
 ┣ 📂rsconnect
 ┃ ┗ 📂shinyapps.io
 ┃ ┃ ┗ 📂padil
 ┃ ┃ ┃ ┗ 📜NEW1.dcf
 ┣ 📜.gitignore
 ┣ 📜.RData
 ┣ 📜.Rhistory
 ┣ 📜ASEAN.sav
 ┣ 📜asean_map.rds
 ┣ 📜finaldataasean.csv
 ┣ 📜global.R
 ┣ 📜readme.md
 ┣ 📜server.R
 ┗ 📜ui.R
 ` ` `

---

## 🚀 Panduan Instalasi & Penggunaan Lokal

Ikuti langkah-langkah di bawah ini untuk menjalankan aplikasi ini di lingkungan lokal Anda.

#### 1. Prasyarat
* **Git:** Terinstal di sistem Anda untuk melakukan kloning repositori.
* **R:** Versi 4.1.0 atau lebih baru.
* **RStudio:** Versi 2022.07 atau lebih baru direkomendasikan.

#### 2. Kloning Repositori
Buka Terminal atau Git Bash, lalu jalankan perintah berikut:
```bash
git clone [https://github.com/padil5551234/RshinyApp.git](https://github.com/padil5551234/RshinyApp.git)
cd NAMA_REPOSITORI_ANDA
```
### 3. Daftar semua paket yang dibutuhkan
```
install.packages(c(
  "shiny", "leaflet", "dplyr", "ggplot2", "plotly", "DT", "sf", 
  "shinyjs", "fontawesome", "scales", "tidyr", "GGally", "car", 
  "cluster", "factoextra", "haven", "shinydashboard"
))
```
### 4. Penyiapan data
Aplikasi ini memerlukan file data yang tidak disertakan di dalam repositori.
Buat sebuah folder baru bernama data di dalam direktori utama proyek.
Tempatkan file-file berikut ke dalam folder data tersebut:
- asean_map.rds
- ASEAN.sav

### 5. Menjalankan Aplikasi
Setelah semua paket terinstal dan data sudah disiapkan, buka file ui.R atau server.R di RStudio. 
Klik tombol "Run App" yang muncul di bagian atas editor untuk meluncurkan aplikasi.

# [**Lihat Demo Langsung di Sini!**](https://padil.shinyapps.io/NEW1/)

## 📊 Sumber Data
Data yang digunakan dalam proyek ini bersumber dari berbagai institusi dan platform data publik yang kredibel. Berikut adalah daftar sumber utama:
- Badan Pusat Statistik (BPS) Indonesia: Digunakan untuk mendapatkan data statistik spesifik terkait Indonesia. Kunjungi BPS
- The World Bank: Data mengenai curah hujan rata-rata (Average precipitation in depth). Kunjungi World Bank Data
- ASEANStats: Data Indikator Tujuan Pembangunan Berkelanjutan (SDG Indicators) untuk negara-negara ASEAN. Kunjungi ASEANStats
- EDGAR (The Emissions Database for Global Atmospheric Research): Sumber data emisi gas rumah kaca global. Kunjungi EDGAR
- Global Data Lab: Menyediakan data geospasial yang digunakan untuk pemetaan. Kunjungi Global Data Lab

## 📜 Lisensi
Proyek ini dilisensikan di bawah Lisensi MIT.
Lisensi ini mengizinkan siapa saja untuk menggunakan, menyalin,
memodifikasi, dan mendistribusikan kode ini untuk tujuan apa pun, 
baik komersial maupun non-komersial, selama pemberitahuan hak cipta 
dan lisensi asli disertakan dalam semua salinan atau bagian penting dari perangkat lunak.

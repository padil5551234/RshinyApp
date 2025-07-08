# ==========================================================================
# ui.R (LENGKAP & FINAL)
# ==========================================================================

ui <- fluidPage(
  useShinyjs(),
  tags$head(tags$style(HTML("
    body {font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;}
    .sidebar {
      background: #111;
      height: 100vh;
      padding: 20px;
      color: white;
      width: 200px;
      position: fixed;
      top: 0; left: 0;
      display: flex;
      flex-direction: column;
      font-weight: 600;
      z-index: 10000;
    }
    .sidebar .menu-item {
      padding: 10px 15px;
      cursor: pointer;
      border-radius: 8px;
      margin-bottom: 10px;
      font-size: 18px;
      color: white;
      transition: background-color 0.2s;
    }
    .sidebar .menu-item.active, .sidebar .menu-item:hover {
      background-color: #ff6600;
      color: white;
      text-decoration: none;
    }
    .header {
      position: fixed;
      top: 0; left: 200px; right: 0;
      height: 60px;
      background: linear-gradient(90deg, #ffbb33, #ff6600);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 25px;
      font-weight: 700;
      font-size: 22px;
      color: black;
      z-index: 9999;
    }
    .header .right {
      display: flex;
      align-items: center;
      gap: 20px;
      font-weight: 600;
      font-size: 16px;
    }
    .header .user-icon {
      border: 2px solid black;
      border-radius: 50%;
      width: 32px;
      height: 32px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      background: white;
      color: black;
    }
    .content {
      margin-left: 200px;
      margin-top: 60px;
      padding: 30px 40px;
      background: #f9f9f9;
      min-height: calc(100vh - 60px);
    }
    .overview-box {
      background: white;
      border-radius: 15px;
      padding: 25px;
      box-shadow: 0 0 8px rgba(0,0,0,0.1);
      margin-bottom: 20px;
      font-size: 18px;
      font-weight: 600;
      color: white;
      background: linear-gradient(135deg, #ff6b6b, #f06595);
    }
    .overview-box.asean {
        background: linear-gradient(135deg, #667eea, #764ba2);
    }
    .overview-box.indonesia {
        background: linear-gradient(135deg, #43e97b, #38f9d7);
    }
    #aseanMap {
      height: 600px;
      border-radius: 20px;
      box-shadow: 0 0 10px rgba(0,0,0,0.15);
    }
    .timeline-title{text-align:center;color:#444;margin-bottom:30px;font-weight:700}.timeline-container{position:relative;padding:20px 0;margin-left:20px;margin-bottom:30px}.timeline-container::before{content:'';position:absolute;left:10px;top:0;width:4px;height:100%;background:#ffc18c}.timeline-item{position:relative;margin-bottom:25px;padding-left:40px}.timeline-dot{content:'';position:absolute;left:10px;top:5px;width:16px;height:16px;border-radius:50%;background:#ff6600;border:3px solid #fff;transform:translateX(-50%);z-index:1}.timeline-content{background:white;padding:15px 20px;border-radius:10px;box-shadow:0 4px 12px rgba(0,0,0,.08)}.timeline-date{font-weight:bold;color:#ff6600;margin-bottom:8px;font-size:1.1em}.timeline-desc{color:#333;line-height:1.5}
  "))),
  
  div(class = "sidebar",
      actionLink("menu_overview", label = tagList(icon("clipboard"), "Gambaran"), class = "menu-item active"),
      actionLink("menu_peta", label = tagList(icon("map-marker-alt"), "Peta"), class = "menu-item"),
      actionLink("menu_grafik", label = tagList(icon("chart-bar"), "Grafik"), class = "menu-item"),
      actionLink("menu_unduh", label = tagList(icon("download"), "Unduh"), class = "menu-item"),
      actionLink("menu_video", label = tagList(icon("youtube"), "Video"), class = "menu-item"),
      actionLink("menu_explorer", label = tagList(icon("table"), "Penjelajah Data"), class = "menu-item"),
      actionLink("menu_statistik", label = tagList(icon("chart-line"), "Statistik Inferensial"), class = "menu-item")
  ),
  
  div(class = "header",
      div("INDEKS POLUSI UDARA"),
      div(class = "right",
          span("Bantuan"),
          div(class = "user-icon", icon("user")),
          span("Pengguna")
      )
  ),
  
  div(class = "content",
      tabsetPanel(id = "tabs", type = "hidden",
                  tabPanel("overview",
                           fluidRow(
                             column(4,
                                    h3("Gambaran Umum Data ASEAN", style = "color: #ff6600;"),
                                    div(class = "overview-box asean", textOutput("avg_rainfall_asean")),
                                    div(class = "overview-box asean", textOutput("avg_temperature_asean")),
                                    div(class = "overview-box asean", textOutput("avg_humidity_asean"))
                             ),
                             column(8,
                                    h3("Gambaran Umum Data Indonesia", style = "color: #3399ff;"),
                                    div(class = "overview-box indonesia", textOutput("avg_rainfall_indonesia")),
                                    div(class = "overview-box indonesia", textOutput("avg_temperature_indonesia")),
                                    div(class = "overview-box indonesia", textOutput("avg_humidity_indonesia"))
                             )
                           ),
                           hr(),
                           hr(),
                           h3("Linimasa Proyek Dashboard", class = "timeline-title"),
                           div(class = "timeline-container",
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Sabtu, 26 April 2025"),
                                       div(class = "timeline-desc", "Menentukan judul dan menetapkan locus studi berdasarkan data ASEAN.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Minggu, 27 April 2025"),
                                       div(class = "timeline-desc", "Melakukan pengumpulan dan eksplorasi awal terhadap data, termasuk identifikasi variabel-variabel penting.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Senin, 28 April 2025"),
                                       div(class = "timeline-desc", "Merancang konsep awal dashboard, termasuk pemetaan kebutuhan visualisasi.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Selasa, 29 April 2025"),
                                       div(class = "timeline-desc", "Menyusun laporan progress awal, yang memuat temuan awal dan gambaran desain dashboard.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Minggu ke-8"),
                                       div(class = "timeline-desc", "Mengolah data, termasuk pembersihan data, transformasi, dan normalisasi jika diperlukan.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Minggu ke-9"),
                                       div(class = "timeline-desc", "Melakukan analisis deskriptif seperti distribusi data, nilai tengah, dan deviasi.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Minggu ke-10"),
                                       div(class = "timeline-desc", "Membangun model statistik menggunakan analisis regresi dan ANOVA.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Minggu ke-11 hingga ke-12"),
                                       div(class = "timeline-desc", "Mengembangkan dashboard interaktif menggunakan R-Shiny dan mengintegrasikan hasil analisis.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Minggu ke-13"),
                                       div(class = "timeline-desc", "Menyusun laporan akhir yang mencakup latar belakang, metodologi, hasil, dan dokumentasi.")
                                   )
                               ),
                               div(class = "timeline-item",
                                   div(class = "timeline-dot"),
                                   div(class = "timeline-content",
                                       div(class = "timeline-date", "Minggu ke-14"),
                                       div(class = "timeline-desc", "Membuat video demonstrasi penggunaan dashboard untuk memudahkan pemahaman user.")
                                   )
                               )
                           )
                           # uiOutput("realtime_status_boxes") # Anda tidak memiliki output ini di server, jadi saya komentari untuk sementara
                  ),
                  
                  tabPanel("peta",
                           fluidRow(
                             column(3,
                                    selectInput("map_year", "Pilih Tahun:", choices = unique(all_data$year), selected = max(all_data$year)),
                                    selectInput("map_indicator", "Pilih Indikator Heatmap:", choices = indicators_for_selection, selected = "Suhu"),
                                    uiOutput("map_pollution_type_selector")
                             ),
                             column(9,
                                    leafletOutput("aseanMap", height = "70vh")
                             )
                           )
                  ),
                  tabPanel("grafik",
                           fluidRow(
                             column(3,
                                    selectInput("graph_country", "Pilih Negara:", choices = unique(all_data$country_name), selected = "Indonesia"),
                                    selectInput("graph_indicator", "Pilih Indikator:", choices = indicators_for_selection, selected = "Suhu"),
                                    uiOutput("pollution_type_selector"),
                                    sliderInput("graph_year", "Pilih Rentang Tahun:", min = min(all_data$year), max = max(all_data$year), value = c(min(all_data$year), max(all_data$year)), sep = "", step = 1),
                                    radioButtons("plot_type", "Pilih Jenis Grafik:",
                                                 choices = c("Grafik Garis" = "line", "Grafik Batang" = "bar"),
                                                 selected = "line")
                             ),
                             column(9,
                                    plotlyOutput("indicator_plot", height = "70vh")
                             )
                           )
                  ),
                  tabPanel("unduh",
                           fluidRow(
                             column(3,
                                    selectInput("download_country", "Pilih Negara:", choices = c("Semua", unique(all_data$country_name)), selected = "Semua", multiple = TRUE),
                                    selectInput("download_indicator", "Pilih Indikator:", choices = c("Semua", indicators_for_selection), selected = "Semua", multiple = TRUE),
                                    sliderInput("download_year", "Pilih Rentang Tahun:", min = min(all_data$year), max = max(all_data$year), value = c(min(all_data$year), max(all_data$year)), sep = "", step = 1),
                                    downloadButton("download_data", "Unduh Data", class = "btn btn-primary mt-3")
                             ),
                             column(9,
                                    DTOutput("table_download")
                             )
                           )
                  ),
                  tabPanel("video",
                           h3("Video Tutorial Penggunaan Dashboard"),
                           tags$iframe(
                             style="width:100%; height:500px;",
                             src = "https://www.youtube.com/embed/SKRN34E5w8Q?si=PeobPaIfU3jKACrb", # Placeholder
                             frameborder = "0",
                             allowfullscreen = TRUE
                           )
                  ),
                  tabPanel("explorer",
                           h2("Penjelajah Data"),
                           fluidRow(
                             column(3,
                                    h4("Pilih Dataset"),
                                    selectInput("explorer_dataset", "Dataset:", choices = c("Data Gabungan" = "all", "Data Polusi" = "polusi")),
                                    h4("Ringkasan Variabel"),
                                    uiOutput("explorer_variable_selector"),
                                    actionButton("run_summary", "Tampilkan Ringkasan", class = "btn-primary")
                             ),
                             column(9,
                                    h4("Tabel Data"),
                                    DTOutput("explorer_table"),
                                    hr(),
                                    h4("Ringkasan Statistik"),
                                    verbatimTextOutput("explorer_summary"),
                                    hr(),
                                    h4("Visualisasi Univariat"),
                                    plotOutput("explorer_plot")
                             )
                           )
                  ),
                  tabPanel("statistik",
                           h2("Analisis Statistik Inferensial"),
                           tabsetPanel(
                             type = "pills",
                             tabPanel("Regresi Linear Ganda",
                                      fluidRow(
                                        column(3,
                                               h4("Pengaturan Model"),
                                               selectInput("multi_y_var", "Variabel Dependen (Y):", choices = NULL),
                                               selectizeInput("multi_x_vars", "Variabel Independen (X):", choices = NULL, multiple = TRUE),
                                               actionButton("run_multi_regression", "Jalankan Regresi", class = "btn-primary")
                                        ),
                                        column(9,
                                               h4("Hasil Regresi Ganda"),
                                               verbatimTextOutput("multi_regression_summary"),
                                               hr(),
                                               h4("Diagnostik Model"),
                                               verbatimTextOutput("vif_summary"),
                                               plotOutput("residuals_plot"),
                                               hr(),
                                               h4("Interpretasi Hasil"),
                                               uiOutput("multi_regression_interpretation")
                                        )
                                      )
                             ),
                             tabPanel("ANOVA",
                                      fluidRow(
                                        column(3,
                                               h4("Pengaturan ANOVA"),
                                               selectInput("anova_num_var", "Variabel Numerik:", choices = NULL),
                                               selectInput("anova_cat_var", "Variabel Kategorik (Faktor):", choices = NULL),
                                               actionButton("run_anova", "Jalankan ANOVA", class = "btn-primary")
                                        ),
                                        column(9,
                                               h4("Hasil ANOVA"),
                                               verbatimTextOutput("anova_summary"),
                                               hr(),
                                               h4("Visualisasi Boxplot"),
                                               plotOutput("anova_boxplot"),
                                               hr(),
                                               h4("Uji Lanjutan (Post-Hoc) Tukey HSD"),
                                               verbatimTextOutput("anova_tukey"),
                                               hr(),
                                               h4("Interpretasi Hasil"),
                                               uiOutput("anova_interpretation")
                                        )
                                      )
                             ),
                             tabPanel("Matriks Korelasi",
                                      fluidRow(
                                        column(3,
                                               h4("Pengaturan Korelasi"),
                                               selectizeInput("corr_vars", "Pilih Variabel Numerik:", choices = NULL, multiple = TRUE),
                                               actionButton("run_correlation", "Buat Matriks Korelasi", class = "btn-primary")
                                        ),
                                        column(9,
                                               h4("Matriks Korelasi"),
                                               plotlyOutput("correlation_plot"),
                                               hr(),
                                               h4("Interpretasi Korelasi"),
                                               uiOutput("correlation_interpretation")
                                        )
                                      )
                             ),
                             tabPanel("Analisis Komponen Utama (PCA)",
                                      fluidRow(
                                        column(3,
                                               h4("Pengaturan PCA"),
                                               selectizeInput("pca_vars", "Pilih Variabel untuk PCA:", choices = NULL, multiple = TRUE),
                                               checkboxInput("pca_scale", "Skalakan Variabel", value = TRUE),
                                               actionButton("run_pca", "Jalankan PCA", class = "btn-primary")
                                        ),
                                        column(9,
                                               h4("Hasil PCA"),
                                               verbatimTextOutput("pca_summary"),
                                               hr(),
                                               h4("Visualisasi PCA"),
                                               plotOutput("pca_scree_plot"),
                                               plotOutput("pca_biplot"),
                                               hr(),
                                               h4("Interpretasi Hasil"),
                                               uiOutput("pca_interpretation")
                                        )
                                      )
                             ),
                             tabPanel("K-Means Clustering",
                                      fluidRow(
                                        column(3,
                                               h4("Pengaturan Clustering"),
                                               selectizeInput("kmeans_vars", "Pilih Variabel untuk Clustering:", choices = NULL, multiple = TRUE),
                                               numericInput("kmeans_k", "Jumlah Cluster (k):", value = 3, min = 2, max = 10),
                                               actionButton("run_kmeans", "Jalankan K-Means", class = "btn-primary")
                                        ),
                                        column(9,
                                               h4("Hasil Clustering"),
                                               plotOutput("kmeans_elbow_plot"),
                                               plotOutput("kmeans_cluster_plot"),
                                               hr(),
                                               h4("Ringkasan Cluster"),
                                               verbatimTextOutput("kmeans_summary"),
                                               hr(),
                                               h4("Interpretasi Hasil"),
                                               uiOutput("kmeans_interpretation")
                                        )
                                      )
                             )
                           )
                  )
      )
  )
)
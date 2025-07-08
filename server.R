# ==========================================================================
# server.R (LENGKAP & FINAL)
# ==========================================================================

server <- function(input, output, session) {
  
  # --- Navigasi ---
  observeEvent(input$menu_overview, {
    updateTabsetPanel(session, "tabs", selected = "overview")
    runjs("$('.sidebar .menu-item').removeClass('active'); $('#menu_overview').addClass('active');")
  })
  observeEvent(input$menu_peta, {
    updateTabsetPanel(session, "tabs", selected = "peta")
    runjs("$('.sidebar .menu-item').removeClass('active'); $('#menu_peta').addClass('active');")
  })
  observeEvent(input$menu_grafik, {
    updateTabsetPanel(session, "tabs", selected = "grafik")
    runjs("$('.sidebar .menu-item').removeClass('active'); $('#menu_grafik').addClass('active');")
  })
  observeEvent(input$menu_unduh, {
    updateTabsetPanel(session, "tabs", selected = "unduh")
    runjs("$('.sidebar .menu-item').removeClass('active'); $('#menu_unduh').addClass('active');")
  })
  observeEvent(input$menu_video, {
    updateTabsetPanel(session, "tabs", selected = "video")
    runjs("$('.sidebar .menu-item').removeClass('active'); $('#menu_video').addClass('active');")
  })
  observeEvent(input$menu_statistik, {
    updateTabsetPanel(session, "tabs", selected = "statistik")
    runjs("$('.sidebar .menu-item').removeClass('active'); $('#menu_statistik').addClass('active');")
  })
  observeEvent(input$menu_explorer, {
    updateTabsetPanel(session, "tabs", selected = "explorer")
    runjs("$('.sidebar .menu-item').removeClass('active'); $('#menu_explorer').addClass('active');")
  })
  
  # --- Metrik Gambaran ---
  output$avg_rainfall_asean <- renderText({
    avg <- mean(all_data$value[all_data$Indicator == "Curah_Hujan"], na.rm = TRUE)
    paste("Rata-rata Curah Hujan ASEAN (mm):", round(avg, 1))
  })
  output$avg_temperature_asean <- renderText({
    avg <- mean(all_data$value[all_data$Indicator == "Suhu"], na.rm = TRUE)
    paste("Rata-rata Suhu ASEAN (°C):", round(avg, 1))
  })
  output$avg_humidity_asean <- renderText({
    avg <- mean(all_data$value[all_data$Indicator == "Kelembapan"], na.rm = TRUE)
    paste("Rata-rata Kelembapan ASEAN (%):", round(avg, 1))
  })
  output$avg_rainfall_indonesia <- renderText({
    avg <- all_data %>%
      filter(country_name == "Indonesia", Indicator == "Curah_Hujan") %>%
      pull(value) %>%
      mean(na.rm = TRUE)
    paste("Rata-rata Curah Hujan Indonesia (mm):", round(avg, 1))
  })
  output$avg_temperature_indonesia <- renderText({
    avg <- all_data %>%
      filter(country_name == "Indonesia", Indicator == "Suhu") %>%
      pull(value) %>%
      mean(na.rm = TRUE)
    paste("Rata-rata Suhu Indonesia (°C):", round(avg, 1))
  })
  output$avg_humidity_indonesia <- renderText({
    avg <- all_data %>%
      filter(country_name == "Indonesia", Indicator == "Kelembapan") %>%
      pull(value) %>%
      mean(na.rm = TRUE)
    paste("Rata-rata Kelembapan Indonesia (%):", round(avg, 1))
  })
  
  # --- Logika Peta ---
  output$aseanMap <- renderLeaflet({
    leaflet(asean_map) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 113, lat = -2, zoom = 4)
  })
  
  output$map_pollution_type_selector <- renderUI({
    if (input$map_indicator == "Polusi") {
      selectInput("map_pollution_type", "Pilih Jenis Polusi:", choices = pollution_types)
    }
  })
  
  observe({
    req(input$map_year, input$map_indicator)
    if (input$map_indicator == "Polusi") {
      req(input$map_pollution_type)
    }
    
    map_filter_data <- all_data %>%
      filter(year == input$map_year)
    
    if (input$map_indicator == "Polusi") {
      map_filter_data <- map_filter_data %>%
        filter(Indicator == "Polusi", PollutionType == input$map_pollution_type)
      current_indicator_name <- input$map_pollution_type
    } else {
      map_filter_data <- map_filter_data %>%
        filter(Indicator == input$map_indicator)
      current_indicator_name <- input$map_indicator
    }
    
    map_data <- asean_map %>%
      left_join(map_filter_data, by = c("iso_a2" = "country_iso"))
    
    if (nrow(map_filter_data) == 0 || all(is.na(map_data$value))) {
      leafletProxy("aseanMap") %>%
        clearShapes() %>%
        clearControls() %>%
        addPolygons(data = asean_map,
                    fillColor = "#cccccc", weight = 2, color = "#444444",
                    fillOpacity = 0.5, layerId = ~iso_a2, label = ~name,
                    highlightOptions = highlightOptions(weight = 4, color = "black", bringToFront = TRUE))
      return()
    }
    
    units_map <- c("Suhu" = "°C", "Curah_Hujan" = "mm", "Kelembapan" = "%", "CO2" = "kt", "CH4" = "kt", "N2O" = "kt")
    indicator_unit <- units_map[current_indicator_name]
    
    pal <- colorBin(
      palette = "YlOrRd",
      domain = map_data$value,
      bins = 5,
      pretty = TRUE,
      na.color = "transparent"
    )
    
    legend_title <- paste0(current_indicator_name, " (", input$map_year, ")")
    
    leafletProxy("aseanMap", data = map_data) %>%
      clearShapes() %>%
      clearControls() %>%
      addPolygons(
        fillColor = ~pal(value),
        weight = 2,
        color = "#444444",
        fillOpacity = 0.7,
        layerId = ~iso_a2,
        label = ~paste0(name, "<br>", current_indicator_name, ": ", round(value, 1)),
        highlightOptions = highlightOptions(weight = 4, color = "black", bringToFront = TRUE)
      ) %>%
      addLegend(
        pal = pal,
        values = ~value,
        opacity = 0.9,
        title = legend_title,
        position = "bottomright",
        labFormat = labelFormat(suffix = paste0(" ", indicator_unit)),
        na.label = "Data Tidak Tersedia"
      )
  })
  
  observeEvent(input$aseanMap_shape_click, {
    click <- input$aseanMap_shape_click
    req(click$id, input$map_year)
    
    info_data <- all_data %>%
      filter(country_iso == click$id, year == input$map_year) %>%
      select(Indicator, value) %>%
      tidyr::drop_na(value)
    
    country_name <- unique(all_data$country_name[all_data$country_iso == click$id])
    
    if(nrow(info_data) > 0){
      popup_content_list <- c(
        paste0("<b>", country_name, " (", input$map_year, ")</b>")
      )
      
      units <- list("Curah_Hujan" = " mm", "Suhu" = " °C", "Kelembapan" = " %")
      display_indicators <- c("Suhu", "Curah_Hujan", "Kelembapan")
      
      for (ind in display_indicators) {
        val <- info_data$value[info_data$Indicator == ind]
        if (length(val) > 0 && !is.na(val)) {
          formatted_val <- round(val, 1)
          popup_content_list <- c(popup_content_list, paste0(ind, ": <b>", formatted_val, units[[ind]], "</b>"))
        }
      }
      popup_text <- paste(popup_content_list, collapse = "<br/>")
      
    } else {
      popup_text <- "Data tidak tersedia untuk tahun ini."
    }
    
    leafletProxy("aseanMap") %>%
      clearPopups() %>%
      addPopups(lng = click$lng, lat = click$lat, popup = HTML(popup_text))
  })
  
  # --- Logika Grafik dan Unduh ---
  output$pollution_type_selector <- renderUI({
    if (input$graph_indicator == "Polusi") {
      selectInput("pollution_type", "Pilih Jenis Polusi:",
                  choices = pollution_types,
                  selected = pollution_types[1])
    }
  })
  
  output$download_pollution_type_selector <- renderUI({
    if (input$download_indicator == "Polusi") {
      selectInput("download_pollution_type", "Pilih Jenis Polusi:",
                  choices = pollution_types,
                  selected = pollution_types[1])
    }
  })
  
  filtered_graph_data <- reactive({
    req(input$graph_indicator, input$graph_country, input$graph_year)
    df <- all_data %>%
      filter(country_name == input$graph_country,
             year >= input$graph_year[1], year <= input$graph_year[2])
    
    if (input$graph_indicator == "Polusi") {
      req(input$pollution_type)
      df <- df %>% filter(Indicator == "Polusi", PollutionType == input$pollution_type)
    } else {
      df <- df %>% filter(Indicator == input$graph_indicator)
    }
    df %>% arrange(year)
  })
  
  output$indicator_plot <- renderPlotly({
    df <- filtered_graph_data()
    req(nrow(df) > 0)
    
    current_indicator_name_graph <- if (input$graph_indicator == "Polusi") {
      req(input$pollution_type)
      input$pollution_type
    } else {
      input$graph_indicator
    }
    
    p <- ggplot(df, aes(x = year, y = value)) +
      labs(title = paste("Grafik", current_indicator_name_graph, "di", input$graph_country),
           x = "Tahun", y = current_indicator_name_graph) +
      theme_minimal()
    if (input$plot_type == "line") {
      p <- p + geom_line(color = "#ff6600", size = 1.5) +
        geom_point(color = "#ffcc66", size = 3)
    } else if (input$plot_type == "bar") {
      p <- p + geom_col(fill = "#ff6600")
    }
    ggplotly(p)
  })
  
  filtered_download_data <- reactive({
    # Logika untuk filter unduhan sedikit berbeda, menggunakan "Semua"
    df <- all_data
    
    if (!("Semua" %in% input$download_country)) {
      df <- df %>% filter(country_name %in% input$download_country)
    }
    
    if (!("Semua" %in% input$download_indicator)) {
      df <- df %>% filter(Indicator %in% input$download_indicator)
    }
    
    df <- df %>%
      filter(year >= input$download_year[1], year <= input$download_year[2])
    
    return(df)
  })
  
  output$table_download <- renderDT({
    datatable(filtered_download_data(), options = list(pageLength = 10, scrollX = TRUE))
  })
  
  output$download_data <- downloadHandler(
    filename = function() {
      paste0("data_asean_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(filtered_download_data(), file, row.names = FALSE)
    }
  )
  
  # --- Logika Penjelajah Data & Statistik ---
  explorer_selected_data <- reactive({
    switch(input$explorer_dataset,
           "all" = all_data,
           "polusi" = all_data %>% filter(Indicator == "Polusi"))
  })
  
  output$explorer_variable_selector <- renderUI({
    df <- explorer_selected_data()
    req(df)
    selectInput("explorer_variable", "Pilih Variabel:", choices = names(df))
  })
  
  output$explorer_table <- renderDT({
    df <- explorer_selected_data()
    req(df)
    datatable(df, options = list(pageLength = 5, scrollX = TRUE))
  })
  
  explorer_summary_output <- eventReactive(input$run_summary, {
    df <- explorer_selected_data()
    variable <- input$explorer_variable
    req(df, variable)
    summary(df[[variable]])
  })
  
  output$explorer_summary <- renderPrint({
    explorer_summary_output()
  })
  
  output$explorer_plot <- renderPlot({
    input$run_summary
    isolate({
      df <- explorer_selected_data()
      variable <- input$explorer_variable
      req(df, variable)
      if (is.numeric(df[[variable]])) {
        ggplot(df, aes_string(x = variable)) +
          geom_histogram(aes(y = ..density..), bins = 30, fill = "#667eea", color = "white") +
          geom_density(alpha = .2, fill = "#f06595") +
          labs(title = paste("Distribusi", variable), x = variable, y = "Kepadatan") +
          theme_minimal()
      } else {
        ggplot(df, aes_string(x = variable)) +
          geom_bar(fill = "#43e97b") +
          labs(title = paste("Frekuensi Kategori untuk", variable), x = variable, y = "Jumlah") +
          theme_minimal() +
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
      }
    })
  })
  
  stat_data <- reactive({
    data_to_pivot <- all_data %>%
      mutate(
        PollutionType = ifelse(is.na(PollutionType) | PollutionType == "", "NA", PollutionType),
        indicator_name = ifelse(Indicator == "Polusi", PollutionType, Indicator)
      ) %>%
      distinct(country_name, year, indicator_name, .keep_all = TRUE)
    pivoted_data <- data_to_pivot %>%
      pivot_wider(
        id_cols = c(country_name, year),
        names_from = indicator_name,
        values_from = value
      )
    pivoted_data %>%
      select(where(is.numeric)) %>%
      na.omit()
  })
  
  observe({
    df_wide <- stat_data()
    req(df_wide)
    numeric_cols <- names(df_wide)
    updateSelectInput(session, "multi_y_var", choices = numeric_cols, selected = numeric_cols[1])
    updateSelectizeInput(session, "multi_x_vars", choices = numeric_cols, selected = if(length(numeric_cols) > 2) numeric_cols[2:3] else if(length(numeric_cols) > 1) numeric_cols[2] else NULL)
    updateSelectInput(session, "anova_num_var", choices = "value", selected = "value")
    updateSelectInput(session, "anova_cat_var", choices = c("country_name", "Indicator"), selected = "country_name")
    updateSelectizeInput(session, "corr_vars", choices = numeric_cols, selected = numeric_cols[1:min(4, length(numeric_cols))])
    updateSelectizeInput(session, "pca_vars", choices = numeric_cols, selected = numeric_cols[1:min(5, length(numeric_cols))])
    updateSelectizeInput(session, "kmeans_vars", choices = numeric_cols, selected = numeric_cols[1:min(2, length(numeric_cols))])
  })
  
  multi_regression_model <- eventReactive(input$run_multi_regression, {
    req(input$multi_y_var, input$multi_x_vars, length(input$multi_x_vars) > 0)
    df <- stat_data()
    formula_str <- paste(input$multi_y_var, "~", paste(input$multi_x_vars, collapse = " + "))
    formula <- as.formula(formula_str)
    lm(formula, data = df)
  })
  
  output$multi_regression_summary <- renderPrint({
    summary(multi_regression_model())
  })
  
  output$vif_summary <- renderPrint({
    model <- multi_regression_model()
    if (length(input$multi_x_vars) > 1) {
      vif_values <- car::vif(model)
      cat("Faktor Inflasi Varians (VIF):\n")
      print(vif_values)
      cat("\n(VIF > 5 atau 10 dapat mengindikasikan multikolinearitas)\n")
    } else {
      cat("VIF tidak dihitung untuk satu variabel independen.")
    }
  })
  
  output$residuals_plot <- renderPlot({
    model <- multi_regression_model()
    par(mfrow = c(2, 2))
    plot(model)
    par(mfrow = c(1, 1))
  })
  
  output$multi_regression_interpretation <- renderUI({
    model <- multi_regression_model()
    req(model)
    model_summary <- summary(model)
    adj_r_squared <- model_summary$adj.r.squared
    f_stat <- model_summary$fstatistic
    p_val_f <- pf(f_stat[1], f_stat[2], f_stat[3], lower.tail = FALSE)
    interp <- paste0(
      "<h4>Interpretasi</h4>",
      "<p><b>R-kuadrat yang Disesuaikan:</b> ", round(adj_r_squared, 3), ". Ini menunjukkan bahwa sekitar <b>", round(adj_r_squared * 100, 1), "%</b> dari variabilitas dalam '",
      input$multi_y_var, "' dapat dijelaskan oleh variabel independen yang dipilih.</p>",
      "<p><b>Statistik-F:</b> Model keseluruhan adalah ",
      if (p_val_f < 0.05) "<b>signifikan secara statistik</b>" else "<b>tidak signifikan secara statistik</b>",
      " (nilai-p = ", format.pval(p_val_f, digits = 3), ").</p>",
      "<h5>Interpretasi Koefisien:</h5><ul>"
    )
    coefs <- model_summary$coefficients
    for (i in 2:nrow(coefs)) {
      var_name <- rownames(coefs)[i]
      estimate <- round(coefs[i, 1], 3)
      p_val <- coefs[i, 4]
      interp <- paste0(interp, "<li><b>", var_name, ":</b> Kenaikan satu unit pada '", var_name,
                       "' berasosiasi dengan <b>", estimate, "</b> unit ", if(estimate > 0) "kenaikan" else "penurunan", " pada '", input$multi_y_var,
                       "', dengan variabel lain dianggap konstan. Variabel ini ",
                       if (p_val < 0.05) "<b>signifikan secara statistik</b>" else "<b>tidak signifikan secara statistik</b>",
                       " (p = ", format.pval(p_val, digits = 3), ").</li>")
    }
    interp <- paste0(interp, "</ul>")
    HTML(interp)
  })
  
  anova_model <- eventReactive(input$run_anova, {
    req(input$anova_num_var, input$anova_cat_var)
    formula <- as.formula(paste(input$anova_num_var, "~", input$anova_cat_var))
    aov(formula, data = all_data)
  })
  
  output$anova_summary <- renderPrint({
    summary(anova_model())
  })
  
  output$anova_tukey <- renderPrint({
    model <- anova_model()
    p_value <- summary(model)[[1]][["Pr(>F)"]][1]
    if (p_value < 0.05) {
      TukeyHSD(model)
    } else {
      "Uji post-hoc tidak dilakukan karena ANOVA keseluruhan tidak signifikan."
    }
  })
  
  output$anova_boxplot <- renderPlot({
    req(input$anova_num_var, input$anova_cat_var)
    ggplot(all_data, aes_string(x = input$anova_cat_var, y = input$anova_num_var, fill = input$anova_cat_var)) +
      geom_boxplot(alpha = 0.7) +
      geom_jitter(width = 0.1, alpha = 0.3) +
      labs(title = paste("Boxplot dari", input$anova_num_var, "berdasarkan", input$anova_cat_var),
           x = input$anova_cat_var, y = input$anova_num_var) +
      theme_minimal(base_size = 14) +
      theme(legend.position = "none")
  })
  
  output$anova_interpretation <- renderUI({
    req(anova_model())
    p_value <- summary(anova_model())[[1]][["Pr(>F)"]][1]
    interp <- paste0(
      "<h4>Interpretasi</h4>",
      "<p>ANOVA menguji apakah ada perbedaan rata-rata yang signifikan dari '", input$anova_num_var, "' di antara kelompok '", input$anova_cat_var, "' yang berbeda.</p>",
      "<p>Nilai-p uji-F adalah <b>", format.pval(p_value, digits = 3), "</b>. ",
      if (p_value < 0.05) {
        "Nilai ini kurang dari 0,05, yang menunjukkan <b>bukti kuat</b> adanya perbedaan signifikan antara setidaknya dua kelompok. Lihat hasil Tukey HSD untuk mengetahui kelompok spesifik mana yang berbeda."
      } else {
        "Nilai ini lebih besar dari 0,05, yang menunjukkan <b>tidak ada bukti yang cukup</b> untuk menyimpulkan perbedaan rata-rata yang signifikan di antara kelompok-kelompok."
      }
    )
    HTML(interp)
  })
  
  correlation_data <- eventReactive(input$run_correlation, {
    req(input$corr_vars, length(input$corr_vars) > 1)
    stat_data() %>%
      select(all_of(input$corr_vars)) %>%
      na.omit()
  })
  
  output$correlation_plot <- renderPlotly({
    df <- correlation_data()
    req(ncol(df) > 1)
    plot_ly(
      x = colnames(cor(df)), y = colnames(cor(df)),
      z = round(cor(df), 2), type = "heatmap",
      colorscale = "Viridis", zmin = -1, zmax = 1
    ) %>% layout(title = "Heatmap Korelasi Interaktif")
  })
  
  output$correlation_interpretation <- renderUI({
    req(correlation_data())
    df <- correlation_data()
    req(ncol(df) > 1)
    cor_matrix <- cor(df)
    diag(cor_matrix) <- 0
    max_cor <- max(cor_matrix, na.rm = TRUE)
    max_cor_indices <- which(cor_matrix == max_cor, arr.ind = TRUE)
    min_cor <- min(cor_matrix, na.rm = TRUE)
    min_cor_indices <- which(cor_matrix == min_cor, arr.ind = TRUE)
    interp <- paste0(
      "<h4>Interpretasi</h4>",
      "<p>Matriks menunjukkan koefisien korelasi Pearson. Nilai mendekati 1 menunjukkan korelasi positif yang kuat, mendekati -1 menunjukkan korelasi negatif yang kuat, dan mendekati 0 menunjukkan sedikit atau tidak ada hubungan linear.</p>",
      "<ul><li><b>Korelasi Positif Terkuat:</b> Antara <b>", rownames(cor_matrix)[max_cor_indices[1, 1]], "</b> dan <b>", colnames(cor_matrix)[max_cor_indices[1, 2]], "</b> (r = <b>", round(max_cor, 2), "</b>).</li>",
      "<li><b>Korelasi Negatif Terkuat:</b> Antara <b>", rownames(cor_matrix)[min_cor_indices[1, 1]], "</b> dan <b>", colnames(cor_matrix)[min_cor_indices[1, 2]], "</b> (r = <b>", round(min_cor, 2), "</b>).</li></ul>"
    )
    HTML(interp)
  })
  
  pca_results <- eventReactive(input$run_pca, {
    req(input$pca_vars, length(input$pca_vars) > 1)
    df <- stat_data() %>%
      select(all_of(input$pca_vars)) %>%
      na.omit()
    prcomp(df, scale. = input$pca_scale)
  })
  
  output$pca_summary <- renderPrint({
    summary(pca_results())
  })
  
  output$pca_scree_plot <- renderPlot({
    fviz_eig(pca_results(), addlabels = TRUE, ylim = c(0, 50)) +
      labs(title = "Scree Plot", x = "Komponen Utama", y = "% Varians yang Dijelaskan") +
      theme_minimal(base_size = 14)
  })
  
  output$pca_biplot <- renderPlot({
    fviz_pca_biplot(pca_results(), repel = TRUE, col.var = "#2c3e50", col.ind = "#e74c3c") +
      theme_minimal(base_size = 14)
  })
  
  output$pca_interpretation <- renderUI({
    req(pca_results())
    summary_pca <- summary(pca_results())
    prop_var_pc1 <- round(summary_pca$importance[2, 1] * 100, 1)
    prop_var_pc2 <- round(summary_pca$importance[2, 2] * 100, 1)
    HTML(paste0(
      "<h4>Interpretasi</h4>",
      "<p>PCA mengurangi dimensionalitas data dengan membuat komponen utama yang tidak berkorelasi.</p>",
      "<ul><li><b>PC1:</b> Menjelaskan <b>", prop_var_pc1, "%</b> dari total varians.</li>",
      "<li><b>PC2:</b> Menjelaskan <b>", prop_var_pc2, "%</b> dari total varians.</li>",
      "<li><b>Total Varians:</b> Dua komponen pertama menjelaskan <b>", prop_var_pc1 + prop_var_pc2, "%</b> dari varians.</li></ul>",
      "<p><b>Scree Plot:</b> Membantu memutuskan berapa banyak komponen yang akan dipertahankan. 'Siku' (elbow) seringkali merupakan indikator yang baik.</p>",
      "<p><b>Biplot:</b> Menunjukkan observasi (titik merah) dan variabel asli (panah) dalam ruang PC. Panah yang berdekatan menunjukkan variabel yang berkorelasi positif.</p>"
    ))
  })
  
  kmeans_data <- reactive({
    req(input$kmeans_vars, length(input$kmeans_vars) > 1)
    stat_data() %>%
      select(all_of(input$kmeans_vars)) %>%
      na.omit() %>%
      scale()
  })
  
  kmeans_results <- eventReactive(input$run_kmeans, {
    req(input$kmeans_k)
    set.seed(123)
    kmeans(kmeans_data(), centers = input$kmeans_k, nstart = 25)
  })
  
  output$kmeans_elbow_plot <- renderPlot({
    fviz_nbclust(kmeans_data(), kmeans, method = "wss") +
      labs(subtitle = "Metode Siku (Elbow Method)") +
      theme_minimal(base_size = 14)
  })
  
  output$kmeans_cluster_plot <- renderPlot({
    fviz_cluster(kmeans_results(), data = kmeans_data(),
                 palette = "jco", geom = "point",
                 ellipse.type = "convex", ggtheme = theme_minimal())
  })
  
  output$kmeans_summary <- renderPrint({
    res <- kmeans_results()
    cat("Ukuran Cluster:\n")
    print(res$size)
    cat("\n\nPusat Cluster (Nilai rata-rata untuk data yang diskalakan):\n")
    print(res$centers)
  })
  
  output$kmeans_interpretation <- renderUI({
    req(kmeans_results())
    HTML(paste0(
      "<h4>Interpretasi</h4>",
      "<p>K-Means mempartisi observasi menjadi <b>", input$kmeans_k, "</b> cluster.</p>",
      "<p><b>Plot Siku:</b> Membantu menemukan jumlah cluster (k) yang optimal. 'Siku' menunjukkan di mana penambahan cluster lebih lanjut memberikan hasil yang semakin berkurang.</p>",
      "<p><b>Plot Cluster:</b> Secara visual menunjukkan partisi data. Setiap titik adalah observasi, diwarnai berdasarkan cluster yang ditetapkan.</p>",
      "<p><b>Ringkasan Cluster:</b> Tabel menunjukkan jumlah observasi per cluster dan nilai rata-rata untuk setiap variabel (yang telah diskalakan) di dalam sebuah cluster. Ini membantu dalam membuat profil cluster.</p>"
    ))
  })
}
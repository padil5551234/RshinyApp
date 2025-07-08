# ==========================================================================
# global.R (LENGKAP & FINAL)
# ==========================================================================

# Memuat semua library yang dibutuhkan (rnaturalearth sudah tidak diperlukan di sini)
library(shiny)
library(leaflet)
library(dplyr)
library(ggplot2)
library(plotly)
library(DT)
library(sf)
library(shinyjs)
library(fontawesome)
library(scales)
library(tidyr)
library(GGally)
library(car)
library(cluster)
library(factoextra)
library(haven)

# ==========================================================================
# Impor dan Transformasi Data
# ==========================================================================

# Membaca file data SPSS (.sav).
all_data_raw <- read_sav("ASEAN.sav")

# Mengubah data dari format "lebar" ke "panjang" (tidy)
all_data <- all_data_raw %>%
  pivot_longer(
    cols = -c(country_iso, country_name, year),
    names_to = "Metric",
    values_to = "value"
  ) %>%
  mutate(value = as.numeric(value)) %>%
  mutate(
    Indicator = case_when(
      grepl("CO2|CH4|N2O", Metric) ~ "Polusi",
      TRUE ~ Metric
    ),
    PollutionType = ifelse(Indicator == "Polusi", Metric, NA_character_)
  ) %>%
  select(country_iso, country_name, year, Indicator, PollutionType, value) %>%
  drop_na(value)

# Memperbaiki kode negara Laos agar sesuai standar peta (iso_a2)
all_data <- all_data %>%
  mutate(country_iso = if_else(country_iso == "LAO", "LA", country_iso))

# Membuat objek-objek yang akan digunakan di UI dan Server
all_indicators <- unique(all_data$Indicator)
indicators_for_selection <- all_indicators
pollution_types <- unique(na.omit(all_data$PollutionType))

# Memuat data peta yang sudah diproses dari file .rds
# Ini adalah alternatif dari pemanggilan ne_countries() agar tidak error saat deploy
asean_map <- readRDS("asean_map.rds")
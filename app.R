.libPaths(c(
  normalizePath("r_libs2", mustWork = FALSE),
  normalizePath("r_libs", mustWork = FALSE),
  .libPaths()
))

library(shiny)
library(tidyverse)
library(DT)

# Combined mortality sources kept for "Both" support and backward compatibility.
combined_mortality_sources <- tribble(
  ~country, ~cause, ~sex, ~file, ~format,
  "Germany", "Neoplasms", "Both", "germany_cancer_clean.csv", "clean",
  "Germany", "Cardiovascular Diseases", "Both", "germany_cvs_clean.csv", "clean",
  "Germany", "Tobacco smoking", "Both", "IHME-GBD_2023_DATA_GER_TS.csv", "ihme_both",
  "United Kingdom", "Neoplasms", "Both", "uk_cancer_clean.csv", "clean",
  "United Kingdom", "Cardiovascular Diseases", "Both", "uk_cvs_clean.csv", "clean",
  "United Kingdom", "Tobacco smoking", "Both", "IHME-GBD_2023_DATA_UK_TS.csv", "ihme_both",
  "India", "Neoplasms", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-INC/IHME-GBD_2023_DATA-IN_C.csv", "ihme_both",
  "India", "Cardiovascular Diseases", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-INCV/IHME-GBD_2023_DATA-IN_CV.csv", "ihme_both",
  "India", "Tobacco smoking", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-INT/IHME-GBD_2023_DATA-IN_T.csv", "ihme_both",
  "United States", "Neoplasms", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-USC/IHME-GBD_2023_DATA-US_C.csv", "ihme_both",
  "United States", "Cardiovascular Diseases", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-USCV/IHME-GBD_2023_DATA-US_CV.csv", "ihme_both",
  "United States", "Tobacco smoking", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-UST/IHME-GBD_2023_DATA-US_T.csv", "ihme_both",
  "Japan", "Neoplasms", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-JPC/IHME-GBD_2023_DATA-JP_C.csv", "ihme_both",
  "Japan", "Cardiovascular Diseases", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-JPCV/IHME-GBD_2023_DATA-JP_CV.csv", "ihme_both",
  "Japan", "Tobacco smoking", "Both", "C:/Users/Neha/Downloads/IHME-GBD_2023_DATA-JPT/IHME-GBD_2023_DATA-JP_T.csv", "ihme_both"
)

# Sex-specific mortality sources introduced for donut and Male/Female/Both chart mode.
sex_mortality_sources <- tribble(
  ~country, ~cause, ~sex, ~file,
  "Germany", "Neoplasms", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-GER-M/IHME-GBD_2023_DATA-GER_N_M.csv",
  "Germany", "Neoplasms", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-GER-F/IHME-GBD_2023_DATA-GER_N_F.csv",
  "Germany", "Cardiovascular Diseases", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-45e22f78-1/IHME-GBD_2023_DATA-GER_CV_M.csv",
  "Germany", "Cardiovascular Diseases", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-8d97f3a9-1/IHME-GBD_2023_DATA-GER_CV_F.csv",
  "Germany", "Tobacco smoking", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-0ed8d548-1/IHME-GBD_2023_DATA-GER_T_M.csv",
  "Germany", "Tobacco smoking", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-6844b2a7-1/IHME-GBD_2023_DATA-GER_T_F.csv",
  "India", "Neoplasms", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-ee73d786-1/IHME-GBD_2023_DATA-IN_N_M.csv",
  "India", "Neoplasms", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-aebf8d2c-1/IHME-GBD_2023_DATA-IN_N_F.csv",
  "India", "Cardiovascular Diseases", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-3b2921ab-1/IHME-GBD_2023_DATA-IND_CV_M.csv",
  "India", "Cardiovascular Diseases", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-374fa478-1/IHME-GBD_2023_DATA-IN_CV_F.csv",
  "India", "Tobacco smoking", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-2f2975b1-1/IHME-GBD_2023_DATA-IND_T_M.csv",
  "India", "Tobacco smoking", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-60a61430-1/IHME-GBD_2023_DATA-IND_T_F.csv",
  "Japan", "Neoplasms", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-f4986204-1/IHME-GBD_2023_DATA-J_N_M.csv",
  "Japan", "Neoplasms", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-93768a0a-1/IHME-GBD_2023_DATA-b5823d0d-1/IHME-GBD_2023_DATA-J_F_N.csv",
  "Japan", "Cardiovascular Diseases", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-9acdd463-1/IHME-GBD_2023_DATA-J_CV_M.csv",
  "Japan", "Cardiovascular Diseases", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-8a23941d-1/IHME-GBD_2023_DATA-J_CV_F.csv",
  "Japan", "Tobacco smoking", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-74da1a20-1/IHME-GBD_2023_DATA-J_T_M.csv",
  "Japan", "Tobacco smoking", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-173a12a7-1/IHME-GBD_2023_DATA-J_T_F.csv",
  "United States", "Neoplasms", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-b8785963-1/IHME-GBD_2023_DATA-US_N_M.csv",
  "United States", "Neoplasms", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-051deef8-1/IHME-GBD_2023_DATA-US_N_F.csv",
  "United States", "Cardiovascular Diseases", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-c79b04a7-1/IHME-GBD_2023_DATA-US_CV_M.csv",
  "United States", "Cardiovascular Diseases", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-1498c68a-1/IHME-GBD_2023_DATA-US_CV_F.csv",
  "United States", "Tobacco smoking", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-cf79121a-1/IHME-GBD_2023_DATA-US_T_M.csv",
  "United States", "Tobacco smoking", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-d1f838c3-1/IHME-GBD_2023_DATA-US_T_F.csv",
  "United Kingdom", "Cardiovascular Diseases", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-802e2425-1/IHME-GBD_2023_DATA-UK_CV_M.csv",
  "United Kingdom", "Cardiovascular Diseases", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-58c7ace6-1/IHME-GBD_2023_DATA-UK_CV_F.csv",
  "United Kingdom", "Tobacco smoking", "Male", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-93768a0a-1/IHME-GBD_2023_DATA-UK_T_M.csv",
  "United Kingdom", "Tobacco smoking", "Female", "C:/Users/Neha/OneDrive/Documents/codex/IHME-GBD_2023_DATA-be330f99-1/IHME-GBD_2023_DATA-UK_T_F.csv"
)

cause_choices <- c("Neoplasms", "Cardiovascular Diseases", "Tobacco smoking")

normalize_country <- function(x) {
  case_when(
    str_squish(x) == "US" ~ "United States",
    str_squish(x) == "United States of America" ~ "United States",
    TRUE ~ str_squish(x)
  )
}

normalize_cause <- function(x) {
  case_when(
    str_to_lower(str_squish(x)) == "tobacco smoking" ~ "Tobacco smoking",
    TRUE ~ str_squish(x)
  )
}

standardize_sex <- function(x) {
  case_when(
    str_to_lower(str_squish(x)) == "male" ~ "Male",
    str_to_lower(str_squish(x)) == "female" ~ "Female",
    str_to_lower(str_squish(x)) == "both" ~ "Both",
    TRUE ~ str_squish(x)
  )
}

country_badge <- function(country) {
  case_when(
    country == "Germany" ~ "DE",
    country == "United Kingdom" ~ "UK",
    country == "India" ~ "IN",
    country == "United States" ~ "US",
    country == "Japan" ~ "JP",
    TRUE ~ "GL"
  )
}

cause_badge <- function(cause) {
  case_when(
    cause == "Neoplasms" ~ "ONC",
    cause == "Cardiovascular Diseases" ~ "CVD",
    cause == "Tobacco smoking" ~ "TOB",
    TRUE ~ "GEN"
  )
}

empty_mortality_frame <- function() {
  tibble(year = numeric(), mortality_rate = numeric())
}

empty_loaded_mortality_frame <- function() {
  tibble(
    country = character(),
    cause = character(),
    sex = character(),
    year = numeric(),
    mortality_rate = numeric()
  )
}

empty_intervention_frame <- function() {
  tibble(
    country = character(),
    intervention = character(),
    year = numeric(),
    cause = character()
  )
}

missing_columns <- function(data, required_columns) {
  setdiff(required_columns, names(data))
}

resolve_data_file <- function(file) {
  if (file.exists(file)) {
    return(file)
  }

  user_profile <- Sys.getenv("USERPROFILE", unset = NA_character_)
  home_drive <- Sys.getenv("HOMEDRIVE", unset = "")
  home_path <- Sys.getenv("HOMEPATH", unset = "")
  windows_home <- if (!is.na(user_profile) && nzchar(user_profile)) {
    user_profile
  } else if (nzchar(home_drive) && nzchar(home_path)) {
    paste0(home_drive, home_path)
  } else {
    NA_character_
  }

  search_roots <- unique(c(
    getwd(),
    dirname(getwd()),
    if (!is.na(windows_home)) file.path(windows_home, "Downloads") else NA_character_,
    windows_home,
    path.expand("~")
  ))
  search_roots <- search_roots[!is.na(search_roots) & dir.exists(search_roots)]

  file_name <- basename(file)

  for (root in search_roots) {
    matches <- list.files(
      path = root,
      pattern = paste0("^", gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", file_name), "$"),
      recursive = TRUE,
      full.names = TRUE
    )

    if (length(matches) > 0) {
      return(matches[[1]])
    }
  }

  NA_character_
}

load_combined_mortality_file <- function(file, format) {
  resolved_file <- resolve_data_file(file)

  if (is.na(resolved_file)) {
    return(empty_mortality_frame())
  }

  raw_data <- tryCatch(
    read_csv(resolved_file, show_col_types = FALSE),
    error = function(err) {
      warning(sprintf("Could not read combined mortality file '%s': %s", resolved_file, err$message), call. = FALSE)
      NULL
    }
  )

  if (is.null(raw_data)) {
    return(empty_mortality_frame())
  }

  if (format == "clean") {
    required_columns <- c("Year", "MortalityRate")
    absent <- missing_columns(raw_data, required_columns)

    if (length(absent) > 0) {
      warning(
        sprintf(
          "Combined mortality file '%s' is missing required columns: %s",
          resolved_file,
          paste(absent, collapse = ", ")
        ),
        call. = FALSE
      )
      return(empty_mortality_frame())
    }

    raw_data %>%
      transmute(
        year = as.numeric(Year),
        mortality_rate = as.numeric(MortalityRate)
      ) %>%
      filter(!is.na(year), !is.na(mortality_rate))
  } else {
    required_columns <- c("year", "val")
    absent <- missing_columns(raw_data, required_columns)

    if (length(absent) > 0) {
      warning(
        sprintf(
          "Combined mortality file '%s' is missing required columns: %s",
          resolved_file,
          paste(absent, collapse = ", ")
        ),
        call. = FALSE
      )
      return(empty_mortality_frame())
    }

    raw_data %>%
      transmute(
        year = as.numeric(year),
        mortality_rate = as.numeric(val)
      ) %>%
      filter(!is.na(year), !is.na(mortality_rate))
  }
}

load_combined_mortality_data <- function(sources) {
  loaded <- sources %>%
    mutate(data = map2(file, format, load_combined_mortality_file)) %>%
    select(-file, -format) %>%
    unnest(data)

  if (nrow(loaded) == 0) {
    return(empty_loaded_mortality_frame())
  }

  loaded %>%
    mutate(sex = standardize_sex(sex)) %>%
    arrange(country, cause, sex, year)
}

load_sex_mortality_file <- function(file) {
  resolved_file <- resolve_data_file(file)

  if (is.na(resolved_file)) {
    return(empty_mortality_frame())
  }

  raw_data <- tryCatch(
    read_csv(resolved_file, show_col_types = FALSE),
    error = function(err) {
      warning(sprintf("Could not read sex-specific mortality file '%s': %s", resolved_file, err$message), call. = FALSE)
      NULL
    }
  )

  if (is.null(raw_data)) {
    return(empty_mortality_frame())
  }

  required_columns <- c("year", "val")
  absent <- missing_columns(raw_data, required_columns)

  if (length(absent) > 0) {
    warning(
      sprintf(
        "Sex-specific mortality file '%s' is missing required columns: %s",
        resolved_file,
        paste(absent, collapse = ", ")
      ),
      call. = FALSE
    )
    return(empty_mortality_frame())
  }

  raw_data %>%
    transmute(
      year = as.numeric(year),
      mortality_rate = as.numeric(val)
    ) %>%
    filter(!is.na(year), !is.na(mortality_rate))
}

load_sex_mortality_data <- function(sources) {
  loaded <- sources %>%
    mutate(data = map(file, load_sex_mortality_file)) %>%
    select(-file) %>%
    unnest(data)

  if (nrow(loaded) == 0) {
    return(empty_loaded_mortality_frame())
  }

  loaded %>%
    mutate(sex = standardize_sex(sex)) %>%
    arrange(country, cause, sex, year)
}

load_intervention_data <- function(file) {
  resolved_file <- resolve_data_file(file)

  if (is.na(resolved_file)) {
    return(empty_intervention_frame())
  }

  raw_data <- tryCatch(
    read_csv(resolved_file, show_col_types = FALSE),
    error = function(err) {
      warning(sprintf("Could not read intervention file '%s': %s", resolved_file, err$message), call. = FALSE)
      NULL
    }
  )

  if (is.null(raw_data)) {
    return(empty_intervention_frame())
  }

  required_columns <- c("country", "intervention", "year", "cause")
  absent <- missing_columns(raw_data, required_columns)

  if (length(absent) > 0) {
    warning(
      sprintf(
        "Intervention file '%s' is missing required columns: %s",
        resolved_file,
        paste(absent, collapse = ", ")
      ),
      call. = FALSE
    )
    return(empty_intervention_frame())
  }

  raw_data %>%
    transmute(
      country = normalize_country(country),
      intervention = str_squish(intervention),
      year = as.numeric(year),
      cause = normalize_cause(cause)
    ) %>%
    filter(!is.na(country), !is.na(intervention), !is.na(year), !is.na(cause)) %>%
    arrange(country, cause, year, intervention)
}

combined_mortality_data <- load_combined_mortality_data(combined_mortality_sources)
sex_mortality_data <- load_sex_mortality_data(sex_mortality_sources)
mortality_data <- bind_rows(combined_mortality_data, sex_mortality_data) %>%
  arrange(country, cause, sex, year)

intervention_data <- bind_rows(
  load_intervention_data("Intervention data.csv"),
  load_intervention_data("additional_interventions.csv")
) %>%
  arrange(country, cause, year, intervention)

country_choices <- mortality_data %>%
  distinct(country) %>%
  pull(country)

country_choices <- country_choices[
  country_choices %in% (intervention_data %>% distinct(country) %>% pull(country))
]

if (length(country_choices) == 0) {
  country_choices <- mortality_data %>%
    distinct(country) %>%
    pull(country)
}

default_country <- if ("Germany" %in% country_choices) {
  "Germany"
} else if (length(country_choices) > 0) {
  country_choices[[1]]
} else {
  NULL
}

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      :root {
        --page-bg: #f5f6f8;
        --surface: #ffffff;
        --surface-soft: #fafbfc;
        --border: #dbe3ea;
        --text-main: #1f2937;
        --text-muted: #667085;
        --hero-deep: #8c1736;
        --hero-mid: #b6294a;
        --hero-soft: #d96b67;
        --hero-warm: #e7a07f;
        --accent: #9d2242;
        --accent-soft: #fff6f8;
        --sidebar-top: #fff7f9;
        --sidebar-bottom: #fffdfd;
        --male-color: #8f1837;
        --female-color: #d97a74;
      }
      body {
        background: var(--page-bg);
        color: var(--text-main);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      }
      .container-fluid {
        padding-left: 0;
        padding-right: 0;
      }
      .hero-band {
        position: relative;
        overflow: hidden;
        margin-bottom: 22px;
        padding: 40px 20px 28px;
        background:
          radial-gradient(circle at 16% 22%, rgba(255, 219, 227, 0.18), transparent 22%),
          radial-gradient(circle at 82% 18%, rgba(255, 244, 220, 0.12), transparent 18%),
          radial-gradient(circle at 50% 10%, rgba(255, 255, 255, 0.06), transparent 28%),
          linear-gradient(135deg, var(--hero-deep) 0%, var(--hero-mid) 44%, var(--hero-soft) 74%, var(--hero-warm) 100%);
        border-radius: 0 0 22px 22px;
        box-shadow: 0 14px 32px rgba(126, 25, 54, 0.12);
      }
      .hero-band::before {
        content: '';
        position: absolute;
        inset: 0;
        background:
          linear-gradient(120deg, rgba(255, 255, 255, 0.09), transparent 40%),
          linear-gradient(180deg, rgba(46, 7, 18, 0.02), rgba(46, 7, 18, 0.16));
        pointer-events: none;
      }
      .hero-inner {
        position: relative;
        z-index: 1;
        max-width: 1100px;
        margin: 0 auto;
        text-align: center;
        padding: 0 16px;
      }
      .hero-kicker {
        margin: 0 0 10px;
        color: rgba(255, 246, 246, 0.92);
        font-size: 11px;
        font-weight: 600;
        letter-spacing: 0.22em;
        text-transform: uppercase;
      }
      .hero-title {
        margin: 0 auto;
        max-width: 860px;
        color: #fff8f5;
        font-family: Georgia, 'Times New Roman', serif;
        font-size: 42px;
        line-height: 1.03;
        font-weight: 700;
        letter-spacing: 0.02em;
        text-transform: uppercase;
      }
      .hero-subtitle {
        margin: 14px auto 0;
        max-width: 720px;
        color: rgba(255, 243, 239, 0.92);
        font-size: 16px;
        line-height: 1.5;
        font-weight: 400;
      }
      .dashboard-shell {
        max-width: 1280px;
        margin: 0 auto;
        padding: 0 16px 40px;
      }
      .control-card,
      .summary-card,
      .content-card {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 16px;
        box-shadow: 0 8px 24px rgba(15, 23, 42, 0.05);
      }
      .control-card {
        padding: 18px;
        margin-bottom: 18px;
        background: linear-gradient(180deg, var(--sidebar-top) 0%, var(--sidebar-bottom) 100%);
        border-color: #edd7df;
      }
      .summary-card {
        padding: 16px 18px;
        min-height: 108px;
        margin-bottom: 18px;
      }
      .content-card {
        padding: 18px 20px;
        margin-bottom: 18px;
      }
      .section-title {
        margin: 0 0 14px;
        font-size: 17px;
        font-weight: 600;
        color: #102a43;
      }
      .section-title .fa,
      .summary-label .fa {
        color: var(--accent);
        margin-right: 8px;
      }
      .info-copy {
        margin: 0;
        font-size: 14px;
        line-height: 1.65;
        color: #425466;
      }
      .form-group {
        margin-bottom: 14px;
      }
      .form-group label {
        font-size: 13px;
        font-weight: 600;
        color: #243b53;
      }
      .form-control {
        border: 1px solid var(--border);
        border-radius: 10px;
        box-shadow: none;
        font-size: 14px;
      }
      .form-control:focus {
        border-color: rgba(157, 34, 66, 0.55);
        box-shadow: 0 0 0 3px rgba(157, 34, 66, 0.10);
      }
      .sidebar-subsection {
        margin-top: 14px;
        padding-top: 14px;
        border-top: 1px solid #f0dbe2;
      }
      .donut-title {
        margin: 0 0 4px;
        font-size: 13px;
        font-weight: 600;
        color: #425466;
      }
      .donut-subtitle {
        margin: 0 0 10px;
        font-size: 12px;
        color: var(--text-muted);
      }
      .sex-radio .radio {
        margin-top: 8px;
        margin-bottom: 8px;
      }
      .sex-radio label {
        font-size: 13px;
        font-weight: 600;
        color: #243b53;
      }
      .summary-label {
        margin-bottom: 10px;
        font-size: 13px;
        font-weight: 600;
        color: var(--text-muted);
      }
      .summary-value {
        font-size: 23px;
        font-weight: 700;
        line-height: 1.15;
        color: #102a43;
      }
      .summary-subvalue {
        margin-top: 6px;
        font-size: 12px;
        color: var(--text-muted);
      }
      .code-pill {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 34px;
        height: 24px;
        margin-right: 8px;
        padding: 0 8px;
        border-radius: 999px;
        background: #f7e8ed;
        color: var(--accent);
        font-size: 11px;
        font-weight: 700;
        letter-spacing: 0.06em;
      }
      .table {
        margin-bottom: 0;
      }
      .table thead th {
        border-bottom: 2px solid var(--border);
        background: var(--surface-soft);
        color: #102a43;
        font-weight: 600;
      }
      .table tbody td {
        color: var(--text-main);
        vertical-align: top;
      }
      .table-striped > tbody > tr:nth-of-type(odd) {
        background-color: #f8fbfd;
      }
      .dataTables_wrapper .dataTables_filter {
        float: right;
        margin-bottom: 10px;
      }
      .dataTables_wrapper .dataTables_filter label {
        font-size: 13px;
        font-weight: 600;
        color: #425466;
      }
      .dataTables_wrapper .dataTables_filter input {
        margin-left: 8px;
        min-width: 220px;
        padding: 6px 10px;
        border: 1px solid var(--border);
        border-radius: 10px;
      }
      .dataTables_wrapper .dataTables_info,
      .dataTables_wrapper .dataTables_paginate,
      .dataTables_wrapper .dataTables_length {
        font-size: 12px;
        color: var(--text-muted);
      }
      .dataTables_wrapper .dataTables_paginate .paginate_button.current,
      .dataTables_wrapper .dataTables_paginate .paginate_button.current:hover {
        border: 1px solid #e7c9d3 !important;
        background: #fff3f6 !important;
        color: var(--accent) !important;
      }
      @media (max-width: 768px) {
        .hero-band {
          padding: 34px 16px 24px;
        }
        .hero-title {
          font-size: 30px;
        }
        .hero-subtitle {
          font-size: 15px;
        }
      }
    "))
  ),
  div(
    class = "hero-band",
    div(
      class = "hero-inner",
      p(class = "hero-kicker", "INDEPENDENT PUBLIC HEALTH RESEARCH · 2026"),
      h1(class = "hero-title", "GLOBAL HEALTH POLICY", tags$br(), "& INTERVENTION EXPLORER"),
      p(
        class = "hero-subtitle",
        "Analyzing how national health interventions correlate with mortality trends across major causes of death."
      )
    )
  ),
  div(
    class = "dashboard-shell",
    fluidRow(
      column(
        width = 3,
        div(
          class = "control-card",
          h2(class = "section-title", icon("sliders"), "Filters"),
          selectInput("country", "Country", choices = country_choices, selected = default_country),
          selectInput("cause", "Cause", choices = cause_choices, selected = "Neoplasms"),
          div(
            class = "sidebar-subsection",
            h3(class = "donut-title", "Mortality Distribution by Sex"),
            # Donut explanatory text updated to clarify latest-rate basis.
            p(class = "donut-subtitle", "Latest mortality rates"),
            plotOutput("sexDonut", height = "220px"),
            radioButtons(
              "sex_view",
              "Trend view",
              choices = c("Male", "Female", "Both"),
              selected = "Both",
              inline = FALSE,
              width = "100%"
            )
          )
        ),
        div(
          class = "control-card",
          h2(class = "section-title", icon("info-circle"), "About this tool"),
          p(
            class = "info-copy",
            "This dashboard provides an exploratory visualization of mortality trends alongside major public health policies and interventions across countries."
          )
        )
      ),
      column(
        width = 9,
        fluidRow(
          column(
            width = 4,
            div(
              class = "summary-card",
              div(class = "summary-label", icon("flag"), "Selected Country"),
              uiOutput("selectedCountryCard")
            )
          ),
          column(
            width = 4,
            div(
              class = "summary-card",
              div(class = "summary-label", icon("heartbeat"), "Cause"),
              uiOutput("selectedCauseCard")
            )
          ),
          column(
            width = 4,
            div(
              class = "summary-card",
              div(class = "summary-label", icon("line-chart"), "Latest Mortality"),
              uiOutput("latestMortalityCard")
            )
          )
        ),
        div(
          class = "content-card",
          h2(class = "section-title", "Mortality Trend"),
          plotOutput("mortalityPlot", height = "430px")
        ),
        div(
          class = "content-card",
          h2(class = "section-title", "Interventions"),
          DTOutput("interventionTable")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  selected_interventions <- reactive({
    intervention_data %>%
      filter(country == input$country, cause == input$cause)
  })

  selected_mortality <- reactive({
    mortality_data %>%
      filter(country == input$country, cause == input$cause)
  })

  selected_sex_mortality <- reactive({
    selected_mortality() %>%
      filter(sex %in% c("Male", "Female"))
  })

  selected_combined_mortality <- reactive({
    selected_mortality() %>%
      filter(sex == "Both")
  })

  # Corrected "Both" logic: show overall combined mortality only, not male/female together.
  chart_mortality <- reactive({
    if (input$sex_view == "Both") {
      selected_combined_mortality()
    } else {
      selected_sex_mortality() %>% filter(sex == input$sex_view)
    }
  })

  # Prepare latest-year sex split for the sidebar donut.
  latest_donut_data <- reactive({
    donut_data <- selected_sex_mortality()

    if (nrow(donut_data) == 0) {
      return(NULL)
    }

    latest_year <- max(donut_data$year, na.rm = TRUE)
    donut_data %>%
      filter(year == latest_year) %>%
      arrange(sex)
  })

  output$selectedCountryCard <- renderUI({
    div(
      class = "summary-value",
      tags$span(class = "code-pill", country_badge(input$country)),
      input$country
    )
  })

  output$selectedCauseCard <- renderUI({
    div(
      class = "summary-value",
      tags$span(class = "code-pill", cause_badge(input$cause)),
      input$cause
    )
  })

  output$latestMortalityCard <- renderUI({
    if (input$sex_view == "Both") {
      selected_data <- selected_combined_mortality() %>% arrange(year)

      if (nrow(selected_data) == 0) {
        return(div(class = "summary-subvalue", "No combined mortality data available."))
      }

      latest_row <- slice_tail(selected_data, n = 1)

      return(tagList(
        div(class = "summary-value", format(round(latest_row$mortality_rate, 1), nsmall = 1)),
        div(class = "summary-subvalue", paste0("Overall rate in ", latest_row$year))
      ))
    }

    selected_data <- selected_sex_mortality() %>%
      filter(sex == input$sex_view) %>%
      arrange(year)

    if (nrow(selected_data) == 0) {
      return(div(class = "summary-subvalue", paste0("No ", str_to_lower(input$sex_view), " mortality data available.")))
    }

    latest_row <- slice_tail(selected_data, n = 1)

    tagList(
      div(class = "summary-value", format(round(latest_row$mortality_rate, 1), nsmall = 1)),
      div(class = "summary-subvalue", paste0(input$sex_view, " rate in ", latest_row$year))
    )
  })

  output$sexDonut <- renderPlot({
    donut_data <- latest_donut_data()

    validate(
      need(!is.null(donut_data) && nrow(donut_data) > 0, "Sex-specific mortality data is being integrated in the next version of the dashboard."),
      need(n_distinct(donut_data$sex) == 2, "Sex-specific mortality data is being integrated in the next version of the dashboard.")
    )

    latest_year <- unique(donut_data$year)

    ggplot(
      donut_data,
      aes(x = 2, y = mortality_rate, fill = sex)
    ) +
      geom_col(width = 0.72, color = "white", linewidth = 0.6) +
      coord_polar(theta = "y") +
      xlim(0.8, 2.6) +
      scale_fill_manual(
        values = c("Male" = "#8f1837", "Female" = "#d97a74")
      ) +
      theme_void() +
      theme(
        legend.position = "bottom",
        legend.title = element_blank(),
        legend.text = element_text(size = 10, color = "#425466"),
        plot.margin = margin(6, 6, 6, 6)
      ) +
      annotate("text", x = 0, y = 0, label = latest_year, size = 4, fontface = "bold", color = "#425466")
  })

  output$mortalityPlot <- renderPlot({
    plot_data <- chart_mortality()
    intervention_lines <- selected_interventions()

    if (input$sex_view == "Both") {
      validate(need(nrow(plot_data) > 0, "No combined mortality data available for this selection."))
    } else {
      validate(need(nrow(plot_data) > 0, paste0("No ", str_to_lower(input$sex_view), " mortality data available for this selection.")))
    }

    plot_title <- case_when(
      input$sex_view == "Male" ~ paste("Male", input$cause, "Mortality Trends in", input$country),
      input$sex_view == "Female" ~ paste("Female", input$cause, "Mortality Trends in", input$country),
      TRUE ~ paste(input$cause, "Mortality Trends in", input$country)
    )

    plot_subtitle <- "Intervention-year markers reflect the selected country and cause"

    base_plot <- ggplot(plot_data, aes(x = year, y = mortality_rate))

    if (input$sex_view == "Male") {
      base_plot <- base_plot +
        geom_line(color = "#8f1837", linewidth = 1.15) +
        geom_point(color = "#8f1837", size = 2.2)
    } else if (input$sex_view == "Female") {
      base_plot <- base_plot +
        geom_line(color = "#d97a74", linewidth = 1.15) +
        geom_point(color = "#d97a74", size = 2.2)
    } else {
      base_plot <- base_plot +
        geom_line(color = "#a61e43", linewidth = 1.15) +
        geom_point(color = "#a61e43", size = 2.2)
    }

    base_plot +
      geom_vline(
        data = intervention_lines,
        aes(xintercept = year),
        linetype = "dashed",
        color = "#7d1634",
        linewidth = 0.75,
        alpha = 0.55,
        inherit.aes = FALSE
      ) +
      scale_x_continuous(
        breaks = seq(min(plot_data$year), max(plot_data$year), by = 2)
      ) +
      labs(
        title = plot_title,
        subtitle = plot_subtitle,
        x = "Year",
        y = "Deaths per 100,000 population"
      ) +
      theme_minimal(base_size = 12) +
      theme(
        plot.title = element_text(size = 18, face = "bold", color = "#7d1634"),
        plot.subtitle = element_text(size = 11.5, color = "#6f4b55"),
        axis.title = element_text(size = 11.5, color = "#5a2f3a"),
        axis.text = element_text(color = "#5a2f3a"),
        panel.grid.major.y = element_line(color = "#edd9df"),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank(),
        legend.position = "none"
      )
  })

  output$interventionTable <- renderDT({
    selected_interventions() %>%
      transmute(
        year,
        intervention,
        cause
      ) %>%
      datatable(
        rownames = FALSE,
        options = list(
          dom = "ftip",
          pageLength = 5,
          lengthChange = FALSE,
          autoWidth = TRUE,
          order = list(list(0, "asc"))
        ),
        class = "stripe hover compact"
      )
  })
}

shinyApp(ui = ui, server = server)

library(targets)

source(here::here("R", "functions.R"))

# Set target-specific options such as packages.
tar_option_set(packages = c("purrr", "readr", "ggplot2", "janitor", "dplyr",
                            "here", "lubridate", "tidyr")
)

# Define targets
targets <- list(
  tar_target(files, list.files(here::here("data"), 
                               full.names = TRUE,
                               pattern = "\\.csv$", 
                               recursive = TRUE), # if data is organized by sub-directories; w/ all data, can take awhile
             format = "file"),
  tar_target(raw_data, map_df(files, read_csv_with_col_types)),
  tar_target(d, prep_data(raw_data)),
  
  tar_target(covid_mentions, compute_covid_mentions(d)),
  tar_target(plot_covid_mentions, create_covid_mention_plot(covid_mentions), 
             format = "file"),
  
  tar_target(compute_reactions, compute_reactions_per_post(d)),
  tar_target(plot_reactions, create_reactions_plot(compute_reactions))
)

# End with a call to tar_pipeline() to wrangle the targets together.
# This target script must return a pipeline object.
tar_pipeline(targets)

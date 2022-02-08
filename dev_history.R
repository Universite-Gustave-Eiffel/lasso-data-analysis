library(here)
usethis::create_project(path = here::here("InProgress/06_UMRAE/2021/LASSO") )


usethis::use_git()

# Configure Credentials
usethis::edit_r_environ()

usethis::use_description(
  fields = list(
    Title = "LASSO - Crowdsourced acoustic open data analysis",

    Description = paste("Analyse the data collected between 2017 and 2020 by the NoiseCapture application."),
    `Authors@R` = c(
      person("Nicolas", "Roelandt", email = "nicolas.roelandt@univ-eiffel.fr",
             role = c("aut", "cre"), comment = c(ORCID = "0000-0001-9698-4275")),
      person(given = "Uni. Gustave Eiffel", role = "cph")
    )
  ))

usethis::use_vignette("crowdsourced_acoustic_data_analysis_with_foss4g_2022","Crowdsourced acoustic open data analysis with FOSS4G tools")

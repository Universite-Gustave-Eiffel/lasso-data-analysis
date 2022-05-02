# Exploratory analysis of crowdsourced acoustic open data

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This short analysis explore the [data](https://research-data.ifsttar.fr/dataset.xhtml?persistentId=doi:10.25578/J5DG3W) collected by the [Noisecapture Android application](https://play.google.com/store/apps/details?id=org.noise_planet.noisecapture) between 2017 and 2020.

A [first exploratory analysis](https://nicolas-roelandt.github.io/lasso-data-analysis/articles/temporal_exploratory_analysis.html) 
focus on the tracks recorded in France and the search
for known patterns in environmental acoustics.

These preliminary works are part of the research carried out 
within the framework of the LASSO project 
led by the [UMRAE laboratory](https://www.umrae.fr/en/) ([Univ. Gustave Eiffel](https://www.univ-gustave-eiffel.fr/)/[CEREMA](http://www.cerema.fr/))

## Data source

The raw data are available here :

https://research-data.ifsttar.fr/dataset.xhtml?persistentId=doi:10.25578/J5DG3W

## How to reproduce
### Build the database
#### Server configuration
- Ubuntu 18.04 or higher
- PostgreSQL 10.15 or higher (14.0 is recommended)
- Postgis 2.5 or higher

#### Steps

- Create an empty database named `noisecapture` with the Postgis extension
- Copy in your home folder the SQL script `01_drop_foreign_keys.sql` if your available storage is less than 200 Gb
- Execute the script `00_prepare_database.sh`, comment the second line if you want to keep foreign keys
- Execute the SQL script `02_load_country_data.sql` to load additional data from [NaturalEarth](https://www.naturalearthdata.com/downloads/10m-cultural-vectors/) used by the analysis
- Execute the SQL script `03_create_views.sql` to compute the views that prepare the data used in the analysis.

### Get the source code

As the analysis part of project as been treated as R package, there is several ways 
to get the code source:
- using git

```{bash git-clone, eval=FALSE}
git clone https://github.com/nicolas-roelandt/lasso-data-analysis
```

- using R and the [remotes package](https://remotes.r-lib.org/):

```{r package-installation, eval=FALSE}
# You can clone 

# We suggest to use the remotes packages to install required packages
# install.packages("remotes")
remotes::install_github("nicolas-roelandt/lasso-data-analysis")
```

- download as a [zip archive](https://github.com/nicolas-roelandt/lasso-data-analysis/archive/refs/heads/main.zip)

### Setting up R
This analysis use several packages that you'll need to install beforehand.

```r
# Package list
pkgs <- c("RPostgreSQL",
          "DBI",
          "sf",
          "dplyr",
          "purrr",
          "ggplot2",
          "scales",
          "lubridate",
          "hydroTSM",
          "suncalc",
          "xfun")

# Packages installation from CRAN
# Already installed packages won't be reinstalled
remotes::install_cran(pkgs)
```

### Render [temporal_exploratory_analysis.Rmd](https://github.com/nicolas-roelandt/lasso-data-analysis/blob/FOSS4G2022/vignettes/temporal_exploratory_analysis.Rmd) vignette


Please be sure to adapt the connection parameters to your database.
Those parameters are presented as an example, the database is not available online.

```r
drv <- DBI::dbDriver("PostgreSQL")

con <- DBI::dbConnect(
drv,
dbname ="noisecapture",
host = "noisecaptureDB", #server IP or hostname
port = 5432, #Port on which we ran the proxy
user="noisecapture",
password=Sys.getenv('noisecapture_password') # password stored in .Renviron. Use this to edit it : usethis::edit_r_environ()
)
```



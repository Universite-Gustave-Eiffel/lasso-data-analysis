# Time analysis of Noisecapture data
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This short analysis explore the data collected by the Noisecapture application between 2017 and 2020.

It focuses on the tracks recorded in France.

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

### Render `temporal_analysis.Rmd` vignette
The final analysis is made within R.

Please be sure to adapt the connexion parameters to your setup.

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



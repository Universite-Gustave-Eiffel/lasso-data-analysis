# User guide

## Scripts' general organization

All the scripts available in this git are used for the analysis of the NoiseCapture's database.
- The scripts with the **[Computing]** prefix are meant only to process heavy calculations, clean and process our data etc.
- The scripts with the **[Analysis]** prefix are here to generate graphs and texts linked to the analysis of our database. Those are the visible outputs.
- The *Main_doc.Rmd* is merely a script to organize and knit in order the different children scripts.

## How to run scripts

For an overall visualization of our whole work, you may knit the *Main_doc.Rmd* Rmarkdown file using your software of preference (we used RStudio).
Note that all **[Analysis]** scripts can be stand-alone, meaning you can knit them independently if you only want to see one part of the whole analysis.
**[Computing]** scripts are not meant to be run alone, as they need a particular order and variables to run properly.

**Important** : 
By default, *Main_doc.Rmd* is set in fast generation mode, meaning no **[Computing]** files are evaluated, instead the **[Analysis]** scripts only download the needed already processed data.
This can be switched by setting the *fast* variable to *FALSE* at the very beginning of *Main_doc.Rmd*.
Be aware that the whole process may take between 2-4h depending on your installation.
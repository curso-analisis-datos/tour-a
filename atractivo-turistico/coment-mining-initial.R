system("defaults write org.R-project.R force.LANG es_US.UTF-8")
Sys.setenv(LANG="es")

Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")   
install.packages(Needed, repos='http://cran.us.r-project.org', dependencies=TRUE)


# Configuracion del directorio con los textos
cname <- file.path("D:/dev/curso-analisis-datos/tour-a/atractivo-turistico/data-scraping-to-tripadvisor/datasets")   
cname 
dir(cname)

## Loading required package: NLP
library(NLP)
library(tm)

docs <- VCorpus(DirSource(cname))   
summary(docs)  

World Population Predictor
========================================================
author: Sukhen Chatterjee
date: July 27, 2018
autosize: true
font-family: 'Helvetica'

World Population Predictor
========================================================

This is a very simple application which displays the actual and projected total population of the world by country or region. Here is the link to app.  <https://sukhenc.shinyapps.io/populationpredictor/>.

1. Navigation Panel <small>The left-hand navigation panel has three input boxes and one link to the help web page.</small>
2. Main Panel <small>The right-hand main panel has three sections as following from top to bottom. Country Profile, Plot and Projected Population</small>
3. Link to help page <small>This webpage has additional information about this Shiny Aapp.</small>

Code to read the world bank data and summary of UK data
========================================================


```r
source("loaddata.R")
summary(subset(populationdataset, countryname == "United Kingdom")[,6:7]) 
```

```
      year        population   
 Min.   :1960   Min.   :52.40  
 1st Qu.:1974   1st Qu.:56.20  
 Median :1988   Median :57.00  
 Mean   :1988   Mean   :58.03  
 3rd Qu.:2003   3rd Qu.:59.58  
 Max.   :2017   Max.   :66.02  
```

United Kingdom Population Plot
========================================================

![plot of chunk unnamed-chunk-2](World Population Predictor-figure/unnamed-chunk-2-1.png)

Code for the Projected Population
========================================================

```r
profile <- subset(populationdataset, countryname == "United Kingdom" & year == "2010") 
profile <- profile[,c("countrycode","countryname", "year", "population")]
profile$projectedpopulation <- predict(predmodel, newdata = data.frame(year = 2010))
kable(profile, row.names = FALSE)
```



|countrycode |countryname    | year| population| projectedpopulation|
|:-----------|:--------------|----:|----------:|-------------------:|
|GBR         |United Kingdom | 2010|   62.76637|            62.03376|

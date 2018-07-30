library(plotly)
library(tidyr)
library(dplyr)

# load the world total population data from world bank
rawdata <- read.csv("data/f4231386-be97-414c-af76-042bd86f3397_Data.csv", 
                    colClasses=c(rep("character",4),rep("numeric",58)), 
                    na.strings = "..")

# pick only the needed columns 
wantedCols <- grepl(".*Country*|.*YR*", colnames(rawdata), ignore.case = FALSE)
subsetdata <- rawdata[wantedCols]
columnnames <- colnames(subsetdata)
wantedcolnames <- tolower(c("countryname","countrycode",substr(columnnames[3:length(columnnames)], 8, 13)))
subsetdata <- setNames(subsetdata, wantedcolnames)

# reformat the dataframe to have years as rows (instead of columns)
populationdata <- gather(subsetdata, year, population, yr1960:yr2017) 
populationdata$year <- as.numeric(gsub("yr", "", populationdata$year))

# convert the population in million
populationdata$population <- round(populationdata$population/1000000, 2)
# convert the year column as integer 
populationdata$year <- as.integer(populationdata$year)

## load the country metadata
countrymetadata <- read.csv("data/Data_Extract_From_Health_Nutrition_and_Population_Statistics_Metadata.csv", 
                     colClasses=c(rep("character",31)))
#pick only the needed columns and rename the columns 
countrymetadata <- countrymetadata[,1:4]
countrymetadata <- setNames(countrymetadata, c("countrycode","countrylongname","incomegroup","region"))

#stwich the column order as appropiate 
populationdataset <- inner_join(countrymetadata, populationdata, by = "countrycode") %>% 
        subset(!is.na(population)) %>%
        select("countrycode","countryname","countrylongname","incomegroup","region","countryname","year","population")

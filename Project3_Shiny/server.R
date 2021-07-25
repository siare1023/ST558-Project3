library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(DT)
library(ggrepel)
library(factoextra)
library(caret)

# read in data
raw.data <- read_csv("California_Houses.csv")

# create categories for quantitative variables
summary.median.income <- raw.data$Median_Income %>% summary()
raw.data$Median_Income_Factor <- ifelse(raw.data$Median_Income >= summary.median.income["3rd Qu."], "High: 4.7432 - 15.001", 
                                        ifelse(raw.data$Median_Income >= summary.median.income["Median"], "Medium High: 3.5348 - 4.7431",
                                               ifelse(raw.data$Median_Income >= summary.median.income["1st Qu."], "Medium Low: 2.5634 - 3.5347", 
                                                      "Low: 0.4999 - 2.5633"))) %>% as.factor()

summary.median.age <- raw.data$Median_Age %>% summary()
raw.data$Median_Age_Factor <- ifelse(raw.data$Median_Age >= summary.median.age["3rd Qu."], "37 - 52", 
                                        ifelse(raw.data$Median_Age >= summary.median.age["Median"], "29 - 51",
                                               ifelse(raw.data$Median_Age >= summary.median.age["1st Qu."], "18 - 28", 
                                                      "1 - 17"))) %>% as.factor()

summary.total.rooms <- raw.data$Tot_Rooms %>% summary()
raw.data$Tot_Rooms_Factor <- ifelse(raw.data$Tot_Rooms >= summary.total.rooms["3rd Qu."], "3148 - 39320", 
                                     ifelse(raw.data$Tot_Rooms >= summary.total.rooms["Median"], "2127 - 3147",
                                            ifelse(raw.data$Tot_Rooms >= summary.total.rooms["1st Qu."], "1448 - 2126", 
                                                   "2 - 1447"))) %>% as.factor()

summary.total.bedrooms <- raw.data$Tot_Bedrooms %>% summary()
raw.data$Tot_Bedrooms_Factor <- ifelse(raw.data$Tot_Bedrooms >= summary.total.bedrooms["3rd Qu."], "647 - 6445", 
                                    ifelse(raw.data$Tot_Bedrooms >= summary.total.bedrooms["Median"], "435 - 646",
                                           ifelse(raw.data$Tot_Bedrooms >= summary.total.bedrooms["1st Qu."], "295 - 434", 
                                                  "1 - 294"))) %>% as.factor()

summary.population <- raw.data$Population %>% summary()
raw.data$Population_Factor <- ifelse(raw.data$Population >= summary.population["3rd Qu."], "1725 - 35682", 
                                    ifelse(raw.data$Population >= summary.population["Median"], "1166 - 1724",
                                           ifelse(raw.data$Population >= summary.population["1st Qu."], "787 - 1165", 
                                                  "3 - 786"))) %>% as.factor()

summary.households <- raw.data$Households %>% summary()
raw.data$Households_Factor <- ifelse(raw.data$Households >= summary.households["3rd Qu."], "605 - 6082", 
                                     ifelse(raw.data$Households >= summary.households["Median"], "409 - 604",
                                            ifelse(raw.data$Households >= summary.households["1st Qu."], "280 - 408", 
                                                   "1 - 279"))) %>% as.factor()

summary.coast <- raw.data$Distance_to_coast %>% summary()
raw.data$Distance_to_coast_Factor <- ifelse(raw.data$Distance_to_coast >= summary.coast["3rd Qu."], "Farthest: 49830.4 - 333804.7", 
                                     ifelse(raw.data$Distance_to_coast >= summary.coast["Median"], "Far: 20522.0 - 49830.3",
                                            ifelse(raw.data$Distance_to_coast >= summary.coast["1st Qu."], "Close: 9079.8 - 20521.9", 
                                                   "Closest: 102.7 - 9079.7"))) %>% as.factor()

summary.la <- raw.data$Distance_to_LA %>% summary()
raw.data$Distance_to_LA_Factor <- ifelse(raw.data$Distance_to_LA >= summary.la["3rd Qu."], "Farthest: 527156.2 - 1018260.1", 
                                            ifelse(raw.data$Distance_to_LA >= summary.la["Median"], "Far: 173667.5 - 527156.1",
                                                   ifelse(raw.data$Distance_to_LA >= summary.la["1st Qu."], "Close: 32111.3 - 173667.4", 
                                                          "Closest: 420.6 - 32111.2"))) %>% as.factor()

summary.sd <- raw.data$Distance_to_SanDiego %>% summary()
raw.data$Distance_to_SanDiego_Factor <- ifelse(raw.data$Distance_to_SanDiego >= summary.sd["3rd Qu."], "Farthest: 705795.4 - 1196919.3", 
                                         ifelse(raw.data$Distance_to_SanDiego >= summary.sd["Median"], "Far: 214739.8 - 705795.3",
                                                ifelse(raw.data$Distance_to_SanDiego >= summary.sd["1st Qu."], "Close: 159426.4 - 214739.7", 
                                                       "Closest: 484.9 - 159426.3"))) %>% as.factor()

summary.sj <- raw.data$Distance_to_SanJose %>% summary()
raw.data$Distance_to_SanJose_Factor <- ifelse(raw.data$Distance_to_SanJose >= summary.sj["3rd Qu."], "Farthest: 516946.5 - 836762.7", 
                                               ifelse(raw.data$Distance_to_SanJose >= summary.sj["Median"], "Far: 459758.9 - 516946.4",
                                                      ifelse(raw.data$Distance_to_SanJose >= summary.sj["1st Qu."], "Close: 113119.9 - 459758.8", 
                                                             "Closest: 569.4 - 113119.8"))) %>% as.factor()

summary.sf <- raw.data$Distance_to_SanFrancisco %>% summary()
raw.data$Distance_to_SanFrancisco_Factor <- ifelse(raw.data$Distance_to_SanFrancisco >= summary.sf["3rd Qu."], "Farthest: 584552.0 - 903627.7", 
                                              ifelse(raw.data$Distance_to_SanFrancisco >= summary.sf["Median"], "Far: 526546.7 - 584551.9",
                                                     ifelse(raw.data$Distance_to_SanFrancisco >= summary.sf["1st Qu."], "Close: 117395.5 - 526546.6", 
                                                            "Closest: 456.1 - 117395.4"))) %>% as.factor()

raw.data
# shinyServer arguments
shinyServer(function(input, output, session){
    
}
    
)
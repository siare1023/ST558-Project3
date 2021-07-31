# Purpose of this Shiny App
The purpose of this Shiny App is to explore California housing prices data. Users can:

* Do basic data exploration
* See numerical summaries
* Create and download plots
* Fit three different supervised learning models on the data
* Make predictions on the response variable

Dataset used in the app was derived from collected information using block groups in California from the 1990 census. This dataset has 20,640 observations on 14 variables, which includes the response variable - Median House Value.

The original dataset and more information can be found [here](https://www.kaggle.com/fedesoriano/california-housing-prices-data-extra-features).

# R Packages and Libraries Used
`install.packages(c("shiny", "shinydashboard", "tidyverse", "knitr", "DT", "caret", "tree", "randomForest", "shinycssloaders", "plotly"))`

`library(shiny)`
`library(tidyverse)`
`library(knitr)`
`library(DT)`
`library(caret)`
`library(tree)`
`library(randomForest)`
`library(shinycssloaders)`
`library(shinydashboard)`
`library(plotly)`

# Run the App
`shiny::runGitHub(repo = "ST558-Project3", username = "siare1023", ref = "main")`




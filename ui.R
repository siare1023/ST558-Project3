library(tidyverse)
library(shinydashboard)
library(DT)
library(plotly)
library(shinycssloaders)


# sidebar design
sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("About", tabName = "about", icon = icon("futbol")),
        menuItem("Data", tabName = "data", icon = icon("table")),
        menuItem("Data Exploration", tabName = "explore", icon = icon("chart-bar")),
        menuItem("Modeling", tabName = "model", icon = icon("chart-line"))
    )
)

#_____________________________________________________________________________________

# body design  
body <- dashboardBody(
    tabItems(
        # start "about" tab
        tabItem(tabName = "about",
                tabsetPanel(
                    tabPanel("Purpose",
                        h3("Purpose of this Shiny App"),
                        h4("The purpose of this Shiny App is to explore California housing prices data. Users can:"), 
                        h4(tags$ul(
                            tags$li("Do basic data exploration"), 
                            tags$li("See numerical summaries"), 
                            tags$li("Create and download plots"), 
                            tags$li("Fit three different supervised learning method models on the data"), 
                            tags$li("Make predictions on the response variable"))),
                        br(),
                        img(src = "california_housing.jpeg", align="left", height = "30%", width = "30%")
                    ), # end tabPanel "purpose"
                    
                    tabPanel("Data",
                        h3("About the Data"),
                        h4("This dataset was derived from collected information using block groups in California from the 1990 census. This dataset has 20,640 observations on 14 variables, which includes the response variable - Median House Value."),
                        h4("The original dataset and more information can be found", tags$a(href="https://www.kaggle.com/fedesoriano/california-housing-prices-data-extra-features", "here.")),
                        br(),
                        h3("Data Variables"),
                        h4(tags$ul(
                            tags$li(tags$b("Median House Value")," - Median house value for households within a block (measured in US Dollars) [$]"),
                            tags$li(tags$b("Median Income")," - Median income for households within a block of houses (measured in tens of thousands of US Dollars) [10k$]"),
                            tags$li(tags$b("Median Age")," - Median age of a house within a block; a lower number is a newer building [years]"),
                            tags$li(tags$b("Total Rooms")," - Total number of rooms within a block"),
                            tags$li(tags$b("Total Bedrooms")," - Total number of bedrooms within a block"),
                            tags$li(tags$b("Population")," - Total number of people residing within a block"),
                            tags$li(tags$b("Households")," - Total number of households, a group of people residing within a home unit, for a block"),
                            tags$li(tags$b("Latitude")," - A measure of how far north a house is; a higher value is farther north [°]"),
                            tags$li(tags$b("Longitude")," - A measure of how far west a house is; a higher value is farther west [°]"), 
                            tags$li(tags$b("Distance to Coast")," - Distance to the nearest coast point [m]"),
                            tags$li(tags$b("Distance to Los Angeles")," - Distance to the centre of Los Angeles [m]"),
                            tags$li(tags$b("Distance to San Diego")," - Distance to the centre of San Diego [m]"),
                            tags$li(tags$b("Distance to San Jose")," - Distance to the centre of San Jose [m]"),
                            tags$li(tags$b("Distance to San Francisco")," - Distance to the centre of San Francisco [m]")
                        )),
                        br(),
                        h3("Added Variables"),
                        h4("For the ease of data manipulation and plotting, 14 additional variables are added to the original dataset. They're factor form of the original quantitative variables, each of these new categorical variable has 4 levels corresponding to each of the 4 quantiles."),
                        h4(tags$ul(
                            tags$li(tags$b("Median House Value (Factor)")),
                            tags$li(tags$b("Median Income (Factor)")),
                            tags$li(tags$b("Median Age (Factor)")),
                            tags$li(tags$b("Total Rooms (Factor)")),
                            tags$li(tags$b("Total Bedrooms (Factor)")),
                            tags$li(tags$b("Population (Factor)")),
                            tags$li(tags$b("Households (Factor)")),
                            tags$li(tags$b("Latitude (Factor)")),
                            tags$li(tags$b("Longitude (Factor)")), 
                            tags$li(tags$b("Distance to Coast (Factor)")),
                            tags$li(tags$b("Distance to Los Angeles (Factor)")),
                            tags$li(tags$b("Distance to San Diego (Factor)")),
                            tags$li(tags$b("Distance to San Jose (Factor)")),
                            tags$li(tags$b("Distance to San Francisco (Factor)"))
                        ))
                    ), # end tabPanel "data"
                    
                    tabPanel("Feature",
                        h3("About"),
                        h4("The About page introduces the purpose of this Shiny app, and provides basic background information on the dataset used in the analysis."),
                        br(),
                        h3("Data"),
                        h4("The Data page give users the ability to view raw data in data table format. Users can filter rows of the data by selecting the ranges of any variable, and/or choose different variables for includsion in data table. Outputs include searchable and sortable data table which can be downloaded."),
                        br(),
                        h3("Data Exploration"),
                        h4("The Data Exploration page allow users to create numerical and graphical summaries using the variables of their choosing. Users can change the variables and filter rows to produce graphical plots and summaries. There are 3 types of plots available: scatterplot, histogram and boxplot, users can utilize mouse input to hover, pan, zoom, download plot as .png, etc. There are 3 types of numerical summaries users can create: basic summary on any variable, correlation summary on multiple variables, and frequency table of counts."),
                        br(),
                        h3("Modeling"),
                        h4("The Modeling page allow users to learn about 3 types of supervised learning method models: multiple linear regression, regression tree, and random forest. After selecting method-specific inputs and tuning parameters, users can then use any of the 3 models to fit on a specified proportion of data (called training set). Outputs include fit statistics (root mean squared error (RMSE)) on training and test sets for each model, model fit summaries in numerical and plot forms, and an interface to use models for prediction.")
                    ) # end tabPanel "feature"
                )
        ), # end "about" tab
        
        #_____________________________________________________________________________________
        
        # start "data" table tab
        tabItem(tabName = "data",
                fluidRow(
                    column(3,
                           box(width = 12, title = "Select Variables",
                               checkboxGroupInput(inputId = "select_variables_dt",
                                                  label = "Select Variables to Include",
                                                  choices = list(
                                                      "Median House Value" = "Median_House_Value",
                                                      "Median Income" = "Median_Income",
                                                      "Median Age" = "Median_Age",
                                                      "Total Rooms" = "Tot_Rooms",
                                                      "Total Bedrooms" = "Tot_Bedrooms",
                                                      "Population" = "Population",
                                                      "Households" = "Households",
                                                      "Latitude" = "Latitude",
                                                      "Longitude" = "Longitude",
                                                      "Distance to the Coast" = "Distance_to_coast",
                                                      "Distance to Los Angeles" = "Distance_to_LA",
                                                      "Distance to San Diego" = "Distance_to_SanDiego",
                                                      "Distance to San Jose" = "Distance_to_SanJose",
                                                      "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                                  selected = list(
                                                      "Median House Value" = "Median_House_Value",
                                                      "Median Income" = "Median_Income",
                                                      "Median Age" = "Median_Age",
                                                      "Total Rooms" = "Tot_Rooms",
                                                      "Total Bedrooms" = "Tot_Bedrooms",
                                                      "Population" = "Population",
                                                      "Households" = "Households"
                                                  )
                               )
                           ), # end box "select variables"
                           box(width = 12, title = "Filter Variable Range",
                               #checkboxGroupInput(inputId = "select_response_factor",
                                #                  label = "Filter Median House Value Range (US$)",
                                 #                 choices = list(
                                  #                    "High: 264,725 - 500,001",
                                   #                   "Medium High: 179,700 - 264,724",
                                    #                  "Medium Low: 119,600 - 179,699",
                                     #                 "Low: 14,999 - 119,599"),
                                      #            selected = list(
                                       #               "High: 264,725 - 500,001",
                                        #              "Medium High: 179,700 - 264,724",
                                         #             "Medium Low: 119,600 - 179,699",
                                          #            "Low: 14,999 - 119,599")),
                               sliderInput(inputId = "data_filter_response",
                                           label = "Median House Value (US$)",
                                           min = 14999, max = 500001, value = c(14999, 500001)),
                               sliderInput(inputId = "data_filter_income",
                                           label = "Median Income (10k US$)",
                                           min = 0.4999, max = 15.0001, value = c(0.4999, 15.0001)),
                               sliderInput(inputId = "data_filter_age",
                                           label = "Median Age (years)",
                                           min = 1.00, max = 52.00, value = c(1.00, 52.00)),
                               sliderInput(inputId = "data_filter_rooms",
                                           label = "Total Rooms",
                                           min = 2, max = 39320, value = c(2, 39320)),
                               sliderInput(inputId = "data_filter_bedrooms",
                                           label = "Total Bedrooms",
                                           min = 1.0, max = 6445.0, value = c(1.0, 6445.0)),
                               sliderInput(inputId = "data_filter_population",
                                           label = "Population",
                                           min = 3, max = 35682, value = c(3, 35682)),
                               sliderInput(inputId = "data_filter_households",
                                           label = "Households",
                                           min = 1.0, max = 6082.0, value = c(1.0, 6082.0)),
                               sliderInput(inputId = "data_filter_latitude",
                                           label = "Latitude (°)",
                                           min = 32.54, max = 41.95, value = c(32.54, 41.95)),
                               sliderInput(inputId = "data_filter_longitude",
                                           label = "Longitude (°)",
                                           min = -124.3, max = -114.3, value = c(-124.3, -114.3)),
                               sliderInput(inputId = "data_filter_coast",
                                           label = "Distance to Coast (meters)",
                                           min = 120.7, max = 333804.7, value = c(120.7, 333804.7)),
                               sliderInput(inputId = "data_filter_la",
                                           label = "Distance to Los Angeles (meters)",
                                           min = 420.6, max = 1018260.1, value = c(420.6, 1018260.1)),
                               sliderInput(inputId = "data_filter_sd",
                                           label = "Distance to San Diego (meters)",
                                           min = 484.9, max = 1196919.3, value = c(484.9, 1196919.3)),
                               sliderInput(inputId = "data_filter_sj",
                                           label = "Distance to San Jose (meters)",
                                           min = 569.4, max = 836762.7, value = c(569.4, 836762.7)),
                               sliderInput(inputId = "data_filter_sf",
                                           label = "Distance to San Francisco (meters)",
                                           min = 456.1, max = 903627.7, value = c(456.1, 903627.7))
                               
                           ) # end box 
                    ), # end column 3
                    column(9,
                           downloadButton(outputId = "dt_download", label = "Data Download"),
                           br(),
                           br(),
                           DTOutput(outputId = "dt_table"),
                           p("Due to width restriction, including 9+ variables may cause the data table to run off screen. Please consider downloading the data table as .csv file if this issue arises.")
                    ) # end column 9

                ) # end fluidRow

        ), # end "data" table tab
        
        #_____________________________________________________________________________________
        
        # start "explore" tab
        tabItem(tabName = "explore",
                fluidRow(
                    column(3,
                           box(width = 12, title = "Plot Parameters",
                               selectInput(inputId = "select_plot",
                                           label = tags$b("Select Plot Type",
                                                          style = "color:maroon;, font-size: 15px;"),
                                           choices = list("Scatterplot",
                                                          "Histogram",
                                                          "Boxplot")),
                               conditionalPanel(
                                   condition = "input.select_plot == 'Scatterplot'",
                                   selectInput(inputId = "scatter_x",
                                               label = "X-axis Variable",
                                               choices = list(
                                                   "Median House Value" = "Median_House_Value",
                                                   "Median Income" = "Median_Income",
                                                   "Median Age" = "Median_Age",
                                                   "Total Rooms" = "Tot_Rooms",
                                                   "Total Bedrooms" = "Tot_Bedrooms",
                                                   "Population" = "Population",
                                                   "Households" = "Households",
                                                   "Latitude" = "Latitude",
                                                   "Longitude" = "Longitude",
                                                   "Distance to the Coast" = "Distance_to_coast",
                                                   "Distance to Los Angeles" = "Distance_to_LA",
                                                   "Distance to San Diego" = "Distance_to_SanDiego",
                                                   "Distance to San Jose" = "Distance_to_SanJose",
                                                   "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                               selected = "Median_Income"),
                                   selectInput(inputId = "scatter_y",
                                               label = "Y-axis Variable",
                                               choices = list(
                                                   "Median House Value" = "Median_House_Value",
                                                   "Median Income" = "Median_Income",
                                                   "Median Age" = "Median_Age",
                                                   "Total Rooms" = "Tot_Rooms",
                                                   "Total Bedrooms" = "Tot_Bedrooms",
                                                   "Population" = "Population",
                                                   "Households" = "Households",
                                                   "Latitude" = "Latitude",
                                                   "Longitude" = "Longitude",
                                                   "Distance to the Coast" = "Distance_to_coast",
                                                   "Distance to Los Angeles" = "Distance_to_LA",
                                                   "Distance to San Diego" = "Distance_to_SanDiego",
                                                   "Distance to San Jose" = "Distance_to_SanJose",
                                                   "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                               selected = "Median_House_Value"),
                                   selectInput(inputId = "scatter_z_factor",
                                               label = "Variable to Color By",
                                               choices = list(
                                                   "Median House Value (Factor)" = "Median_House_Value_Factor",
                                                   "Median Income (Factor)" = "Median_Income_Factor",
                                                   "Median Age (Factor)" = "Median_Age_Factor",
                                                   "Total Rooms (Factor)" = "Tot_Rooms_Factor",
                                                   "Total Bedrooms (Factor)" = "Tot_Bedrooms_Factor",
                                                   "Population (Factor)" = "Population_Factor",
                                                   "Households (Factor)" = "Households_Factor",
                                                   "Latitude (Factor)" = "Latitude_Factor",
                                                   "Longitude (Factor)" = "Longitude_Factor",
                                                   "Distance to the Coast (Factor)" = "Distance_to_coast_Factor",
                                                   "Distance to Los Angeles (Factor)" = "Distance_to_LA_Factor",
                                                   "Distance to San Diego (Factor)" = "Distance_to_SanDiego_Factor",
                                                   "Distance to San Jose (Factor)" = "Distance_to_SanJose_Factor",
                                                   "Distance to San Francisco (Factor)" = "Distance_to_SanFrancisco_Factor"),
                                               selected = "Median_Age_Factor")
                               ), # end conditionalPanel "scatterplot"
                               
                               conditionalPanel(
                                   condition = "input.select_plot == 'Histogram'",
                                   selectInput(inputId = "histo_x",
                                               label = "Select a Variable",
                                               choices = list(
                                                   "Median House Value" = "Median_House_Value",
                                                   "Median Income" = "Median_Income",
                                                   "Median Age" = "Median_Age",
                                                   "Total Rooms" = "Tot_Rooms",
                                                   "Total Bedrooms" = "Tot_Bedrooms",
                                                   "Population" = "Population",
                                                   "Households" = "Households",
                                                   "Latitude" = "Latitude",
                                                   "Longitude" = "Longitude",
                                                   "Distance to the Coast" = "Distance_to_coast",
                                                   "Distance to Los Angeles" = "Distance_to_LA",
                                                   "Distance to San Diego" = "Distance_to_SanDiego",
                                                   "Distance to San Jose" = "Distance_to_SanJose",
                                                   "Distance to San Francisco" = "Distance_to_SanFrancisco"))
                               ), # end conditionalPanel "histogram"
                               
                               conditionalPanel(
                                   condition = "input.select_plot == 'Boxplot'",
                                   selectInput(inputId = "box_x_factor",
                                               label = "Select X Variable",
                                               choices = list(
                                                   "Median House Value (Factor)" = "Median_House_Value_Factor",
                                                   "Median Income (Factor)" = "Median_Income_Factor",
                                                   "Median Age (Factor)" = "Median_Age_Factor",
                                                   "Total Rooms (Factor)" = "Tot_Rooms_Factor",
                                                   "Total Bedrooms (Factor)" = "Tot_Bedrooms_Factor",
                                                   "Population (Factor)" = "Population_Factor",
                                                   "Households (Factor)" = "Households_Factor",
                                                   "Latitude (Factor)" = "Latitude_Factor",
                                                   "Longitude (Factor)" = "Longitude_Factor",
                                                   "Distance to the Coast (Factor)" = "Distance_to_coast_Factor",
                                                   "Distance to Los Angeles (Factor)" = "Distance_to_LA_Factor",
                                                   "Distance to San Diego (Factor)" = "Distance_to_SanDiego_Factor",
                                                   "Distance to San Jose (Factor)" = "Distance_to_SanJose_Factor",
                                                   "Distance to San Francisco (Factor)" = "Distance_to_SanFrancisco_Factor"),
                                               selected = "Median_House_Value_Factor"),
                                   selectInput(inputId = "box_y",
                                               label = "Select Y Variable",
                                               choices = list(
                                                   "Median House Value" = "Median_House_Value",
                                                   "Median Income" = "Median_Income",
                                                   "Median Age" = "Median_Age",
                                                   "Total Rooms" = "Tot_Rooms",
                                                   "Total Bedrooms" = "Tot_Bedrooms",
                                                   "Population" = "Population",
                                                   "Households" = "Households",
                                                   "Latitude" = "Latitude",
                                                   "Longitude" = "Longitude",
                                                   "Distance to the Coast" = "Distance_to_coast",
                                                   "Distance to Los Angeles" = "Distance_to_LA",
                                                   "Distance to San Diego" = "Distance_to_SanDiego",
                                                   "Distance to San Jose" = "Distance_to_SanJose",
                                                   "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                               selected = "Median_Income"),
                                   selectInput(inputId = "box_z_factor",
                                               label = "Select a Variable to find Mean",
                                               choices = list(
                                                   "Median House Value (Factor)" = "Median_House_Value_Factor",
                                                   "Median Income (Factor)" = "Median_Income_Factor",
                                                   "Median Age (Factor)" = "Median_Age_Factor",
                                                   "Total Rooms (Factor)" = "Tot_Rooms_Factor",
                                                   "Total Bedrooms (Factor)" = "Tot_Bedrooms_Factor",
                                                   "Population (Factor)" = "Population_Factor",
                                                   "Households (Factor)" = "Households_Factor",
                                                   "Latitude (Factor)" = "Latitude_Factor",
                                                   "Longitude (Factor)" = "Longitude_Factor",
                                                   "Distance to the Coast (Factor)" = "Distance_to_coast_Factor",
                                                   "Distance to Los Angeles (Factor)" = "Distance_to_LA_Factor",
                                                   "Distance to San Diego (Factor)" = "Distance_to_SanDiego_Factor",
                                                   "Distance to San Jose (Factor)" = "Distance_to_SanJose_Factor",
                                                   "Distance to San Francisco (Factor)" = "Distance_to_SanFrancisco_Factor"),
                                               selected = "Median_Age_Factor")
                               ) # end conditionalPanel "boxplot"
                           ), # end box "plot parameters"
                           
                           box(width = 12, title = "Numerical Summaries",
                               selectInput(inputId = "explore_summaries_type",
                                           label = tags$b("Type of Numerical Summary",
                                                          style = "color:maroon;, font-size: 15px;"),
                                           choices = list("Basic Summary",
                                                          "Correlation Summary",
                                                          "Frequency Table")),
                               conditionalPanel(
                                   condition = "input.explore_summaries_type == 'Basic Summary'",
                                   selectInput(inputId = "summaries_var",
                                               label = "Select a Variable",
                                               choices = list(
                                                   "Median House Value" = "Median_House_Value",
                                                   "Median Income" = "Median_Income",
                                                   "Median Age" = "Median_Age",
                                                   "Total Rooms" = "Tot_Rooms",
                                                   "Total Bedrooms" = "Tot_Bedrooms",
                                                   "Population" = "Population",
                                                   "Households" = "Households",
                                                   "Latitude" = "Latitude",
                                                   "Longitude" = "Longitude",
                                                   "Distance to the Coast" = "Distance_to_coast",
                                                   "Distance to Los Angeles" = "Distance_to_LA",
                                                   "Distance to San Diego" = "Distance_to_SanDiego",
                                                   "Distance to San Jose" = "Distance_to_SanJose",
                                                   "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                               selected = "Median_House_Value")
                               ), # end conditionalPanel "basic summary"
                               
                               conditionalPanel(
                                   condition = "input.explore_summaries_type == 'Correlation Summary'",
                                   checkboxGroupInput(inputId = "summaries_corr",
                                                      label = "Select Variable(s) to See Correlation",
                                                      choices = list(
                                                          "Median House Value" = "Median_House_Value",
                                                          "Median Income" = "Median_Income",
                                                          "Median Age" = "Median_Age",
                                                          "Total Rooms" = "Tot_Rooms",
                                                          "Total Bedrooms" = "Tot_Bedrooms",
                                                          "Population" = "Population",
                                                          "Households" = "Households",
                                                          "Latitude" = "Latitude",
                                                          "Longitude" = "Longitude",
                                                          "Distance to the Coast" = "Distance_to_coast",
                                                          "Distance to Los Angeles" = "Distance_to_LA",
                                                          "Distance to San Diego" = "Distance_to_SanDiego",
                                                          "Distance to San Jose" = "Distance_to_SanJose",
                                                          "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                                      selected = list("Median House Value" = "Median_House_Value",
                                                                      "Median Income" = "Median_Income",
                                                                      "Median Age" = "Median_Age")
                                    ) # end checkboxGroupInput
                                                   
                               ), # end conditionalPanel "correlation summary"
                               
                               conditionalPanel(
                                   condition = "input.explore_summaries_type == 'Frequency Table'",
                                   selectInput(inputId = "summaries_freq",
                                               label = "Select a Variable",
                                               choices = list(
                                                   "Median House Value" = "Median_House_Value",
                                                   "Median Income" = "Median_Income",
                                                   "Median Age" = "Median_Age",
                                                   "Total Rooms" = "Tot_Rooms",
                                                   "Total Bedrooms" = "Tot_Bedrooms",
                                                   "Population" = "Population",
                                                   "Households" = "Households",
                                                   "Latitude" = "Latitude",
                                                   "Longitude" = "Longitude",
                                                   "Distance to the Coast" = "Distance_to_coast",
                                                   "Distance to Los Angeles" = "Distance_to_LA",
                                                   "Distance to San Diego" = "Distance_to_SanDiego",
                                                   "Distance to San Jose" = "Distance_to_SanJose",
                                                   "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                               selected = "Median_House_Value"),
                                   sliderInput(inputId = "freq_breaks",
                                               label = "Select Number of Breaks",
                                               min = 2, max = 10, value = 4, step = 1)
                               ), # end conditionalPanel "frequency table"
                           ), # end box "numerical summaries"
                           
                           box(width = 12, title = "Filter by Variables",
                               
                               checkboxInput(inputId = "filter_response_check",
                                             label = tags$b("Filter by Range of Median House Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_response_check == 1",
                                   sliderInput(inputId = "explore_filter_response",
                                               label = "Median House Value (US$)",
                                               min = 14999, max = 500001, value = c(14999, 500001))
                               ),
                               
                               checkboxInput(inputId = "filter_income_check",
                                             label = tags$b("Filter by Range of Median Income Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_income_check == 1",
                                   sliderInput(inputId = "explore_filter_income",
                                               label = "Median Income (10k US$)",
                                               min = 0.4999, max = 15.0001, value = c(0.4999, 15.0001))
                               ),
                               
                               checkboxInput(inputId = "filter_age_check",
                                             label = tags$b("Filter by Range of Median Age Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_age_check == 1",
                                   sliderInput(inputId = "explore_filter_age",
                                               label = "Median Age (years)",
                                               min = 1.00, max = 52.00, value = c(1.00, 52.00))
                               ),
                               
                               checkboxInput(inputId = "filter_rooms_check",
                                             label = tags$b("Filter by Range of Total Rooms Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_rooms_check == 1",
                                   sliderInput(inputId = "explore_filter_rooms",
                                               label = "Total Rooms",
                                               min = 2, max = 39320, value = c(2, 39320))
                               ),
                               
                               checkboxInput(inputId = "filter_bedrooms_check",
                                             label = tags$b("Filter by Range of Total Bedrooms Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_bedrooms_check == 1",
                                   sliderInput(inputId = "explore_filter_bedrooms",
                                               label = "Total Bedrooms",
                                               min = 1.0, max = 6445.0, value = c(1.0, 6445.0))
                               ),
                               
                               checkboxInput(inputId = "filter_population_check",
                                             label = tags$b("Filter by Range of Population Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_population_check == 1",
                                   sliderInput(inputId = "explore_filter_population",
                                               label = "Population",
                                               min = 3, max = 35682, value = c(3, 35682))
                               ),
                               
                               checkboxInput(inputId = "filter_households_check",
                                             label = tags$b("Filter by Range of Households Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_households_check == 1",
                                   sliderInput(inputId = "explore_filter_households",
                                               label = "Households",
                                               min = 1.0, max = 6082.0, value = c(1.0, 6082.0))
                               ),
                               
                               checkboxInput(inputId = "filter_latitude_check",
                                             label = tags$b("Filter by Range of Latitude Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_latitude_check == 1",
                                   sliderInput(inputId = "explore_filter_latitude",
                                               label = "Latitude (°)",
                                               min = 32.54, max = 41.95, value = c(32.54, 41.95))
                               ),
                               
                               checkboxInput(inputId = "filter_longitude_check",
                                             label = tags$b("Filter by Range of Longitude Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_longitude_check == 1",
                                   sliderInput(inputId = "explore_filter_longitude",
                                               label = "Longitude (°)",
                                               min = -124.3, max = -114.3, value = c(-124.3, -114.3))
                               ),
                               
                               checkboxInput(inputId = "filter_coast_check",
                                             label = tags$b("Filter by Range of Distance to the Coast", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_coast_check == 1",
                                   sliderInput(inputId = "explore_filter_coast",
                                               label = "Distance to Coast (meters)",
                                               min = 120.7, max = 333804.7, value = c(120.7, 333804.7))
                               ),
                               
                               checkboxInput(inputId = "filter_la_check",
                                             label = tags$b("Filter by Range of Distance to Los Angeles", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "filter_la_check == 1",
                                   sliderInput(inputId = "explore_filter_la",
                                               label = "Distance to Los Angeles (meters)",
                                               min = 420.6, max = 1018260.1, value = c(420.6, 1018260.1))
                               ),
                               
                               checkboxInput(inputId = "filter_sd_check",
                                             label = tags$b("Filter by Range of Distance to San Diego", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_sd_check == 1",
                                   sliderInput(inputId = "explore_filter_sd",
                                               label = "Distance to San Diego (meters)",
                                               min = 484.9, max = 1196919.3, value = c(484.9, 1196919.3))
                               ),
                               
                               checkboxInput(inputId = "filter_sj_check",
                                             label = tags$b("Filter by Range of Distance to San Jose", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_sj_check == 1",
                                   sliderInput(inputId = "explore_filter_sj",
                                               label = "Distance to San Jose (meters)",
                                               min = 569.4, max = 836762.7, value = c(569.4, 836762.7))
                               ),
                               
                               checkboxInput(inputId = "filter_sf_check",
                                             label = tags$b("Filter by Range of Distance to San Francisco", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_sf_check == 1",
                                   sliderInput(inputId = "explore_filter_sf",
                                               label = "Distance to San Francisco (meters)",
                                               min = 456.1, max = 903627.7, value = c(456.1, 903627.7))
                               )
                               
                           ) # end box "filter variables"
                        
                    ), # end column 3
                    column(9,
                           #box(width = 12,
                            #   dataTableOutput(outputId = "explore_table")
                           #),
                           box(width = 12,
                               plotlyOutput(outputId = "explore_plot") %>% withSpinner(color="#800000")
                               
                           ) # end box
                    ), # end column 9
                    column(9,
                           h4("Numerical Summaries"),
                           dataTableOutput(outputId = "explore_numerical_summary"),
                           downloadButton(outputId = "summary_download", label = "Summary Download"),
                           p("Due to width restriction, for the Correlation Summary table, including 8+ variables may cause the data table to run off screen. Please consider downloading the numerical summary as .csv file if this issue arises.")
                        
                    ) # end column 
                    
                ) # end fluidRow
            
        ), # end explore tab
        
        #_____________________________________________________________________________________
        
        # start "model" tab
        tabItem(tabName = "model",
                tabsetPanel(
                    tabPanel("Modeling Info",
                             h3("About Multiple Linear Regression Model"),
                             h4("Multiple linear regression model is a type of regression model under supervised learning methods. Multiple linear regression model is about using several explanatory variables to predict the outcome of the response variable. We're trying to model the linear relationship between the explanatory variables and the response variable. Multiple linear regression is an extension of simple linear regression model but can include more explanatory variables and/or higher ordered terms. An example of what a multiple linear regression formula with 2 first order predictor variables and their interaction looks like is:"),
                             h4(withMathJax(helpText("$$Y_i=\\beta_0+\\beta_1x_{1i}+\\beta_2x_{2i}+\\beta_3x_{1i}x_{2i}+...+E_i$$"))),
                             h4("For all 3 models we use in this app, we'll be comparing the root mean squared error (RMSE) statistic to determine how well a model is doing. The formula for RMSE is:"),
                             h4(withMathJax(helpText("$$RMSE = \\sqrt{\\frac{\\sum_{i=1}^n(y_i-\\hat{y}_i)^2}{n}}$$"))),
                             h4(tags$b("Benefits:"),"Multiple linear regression models are usually easier to implement and use less time and resources. And by using multiple linear regression, it can lead to a more accurate and precise understanding of the association of each individual predictor with the response. It also gives us an understanding of the association of all the predictors as a whole with the response, and the association between the various predictor variables themselves."),
                             h4(tags$b("Drawbacks:"),"For multiple linear regression models there are assumptions for inference we need to check, such as the homogeneity of the variance, independence of observations, whether data follow a normal distribution, linearity of the best fit line, etc. Also, because we can use many different forms of predictors in multiple linear regression (first ordered terms, quadratic, interactions, etc.) it can sometimes be difficult to determine which predictors to fit and automating this selection can be difficult. For example, we don't really want to have an interaction term without having both of the main effects also included, we don't want to have a quadratic term in the model without having the linear term in it."),
                             br(),
                             h3("About Regression Tree Model"),
                             h4("Regression tree is a type of tree based model under supervised learning methods. For tree based methods, we take the predictor space and split them into regions, then develop different predictions based on the different regions. For the regression tree specifically, we are predicting a continuous response. If we want to model a constant within each region, the optimal constant to use is the mean within that particular region. Thus, we use the mean of all the observations in a given predictor space region as the prediction, and will use the root mean squared error (RMSE) to judge how well the model performs."),
                             h4("A crucial part of fitting a regression tree is picking where to split up the regions. What regression tree does is it takes every possible value for each predictor we're fitting, find the residual sums of squares (RSS), then try to minimize this RSS based on using the mean value for each possible split. We're trying to minimize this equation:"),
                             h4(withMathJax(helpText("$$\\sum_{i:x_i \\in R_1 (j,s)} (y_i + \\bar{y}_{R_1})^2 + \\sum_{i:x_i \\in R_2 (j,s)} (y_i + \\bar{y}_{R_2})^2$$"))),
                             h4("For each region, we'd consider all possible combinations of j and s values and find a pair of j and s that'd minimize the sum of squared errors across all the points in each one of those regions."),
                             h4(withMathJax(helpText("$$R_1(j,s) = {x|x_j <s}$$"))),
                             h4(withMathJax(helpText("$$R_2(j,s) = {x|x_j \\ge s}$$"))),
                             h4("So we're trying to find 2 regions (R1 and R2) where we find a value s that we're splitting on, then go across all possible predictors (j represents which predictor we're looking at, s is which value we're using to split that predictor)."),
                             h4("Once a split is chosen, we go through the same process to create a second split. Keep splitting and splitting to grow a big tree that has many nodes (bottom most values), then prune this tree back using some algorithm (most common is cost-complexity pruning, which is done so we don't overfit to the training data). If we have a really big tree then our tree will generally have low amount of bias but high amount of variance, so by pruning the tree back we'd decrease the variance but increase the bias, balancing both will hopefully gain overall prediction strength. To choose how far to prune back our tree, we can use a method such as doing training/test error or using the cross-validation. For the purpose of this shiny app, we're using the caret package, we'll just need to consider which variables to fit, how many folds to use in cross-validation, and specify tuning parameter, the caret package will output a result and help us see which model had the lowest RMSE value."),
                             h4(tags$b("Benefits:"),"Tree based methods (such as the regression tree) are great because they're easy to read, usually no instructions are needed for people to read the plots as the concepts behind them are intuitive. Predictors used in the model fit do not need to be scaled. No statistical assumptions are necessary to fit these regression tree models. Compared with a linear regression model where a more rigid structure is fit (aka fitting a line/curve between 2 variables), the regression tree splits up the predictor region into different regions, and by making different predictions for different regions, the regression tree method is more flexible. For tree based methods there are built in variable selection, so we do not need to worry about fitting interaction terms as the general nature of the trees allow them to find interaction effects on their own."),
                             h4(tags$b("Drawbacks:"), "Small changes in data can vastly change the tree (thus change the final tree we end up with), because of this regression tree models tend to have high variance. There's no optimal algorithm designed for fitting these trees. Greedy algorithm is greedy because it's only looking one step ahead (what's the best possible split right now, not what's the best possible 2 or 3 splits we can do at once). Usually an extra step in the modeling process is needed because we need to prune the tree back. Regression tree methods do not perform well for prediction purposes, instead we can use ensemble learning methods where we fit lots of trees then average their predictions, which we'll discuss in the Random Forest Model section below."),
                             br(),
                             h3("About Random Forest Model"),
                             h4("Random forest is another type of tree based model under the supervised learning methods. To understand the random forest model, we need to first understand bootstrap. Bootstrap is the idea of getting multiple samples from the same population. If we have a fitted model, we can create random samples from that model or treat the data as a population and sample from that. We get 1 bootstrap sample, apply the model to it, repeat this process over and over again to see behavior of the model over many bootstrap samples. For a random forest, we'd get a bootstrap sample (with replacement) from the original population and fit a tree with a random subset of predictors to this bootstrap sample, and repeat this process many times. When we have a new observation we want to predict for, we predict it for every one of the trees (fit on bootstrap samples) and take the average of these predictions as the final prediction. Can look at variable importance measures which will give us an idea of which predictors were most important for fitting our final models."),
                             h4("By randomly selecting a subset of predictors to fit, we can improve the test error rate. The crucial part of doing random forest is figuring out how many of our predictors to include when doing a particular tree fit. Usually we pick m number of predictors from p total predictors using this formula:"),
                             h4(withMathJax(helpText("$$m=\\frac{p}{3}$$"))),
                             h4("We can also determine what m should be through the out-of-bag error idea where we can fit the trees for many different values of m, then choose which one was best based on the out-of-bag error rate. For the purpose of this shiny app, we're using the caret package, we'll just need to consider which variables to fit, how many folds to use in cross-validation, and specify what values of m we want to try to fit to, the caret package will do the rest to help us determine which model had the lowest RMSE value."),
                             h4(tags$b("Benefits:"),"By averaging the tree predictions across many samples we decrease the variance in our prediction but we do lose interpretability, so we can no longer say we're splitting on a variable to get our results. This does improve prediction accuracy greatly. With random forest models we do not need to worry about pruning, we can just fit a full tree on a sample. Random forest (along with bagged tree and boosted tree) prediction will usually outperform regression models and will certainly outperform single tree models."),
                             h4(tags$b("Drawbacks:"), "By doing random forest instead of regression tree, we'd lose the interpretability of the trees, but if we mostly care about prediction then losing the interpretability of the trees is not a big issue. However, random forest models are more time-consuming to fit and will usually require more resources, so the overhead of fitting the data could be troublesome especially when there's a lot of data."),
                        
                    ), # end tabPanel "modeling info"
                    tabPanel("Model Fitting",
                             fluidRow(
                                 column(3,
                                        box(width = 12,
                                            title = "Model Parameters",
                                            sliderInput(inputId = "train_select",
                                                        label = "Training Data (% of Data Set)",
                                                        min = 10, max = 100, step = 5, value = 20
                                            ),
                                            tags$style("p {color:red; font-size:12px; font-style:italic;}"),
                                            p("Due to the size of the dataset (20,640 total records), default training set is only 20% to avoid long processing time. At the default setting, it takes around 2 minutes to see results. Please be aware increasing training set percentage, adding more variables, and altering other tuning parameter settings will require longer processing time."),
                                            checkboxGroupInput(inputId = "predictor_select",
                                                               label = "Select Predictor Variables",
                                                               choices = c("Median Income" = "Median_Income",
                                                                           "Median Age" = "Median_Age",
                                                                           "Total Rooms" = "Tot_Rooms",
                                                                           "Total Bedrooms" = "Tot_Bedrooms",
                                                                           "Population" = "Population",
                                                                           "Households" = "Households",
                                                                           "Latitude" = "Latitude",
                                                                           "Longitude" = "Longitude",
                                                                           "Distance to the Coast" = "Distance_to_coast",
                                                                           "Distance to Los Angeles" = "Distance_to_LA",
                                                                           "Distance to San Diego" = "Distance_to_SanDiego",
                                                                           "Distance to San Jose" = "Distance_to_SanJose",
                                                                           "Distance to San Francisco" = "Distance_to_SanFrancisco"),
                                                               selected = list(
                                                                   "Median Income" = "Median_Income",
                                                                   "Median Age" = "Median_Age") 
                                            )
                                        ), # end box
                                        box(width = 12,
                                            title = "Model Type",
                                            checkboxInput(inputId = "model_select_mlr",
                                                          label = tags$b("Multiple Linear Regression", style = "color:maroon; font-size: 18px;"),
                                                          value = TRUE),
                                            conditionalPanel(
                                                condition = "input.model_select_mlr == 1",
                                                checkboxInput(inputId = "var_interact", 
                                                              label = "Interact Variables", 
                                                              value = FALSE)
                                            ),
                                            checkboxInput(inputId = "model_select_tree",
                                                          label = tags$b("Regression Tree", style = "color:maroon; font-size: 18px;"),
                                                          value = TRUE),
                                            conditionalPanel(
                                                condition = "input.model_select_tree == 1",
                                                numericInput(inputId = "cp_min",
                                                             label = "Complexity Parameter (min. value)",
                                                             value = 0.01,
                                                             min = 0.001, max = 0.02, step = 0.005),
                                                numericInput(inputId = "cp_max",
                                                             label = "Complexity Parameter (max. value)",
                                                             value = 0.03,
                                                             min = 0.03, max = 0.1, step = 0.005),
                                                numericInput(inputId = "cp_by",
                                                             label = "Step by",
                                                             value = 0.001,
                                                             min = 0.001, max = 0.005, step = 0.001)
                                            ),
                                            checkboxInput(inputId = "model_select_rf",
                                                          label = tags$b("Random Forest", style = "color:maroon; font-size: 18px;"),
                                                          value = TRUE),
                                            conditionalPanel(
                                                condition = "input.model_select_rf == 1",
                                                sliderInput(inputId = "mtry",
                                                            label = "# of Randomly Selected Predictors",
                                                            min = 1, max = 13, value = 2, step = 1)
                                            ),
                                            conditionalPanel(
                                                condition = "(input.model_select_tree | input.model_select_rf) == 1",
                                                checkboxInput(inputId = "cv",
                                                              label = "Cross Validation",
                                                              value = TRUE),
                                                conditionalPanel(
                                                    condition = "input.cv == 1",
                                                    sliderInput(inputId = "folds",
                                                                label = "Folds",
                                                                min = 2, max = 10, value = 5))
                                            ),
                                            actionButton(inputId = "submit_models",
                                                         label = "Fit Models on Training Data",
                                                         style="color:#ffffff; background-color:#800000;")
                                        ) # end box
                                ), # end column 3
                                column(9, 
                                       h3("Training Data RMSE"),
                                       h4(strong("Multiple Linear Regression")),
                                       verbatimTextOutput("rmse_training_mlr") %>% withSpinner(color="#800000"), 
                                       verbatimTextOutput("result_training_mlr"),
                                       h4(strong("Regression Tree")),
                                       verbatimTextOutput("rmse_training_tree"),
                                       verbatimTextOutput("result_training_tree"),
                                       h4(strong("Random Forest")),
                                       verbatimTextOutput("rmse_training_rf"),
                                       verbatimTextOutput("result_training_rf"),
                                       br(),
                                       h3("Test Data Results"),
                                       h4(strong("Multiple Linear Regression")),
                                       verbatimTextOutput("rmse_testing_mlr"),
                                       h4(strong("Regression Tree")),
                                       verbatimTextOutput("rmse_testing_tree"),
                                       h4(strong("Random Forest")),
                                       verbatimTextOutput("rmse_testing_rf"),
                                       br(),
                                       h3("Model Summary"),
                                       h4(strong("Multiple Linear Regression")),
                                       conditionalPanel(
                                           condition = "input.model_select_mlr == 1",
                                           verbatimTextOutput("summary_mlr")
                                       ),
                                       br(),
                                       h4(strong("Regression Tree")),
                                       conditionalPanel(
                                           condition = "input.model_select_tree == 1",
                                           plotOutput(outputId = "summary_tree")
                                       ),
                                       br(),
                                       h4(strong("Random Forest")),
                                       conditionalPanel(
                                           condition = "input.model_select_rf == 1",
                                           plotOutput(outputId = "summary_rf")
                                       ),
                                       h5(tags$b("%IncMSE"), " indicates percent increase in mean squared error (MSE), where larger the value of % increase in MSE means more important that variable was to the overall prediction.", tags$b("IncNodePurity"), " is increase in node purity is analogous to Gini-based importance, and is calculated based on the reduction in sum of squared errors whenever a variable is chosen to split. Higher values of increase in node purity also mean higher the importance of the variable in our model.")
                                    
                                ) # end column 9
                             ) # end of fluidRow
                        
                    ), # end tabPanel "model fitting"
                    tabPanel("Prediction",
                        fluidRow(
                            column(4,
                                   box(width = 12, title = "Enter Values to Predict Median House Value",
                                       numericInput(inputId = "predict_median_income",
                                                    label = "Median Income (10k USD$) [0 - 20]",
                                                    value = 3.5,
                                                    min = 0, max = 20),
                                       numericInput(inputId = "predict_median_age",
                                                    label = "Median Age (years) [1 - 60]",
                                                    value = 29,
                                                    min = 1, max = 60),
                                       numericInput(inputId = "predict_tot_rooms",
                                                    label = "Total # of Rooms (within a block) [1 - 40000]",
                                                    value = 2127,
                                                    min = 1, max = 40000),
                                       numericInput(inputId = "predict_tot_bedrooms",
                                                    label = "Total # of Bedrooms (within a block) [1 - 7000]",
                                                    value = 435,
                                                    min = 1, max = 7000),
                                       numericInput(inputId = "predict_population",
                                                    label = "Total # of People (within a block) [1 - 40000]",
                                                    value = 1166,
                                                    min = 1, max = 40000),
                                       numericInput(inputId = "predict_households",
                                                    label = "Total # of Households (within a block) [1 - 6500]",
                                                    value = 409,
                                                    min = 1, max = 6500),
                                       numericInput(inputId = "predict_latitude",
                                                    label = "Latitude (how far north) [32 - 45]",
                                                    value = 34.3,
                                                    min = 32, max = 45),
                                       numericInput(inputId = "predict_longitude",
                                                    label = "Longitude (how far west) [-125 - -110]",
                                                    value = -118,
                                                    min = -125, max = -110),
                                       numericInput(inputId = "predict_distance_coast",
                                                    label = "Distance to Coast (meters) [100 - 340000]",
                                                    value = 20000,
                                                    min = 100, max = 340000),
                                       numericInput(inputId = "predict_distance_la",
                                                    label = "Distance to Los Angeles (meters) [400 - 1020000]",
                                                    value = 175000,
                                                    min = 400, max = 1020000),
                                       numericInput(inputId = "predict_distance_sd",
                                                    label = "Distance to San Diego (meters) [480 - 1200000]",
                                                    value = 215000,
                                                    min = 480, max = 1200000),
                                       numericInput(inputId = "predict_distance_sj",
                                                    label = "Distance to San Jose (meters) [550 - 840000]",
                                                    value = 460000,
                                                    min = 550, max = 840000),
                                       numericInput(inputId = "predict_distance_sf",
                                                    label = "Distance to San Francisco (meters) [450 - 905000]",
                                                    value = 530000,
                                                    min = 450, max = 905000),
                                       selectInput(inputId = "predict_select_model",
                                                   label = "Select Model to Use for Prediction",
                                                   choices = c("Multiple Linear Regression",
                                                               "Regression Tree",
                                                               "Random Forest"),
                                                   selected = "Regression Tree"),
                                       actionButton(inputId = "submit_predict",
                                                    label = "Make Prediction",
                                                    style="color:#ffffff; background-color:#800000;"),
                                       p("(Be sure to fit model on training data first from the Model Fitting Tab before making a prediction.)")
                                   ) # end box
                            ), # end column 3
                            column(8,
                                box(width = 12,
                                    h3("Prediction for Median House Value (USD$)"),
                                    verbatimTextOutput(outputId = "predict_value")
                                ) # end box
                            ) # end column 9
                        ) # end fluidRow
                    ) # end tabPanel "prediction"
                        
                ) # end tabsetPanel
            
        ) # end "model" tab
        
    ) # end tabItems
) # end dashboardBody

#_____________________________________________________________________________________

# App arguments
dashboardPage(
    dashboardHeader(title = "CHP Data Analysis"),
    sidebar,
    body
)
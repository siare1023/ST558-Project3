library(ggplot2)
library(shinydashboard)
library(DT)
library(factoextra)
library(plotly)

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
                    tabPanel("Purpose"),
                    tabPanel("Data")
                )
        ), # end "about" tab
        
        #_____________________________________________________________________________________
        
        # start "data" table tab
        tabItem(tabName = "data",
                fluidRow(
                    column(3,
                           box(width = 12,
                               checkboxGroupInput(inputId = "select_variables_dt",
                                                  label = "Select Variables",
                                                  choices = list(
                                                      "Median House Value" = "Median_House_Value",
                                                      "Median Income" = "Median_Income",
                                                      "Median Age" = "Median_Age",
                                                      "Total Rooms" = "Tot_Rooms",
                                                      "Total Bedrooms" = "Tot_Bedrooms",
                                                      "Population" = "Population",
                                                      "Households" = "Households",
                                                      "Lattitude" = "Lattitude",
                                                      "Longitude" = "Longitude",
                                                      "Distance to the Coast" = "Distance_to_coast",
                                                      "Distance to Los Angeles" = "Distance_to_LA",
                                                      "Distance to San Diego" = "Distance_to_SanDiego",
                                                      "Distance to San Jose" = "Distance_to_SanJose",
                                                      "Distance to San Francisco" = "Distance_to_SanFrancisco"
                                                  ),
                                                  selected = list(
                                                      "Median House Value" = "Median_House_Value",
                                                      "Median Income" = "Median_Income",
                                                      "Median Age" = "Median_Age",
                                                      "Total Rooms" = "Tot_Rooms",
                                                      "Total Bedrooms" = "Tot_Bedrooms",
                                                      "Population" = "Population",
                                                      "Households" = "Households"
                                                  )
                               ),
                               checkboxGroupInput(inputId = "select_response_factor",
                                                  label = "Filter Median House Value Range (US$)",
                                                  choices = list(
                                                      "High: 264,725 - 500,001",
                                                      "Medium High: 179,700 - 264,724",
                                                      "Medium Low: 119,600 - 179,699",
                                                      "Low: 14,999 - 119,599"
                                                  ),
                                                  selected = list(
                                                      "High: 264,725 - 500,001",
                                                      "Medium High: 179,700 - 264,724",
                                                      "Medium Low: 119,600 - 179,699",
                                                      "Low: 14,999 - 119,599"
                                                  )
                               )
                           ) # end box
                    ), # end column 3
                    column(9,
                           downloadButton(outputId = "dt_download", label = "Data Download"),
                           br(),
                           br(),
                           DTOutput(outputId = "dt_table")
                    ) # end column 9
                    
                ) # end fluidRow

        ), # end "data" table tab
        
        #_____________________________________________________________________________________
        
        # start "explore" tab
        tabItem(tabName = "explore",
                
            
        ), # end explore tab
        
        #_____________________________________________________________________________________
        
        # start "model" tab
        tabItem(tabName = "model",
                tabsetPanel(
                    tabPanel("Modeling Info",
                             h3("About Multiple Linear Regression Model"),
                             h3("About Regression Tree Model"),
                             h3("About Random Forest Model")
                        
                    ), # end tabPanel "modeling info"
                    tabPanel("Model Fitting",
                             fluidRow(
                                 column(3,
                                        box(width = 12,
                                            title = "Model Parameters",
                                            sliderInput(inputId = "train_select",
                                                        label = "Training Data (% of Data Set)",
                                                        min = 50, max = 100, step = 5, value = 80
                                            ),
                                            checkboxGroupInput(inputId = "predictor_select",
                                                               label = "Select Predictor Variables",
                                                               choices = c("Median Income" = "median_income",
                                                                           "Median Age" = "median_age",
                                                                           "Total Rooms" = "tot_rooms",
                                                                           "Total Bedrooms" = "tot_bedrooms",
                                                                           "Population" = "population",
                                                                           "Households" = "households",
                                                                           "Lattitude" = "lattitude",
                                                                           "Longitude" = "longitude",
                                                                           "Distance to the Coast" = "distance_to_coast",
                                                                           "Distance to Los Angeles" = "distance_to_la",
                                                                           "Distance to San Diego" = "distance_to_sd",
                                                                           "Distance to San Jose" = "distance_to_sj",
                                                                           "Distance to San Francisco" = "distance_to_sf")
                                            )
                                        ), # end box
                                        box(width = 12,
                                            title = "Model Type",
                                            checkboxInput(inputId = "model_select_mlr",
                                                          label = tags$b("Multiple Linear Regression"),
                                                          value = FALSE),
                                            conditionalPanel(
                                                condition = "input.model_select_mlr == 1",
                                                checkboxInput(inputId = "var_interact", 
                                                              label = "Interact Variables", 
                                                              value = FALSE)
                                            ),
                                            checkboxInput(inputId = "model_select_tree",
                                                          label = tags$b("Regression Tree"),
                                                          value = FALSE),
                                            conditionalPanel(
                                                condition = "input.model_select_tree == 1",
                                                numericInput(inputId = "cp_min",
                                                             label = "Complexity Parameter (min. value)",
                                                             value = 0.01,
                                                             min = 0.005, max = 0.02, step = 0.005),
                                                numericInput(inputId = "cp_max",
                                                             label = "Complexity Parameter (max. value)",
                                                             value = 0.03,
                                                             min = 0.03, max = 0.05, step = 0.005),
                                                numericInput(inputId = "cp_by",
                                                             label = "Step by",
                                                             value = 0.001,
                                                             min = 0.001, max = 0.005, step = 0.001)
                                            ),
                                            checkboxInput(inputId = "model_select_rf",
                                                          label = tags$b("Random Forest"),
                                                          value = FALSE),
                                            conditionalPanel(
                                                condition = "input.model_select_rf == 1",
                                                sliderInput(inputId = "mtry",
                                                            label = "# of Randomly Selected Predictors",
                                                            min = 1, max = 12, value = 6, step = 1)
                                            ),
                                            conditionalPanel(
                                                condition = "(input.model_select_tree | input.model_select_rf) == 1",
                                                checkboxInput(inputId = "cv",
                                                              label = "Cross Validation",
                                                              value = FALSE),
                                                conditionalPanel(
                                                    condition = "input.cv == 1",
                                                    sliderInput(inputId = "folds",
                                                                label = "Folds",
                                                                min = 2, max = 10, value = 5))
                                            ),
                                            actionButton(inputId = "submit_models",
                                                         label = "Fit Models on Training Data")
                                        ) # end box
                                ), # end column 3
                                column(9,
                                       h4("RMSE of Training Data"),
                                       verbatimTextOutput("rmse_training"),
                                       h4("RMSE of Testing Data"),
                                       verbatimTextOutput("rmse_testing"),
                                       h4("Model Summary"),
                                       conditionalPanel(
                                           condition = "input.model_select_mlr == 1",
                                           verbatimTextOutput("summary_mlr")
                                       ),
                                       conditionalPanel(
                                           condition = "input.model_select_tree == 1",
                                           verbatimTextOutput("summary_tree")
                                       ),
                                       conditionalPanel(
                                           condition = "input.model_select_rf == 1",
                                           verbatimTextOutput("summary_rf")
                                       )
                                    
                                ) # end column 9
                             ) # end of fluidRow
                        
                    ), # end tabPanel "model fitting"
                    tabPanel("Prediction"
                        
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
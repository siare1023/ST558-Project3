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
                               ),
                               checkboxGroupInput(inputId = "select_response_factor",
                                                  label = "Filter Median House Value Range (US$)",
                                                  choices = list(
                                                      "High: 264,725 - 500,001",
                                                      "Medium High: 179,700 - 264,724",
                                                      "Medium Low: 119,600 - 179,699",
                                                      "Low: 14,999 - 119,599"),
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
                fluidRow(
                    column(3,
                           box(width = 12, title = "Filter by Variables",
                               
                               checkboxInput(inputId = "filter_response_check",
                                             label = tags$b("Filter by Range of Median House Value", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_response_check == 1",
                                   checkboxGroupInput(inputId = "filter_response",
                                                      label = "Filter Median House Value Range (US$)",
                                                      choices = list(
                                                          "High: 264,725 - 500,001",
                                                          "Medium High: 179,700 - 264,724",
                                                          "Medium Low: 119,600 - 179,699",
                                                          "Low: 14,999 - 119,599"),
                                                      selected = list(
                                                          "High: 264,725 - 500,001",
                                                          "Medium High: 179,700 - 264,724",
                                                          "Medium Low: 119,600 - 179,699",
                                                          "Low: 14,999 - 119,599"))
                               ),
                               
                               checkboxInput(inputId = "filter_coast_check",
                                             label = tags$b("Filter by Range of Distance to the Coast", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_coast_check == 1",
                                   checkboxGroupInput(inputId = "filter_coast",
                                                      label = "Filter Distance to the Coast (meters)",
                                                      choices = list(
                                                          "Farthest: 49,830.4 - 333,804.7",
                                                          "Far: 20,522.0 - 49,830.3",
                                                          "Close: 9,079.8 - 20,521.9",
                                                          "Closest: 102.7 - 9,079.7"),
                                                      selected = list(
                                                          "Farthest: 49,830.4 - 333,804.7",
                                                          "Far: 20,522.0 - 49,830.3",
                                                          "Close: 9,079.8 - 20,521.9",
                                                          "Closest: 102.7 - 9,079.7"))
                               ),
                               
                               checkboxInput(inputId = "filter_la_check",
                                             label = tags$b("Filter by Range of Distance to Los Angeles", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_la_check == 1",
                                   checkboxGroupInput(inputId = "filter_la",
                                                      label = "Filter Distance to Los Angeles (meters)",
                                                      choices = list(
                                                          "Farthest: 527,156.2 - 1,018,260.1",
                                                          "Far: 173,667.5 - 527,156.1",
                                                          "Close: 32,111.3 - 173,667.4",
                                                          "Closest: 420.6 - 32,111.2"),
                                                      selected = list(
                                                          "Farthest: 527,156.2 - 1,018,260.1",
                                                          "Far: 173,667.5 - 527,156.1",
                                                          "Close: 32,111.3 - 173,667.4",
                                                          "Closest: 420.6 - 32,111.2"))
                               ),
                               
                               checkboxInput(inputId = "filter_sd_check",
                                             label = tags$b("Filter by Range of Distance to San Diego", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_sd_check == 1",
                                   checkboxGroupInput(inputId = "filter_sd",
                                                      label = "Filter Distance to San Diego (meters)",
                                                      choices = list(
                                                          "Farthest: 705,795.4 - 1,196,919.3",
                                                          "Far: 214,739.8 - 705,795.3",
                                                          "Close: 159,426.4 - 214,739.7",
                                                          "Closest: 484.9 - 159,426.3"),
                                                      selected = list(
                                                          "Farthest: 705,795.4 - 1,196,919.3",
                                                          "Far: 214,739.8 - 705,795.3",
                                                          "Close: 159,426.4 - 214,739.7",
                                                          "Closest: 484.9 - 159,426.3"))
                               ),
                               
                               checkboxInput(inputId = "filter_sj_check",
                                             label = tags$b("Filter by Range of Distance to San Jose", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_sj_check == 1",
                                   checkboxGroupInput(inputId = "filter_sj",
                                                      label = "Filter Distance to San Jose (meters)",
                                                      choices = list(
                                                          "Farthest: 516,946.5 - 836,762.7",
                                                          "Far: 459,758.9 - 516,946.4",
                                                          "Close: 113,119.9 - 459,758.8",
                                                          "Closest: 569.4 - 113,119.8"),
                                                      selected = list(
                                                          "Farthest: 516,946.5 - 836,762.7",
                                                          "Far: 459,758.9 - 516,946.4",
                                                          "Close: 113,119.9 - 459,758.8",
                                                          "Closest: 569.4 - 113,119.8"))
                               ),
                               
                               checkboxInput(inputId = "filter_sf_check",
                                             label = tags$b("Filter by Range of Distance to San Francisco", 
                                                            style = "color:maroon; font-size: 15px;"),
                                             value = FALSE),
                               conditionalPanel(
                                   condition = "input.filter_sf_check == 1",
                                   checkboxGroupInput(inputId = "filter_sf",
                                                      label = "Filter Distance to San Francisco (meters)",
                                                      choices = list(
                                                          "Farthest: 584,552.0 - 903,627.7",
                                                          "Far: 526,546.7 - 584,551.9",
                                                          "Close: 117,395.5 - 526,546.6",
                                                          "Closest: 456.1 - 117,395.4"),
                                                      selected = list(
                                                          "Farthest: 584,552.0 - 903,627.7",
                                                          "Far: 526,546.7 - 584,551.9",
                                                          "Close: 117,395.5 - 526,546.6",
                                                          "Closest: 456.1 - 117,395.4"))
                               )
                               
                           ), # end box "filter variables"
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
                                           choices = list("Basic Summary")),
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
                               )
                                           
                                   
                               
                               
                               
                           ) # end box "numerical summaries"
                        
                    ), # end column 3
                    column(9,
                           #box(width = 12,
                            #   dataTableOutput(outputId = "explore_table")
                           #),
                           box(width = 12,
                               plotlyOutput(outputId = "explore_plot")
                               
                           ) # end box
                    ), # end column 9
                    column(4,
                           h4("Basic Summary"),
                           verbatimTextOutput(outputId = "explore_basic_summary")
                        
                    ) # end column 
                    
                ) # end fluidRow
            
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
                                                        min = 10, max = 100, step = 5, value = 20
                                            ),
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
                                                          label = tags$b("Random Forest", style = "color:maroon; font-size: 18px;"),
                                                          value = TRUE),
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
                                                              value = TRUE),
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
                                       h3("Training Data RMSE"),
                                       strong("Multiple Linear Regression"),
                                       verbatimTextOutput("rmse_training_mlr"),
                                       verbatimTextOutput("result_training_mlr"),
                                       strong("Regression Tree"),
                                       verbatimTextOutput("rmse_training_tree"),
                                       verbatimTextOutput("result_training_tree"),
                                       strong("Random Forest"),
                                       verbatimTextOutput("rmse_training_rf"),
                                       verbatimTextOutput("result_training_rf"),
                                       br(),
                                       h3("Test Data Results"),
                                       strong("Multiple Linear Regression"),
                                       verbatimTextOutput("rmse_testing_mlr"),
                                       strong("Regression Tree"),
                                       verbatimTextOutput("rmse_testing_tree"),
                                       strong("Random Forest"),
                                       verbatimTextOutput("rmse_testing_rf"),
                                       br(),
                                       h3("Model Summary"),
                                       strong("Multiple Linear Regression"),
                                       conditionalPanel(
                                           condition = "input.model_select_mlr == 1",
                                           verbatimTextOutput("summary_mlr")
                                       ),
                                       br(),
                                       strong("Regression Tree"),
                                       conditionalPanel(
                                           condition = "input.model_select_tree == 1",
                                           plotOutput(outputId = "summary_tree")
                                       ),
                                       br(),
                                       strong("Random Forest"),
                                       conditionalPanel(
                                           condition = "input.model_select_rf == 1",
                                           plotOutput(outputId = "summary_rf")

                                       )
                                    
                                ) # end column 9
                             ) # end of fluidRow
                        
                    ), # end tabPanel "model fitting"
                    tabPanel("Prediction",
                        fluidRow(
                            column(4,
                                   box(width = 12, title = "Enter Values to Predict Median House Value",
                                       numericInput(inputId = "predict_median_income",
                                                    label = "Median Income (10k USD$)",
                                                    value = 3.5,
                                                    min = 0, max = 20),
                                       numericInput(inputId = "predict_median_age",
                                                    label = "Median Age (years)",
                                                    value = 29,
                                                    min = 1, max = 60),
                                       numericInput(inputId = "predict_tot_rooms",
                                                    label = "Total # of Rooms (within a block)",
                                                    value = 2127,
                                                    min = 1, max = 40000),
                                       numericInput(inputId = "predict_tot_bedrooms",
                                                    label = "Total # of Bedrooms (within a block)",
                                                    value = 435,
                                                    min = 1, max = 7000),
                                       numericInput(inputId = "predict_population",
                                                    label = "Total # of People (within a block)",
                                                    value = 1166,
                                                    min = 1, max = 40000),
                                       numericInput(inputId = "predict_households",
                                                    label = "Total # of Households (within a block)",
                                                    value = 409,
                                                    min = 1, max = 6500),
                                       numericInput(inputId = "predict_latitude",
                                                    label = "Latitude (how far north)",
                                                    value = 34.3,
                                                    min = 32, max = 45),
                                       numericInput(inputId = "predict_longitude",
                                                    label = "Longitude (how far west)",
                                                    value = -118,
                                                    min = -125, max = -110),
                                       numericInput(inputId = "predict_distance_coast",
                                                    label = "Distance to Coast (meters)",
                                                    value = 20000,
                                                    min = 100, max = 340000),
                                       numericInput(inputId = "predict_distance_la",
                                                    label = "Distance to Los Angeles (meters)",
                                                    value = 175000,
                                                    min = 400, max = 1020000),
                                       numericInput(inputId = "predict_distance_sd",
                                                    label = "Distance to San Diego (meters)",
                                                    value = 215000,
                                                    min = 480, max = 1200000),
                                       numericInput(inputId = "predict_distance_sj",
                                                    label = "Distance to San Jose (meters)",
                                                    value = 460000,
                                                    min = 550, max = 840000),
                                       numericInput(inputId = "predict_distance_sf",
                                                    label = "Distance to San Francisco (meters)",
                                                    value = 530000,
                                                    min = 450, max = 905000),
                                       selectInput(inputId = "predict_select_model",
                                                   label = "Select Model to Use for Prediction",
                                                   choices = c("Multiple Linear Regression",
                                                               "Regression Tree",
                                                               "Random Forest"),
                                                   selected = "Regression Tree"),
                                       actionButton(inputId = "submit_predict",
                                                    label = "Make Prediction")
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
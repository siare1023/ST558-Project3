library(shiny)
library(dplyr)
library(readr)
library(ggplot2)
library(DT)
library(ggrepel)
library(factoextra)
library(caret)

# read in data
raw_data <- read_csv("California_Houses.csv")
raw_data_original <- raw_data %>% sample_frac(0.01)
raw_data_added <- read_csv("California_Houses.csv")

# create categories for quantitative variables
summary.median.house.value <- raw_data_added$Median_House_Value %>% summary()
raw_data_added$Median_House_Value_Factor <- ifelse(raw_data_added$Median_House_Value >= summary.median.house.value["3rd Qu."], "High: 264,725 - 500,001", 
                                        ifelse(raw_data_added$Median_House_Value >= summary.median.house.value["Median"], "Medium High: 179,700 - 264,724",
                                               ifelse(raw_data_added$Median_House_Value >= summary.median.house.value["1st Qu."], "Medium Low: 119,600 - 179,699", 
                                                      "Low: 14,999 - 119,599"))) %>% as.factor()

summary.median.income <- raw_data_added$Median_Income %>% summary()
raw_data_added$Median_Income_Factor <- ifelse(raw_data_added$Median_Income >= summary.median.income["3rd Qu."], "High: 4.7432 - 15.001", 
                                        ifelse(raw_data_added$Median_Income >= summary.median.income["Median"], "Medium High: 3.5348 - 4.7431",
                                               ifelse(raw_data_added$Median_Income >= summary.median.income["1st Qu."], "Medium Low: 2.5634 - 3.5347", 
                                                      "Low: 0.4999 - 2.5633"))) %>% as.factor()

summary.median.age <- raw_data_added$Median_Age %>% summary()
raw_data_added$Median_Age_Factor <- ifelse(raw_data_added$Median_Age >= summary.median.age["3rd Qu."], "37 - 52", 
                                        ifelse(raw_data_added$Median_Age >= summary.median.age["Median"], "29 - 51",
                                               ifelse(raw_data_added$Median_Age >= summary.median.age["1st Qu."], "18 - 28", 
                                                      "1 - 17"))) %>% as.factor()

summary.total.rooms <- raw_data_added$Tot_Rooms %>% summary()
raw_data_added$Tot_Rooms_Factor <- ifelse(raw_data_added$Tot_Rooms >= summary.total.rooms["3rd Qu."], "3148 - 39320", 
                                     ifelse(raw_data_added$Tot_Rooms >= summary.total.rooms["Median"], "2127 - 3147",
                                            ifelse(raw_data_added$Tot_Rooms >= summary.total.rooms["1st Qu."], "1448 - 2126", 
                                                   "2 - 1447"))) %>% as.factor()

summary.total.bedrooms <- raw_data_added$Tot_Bedrooms %>% summary()
raw_data_added$Tot_Bedrooms_Factor <- ifelse(raw_data_added$Tot_Bedrooms >= summary.total.bedrooms["3rd Qu."], "647 - 6445", 
                                    ifelse(raw_data_added$Tot_Bedrooms >= summary.total.bedrooms["Median"], "435 - 646",
                                           ifelse(raw_data_added$Tot_Bedrooms >= summary.total.bedrooms["1st Qu."], "295 - 434", 
                                                  "1 - 294"))) %>% as.factor()

summary.population <- raw_data_added$Population %>% summary()
raw_data_added$Population_Factor <- ifelse(raw_data_added$Population >= summary.population["3rd Qu."], "1725 - 35682", 
                                    ifelse(raw_data_added$Population >= summary.population["Median"], "1166 - 1724",
                                           ifelse(raw_data_added$Population >= summary.population["1st Qu."], "787 - 1165", 
                                                  "3 - 786"))) %>% as.factor()

summary.households <- raw_data_added$Households %>% summary()
raw_data_added$Households_Factor <- ifelse(raw_data_added$Households >= summary.households["3rd Qu."], "605 - 6082", 
                                     ifelse(raw_data_added$Households >= summary.households["Median"], "409 - 604",
                                            ifelse(raw_data_added$Households >= summary.households["1st Qu."], "280 - 408", 
                                                   "1 - 279"))) %>% as.factor()

summary.coast <- raw_data_added$Distance_to_coast %>% summary()
raw_data_added$Distance_to_coast_Factor <- ifelse(raw_data_added$Distance_to_coast >= summary.coast["3rd Qu."], "Farthest: 49830.4 - 333804.7", 
                                     ifelse(raw_data_added$Distance_to_coast >= summary.coast["Median"], "Far: 20522.0 - 49830.3",
                                            ifelse(raw_data_added$Distance_to_coast >= summary.coast["1st Qu."], "Close: 9079.8 - 20521.9", 
                                                   "Closest: 102.7 - 9079.7"))) %>% as.factor()

summary.la <- raw_data_added$Distance_to_LA %>% summary()
raw_data_added$Distance_to_LA_Factor <- ifelse(raw_data_added$Distance_to_LA >= summary.la["3rd Qu."], "Farthest: 527156.2 - 1018260.1", 
                                            ifelse(raw_data_added$Distance_to_LA >= summary.la["Median"], "Far: 173667.5 - 527156.1",
                                                   ifelse(raw_data_added$Distance_to_LA >= summary.la["1st Qu."], "Close: 32111.3 - 173667.4", 
                                                          "Closest: 420.6 - 32111.2"))) %>% as.factor()

summary.sd <- raw_data_added$Distance_to_SanDiego %>% summary()
raw_data_added$Distance_to_SanDiego_Factor <- ifelse(raw_data_added$Distance_to_SanDiego >= summary.sd["3rd Qu."], "Farthest: 705795.4 - 1196919.3", 
                                         ifelse(raw_data_added$Distance_to_SanDiego >= summary.sd["Median"], "Far: 214739.8 - 705795.3",
                                                ifelse(raw_data_added$Distance_to_SanDiego >= summary.sd["1st Qu."], "Close: 159426.4 - 214739.7", 
                                                       "Closest: 484.9 - 159426.3"))) %>% as.factor()

summary.sj <- raw_data_added$Distance_to_SanJose %>% summary()
raw_data_added$Distance_to_SanJose_Factor <- ifelse(raw_data_added$Distance_to_SanJose >= summary.sj["3rd Qu."], "Farthest: 516946.5 - 836762.7", 
                                               ifelse(raw_data_added$Distance_to_SanJose >= summary.sj["Median"], "Far: 459758.9 - 516946.4",
                                                      ifelse(raw_data_added$Distance_to_SanJose >= summary.sj["1st Qu."], "Close: 113119.9 - 459758.8", 
                                                             "Closest: 569.4 - 113119.8"))) %>% as.factor()

summary.sf <- raw_data_added$Distance_to_SanFrancisco %>% summary()
raw_data_added$Distance_to_SanFrancisco_Factor <- ifelse(raw_data_added$Distance_to_SanFrancisco >= summary.sf["3rd Qu."], "Farthest: 584552.0 - 903627.7", 
                                              ifelse(raw_data_added$Distance_to_SanFrancisco >= summary.sf["Median"], "Far: 526546.7 - 584551.9",
                                                     ifelse(raw_data_added$Distance_to_SanFrancisco >= summary.sf["1st Qu."], "Close: 117395.5 - 526546.6", 
                                                            "Closest: 456.1 - 117395.4"))) %>% as.factor()

# shinyServer arguments
shinyServer(function(input, output, session){
    
  
  # ____________________________________________________________________________________________________________________
  # data table tab
  # data tab data
  get_dt <- reactive({
    new_data <- raw_data_added %>% filter(Median_House_Value_Factor %in% (input$select_response_factor)) %>% select(as.vector(input$select_variables_dt))
  }) # end data tab data
  
  # data tab output
  output$dt_table <- renderDT({
    get_dt()
  }) # end data tab output
  
  # data download handler
  output$dt_download<- downloadHandler(
    filename = "CHP_data_table.csv",
    content = function(file) {
      write.csv(get_dt(), file, row.names = FALSE)
    }
  ) # end data download

  # ____________________________________________________________________________________________________________________
  # explore tab
  
  
  # ____________________________________________________________________________________________________________________
  # model tab
  
  # get training & test data
  train_test_data <- reactive({
    
    # set seed prior to sampling
    set.seed(7)
    train <- sample(1:nrow(raw_data_original), size = nrow(raw_data_original)*(as.numeric(input$train_select)/100))
    test <- dplyr::setdiff(1:nrow(raw_data_original), train)
    training_data <- raw_data_original[train, ]
    test_data <- raw_data_original[test, ]
    
    return(list("training_data"=training_data,"test_data"=test_data))
    
  }) #end training & test data set
  
  
  # model parameters
  modeling_parameters <- reactive({
    
    # create formula for modeling
    if(input$var_interact == 1 & input$model_select_mlr == 1) {
      predictors <- paste(input$predictor_select, collapse = "*")
    } else {
      predictors <- paste(input$predictor_select, collapse = "+")
    }
    response <- paste("Median_House_Value")
    formula <- as.formula(paste(response,"~",predictors))
    
    # cv
    trControl <-  trainControl(method = "cv", number = input$folds)
    
    # tuning grid
    tree_grid <- data.frame(cp = seq(input$cp_min, input$cp_max, by = input$cp_by))
    rf_grid <- data.frame(mtry = 1:(input$mtry))
    
    return(list("formula"=formula, "trControl"=trControl, "tree_grid"=tree_grid, "rf_grid"=rf_grid))

  })
  
  # model multiple linear regression
  fit_mlr <- reactive({
    modeling_parameters <- modeling_parameters()
    train_test_data <- train_test_data()
    if(input$model_select_mlr==1) {
      set.seed(7)
      fit_mlr_model <- train(modeling_parameters[["formula"]],
                        data = train_test_data[["training_data"]],
                        method = "lm",
                        preProcess = c("center", "scale"),
                        trControl = modeling_parameters[["trControl"]])
      predict_mlr <- postResample(predict(fit_mlr_model, newdata = train_test_data[["test_data"]]), 
                                  obs = train_test_data[["test_data"]]$Median_House_Value)
      return(list("fit_mlr_train"=fit_mlr_model, "fit_mlr_test"=predict_mlr))
    }  
  })
  
  output$rmse_training_mlr <- renderPrint({
    fit_mlr <- fit_mlr()
    fit_mlr[["fit_mlr_train"]]
  })
  
  output$rmse_testing_mlr <- renderPrint({
    fit_mlr <- fit_mlr()
    fit_mlr[["fit_mlr_test"]]
  })

  # model regression tree
  fit_tree <- reactive({
    modeling_parameters <- modeling_parameters()
    train_test_data <- train_test_data()
    if(input$model_select_tree==1) {
      set.seed(7)
      fit_tree_model <- train(modeling_parameters[["formula"]],
                             data = train_test_data[["training_data"]],
                             method = "rpart",
                             preProcess = c("center", "scale"),
                             trControl = modeling_parameters[["trControl"]],
                             tuneGrid = modeling_parameters[["tree_grid"]])
      predict_tree <- postResample(predict(fit_tree_model, newdata = train_test_data[["test_data"]]), 
                                  obs = train_test_data[["test_data"]]$Median_House_Value)
      return(list("fit_tree_train"=fit_tree_model, "fit_tree_test"=predict_tree))
    }  
  })
  
  output$rmse_training_tree <- renderPrint({
    fit_tree <- fit_tree()
    fit_tree[["fit_tree_train"]]
  })
  
  output$rmse_testing_tree <- renderPrint({
    fit_tree <- fit_tree()
    fit_tree[["fit_tree_test"]]
  })
  
  # model random forest
  fit_rf <- reactive({
    modeling_parameters <- modeling_parameters()
    train_test_data <- train_test_data()
    if(input$model_select_rf==1) {
      set.seed(7)
      fit_rf_model <- train(modeling_parameters[["formula"]],
                              data = train_test_data[["training_data"]],
                              method = "rf",
                              preProcess = c("center", "scale"),
                              trControl = modeling_parameters[["trControl"]],
                              tuneGrid = modeling_parameters[["rf_grid"]])
      predict_rf <- postResample(predict(fit_rf_model, newdata = train_test_data[["test_data"]]), 
                                   obs = train_test_data[["test_data"]]$Median_House_Value)
      return(list("fit_rf_train"=fit_rf_model, "fit_rf_test"=predict_rf))
    }  
  })
  
  output$rmse_training_rf <- renderPrint({
    fit_rf <- fit_rf()
    fit_rf[["fit_rf_train"]]
  })  
  
  output$rmse_testing_rf <- renderPrint({
    fit_rf <- fit_rf()
    fit_rf[["fit_rf_test"]]
  })  
  
  
  
  
}) # end shinyServer arguments
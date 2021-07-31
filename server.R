library(shiny)
library(tidyverse)
library(knitr)
library(DT)
library(caret)
library(tree)
library(randomForest)
library(shinycssloaders)

# read in data
#raw_data_original <- read_csv("California_Houses.csv")
raw_data <- read_csv("California_Houses.csv")
raw_data_original <- raw_data %>% sample_frac(0.05)
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
raw_data_added$Tot_Rooms_Factor <- ifelse(raw_data_added$Tot_Rooms >= summary.total.rooms["3rd Qu."], "3,148 - 39,320", 
                                          ifelse(raw_data_added$Tot_Rooms >= summary.total.rooms["Median"], "2,127 - 3,147",
                                                 ifelse(raw_data_added$Tot_Rooms >= summary.total.rooms["1st Qu."], "1,448 - 2,126", 
                                                        "2 - 1,447"))) %>% as.factor()

summary.total.bedrooms <- raw_data_added$Tot_Bedrooms %>% summary()
raw_data_added$Tot_Bedrooms_Factor <- ifelse(raw_data_added$Tot_Bedrooms >= summary.total.bedrooms["3rd Qu."], "647 - 6,445", 
                                             ifelse(raw_data_added$Tot_Bedrooms >= summary.total.bedrooms["Median"], "435 - 646",
                                                    ifelse(raw_data_added$Tot_Bedrooms >= summary.total.bedrooms["1st Qu."], "295 - 434", 
                                                           "1 - 294"))) %>% as.factor()

summary.population <- raw_data_added$Population %>% summary()
raw_data_added$Population_Factor <- ifelse(raw_data_added$Population >= summary.population["3rd Qu."], "1,725 - 3,5682", 
                                           ifelse(raw_data_added$Population >= summary.population["Median"], "1,166 - 1,724",
                                                  ifelse(raw_data_added$Population >= summary.population["1st Qu."], "787 - 1,165", 
                                                         "3 - 786"))) %>% as.factor()

summary.households <- raw_data_added$Households %>% summary()
raw_data_added$Households_Factor <- ifelse(raw_data_added$Households >= summary.households["3rd Qu."], "605 - 6,082", 
                                           ifelse(raw_data_added$Households >= summary.households["Median"], "409 - 604",
                                                  ifelse(raw_data_added$Households >= summary.households["1st Qu."], "280 - 408", 
                                                         "1 - 279"))) %>% as.factor()

summary.coast <- raw_data_added$Distance_to_coast %>% summary()
raw_data_added$Distance_to_coast_Factor <- ifelse(raw_data_added$Distance_to_coast >= summary.coast["3rd Qu."], "Farthest: 49,830.4 - 333,804.7", 
                                                  ifelse(raw_data_added$Distance_to_coast >= summary.coast["Median"], "Far: 20,522.0 - 49,830.3",
                                                         ifelse(raw_data_added$Distance_to_coast >= summary.coast["1st Qu."], "Close: 9,079.8 - 20,521.9", 
                                                                "Closest: 102.7 - 9,079.7"))) %>% as.factor()

summary.la <- raw_data_added$Distance_to_LA %>% summary()
raw_data_added$Distance_to_LA_Factor <- ifelse(raw_data_added$Distance_to_LA >= summary.la["3rd Qu."], "Farthest: 527,156.2 - 1,018,260.1", 
                                               ifelse(raw_data_added$Distance_to_LA >= summary.la["Median"], "Far: 173,667.5 - 527,156.1",
                                                      ifelse(raw_data_added$Distance_to_LA >= summary.la["1st Qu."], "Close: 32,111.3 - 173,667.4", 
                                                             "Closest: 420.6 - 32,111.2"))) %>% as.factor()

summary.sd <- raw_data_added$Distance_to_SanDiego %>% summary()
raw_data_added$Distance_to_SanDiego_Factor <- ifelse(raw_data_added$Distance_to_SanDiego >= summary.sd["3rd Qu."], "Farthest: 705,795.4 - 1,196,919.3", 
                                                     ifelse(raw_data_added$Distance_to_SanDiego >= summary.sd["Median"], "Far: 214,739.8 - 705,795.3",
                                                            ifelse(raw_data_added$Distance_to_SanDiego >= summary.sd["1st Qu."], "Close: 159,426.4 - 214,739.7", 
                                                                   "Closest: 484.9 - 159,426.3"))) %>% as.factor()

summary.sj <- raw_data_added$Distance_to_SanJose %>% summary()
raw_data_added$Distance_to_SanJose_Factor <- ifelse(raw_data_added$Distance_to_SanJose >= summary.sj["3rd Qu."], "Farthest: 516,946.5 - 836,762.7", 
                                                    ifelse(raw_data_added$Distance_to_SanJose >= summary.sj["Median"], "Far: 459,758.9 - 516,946.4",
                                                           ifelse(raw_data_added$Distance_to_SanJose >= summary.sj["1st Qu."], "Close: 113,119.9 - 459,758.8", 
                                                                  "Closest: 569.4 - 113,119.8"))) %>% as.factor()

summary.sf <- raw_data_added$Distance_to_SanFrancisco %>% summary()
raw_data_added$Distance_to_SanFrancisco_Factor <- ifelse(raw_data_added$Distance_to_SanFrancisco >= summary.sf["3rd Qu."], "Farthest: 584,552.0 - 903,627.7", 
                                                         ifelse(raw_data_added$Distance_to_SanFrancisco >= summary.sf["Median"], "Far: 526,546.7 - 584,551.9",
                                                                ifelse(raw_data_added$Distance_to_SanFrancisco >= summary.sf["1st Qu."], "Close: 117,395.5 - 526,546.6", 
                                                                       "Closest: 456.1 - 117,395.4"))) %>% as.factor()

# shinyServer arguments
shinyServer(function(input, output, session){
  
  # stop app when closing
  #session$onSessionEnded(function() {
  #  stopApp()
  #})
  
  
  # ____________________________________________________________________________________________________________________
  # data table tab
  # data tab data
  get_dt <- reactive({
    #new_data <- raw_data_added %>% filter(Median_House_Value_Factor %in% (input$select_response_factor)) %>% select(as.vector(input$select_variables_dt))
    
    new_data <- raw_data_added %>% 
      filter(
        (Median_House_Value <= (input$data_filter_response[2])) &
          (Median_House_Value >= (input$data_filter_response[1]))) %>%
      filter(
        (Median_Income <= (input$data_filter_income[2])) &
          (Median_Income >= (input$data_filter_income[1]))) %>%
      filter(
        (Median_Age <= (input$data_filter_age[2])) &
          (Median_Age >= (input$data_filter_age[1]))) %>%
      filter(
        (Tot_Rooms <= (input$data_filter_rooms[2])) &
          (Tot_Rooms >= (input$data_filter_rooms[1]))) %>%
      filter(
        (Tot_Bedrooms <= (input$data_filter_bedrooms[2])) &
          (Tot_Bedrooms >= (input$data_filter_bedrooms[1]))) %>%
      filter(
        (Population <= (input$data_filter_population[2])) &
          (Population >= (input$data_filter_population[1]))) %>%
      filter(
        (Households <= (input$data_filter_households[2])) &
          (Households >= (input$data_filter_households[1]))) %>%
      filter(
        (Latitude <= (input$data_filter_latitude[2])) &
          (Latitude >= (input$data_filter_latitude[1]))) %>%
      filter(
        (Longitude <= (input$data_filter_longitude[2])) &
          (Longitude >= (input$data_filter_longitude[1]))) %>%
      filter(
        (Distance_to_coast <= (input$data_filter_coast[2])) &
          (Distance_to_coast >= (input$data_filter_coast[1]))) %>%
      filter(
        (Distance_to_LA <= (input$data_filter_la[2])) &
          (Distance_to_LA >= (input$data_filter_la[1]))) %>%
      filter(
        (Distance_to_SanDiego <= (input$data_filter_sd[2])) &
          (Distance_to_SanDiego >= (input$data_filter_sd[1]))) %>%
      filter(
        (Distance_to_SanJose <= (input$data_filter_sj[2])) &
          (Distance_to_SanJose >= (input$data_filter_sj[1]))) %>%
      filter(
        (Distance_to_SanFrancisco <= (input$data_filter_sf[2])) &
          (Distance_to_SanFrancisco >= (input$data_filter_sf[1]))) %>%
      select(as.vector(input$select_variables_dt))
  }) # end data tab data
  
  # data tab output
  output$dt_table <- renderDT({
    options = list(autowidth = TRUE,
                   width = "200px")
    get_dt <- get_dt()
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
  
  # filter data
  explore_data <- reactive({
    explore_data <- raw_data_added %>% 
      #filter((Median_House_Value_Factor %in% input$filter_response) & 
      #         (Distance_to_coast_Factor %in% input$filter_coast) & 
      #         (Distance_to_LA_Factor %in% input$filter_la) & 
      #         (Distance_to_SanDiego_Factor %in% input$filter_sd) & 
      #         (Distance_to_SanJose_Factor %in% input$filter_sj) & 
      #         (Distance_to_SanFrancisco_Factor %in% input$filter_sf)
      #       )
      filter(
        (Median_House_Value <= (input$explore_filter_response[2])) &
          (Median_House_Value >= (input$explore_filter_response[1]))) %>%
      filter(
        (Median_Income <= (input$explore_filter_income[2])) &
          (Median_Income >= (input$explore_filter_income[1]))) %>%
      filter(
        (Median_Age <= (input$explore_filter_age[2])) &
          (Median_Age >= (input$explore_filter_age[1]))) %>%
      filter(
        (Tot_Rooms <= (input$explore_filter_rooms[2])) &
          (Tot_Rooms >= (input$explore_filter_rooms[1]))) %>%
      filter(
        (Tot_Bedrooms <= (input$explore_filter_bedrooms[2])) &
          (Tot_Bedrooms >= (input$explore_filter_bedrooms[1]))) %>%
      filter(
        (Population <= (input$explore_filter_population[2])) &
          (Population >= (input$explore_filter_population[1]))) %>%
      filter(
        (Households <= (input$explore_filter_households[2])) &
          (Households >= (input$explore_filter_households[1]))) %>%
      filter(
        (Latitude <= (input$explore_filter_latitude[2])) &
          (Latitude >= (input$explore_filter_latitude[1]))) %>%
      filter(
        (Longitude <= (input$explore_filter_longitude[2])) &
          (Longitude >= (input$explore_filter_longitude[1]))) %>%
      filter(
        (Distance_to_coast <= (input$explore_filter_coast[2])) &
          (Distance_to_coast >= (input$explore_filter_coast[1]))) %>%
      filter(
        (Distance_to_LA <= (input$explore_filter_la[2])) &
          (Distance_to_LA >= (input$explore_filter_la[1]))) %>%
      filter(
        (Distance_to_SanDiego <= (input$explore_filter_sd[2])) &
          (Distance_to_SanDiego >= (input$explore_filter_sd[1]))) %>%
      filter(
        (Distance_to_SanJose <= (input$explore_filter_sj[2])) &
          (Distance_to_SanJose >= (input$explore_filter_sj[1]))) %>%
      filter(
        (Distance_to_SanFrancisco <= (input$explore_filter_sf[2])) &
          (Distance_to_SanFrancisco >= (input$explore_filter_sf[1])))
  }) # end reactive

#  output$explore_table <- renderDataTable({
#  explore_data <- explore_data()
#  })
  
  output$explore_plot <- renderPlotly({
    explore_data <- explore_data()
    
    if(input$select_plot == "Scatterplot") {
      ggplot(explore_data, aes_string(x=input$scatter_x, y=input$scatter_y)) +
        geom_point(aes_string(color=input$scatter_z_factor))
    } else if(input$select_plot == "Histogram") {
      ggplot(explore_data, aes_string(x=input$histo_x)) +
        geom_histogram(color = "rosybrown", fill = "thistle4")
    } else if(input$select_plot == "Boxplot") {
      ggplot(explore_data, aes_string(x=input$box_x_factor, y=input$box_y)) +
        geom_boxplot() +
        stat_summary(fun.y = mean, geom = "line", lwd = 1, 
                     aes_string(group = input$box_z_factor, col = input$box_z_factor))
    }
  })
  
  output$explore_numerical_summary <- renderPrint({
    explore_data <- explore_data()
    
    if(input$explore_summaries_type == "Basic Summary") {
      explore_summary_variable <- explore_data %>% select(input$summaries_var) %>% pull()
      explore_summary_output <- c(summary(explore_summary_variable), 
                                  "St.Dev."=sd(explore_summary_variable))
          } else if(input$explore_summaries_type == "Correlation Summary") {
      explore_summary_output <- explore_data %>% select(input$summaries_corr) %>% cor(method = "pearson")
    } else if(input$explore_summaries_type == "Frequency Table") {
      explore_summary_output <- explore_data %>% select(input$summaries_freq) %>% 
        pull() %>% cut(breaks = input$freq_breaks, dig.lab = 10) %>% 
        table() %>% kable(caption = "Frequency Table", 
                          col.names = c(paste0("Range of ", as.character(input$summaries_freq)), "Count"))
    }
    return(explore_summary_output)
    
  })
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
  
  # update random forest tuning parameter max
  observe({
    updateSliderInput(session, inputId = "mtry", max = length(input$predictor_select))
  })
    
  # model parameters
  modeling_parameters <- reactive({
    
    # create formula for modeling
    if(input$model_select_mlr == 1 & input$var_interact == 1) {
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
  fit_mlr <- eventReactive(input$submit_models, {
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
    fit_mlr[["fit_mlr_train"]]$results["RMSE"] %>% min()
  })
  
  output$result_training_mlr <- renderPrint({
    fit_mlr <- fit_mlr()
    fit_mlr[["fit_mlr_train"]]
  })
  
  output$rmse_testing_mlr <- renderPrint({
    fit_mlr <- fit_mlr()
    fit_mlr[["fit_mlr_test"]]
  })
  
  # model regression tree
  fit_tree <- eventReactive(input$submit_models, {
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
    fit_tree[["fit_tree_train"]]$results["RMSE"] %>% min()
  })
  
  output$result_training_tree <- renderPrint({
    fit_tree <- fit_tree()
    fit_tree[["fit_tree_train"]]
  })
  
  output$rmse_testing_tree <- renderPrint({
    fit_tree <- fit_tree()
    fit_tree[["fit_tree_test"]]
  })
  
  # model random forest
  fit_rf <- eventReactive(input$submit_models, {
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
    fit_rf[["fit_rf_train"]]$results["RMSE"] %>% min()
  })
  
  output$result_training_rf <- renderPrint({
    fit_rf <- fit_rf()
    fit_rf[["fit_rf_train"]]
  })  
  
  output$rmse_testing_rf <- renderPrint({
    fit_rf <- fit_rf()
    fit_rf[["fit_rf_test"]]
  })  
  
  # summary of multiple linear regression
  output$summary_mlr <- renderPrint({
    fit_mlr <- fit_mlr()
    summary(fit_mlr[["fit_mlr_train"]])
  })  
  
  # summary of regression tree
  tree_plot <- eventReactive(input$submit_models, {
    train_test_data <- train_test_data()
    predictors <- paste(input$predictor_select, collapse = "+")
    response <- paste("Median_House_Value")
    formula <- as.formula(paste(response,"~",predictors))
    treeFit <- tree(formula,
                    data = train_test_data[["training_data"]])
    plot(treeFit); text(treeFit)
  })
  
  output$summary_tree <- renderPlot({
    tree_plot <- tree_plot()
  })
  
  # summary of random forest
  rf_plot <- eventReactive(input$submit_models, {
    train_test_data <- train_test_data()
    predictors <- paste(input$predictor_select, collapse = "+")
    response <- paste("Median_House_Value")
    formula <- as.formula(paste(response,"~",predictors))
    Variance.Importance.Dotchart <- randomForest(formula, 
                          data = train_test_data[["training_data"]], 
                          mtry = 1:(input$mtry),
                          importance = TRUE)
    varImpPlot(Variance.Importance.Dotchart)
  })
  
  output$summary_rf<- renderPlot({
    rf_plot <- rf_plot()
  })
  
  
  # ____________________________________________________________________________________________________________________
  # prediction tab

  prediction_result <- reactive({
    Median_Income <- input$predict_median_income
    Median_Age <- input$predict_median_age
    Tot_Rooms <- input$predict_tot_rooms
    Tot_Bedrooms <- input$predict_tot_bedrooms
    Population <- input$predict_population
    Households <- input$predict_households
    Latitude <- input$predict_latitude
    Longitude <- input$predict_longitude
    Distance_to_coast <- input$predict_distance_coast
    Distance_to_LA <- input$predict_distance_la
    Distance_to_SanDiego <- input$predict_distance_sd
    Distance_to_SanJose <- input$predict_distance_sj
    Distance_to_SanFrancisco <- input$predict_distance_sf
    
    predict_data <- as.data.frame(cbind(Median_Income,
                                        Median_Age,
                                        Tot_Rooms,
                                        Tot_Bedrooms,
                                        Population,
                                        Households,
                                        Latitude,
                                        Longitude,
                                        Distance_to_coast,
                                        Distance_to_LA,
                                        Distance_to_SanDiego,
                                        Distance_to_SanJose,
                                        Distance_to_SanFrancisco))
    
    fit_mlr <- fit_mlr()
    fit_tree <- fit_tree()
    fit_rf <- fit_rf()
    if(input$predict_select_model=="Multiple Linear Regression"){
      predict_result <- predict(fit_mlr[["fit_mlr_train"]],
                                newdata = predict_data) %>% round(2)
    } else if(input$predict_select_model=="Regression Tree") {
      predict_result <- predict(fit_tree[["fit_tree_train"]],
                                newdata = predict_data) %>% round(2)
    } else if(input$predict_select_model=="Random Forest") {
      predict_result <- predict(fit_rf[["fit_rf_train"]],
                                newdata = predict_data) %>% round(2)
    }
    return(list("Prediction Value"=predict_result, "Model Used"=input$predict_select_model))
    
  })
  
  output$predict_value <- renderPrint({
    prediction_result <- prediction_result()
    prediction_result
#    paste0("Based on the inputted predictor values, the prediction for Median House Value using the ", prediction_result[["chosen_model"]], " model is USD $", prediction_result[["result"]], ".")
  })
  
    
}) # end shinyServer arguments
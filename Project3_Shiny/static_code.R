raw_data_original <- read_csv("California_Houses.csv")
raw_data_original$Median_House_Value %>% summary()

# training and test data
training.percentage <- 0.8
set.seed(7)
training <- sample(1:nrow(raw_data_original), size = nrow(raw_data_original)*training.percentage)
test <- dplyr::setdiff(1:nrow(raw_data_original), training)
training.data <- raw_data_original[training, ]
test.data <- raw_data_original[test, ]

# pick aic predictors
# only 1st order
fit.aic1 <- step(lm(Median_House_Value ~ ., data = training.data), direction = "both")
# 1st order + interactions
fit.aic2 <- step(lm(Median_House_Value ~ .^2, data = training.data), direction = "both")

# use aic predictors (1st order terms)
set.seed(7)
fit.mlr1 <- train(fit.aic1$terms,
                  data = training.data,
                  method = "lm",
                  preProcess = c("center", "scale"),
                  trControl = trainControl(method = "cv", number = 10))
fit.mlr1$results

predict.mlr1 <- postResample(predict(fit.mlr1, newdata = test.data), obs = test.data$Median_House_Value)

summary(fit.mlr1)



# use aic predictors (1st order + interactions)
set.seed(7)
fit.mlr2 <- train(fit.aic2$terms,
                  data = training.data,
                  method = "lm",
                  preProcess = c("center", "scale"),
                  trControl = trainControl(method = "cv", number = 10))
predict.mlr2 <- postResample(predict(fit.mlr2, newdata = test.data), obs = test.data$Median_House_Value)

summary(fit.mlr2)

# regression tree model
set.seed(7)
fit.regression.trial <- train(Median_House_Value ~ ., data = training.data,
                              method = "rpart",
                              preProcess = c("center", "scale"),
                              trControl = trainControl(method = "cv", number = 10))

set.seed(7)
fit.regression <- train(Median_House_Value ~ ., data = training.data,
                        method = "rpart",
                        preProcess = c("center", "scale"),
                        trControl = trainControl(method = "cv", number = 10),
                        tuneGrid = data.frame(cp = seq(0.01, 0.05, by = 0.001)))
predict.regression <- postResample(predict(fit.regression, newdata = test.data), test.data$Median_House_Value)

summary(fit.regression)
min.rmse <- fit.regression$results["RMSE"] %>% min()
predict.regression["RMSE"]

treeFit <- tree::tree(Median_House_Value ~ Median_Income + Median_Age + Tot_Rooms, data = training.data)
plot(treeFit); text(treeFit)

model_param <- Median_House_Value ~ Median_Age + Tot_Rooms + Population

predictors <- paste(predictor_select, collapse = "+")
response <- paste("Median_House_Value")
formula <- as.formula(paste(response,"~",predictors))
treeFit2 <- tree(model_param,
                 data = training.data)
plot(treeFit2)
text(treeFit2)



# random forest model
set.seed(7)
fit.rf <- train(Median_House_Value ~ ., data = training.data,
                method = "rf",
                preProcess = c("center", "scale"),
                trControl = trainControl(method = "cv", number = 10),
                tuneGrid = data.frame(mtry = 1:(ncol(raw_data_original)-1)),
                importance = TRUE)
fit.rf$results["RMSE"] %>% min()

predict.rf <- postResample(predict(fit.rf, newdata = test.data), test.data$Median_House_Value)

rf.fit <- randomForest::randomForest(model_param, data = test.data, mtry=1:3, importance = TRUE)
randomForest::varImpPlot(rf.fit)

# comparison
compare.rmse <- data.frame(predict.mlr1,
                           predict.mlr2,
                           predict.regression,
                           predict.rf)

colnames(compare.rmse) <- c("mlr aic1", "mlr aic2", "regression tree", "random forest")
compare.rmse

min.compare.rmse <- min(compare.rmse["RMSE", ])
min.test <- compare.rmse["RMSE", ] == min.compare.rmse


#------------------------------------------------------------------------
set.seed(7)
train <- sample(1:nrow(raw_data_original), size = nrow(raw_data_original)*(as.numeric(70)/100))
test <- dplyr::setdiff(1:nrow(raw_data_original), train)
training_data <- raw_data_original[train, ]
test_data <- raw_data_original[test, ]
train_test_data <- list("training_data"=training_data,"test_data"=test_data)
train_test_data[["test_data"]]$Median_House_Value

var_interact <- 1
model_select_mlr <- 1
predictor_select <- list("Median_Age", "Tot_Rooms")

if(var_interact == 1 & model_select_mlr == 1) {
  predictors <- paste(predictor_select, collapse = "*")
} else {
  predictors <- paste(predictor_select, collapse = "+")
}
response <- paste("Median_House_Value")
formula <- as.formula(paste(response,"~",predictors))

# cv
folds <- 5
trControl <-  trainControl(method = "cv", number = folds)

# tuning grid
cp_min <- 0.01
cp_max <- 0.03
cp_by <- 0.001
tree_grid <- data.frame(cp = seq(cp_min, cp_max, by = cp_by))
mtry <- 9
rf_grid <- data.frame(mtry = 1:(mtry-1))

modeling_parameters <- list("formula"=formula, "trControl"=trControl, "tree_grid"=tree_grid, "rf_grid"=rf_grid)
modeling_parameters[["rf_grid"]]

if(model_select_mlr==1) {
  set.seed(7)
  fit_mlr_model <- train(as.formula(modeling_parameters[["formula"]]),
                         data = train_test_data[["training_data"]],
                         method = "lm",
                         preProcess = c("center", "scale"),
                         trControl = modeling_parameters[["trControl"]])
  predict_mlr <- postResample(predict(fit_mlr_model, newdata = train_test_data[["test_data"]]), 
                              obs = train_test_data[["test_data"]]$Median_House_Value)
  return(predict_mlr["RMSE"])
} else {
  paste0("You must select Multiple Linear Regression to see result.")
}

as.formula(modeling_parameters[["formula"]])

model_select_rf <- 1
fit_rf <- if(model_select_rf==1) {
  set.seed(7)
  fit_rf_model <- train(modeling_parameters[["formula"]],
                        data = train_test_data[["training_data"]],
                        method = "rf",
                        preProcess = c("center", "scale"),
                        trControl = modeling_parameters[["trControl"]],
                        tuneGrid = modeling_parameters[["rf_grid"]])
  predict_rf <- postResample(predict(fit_rf_model, newdata = train_test_data[["test_data"]]), 
                             obs = train_test_data[["test_data"]]$Median_House_Value)
}  

fit_rf_model$xlevels

output$rmse_training_tree <- renderPrint({
  fit_rf <- fit_rf()
  fit_rf
})  

#------------------------------------------------------------------------

varXselect <- "Median_Income"
varYselect <- "Median_House_Value" #"Population"
varZselect <- "Tot_Bedrooms_Factor"
varWselect <- "Median_Income_Factor"
ggplot(raw_data_added, aes_string(x=varXselect, y=varYselect)) +
  geom_point(aes_string(color=varWselect)) #+
  #facet_wrap(~varWselect)
  #geom_smooth(method = lm, col = "red") + 
  #geom_smooth()

binWidth <- 150
ggplot(raw_data_added, aes_string(x=varXselect)) +
  geom_histogram()
  #stat_ecdf(geom="step")

ggplot(raw_data_added, aes_string(x=varZselect, y=varYselect)) +
  geom_boxplot() +
  stat_summary(fun.y = mean, geom = "line", lwd = 1, aes_string(group = varWselect, col = varWselect))


cov.stat <- raw_data_added %>% select(Median_Income, Population, Median_Age, Median_House_Value) %>% cov(method = "pearson")
corrplot::corrplot(cov.stat)
cor(raw_data_added$Median_Income, raw_data_added$Median_Age)

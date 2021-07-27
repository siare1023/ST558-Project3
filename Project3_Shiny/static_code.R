raw.data.original <- read_csv("California_Houses.csv")
raw.data.original$Median_House_Value %>% summary()

# training and test data
training.percentage <- 0.01
set.seed(7)
training <- sample(1:nrow(raw.data.original), size = nrow(raw.data.original)*training.percentage)
test <- dplyr::setdiff(1:nrow(raw.data.original), training)
training.data <- raw.data.original[training, ]
test.data <- raw.data.original[test, ]

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
predict.mlr1 <- postResample(predict(fit.mlr1, newdata = test.data), obs = test.data$Median_House_Value)

# use aic predictors (1st order + interactions)
set.seed(7)
fit.mlr2 <- train(fit.aic2$terms,
                  data = training.data,
                  method = "lm",
                  preProcess = c("center", "scale"),
                  trControl = trainControl(method = "cv", number = 10))
predict.mlr2 <- postResample(predict(fit.mlr2, newdata = test.data), obs = test.data$Median_House_Value)

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

# random forest model
set.seed(7)
fit.rf <- train(Median_House_Value ~ ., data = training.data,
                method = "rf",
                preProcess = c("center", "scale"),
                trControl = trainControl(method = "cv", number = 10),
                tuneGrid = data.frame(mtry = 1:(ncol(raw.data.original)-1)))
predict.rf <- postResample(predict(fit.rf, newdata = test.data), test.data$Median_House_Value)

# comparison
compare.rmse <- data.frame(predict.mlr1,
                          predict.mlr2,
                          predict.regression,
                          predict.rf)

colnames(compare.rmse) <- c("mlr aic1", "mlr aic2", "regression tree", "random forest")
compare.rmse

min.compare.rmse <- min(compare.rmse["RMSE", ])
min.test <- compare.rmse["RMSE", ] == min.compare.rmse

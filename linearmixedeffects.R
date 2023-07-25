library(Matrix)
library(caret)
library(lme4)
library(MuMIn)

dataframe <- read.csv("C:\\Users\\namil\\Documents\\stmi-lab-namila\\combined_dataset")
dataframe <- na.omit(dataframe)
dim(dataframe)

#filter meals as needed
#only bfast
filtered_df <- dataframe[dataframe$Meal.Type == "breakfast", ]
#breakfast and lunches
filtered_df <- dataframe[dataframe$Meal.Type != "dinner", ]

convcols <- c(6,7,8,9, 10, 11, 12, 13, 14) 
dataframe[, convcols] <- lapply(dataframe[, convcols], as.numeric)

set.seed(123)  # Set a seed for reproducibility
trainIndex <- createDataPartition(dataframe$dexcom.3hr.auc, p = 0.7, list = FALSE)
train_data <- dataframe[trainIndex, ]
test_data <- dataframe[-trainIndex, ]

model <- lmer(peakheight ~ HbA1c + calories + carbs + protein + fat + (1|participant_id), data = train_data)
summary(model)

predicted <- predict(model, newdata = test_data)
actual <- test_data$peakheight
plot(predicted, actual, xlab = "Predicted", ylab = "actual")

#errors
rmse <- sqrt(mean((predicted - actual)^2))
r_squared <- r.squaredGLMM(model)

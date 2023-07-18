library(Matrix)
library(lme4)

dataframe <- read.csv("C:\\Users\\namil\\Documents\\stmi-lab-namila\\combined_dataset")
dim(dataframe)

convcols <- c(2,3,4,5,6,7,8,9, 10, 11) 
dataframe[, convcols] <- lapply(dataframe[, convcols], as.numeric)

model <- lmer(peakheight ~ calories + carbs + protein + fat + (1|participant_id), data = dataframe )
summary(model)

predicted <- predict(model, newdata = dataframe)
plot(predicted, dataframe$peakheight, xlab = "Predicted", ylab = "actual")

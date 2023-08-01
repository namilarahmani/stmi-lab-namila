library(Matrix)
library(caret)
library(lme4)
library(MuMIn)
suppressWarnings({
  #read in data
  dataframe <- read.csv("C:\\Users\\namil\\Documents\\stmi-lab-namila\\combineddatasetwmed")
  dim(dataframe)
  
  #filter meals as needed : only bfast (comment out for all meals)
  dataframe <- dataframe[dataframe$Meal.Type == "breakfast", ]

  #make peak height numeric from chr
  convcols <- c(6:15) 
  dataframe[, convcols] <- lapply(dataframe[, convcols], as.numeric)
  dataframe <- na.omit(dataframe)
  
  #split data and scale
  set.seed(123)  # Set a seed for reproducibility
  dataframe[, c("HbA1c","calories","carbs", "protein", "fat", "Age", "cholesterol")] <- scale(dataframe[, c("HbA1c","calories","carbs", "protein", "fat", "Age", "cholesterol")])
  trainIndex <- createDataPartition(dataframe$dexcom.3hr.auc, p = 0.7, list = FALSE)
  train_data <- dataframe[trainIndex, ]
  test_data <- dataframe[-trainIndex, ]
  
  #base model with only macros
  model <- lmer(peakheight ~ calories + carbs + protein + fat + (1|participant_id), data = train_data)
  summary(model)
  
  #calculate errors
  predicted <- predict(model, newdata = test_data)
  actual <- test_data$peakheight
  plot(predicted, actual, xlab = "Predicted", ylab = "actual")
  rmse <- sqrt(mean((predicted - actual)^2))
  r_squared <- r.squaredGLMM(model)
  cat(sprintf("rmse: %f and r squared: %f", rmse, r_squared[1]))
  
  #add to results dataframe
  results <- data.frame(feature = character(), RMSE = numeric(), R2 = numeric())
  newrow <- c("base", rmse, r_squared[1])
  results[1, ] <- newrow
  
  #base with hba1c and age
  model <- lmer(peakheight ~ HbA1c + calories + carbs + protein + fat + Age + (1|participant_id), data = train_data)
  summary(model)
  predicted <- predict(model, newdata = test_data)
  actual <- test_data$peakheight
  plot(predicted, actual, xlab = "Predicted", ylab = "actual")
  rmse <- sqrt(mean((predicted - actual)^2))
  r_squared <- r.squaredGLMM(model)
  cat(sprintf("rmse: %f and r squared: %f", rmse, r_squared[1]))
  newrow <- c("base with hba1c trig age", rmse, r_squared[1])
  results <- rbind(results, newrow)
  
  
  #with hdl
  model <- lmer(peakheight ~ HbA1c + calories + carbs + protein + fat + Age + HDL + (1|participant_id), data = train_data)
  summary(model)
  predicted <- predict(model, newdata = test_data)
  actual <- test_data$peakheight
  rmse <- sqrt(mean((predicted - actual)^2))
  r_squared <- r.squaredGLMM(model)
  cat(sprintf("rmse: %f and r squared: %f", rmse, r_squared[1]))
  newrow <- c("withhdl", rmse, r_squared[1])
  results <- rbind(results, newrow)
  
  #with one activity feature at a time
  depvars <- c("mets.3.hr.auc", "mets.3.hr.avg", "hrmax", "hrauc", "activeMin_2", "activeMin_3","activeMin_4")
  for(i in 1:length(depvars)){
    lmerformula <- paste0("peakheight ~ HbA1c + calories + carbs + protein + fat + Age + ", depvars[i], " + (1|participant_id)")
    
    dataframe[, depvars[i]] <- scale(dataframe[, depvars[i]])
    model <- lmer(as.formula(lmerformula), data = train_data)
    summary(model)
    
    #errors
    predicted <- predict(model, newdata = test_data)
    actual <- test_data$peakheight
    plot(predicted, actual, xlab = "Predicted", ylab = "actual")
    rmse <- sqrt(mean((predicted - actual)^2))
    r_squared <- r.squaredGLMM(model)
    cat(sprintf("RMSE: %f and R^2: %f", rmse, r_squared[1]))
    
    newrow <- c(depvars[i], rmse, r_squared[1])
    results <- rbind(results, newrow)
  }
  
  #base with multiple activity features combined
  improvers <- c("mets.3.hr.auc", "mets.3.hr.avg", "activeMin_2", "activeMin_3","activeMin_4", "hrauc")
  stringform <- paste0("peakheight ~ HbA1c + calories + carbs + protein + fat + Age + ", paste(improvers,  collapse = " + "), " + (1|participant_id)")
  model <- lmer(as.formula(stringform), data = train_data)
  summary(model)
  
  #evaluate model
  predicted <- predict(model, newdata = test_data)
  actual <- test_data$peakheight
  plot(predicted, actual, xlab = "Predicted", ylab = "actual")
  rmse <- sqrt(mean((predicted - actual)^2))
  r_squared <- r.squaredGLMM(model)
  cat(sprintf("RMSE: %f and R^2: %f", rmse, r_squared[1]))
  newrow <- c("combined", rmse, r_squared[1])
  results <- rbind(results, newrow)
  
  #base with multiple activity features and triglycerides
  improvers <- c("mets.3.hr.auc", "mets.3.hr.avg", "activeMin_2", "activeMin_3","activeMin_4", "hrauc", "triglycerides")
  stringform <- paste0("peakheight ~ HbA1c + calories + carbs + protein + fat + Age + ", paste(improvers,  collapse = " + "), " + (1|participant_id)")
  model <- lmer(as.formula(stringform), data = train_data)
  
  #evaluate model
  predicted <- predict(model, newdata = test_data)
  actual <- test_data$peakheight
  plot(predicted, actual, xlab = "Predicted", ylab = "actual")
  rmse <- sqrt(mean((predicted - actual)^2))
  r_squared <- r.squaredGLMM(model)
  cat(sprintf("RMSE: %f and R^2: %f", rmse, r_squared[1]))
  newrow <- c("combined w trig", rmse, r_squared[1])
  results <- rbind(results, newrow)

})

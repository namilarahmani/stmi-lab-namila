# Evaluating Effects of Physical Activity and Nutrition on Postprandial Glycemic Response (PPGR)
Hello! This repository is for my work with Dr. Mortazavi and the STMI lab at Texas A&M University through PATHSUP REU 2023 

## Summary
Processed raw data and built extreme gradient boosting models and linear mixed effects models to evaluate relationships between macronutrient content, activity, individual lab data, and glycemic response (CGM data) for applications in automated diet monitoring or personalized nutritional recommendations for glycemic control. 

## Overview of Key Files
- `combined_dataset.ipynb`: used to generate individual and combined datasets from raw fitbit and CGM data
- `xgboost_notuning.ipynb`: preliminary xgboost modeling with no hyperparameter tuning - can be used with different input columns to run tests quickly. Uses individual datasets and runs with and without dinner meals
- `tunedxgboost2.ipynb`: xgboost modeling with gridsearch hyperparameter tuning - was used for poster results and works similarly to untuned file but takes some time to run
- `linearmixedeffects.R`: builds linear mixed effects model with combined dataset and looks at coefficient of correlation - results will be generated in a dataframe but not exported
 
## Dataset
To run files, download participant xlxs files in `mealtimes` subdirectory as well as participant demographics, Fitbit raw data, and Dexcom CGM raw data from STMI drive

## Future Work
- **Features:** Experiment with more individual lab features, METs features, and integration with gut microbiome data.
- **Time Frames:** Change postprandial time window (ex: shorter/longer or factoring in pre-meal activity), and experiment with overall post-dinner time window or day by day predictions
- Expand LME to predict other features (like macronutrient predictions)
  
Feel free to contact me at namilarahmani@gmail.com for any additional information :)

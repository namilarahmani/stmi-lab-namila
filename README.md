# Evaluating Effects of Physical Activity and Nutrition on Postprandial Glycemic Response (PPGR)
Work with Dr. Mortazavi and STMI lab at Texas A&M University through PATHSUP REU 2023 

## Summary
Built extreme gradient boosting models and linear mixed effects models to evaluate relationships between macronutrient content, activity, individual lab data, and glycemic response (CGM data) for applications in automated diet monitoring or personalized nutritional recommendations for glycemic control.

## Overview of Key Files
- `combined_dataset.ipynb`: used to generate individual and combined datasets from raw fitbit and CGM data
- `xgboost_notuning.ipynb`: preliminary xgboost modeling with no hyperparameter tuning - can be used with different input columns to run tests quickly
- `tunedxgboost2.ipynb`: xgboost modeling with gridsearch hyperparameter tuning - was used for poster results and works similarly to untuned file but takes some time to run
- `linearmixedeffects.R`: builds linear mixed effects model with combined dataset - results will be generated in a dataframe but not exported
 
## Dataset
To run files, download participant csvs in `mealtimes` folder as well as Fitbit and Dexcom CGM raw data from STMI drive

Feel free to contact me at namilarahmani@gmail.com for any additional information :)

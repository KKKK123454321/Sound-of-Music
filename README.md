# Predict the rating of songs
The final placement on the leaderboard: 7/68 (RMSE: 14.5). An improved version can achive a RMSE of 12 (1/68).

## 1. Introduction
This report outlines the process undertaken to predict rating of songs based on their auditory features. This project was based on a dataset consisting of 19 features related to the property, the host and reviews of over 21000 songs. The goal was to develop a supervised machine learning model that resulted in the lowest root mean squared error (RMSE) on a previously unseen dataset of songs' features.

## 2. Modeling Framework
### Data Transformation
Feature engineering was used to create meaningful additional features from text data in the original dataset. 
- Handling List variable *genre*:
  - [ ] Extracting genre information: Remove the square brackets and commas from the "genre" field, allowing multiple genre values to be split into individual values.
  
  - [ ] Determining the uniqueness of genre values: The unique genre values are stored in a vector after removing any duplicates.
  
  - [ ] Creating new columns in the dataset: Based on the unique genre values obtained in the previous step, new columns are created in the dataset with each column representing a genre value.
  
  - [ ] Representing genre values as binary form: By iterating through each row's genre field, the code sets the corresponding column to 1 if a song belongs to that genre. Other columns associated with different genre values are set to 0, indicating that the song does not belong to those genres.
        
  - [ ] Selecting and combining columns based on a frequency threshold of 200.
 
- Unit conversion, handling outliers and categorical variables:
  - [ ] Converting track duration to minutes: Divide the track duration by the milliseconds per minute to obtain the corresponding duration in minutes. 
  - [ ] Handling outliers in the rating variable: Replace negative ratings with 0 and delete all rows with a rating less than 10.
  - [ ] Categorizing time signature: Classify songs with a time signature of 0, 1, or 5 as "Four", and classify all other time signatures as "Other".
  - [ ] Finding performers with the string "The": Use the grep function to find performers with the string "The" in their name.

### Modelling
- [ ] Initially, a linear regression model was built with the rating variable as the response and all other variables as predictors.
  - [ ] Stepwise model selection: Use the "stepAIC" function from the "MASS" package to perform stepwise model selection based on AIC.
  - [ ] VIF test: Use the "vif" function from the "car" package to check for multicollinearity among the predictors in the final model.
- [ ] Then, Gradient Boosting and Random Forest with the most influential factors were built to improve prediction accuracy.
- [ ] Finally, a Tuned Forest Ranger generated predictions with the lowest RMSE. After each model run, the test RMSE was calculated and compared with the proceeding model run. If the RMSE increased, the model was first tuned by changing tuning the following parameters:
  - [ ] the number of trees (num_trees)
  - [ ] the number of predictors used in each random forest (mtry) : if the current model achieves a higher R-squared value (r.squared) than the previously best model, the corresponding mtry value and R-squared value are updated.

## 3. Final remarks
Update on 9/15/2023: 
If the original dataset contains brief descriptions of the songs, Natural Language Processing techniques can be more useful to lower the RMSE. However, we can also apply NLP techniques on the songs title and genre in the current dataset:
- [ ] Named Entity Recognition (NER): Identify entities with specific meanings in the song titles and genre, such as locations, names of people, or organizations. This information can be used to construct corresponding textual features.
- [ ] Sentiment Analysis: Analyze the sentiment polarity (positive or negative) in the song titles. Libraries like VADER or TextBlob can be utilized to perform sentiment analysis and incorporate the sentiment polarity as textual features.


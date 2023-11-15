### Data
Data and how data was generated could be found here [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### Data Set Process
1. pick the index of variables names containing mean or std via regular expression;
2. remove "()" and "-", and then lower case the variable names chosen;
3. read and combine the related files horizontally;
4. reshape the combined data.table to create data.tables showing means by subject and activities;
5. write out and save the data in csv form

### Data
Data and how data was generated could be found here [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

### Data Set Process
1. pick the index of variables names containing mean or std via regular expression;
2. remove "()" and use gsub make to the variable names chosen more readable;
3. read and combine the related files;
4. work out the means by subject and activities via pipe;
5. write out and save the data in txt form

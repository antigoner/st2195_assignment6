//Content of Repository
Contains two scripts (Python and R) to perform the operations described below, and 
this readme.md file. The operation steps are numbered accordingly in the scripts.

  1. Load and merge the datasets keeping all information available for the dates in
     which there is a measurement in “fx.csv”.

  2. Remove entries with obvious outliers or mistakes, if any.
     
  3. Handle missing observations for the exchange rate. Replace any missing exchange
     rate with the latest information available.

  4. Calculate the exchange rate return. Extend the original dataset with the
  following variables:
     “good_news” (equal to 1 when the exchange rate return is
     larger than 0.5 percent, 0 otherwise) and,
     “bad_news” (equal to 1 when the exchange rate return
     is lower than -0.5 percent, 0 otherwise).

  5. Remove the entries for which contents column has NA values. Generate and
  store in csv the following tables:
    a. “good_indicators” – with the 20 most common words (excluding articles,
        prepositions and similar connectors) associated with entries wherein
        “good_news” is equal to 1;
    b. “bad_indicators” – with the 20 most common words (excluding articles,
        prepositions and similar connectors) associated with entries wherein
        “bad_news” is equal to 1;


//sources

original_speeches.csv from ECB speeches dataset:
https://www.ecb.europa.eu/press/key/html/downloads.en.html

original_fx.csv (daily EUR/USD reference exchange rate) from the ECB Data Portal:
https://data.ecb.europa.eu

stop_words_english.txt (list of stop words):
https://countwordsfree.com/stopwords

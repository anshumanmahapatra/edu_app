


# python -m spacy download en_core_web_lg





import nltk


nltk.download('vader_lexicon')


from nltk.sentiment.vader import SentimentIntensityAnalyzer 


sid=SentimentIntensityAnalyzer ()



x=sid.polarity_scores("she is a bitch 4234 4 >>")


x['neg']


import re
x=re.sub("[^a-zA-Z]"," ","jfkn12fe")
print(x)




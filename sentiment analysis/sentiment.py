
import argparse
ap = argparse.ArgumentParser()

ap.add_argument("--text",required=True,help="sentense whose sentiment o be analysed")
arg = vars(ap.parse_args())

import warnings
warnings.filterwarnings("ignore")

import nltk
nltk.download('vader_lexicon')
import re
nltk.download("stopwords")
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
lemma = WordNetLemmatizer()
doc = arg["text"]
doc = re.sub('[^a-zA-Z]',' ',doc)
doc = doc.split()
all_stopwords =  stopwords.words("english")
doc = [lemma.lemmatize(word) for word in doc if word not in set(all_stopwords)]
doc = ' '.join(doc)
from nltk.sentiment.vader import SentimentIntensityAnalyzer
sid  = SentimentIntensityAnalyzer()
sentiment=sid.polarity_scores(doc)
if sentiment['neg'] >0.5:
    print("hate speech")
else:
    print("not hate speech")
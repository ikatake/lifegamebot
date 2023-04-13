import sys
import tweepy
import _key_secret_

client = tweepy.Client(
    consumer_key=_key_secret_.ck, 
    consumer_secret=_key_secret_.cs,
    access_token=_key_secret_.at,
    access_token_secret=_key_secret_.ats
)

file_name:str = sys.argv[1]
with open(file_name) as f:
    s = f.read()

response = client.create_tweet(
    text=s
)
print(f"https://twitter.com/user/status/{response.data['id']}")
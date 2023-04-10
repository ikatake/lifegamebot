import tweepy


consumer_key = "Ufou5JQhr28ogVIag7841ezMD"
consumer_secret = "XPjlrB2U3Qasy6alCa5oBK1SnV86bgLmxYpxfzbUAF5ZBcDguW"
access_token = "51450169-5AvuaTtmtlfFAUV1gTe0NmV4vULUGVjRPaLl49oWk"
access_token_secret = "XNsPiFZO1l2HnyE9L3WHzv3mluf8eFDRYPOSf6pn3RIph"

client = tweepy.Client(
    consumer_key=consumer_key, consumer_secret=consumer_secret,
    access_token=access_token, access_token_secret=access_token_secret
)

# Create Tweet

# The app and the corresponding credentials must have the Write permission

# Check the App permissions section of the Settings tab of your app, under the
# Twitter Developer Portal Projects & Apps page at
# https://developer.twitter.com/en/portal/projects-and-apps

# Make sure to reauthorize your app / regenerate your access token and secret 
# after setting the Write permission

response = client.create_tweet(
    text="これは試験放送です。本日は晴天なり。本日は晴天なり。これは試験放送です。"
)
print(f"https://twitter.com/user/status/{response.data['id']}")
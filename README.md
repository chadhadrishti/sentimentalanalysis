# sentimentalanalysis
Context
VaccineMyths (r/VaccineMyths), is a subreddit where people discuss about various Vaccine Myths.

The data might contain a small percent of harsh language, the posts were not filtered.

Colection
Reddit posts from subreddit VaccineMyths , downloaded from https://www.reddit.com/r/VaccineMyths/ using praw (The Python Reddit API Wrapper).

Script used for collection can be found here: Reddit extract content

Content
Data contains both posts and comments.
Both posts and comments contains the following fields:

title - relevant for posts
score - relevant for posts - based on impact, number of comments
id - unique id for posts/comments
url - relevant for posts - url of post thread
commns_num - relevant for post - number of comments to this post
created - date of creation
body - relevant for posts/comments - text of the post or comment
timestamp - timestamp
Inspiration
You can use the data to:

Perform sentiment analysis;
Identify discussion topics;

\

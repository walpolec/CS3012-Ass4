install.packages("jsonlite")
install.packages("httpuv")
install.packages("httr")
install.packages("plotly")

library(jsonlite)
library(httpuv)
library(httr)
library(plotly)

# Can be github, linkedin etc depending on application
oauth_endpoints("github")

# Change based on what your application is
github_app = oauth_app(appname = "CS3012_API",
                       key = "4ca0f78923e70a27dc65",
                       secret = "cff288c23cc050745eaeca069adffd036f93387e")

# Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), github_app)

# Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)

# Take action on http error
stop_for_status(req)

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitDF = jsonlite::fromJSON(jsonlite::toJSON(json1))

# Subset data.frame
gitDF[gitDF$full_name == "jtleek/datasharing", "created_at"] 

# The code above was sourced from Michael Galarnyk's blog, found at:
# https://towardsdatascience.com/accessing-data-from-github-api-using-r-3633fb62cb08

# -----------------------------------------------------------------------------------

myData = fromJSON("https://api.github.com/users/walpolec")
# Number of followers
myData$followers
# Number following
myData$following
#Number of public repositories
myData$public_repos
  
myFollowers = fromJSON("https://api.github.com/users/walpolec/followers")
# Usernames of followers
myFollowers$login
# Number of people following me
length(myFollowers$login)
# Type of follower
myFollowers$type
# Followers url
myFollowers$url

usersImFollowing = fromJSON("https://api.github.com/users/walpolec/following") 
# Usernames of users I follow 
usersImFollowing$login
# Number of users I follow
length(usersImFollowing$login)
# Type of follower
usersImFollowing$type
# Followers url
usersImFollowing$url

repos = fromJSON("https://api.github.com/users/walpolec/repos")
# Names of repositories
repos$name
# Dates repositories created at
repos$created_at
# Language of repository
repos$language

#Can be replicated for any other user - this user taken from myFollowers$url
myData2 = fromJSON("https://api.github.com/users/endam1234")
# Number of followers
myData2$followers
# Number following
myData2$following
#Number of public repositories
myData2$public_repos

myFollowers2 = fromJSON("https://api.github.com/users/endam1234/followers")
# Usernames of followers
myFollowers2$login
# Number of people following me
length(myFollowers2$login)
# Type of follower
myFollowers2$type
# Followers url
myFollowers2$url

usersImFollowing2 = fromJSON("https://api.github.com/users/endam1234/following") 
# Usernames of users I follow 
usersImFollowing2$login
# Number of users I follow
length(usersImFollowing2$login)
# Type of follower
usersImFollowing2$type
# Followers url
usersImFollowing2$url

repos2 = fromJSON("https://api.github.com/users/endam1234/repos")
# Names of repositories
repos2$name
# Dates repositories created at
repos2$created_at
# Language of repository
repos2$language

#Link R to plotly. This creates online interactive graphs based on the d3js library
Sys.setenv("plotly_username"="")
Sys.setenv("plotly_api_key"="")

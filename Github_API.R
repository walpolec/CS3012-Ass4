install.packages("jsonlite")
install.packages("httpuv")
install.packages("httr")
install.packages("plotly")

library(plotly)
library(jsonlite)
library(httpuv)
library(httr)
require(devtools)

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

#Access User 'acadavid' Following to get list of users
acadavidData = GET("https://api.github.com/users/acadavid/following", gtoken)
# Extract content from acadavid
acadavidDataContent = content(acadavidData)
# Put content in dataframe
acadavidFollowingDataFrame = jsonlite::fromJSON(jsonlite::toJSON(acadavidDataContent))
# Subset dataframe
acadavidFollowingDataFrame$login
# Retrieve list usernames
id = acadavidFollowingDataFrame$login
user_ids = c(id)
# Create empty vector and data.frame
allUsers = c()
allUsersDF = data.frame(
  username = integer(),
  following = integer(),
  followers = integer(),
  repos = integer(),
  dateCreated = integer()
)
# Loop through usernames and find users to add to list
for(i in 1:length(user_ids))
{
  #Retrieve list of individual users 
  followingURL = paste("https://api.github.com/users/", user_ids[i], "/following", sep = "")
  following = GET(followingURL, gtoken)
  followingContent = content(following)
  #Ignore if they've 0 followers
  if(length(followingContent) == 0)
  {
    next
  }
  followingDF = jsonlite::fromJSON(jsonlite::toJSON(followingContent))
  followingLogin = followingDF$login
  #Loop through 'following' users
  for (j in 1:length(followingLogin))
  {
    #Check that user not already in list of users
    if (is.element(followingLogin[j], allUsers) == FALSE)
    {
      #Add user to list of users
      allUsers[length(allUsers) + 1] = followingLogin[j]
      #Retrieve data on each user
      followingURL2 = paste("https://api.github.com/users/", followingLogin[j], sep = "")
      following2 = GET(followingURL2, gtoken)
      followingContent2 = content(following2)
      followingDF2 = jsonlite::fromJSON(jsonlite::toJSON(followingContent2))
      #Retrieve each users following
      followingNumber = followingDF2$following
      #Retrieve each users followers
      followersNumber = followingDF2$followers
      #Retrieve each users number repositories
      reposNumber = followingDF2$public_repos
      #Retrieve year which each user joined Github
      yearCreated = substr(followingDF2$created_at, start = 1, stop = 4)
      #Add users data to a new row in dataframe
      allUsersDF[nrow(allUsersDF) + 1, ] = c(followingLogin[j], followingNumber, followersNumber, reposNumber, yearCreated)
    }
    next
  }
  #Stop when there are more than 400 users
  if(length(allUsers) > 400)
  {
    break
  }
  next
}

#Link R to plotly. This creates online interactive graphs based on the d3js library
Sys.setenv("plotly_username"="walpolec")
Sys.setenv("plotly_api_key"="I7l5K1eZw8nlkzX7TNYP")

#Produce scatter plot of Following vs Followers
plot1 = plot_ly(data = allUsersDF, x = ~following, y = ~followers, text = ~paste("Following: ", following, 
                                                                                  "<br>Followers: ", followers))
plot1
#Upload the plot to Plotly
Sys.setenv("plotly_username" = "walpolec")
Sys.setenv("plotly_api_key" = "I7l5K1eZw8nlkzX7TNYP")
api_create(plot1, filename = "Following vs Followers")
#PLOTLY LINK: https://plot.ly/~walpolec/1/#/

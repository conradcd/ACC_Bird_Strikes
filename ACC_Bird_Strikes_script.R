# Install/Load Required Packages
install.packages("RCurl")
library(RCurl)


# Read CSV 
require(RCurl)
full_set = read.csv(text = getURL("https://raw.githubusercontent.com/conradcd/ACC_Bird_Strikes/master/1991-2017_match.csv"), header = T)

# Install/Load Required Packages
install.packages("RCurl")
library(RCurl)


# Read CSV 
require(RCurl)
full_set = read.csv(text = getURL("https://raw.githubusercontent.com/conradcd/ACC_Bird_Strikes/master/1991-2017_match.csv"), header = T)


# Make survival binary from "Disposition"
Survive_full = c()
for(i in seq(1, nrow(full_set))){
  if(full_set$Disposition[i]=="Died" | full_set$Disposition[i]=="Euthanized" | full_set$Disposition[i]=="DIED" | full_set$Disposition[i]=="NR/EUTHANIZED" | full_set$Disposition[i]=="NR/DIED" | full_set$Disposition[i]=="TRANSFERRED/EUTHANIZED" | full_set$Disposition[i]=="TRANSFERRED/DIED") {
    Survive_full[i] = 0
  }
  else if(full_set$Disposition[i]== "Released" | full_set$Disposition[i]=="Self-Release" | full_set$Disposition[i]=="RELEASED" | full_set$Disposition[i]=="NR/RELEASED") {
    Survive_full[i] = 1
  }
}
full_set = cbind(full_set, Survive_full)
Survive_full = full_set$Survive_full

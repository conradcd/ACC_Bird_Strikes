# Install/Load Required Packages
install.packages("RCurl")
library(RCurl)


# Read CSV 
require(RCurl)
full_set = read.csv(text = getURL("https://raw.githubusercontent.com/conradcd/ACC_Bird_Strikes/master/1991-2017_match.csv"), header = T)

# This CSV file is a combination of strike data from 2013-2017
# pulled from an online database, and older data from 1991-2013 
# exported to CSV from a Microsoft Access file. The older data 
# has less info, so columns were deleted from the newer set to match.

# Common species name is missing from the older data, so first...
# (despite countless attempts, this simple task eluded me)

# First, lets quickly examine which species are most prevalent
full_sp = full_set$Species_Abv
abv_freq = table(full_sp)
sort(abv_freq)
pie(abv_freq)

# Since I'm having trouble with the common name for all abbreviations,
# what are the names of the top ten? 
# Common name for top 10
for(i in seq(1, nrow(full_set)))  {
  if(full_set$Species_Abv[i] == "RTHA")
    full_set$Common.Species.Name[i] = "Red-Tailed Hawk"
  else if(full_set$Species_Abv[i] == "BDOW")
    full_set$Common.Species.Name[i] = "Barred Owl"
  else if(full_set$Species_Abv[i] == "EASO")
    full_set$Common.Species.Name[i] = "Eastern Screech Owl"
  else if(full_set$Species_Abv[i] == "GHOW")
    full_set$Common.Species.Name[i] = "Great Horned Owl"
  else if(full_set$Species_Abv[i] == "OSPR")
    full_set$Common.Species.Name[i] = "Osprey"
  else if(full_set$Species_Abv[i] == "RSHA")
    full_set$Common.Species.Name[i] = "Red-Shouldered Hawk"
  else if(full_set$Species_Abv[i] == "COHA")
    full_set$Common.Species.Name = "Cooper's Hawk"
  else if(full_set$Species_Abv[i] == "MIKI")
    full_set$Common.Species.Name[i] = "Mississippi Kite"
  else if(full_set$Species_Abv[i] == "TUVU")
    full_set$Common.Species.Name[i] = "Turkey Vulture"
  else if(full_set$Species_Abv[i] == "BAEA")
    full_set$Common.Species.Name[i] = "Bald Eagle"
}


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



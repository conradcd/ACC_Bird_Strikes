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

# "Disposition" has quite a few factors that either ammount to 'lived' or 'died',
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

# Model survival based on species and duration of care 
glm_full = glm(full_set$Survive_full ~ full_set$Species_Abv + full_set$Duration.of.Care)
summary(glm_full)
plot(glm_full)

# Based on P-value, "Duration of Care" is most significant, which stands to reason,
# as birds that died or were euathanized would have shorter durations.
# There are some statistically significant species with relatively high T-values:
# AMKE (American Kestrel): 4.085
# BAEA (Bald Eagle): 3.576
# BDOW (Barred Owl): 3.89
# BNOW (Barn Owl): 3.65
# EASO (Eastern Screech Owl): 4.625
# MIKI (Mississippi Kite): 4.097

# In each of these, species is positively correlated with survival. 
# Each of these species is highly represented, so it's possible the bird hospital
# is simply more experienced in dealing with them

# Subset top ten representatives 
full_sub = full_set[full_set$Species_Abv == c("RTHA", "BDOW", "EASO", "GHOW", "OSPR", "RSHA", "COHA", "MIKI", "TUVU", "BAEA"),]
Survive_sub = full_sub$Survive_full
sp_sub = full_sub$Species_Abv
doc_sub = full_sub$Duration.of.Care
glm_sub = glm(Survive_sub ~ sp_sub + doc_sub)
summary(glm_sub)
# With the rest of the species removed, species does not have a significant efect on survival

# Let's look at some individual species
Barred_Owl = strikes[strikes$Other.Idenifier == "BDOW" | strikes$Common.Species.Name == "Barred OWl",]
Barred_Owl
glm_BDOW = glm(Barred_Owl$Survive ~ Barred_Owl$Life.Stage + Barred_Owl$Duration.of.Care..in.days. + Barred_Owl$Anatomical.site.of.Injury)
summary(glm_BDOW)

Red_Tailed_Hawk = strikes[strikes$Other.Idenifier == "RTHA" | strikes$Common.Species.Name == "Red-Tailed Hawk",]
Red_Tailed_Hawk
glm_RTHA = glm(Red_Tailed_Hawk$Survive ~ Red_Tailed_Hawk$Life.Stage + Red_Tailed_Hawk$Duration.of.Care..in.days. + Red_Tailed_Hawk$Anatomical.site.of.Injury)
summary(glm_RTHA)

# The older dataset (1991-2013) has more consistent nomenclature on "Details of Rescue",
# so examine the factors and see if any play a significant role in survival

# Old data read CSV
require(RCurl)
old = read.csv(text = getURL("https://raw.githubusercontent.com/conradcd/ACC_Bird_Strikes/master/1991-2013.csv"), header = T)

# Factors of "Details of Rescue"
unique(old$Details.of.rescue)
# ...Brutal. Need to clean these up to make any sense of them 
# "S ____" stands for 'suspected' and according to my contact at the Birds of Prey center, they're usually accurate
Details = table(old$Details.of.rescue)
sort(Details)

# Create new column narrowing down the factors to work with 
Details_clean = c()
Details_clean = old$Details_clean
for(i in seq(1, nrow(old))) {
  if(old$Details.of.rescue[i] == "ORPHANED" | old$Details.of.rescue[i] == "TRANSFER IN/ORPHANED" | old$Details.of.rescue[i] == "ORPHANED/EMACIATION" | old$Details.of.rescue[i] == "ORPHANED/FFN" | old$Details.of.rescue[i] == "ORPHANED/NEST DEST" | old$Details.of.rescue[i] == "ORPHANED/FLEDGLING" | old$Details.of.rescue[i] == "ORPHANED: FLEDGLING" | old$Details.of.rescue[i] == "ORPHANED: FFN" | old$Details.of.rescue[i] == "ORPHANED: TREE CUT" | old$Details.of.rescue[i] == "ORPHANED: NEST DEST" | old$Details.of.rescue[i] == "ORPHAN/KIDNAP" | old$Details.of.rescue[i] == "ORPHANED: JUMPED" | old$Details.of.rescue[i] == "Orphaned: FFN" | old$Details.of.rescue[i] == "ORPHANED: BRANCHER" | old$Details.of.rescue[i] == "ORPHANED/KIDNAPPED" | old$Details.of.rescue[i] == "ORPHANED/KIDNAP" | old$Details.of.rescue[i] == "ORPHANED/TREE CUT") {
    Details_clean[i] = "Orphaned"
  }
  else if(old$Details.of.rescue[i] == "COLLISION" | old$Details.of.rescue[i] == "S COLLISION" | old$Details.of.rescue[i] == "TRANSFER IN/S COLLISION" | old$Details.of.rescue[i] == "TRANSFER IN/COLLISION" | old$Details.of.rescue[i] == "COLLISION/ENTANGLED" | old$Details.of.rescue[i] == "COLLISION/GUNSHOT" | old$Details.of.rescue[i] == "S COLLISION/GUNSHOT" | old$Details.of.rescue[i] == "S COLLISION/INFECTION" | old$Details.of.rescue[i] == "S COLLSION" | old$Details.of.rescue[i] == "S COLLISION/EMAC" | old$Details.of.rescue[i] == "COLLISION: FFN") {
    Details_clean[i] = "Collision"
  }
  else if(old$Details.of.rescue[i] == "EMACIATION" | old$Details.of.rescue[i] == "TRANSFER IN/EMACIATION" | old$Details.of.rescue[i] == "TRAPPED/EMACIATION" | old$Details.of.rescue[i] == "TRAPPED/EMACIATED") {
    Details_clean[i] = "Emaciated"
  }
  else if(old$Details.of.rescue[i] == "HBC" | old$Details.of.rescue[i] == "S HBC/GUNSHOT" | old$Details.of.rescue[i] == "HBC/GUNSHOT" | old$Details.of.rescue[i] == "TRANSFER IN/S HBC" | old$Details.of.rescue[i] == "HBC/ENTANGLED" | old$Details.of.rescue[i] == "HBC/ S COLLISION") {
    Details_clean[i] = "HBC"
  }
  else if(old$Details.of.rescue[i] == "GUNSHOT" | old$Details.of.rescue[i] == "GUNSHOT" | old$Details.of.rescue[i] == "GUNSHOT/SPP CONFLICT") {
    Details_clean[i] = "Gunshot"
  }
}
old = cbind(old, Details_clean)
Details_clean = old$Details_clean
# This isn't doing what it is supposed to 

# Old binary survive
Survive_old = c()
for(i in seq(1, nrow(old))){
  if(old$Disposition[i]=="Died" | old$Disposition[i]=="Euthanized" | old$Disposition[i]=="DIED" | old$Disposition[i]=="NR/EUTHANIZED" | old$Disposition[i]=="NR/DIED" | old$Disposition[i]=="TRANSFERRED/EUTHANIZED" | old$Disposition[i]=="TRANSFERRED/DIED") {
    Survive_old[i] = 0
  }
  else if(old$Disposition[i]== "Released" | old$Disposition[i]=="Self-Release" | old$Disposition[i]=="RELEASED" | old$Disposition[i]=="NR/RELEASED") {
    Survive_old[i] = 1
  }
}
old = cbind(old, Survive_old)
Survive_old = old$Survive_old
# also not working properly 
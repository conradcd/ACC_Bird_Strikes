

# Load packages and CSV
install.packages("RCurl")
library(RCurl)
install.packages("ggplot2")
library(ggplot2)
require(RCurl)
full_set = read.csv(text = getURL("https://raw.githubusercontent.com/conradcd/ACC_Bird_Strikes/master/1991-2017_match.csv"), header = T)

# Which species are most represented
full_sp = full_set$Species_Abv
abv_freq = table(full_sp)
abv_freq_sort = sort(abv_freq)
abv_freq_sort




# Make survival binary
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

# Subset and Frequency of survived/died
subset_died = subset(full_set, Survive_full < 1)
subset_survived = subset(full_set, Survive_full > 0)
died_sp = subset_died$Species_Abv
died_freq = table(died_sp)
surv_sp = subset_survived$Species_Abv
surv_freq = table(surv_sp)
plot(died_freq, col = 'red', cex.axis = .5, las = 2)
plot(surv_freq, col = 'green', cex.axis = .5, las = 2)
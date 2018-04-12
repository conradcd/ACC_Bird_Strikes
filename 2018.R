# Install/Load Required Packages
install.packages("RCurl")
library(RCurl)
install.packages("maps")
install.packages("maptools")
library(maps)
library(maptools)
install.packages("zoom")
library(zoom)

# Read CSV
wrmd_2018 = read.csv(text = getURL("https://raw.githubusercontent.com/conradcd/ACC_Bird_Strikes/master/wrmd_2018_edit.csv"), header = T)

# Make survival binary 
unique(wrmd_2018$patients_disposition)
wrmd_survive = c()
for(i in seq(1, nrow(wrmd_2018))){
  if(wrmd_2018$patients_disposition[i] == "Euthanized in 24hr" | wrmd_2018$patients_disposition[i] == "Euthanized +24hr" | wrmd_2018$patients_disposition[i] == "Died +24hr" | wrmd_2018$patients_disposition[i] == "Died in 24hr" | wrmd_2018$patients_disposition[i] == "Dead on arrival") {
    wrmd_survive[i] = 0
  }
  else if(wrmd_2018$patients_disposition[i] == "Released") {
    wrmd_survive[i] = 1
  }
}
wrmd_2018 = cbind(wrmd_2018, wrmd_survive)
wrmd_survive = wrmd_2018$wrmd_survive

# Map new points by suvive binrary
map_SE_surv = map(database="state",regions=c("south carolina"))
points(wrmd_2018$patients_lng_found, wrmd_2018$patients_lat_found, col = wrmd_2018$wrmd_survive, cex = .3)
# Colors aren't visible
# Map new points by species 
map_SE_species = map(database="state",regions=c("south carolina"))
points(wrmd_2018$patients_lng_found, wrmd_2018$patients_lat_found, col = wrmd_2018$species_common_name, cex = .3)
# In both maps I'm having trouble setting the boundaries. Essentially, a zoom would suffice, but this isnt't working either. 

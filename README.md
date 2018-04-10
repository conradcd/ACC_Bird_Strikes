# ACC_Bird_Strikes

This project is a working attempt to analyze data collected by the Avian Conservation Center over the last 25 years on inpatient birds either called in or brought to the Birds of Prey Center in Awendaw, SC. 
The ongoing effort will be to look at (when available) past, and certainly future, geographic data to get a better sense of where birds are being injured in the area. 
Tracking land-cover change over time and the associated rise in bird injuries/mortalities can at the very least inform, if not direct future area development, from a conservation standpoint. 
While currently geographic data is sparse at best, I'll now venture to squeeze whatever information I can out of the data I have, as I went to great lengths just to retrieve it and the birds unfortunatelu sacrificed far more. 

The data comes in three main sets with varying degrees of sophistication and consistancy. 

The first set, chronologically speaking, I've named "old" and covers the years 1991-2013 stored in an ancient Microsoft Access format and exported to Excel and ultimately CSV. 
Initially birds are listed only by a four letter abbreviation and "Day Admited, "Day Released", "Disposition", and a few minor "Details of Rescue" are all that are provided. 
From the Admission and Release dates, I've created a "Duration of Care" column to more closely resemble the nxt set of data

The next set covers the years 2013-2017 and was  recovered from an online database named "Wild-one.org". 
While it has far more information with regard to Rescue details and bird injury/medical care, it lacks consistent nomenclature on many factors and is thus, difficult to analyze. 
For this reason, I've removed many of the variables and combined this with the older data into a term named "full_set", spanning 1991-2017. 

The final piece of data contains only that which has been collected in these first few months of 2018, but already has a staggering 90 entries. It was pulled from an online database called "wrmd.org" and has geographic coordinates, way more information than we would ever need on who found the bird, and pretty thorough medical information with respect to not only the specific injury, but also any exams performed on individual birds. 
This dataset will become increasingly useful as more is added to it but at the moment serves primarily as a reference for what's to come. 

The code included is in R.Script format and is to be run in order

I'd like to thank Dan McGlinn for invaluable statistical and programming guidance, not to mention a level of patience that borders on divine. 
I'd also like to thank Emily Davs and the whole of the Avian Conservation Center, for collecting this mountain of information and allowing me access to it. Also, for some truly uniqe bird encounters I've had in my visits to the Birds of Prey Center. 


install.packages("RJSDMX")
install.packages("dplyr")
install.packages("googleVis")

library(RJSDMX)
library(dplyr)
library(googleVis)

addProvider("Test", "http://7369a.sdmxcloud.org/ws/public/sdmxapi/rest/")
getFlows("Test")

#SEPARATE BASED ON DIRECT AND INDIRECT
TABLE8 <- getTimeSeriesTable("Test", "COE_ASSESSMENT/...")
TABLE8

#SPLIT TABLE BETWEEN DIRECT AND INDIRECT
TABLE8.1 = split(TABLE8,TABLE8$ASSESSMENT)

#DROP COLUMNS
TABLE8.2 = data.frame(TABLE8.1)
TABLE9 = TABLE8.2[-c(7,8,10:14)]

#REORDER COLUMNS data[c(1,3,2)]
TABLE10 <- TABLE9[c(5,1,2,7,6,3,4)]

#DROP VALUES NOT SLO1 http://stackoverflow.com/questions/6650510/remove-rows-from-data-frame-where-a-row-match-a-string
TABLE11 <- TABLE10[TABLE10$DIRECT.SLOS == "SLO1",]

#CONVERT DATE STRING TO NUMERIC
TABLE12 <- mutate(TABLE11, DIRECT.TIME_PERIOD=as.Date(DIRECT.TIME_PERIOD,format="%Y-%d"))

#THANK MATT
cb= "Chris B. says, 'Matt - Thank you!'"

#CREATE THE CHART
m=gvisMotionChart(TABLE12, idvar="DIRECT.ID", timevar="DIRECT.TIME_PERIOD", date.format="%Y-%d")

##PLOT THE CHART
ComboChart <- structure(list(type='MotionChart', 
                             #chartid='myComboChart', 
                             html=list(header=m$html$header,
                                       chart=list(m$html$chart), 
                                       title="Fusion Registry to R -- ",
                                       footer=cb)), class=c("gvis", "list"))
plot(ComboChart)
library(ggplot2)
library(RColorBrewer)
library(dplyr)


# Download and unzip the file:
dir.create("./air_pollution")
urlzip <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(urlzip, destfile = "./air_pollution.zip" )
unzip("./air_pollution.zip", exdir = "./air_pollution" )


# Load the data:
NEI <- readRDS("./air_pollution/summarySCC_PM25.rds")
SCC <- readRDS("./air_pollution/Source_Classification_Code.rds")

#Join NEI and SCC to get the SCC descriptions
joinedNEI <- inner_join(NEI, SCC)


#Filter out only the PM25-PRI records for Baltimore for Mobile Sources and then sum by year using dplyr functions
pm25MotorCounty <- joinedNEI %>% filter(SCC.Level.One == "Mobile Sources" & (fips == "24510" | fips == "06037") & Pollutant == "PM25-PRI") %>% group_by(year, fips) %>% summarise(Emissions = sum(Emissions))

#Plot the x and y using base plot function
ggplot(pm25MotorCounty, aes(x = year, y = Emissions)) + theme_minimal() + 
geom_line(aes(color = pm25MotorCounty$fips)) + labs(title = "Total PM2.5 Motor Vehicle Emissions", x = "Year", y = "PM2.5 Emissions", color = "Fips")

#Store output in a png file
dev.copy(png, "Plot6-PM_Levels_County-Wise_Motor_Vehicles.png")
dev.off()
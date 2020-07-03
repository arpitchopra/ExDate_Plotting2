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
pm25Motor <- joinedNEI %>% filter(SCC.Level.One == "Mobile Sources" & fips == "24510" & Pollutant == "PM25-PRI") %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

#Plot the x and y using base plot function
ggplot(pm25Motor, aes(x = year, y = Emissions)) + theme_minimal() + 
  geom_line() + labs(title = "Total PM2.5 Motor Vehicle Emissions in Baltimore", x = "Year", y = "PM2.5 Emissions")

#Store output in a png file
dev.copy(png, "Plot5-PM_Levels_Baltimore_Motor_Vehicles.png")
dev.off()
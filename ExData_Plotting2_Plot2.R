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


#Filter out only the PM25-PRI records and then sum by year using dplyr functions
pm25Balt <- NEI %>% filter(Pollutant == "PM25-PRI" & fips == "24510") %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

#Plot the x and y using base plot function
plot(pm25Balt$year, pm25Balt$Emissions, type = "o", pch = 19, lwd = 2, col= "blue", main = "Total PM2.5 emissions in Baltimore", xlab = "Year", ylab = "PM2.5 Emissions")

#Store output in a png file
dev.copy(png, "Plot2-PM_Levels_Baltimore_Trend.png")
dev.off()




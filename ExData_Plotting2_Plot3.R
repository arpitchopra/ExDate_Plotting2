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


#Filter out only the PM25-PRI records and then sum by year and type using dplyr functions
pm25BaltType <- NEI %>% filter(Pollutant == "PM25-PRI" & fips == "24510") %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))

#Plot the x and y using base plot function
ggplot(pm25BaltType, aes(x = pm25BaltType$year, y = pm25BaltType$Emissions)) + theme_minimal() + 
geom_line(aes(color = pm25BaltType$type)) + labs(title = "Total PM2.5 Emissions in Baltimore by Type", x = "Year", y = "PM2.5 Emissions", color="Type")

#Store output in a png file
dev.copy(png, "Plot3-PM_Levels_Baltimore_By_Type.png")
dev.off()




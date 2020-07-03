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
joinedNEI <- inner_join(NEI, SCC)

#Filter out only the PM25-PRI records and then sum by year and type using dplyr functions
pm25Coal <- joinedNEI %>% filter(grepl('Coal', Short.Name) & grepl('Comb',SCC.Level.One) & Pollutant == "PM25-PRI") %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

#Plot the x and y using base plot function
ggplot(pm25Coal, aes(x = year, y = Emissions)) + theme_minimal() + 
  geom_line() + labs(title = "Total PM2.5 Coal Emissions in US", x = "Year", y = "PM2.5 Emissions")

#Store output in a png file
dev.copy(png, "Plot4-PM_Levels_US_Coal_Combustion.png")
dev.off()
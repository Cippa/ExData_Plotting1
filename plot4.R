# Clean environment
rm(list = ls())
objects()
search()
intersect(objects(), search())

# Libraries used
library(tidyverse)
library(lubridate)

# Download data
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = fileURL, destfile = "Electric_power_consumption.zip", method = "curl")
# Unzip file
unzip(zipfile = "Electric_power_consumption.zip")

# Read data
powerCons <-
        read.table(
                file = "household_power_consumption.txt",
                header = T,
                sep = ";",
                na.strings = "?",
                stringsAsFactors = F
        )


powerCons$Date <- dmy(powerCons$Date)

# Resize dataset since we work with the dates 2007-02-01 and 2007-02-02 only
powerCons <- powerCons %>%
        filter(Date == "2007-02-01" | Date == "2007-02-02")


# Creating DateTime variable
powerCons$DateTime <- paste(powerCons$Date, powerCons$Time, sep = "_")
powerCons$DateTime <- ymd_hms(powerCons$DateTime)

# Open PNG graphics device
png(filename = "plot4.png", width = 480, height = 480, units = "px")

par(mfrow = c(2,2))

plot(
        powerCons$DateTime,
        powerCons$Global_active_power,
        type = "l",
        xlab = "",
        ylab = "Global ACtive Power (kilowatts)"
)

plot(
        powerCons$DateTime,
        powerCons$Voltage,
        type = "l",
        xlab = "datetime",
        ylab = "Voltage"
)

plot(
        powerCons$DateTime,
        powerCons$Sub_metering_1,
        type = "l",
        xlab = "",
        ylab = "Energy sub metering"
)
lines(powerCons$DateTime,
      powerCons$Sub_metering_2, col = "red")
lines(powerCons$DateTime,
      powerCons$Sub_metering_3, col = "blue")
legend(
        x = "topright",
        bty = "n",
        legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        lty = 1,
        col = c("black", "red", "blue"),
        
)

plot(
        powerCons$DateTime,
        powerCons$Global_reactive_power,
        type = "l",
        xlab = "datetime",
        ylab = "Global_reactive_power"
)

# Close graphics device
dev.off()

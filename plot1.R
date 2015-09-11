#------------------------------------------------------------------------------
# Programe Name: plot1
# Description  : 
#     This programe will download the required file if not already downloaded.
#     By utilizing the subset of the data, plots the graph and saves the graph 
#     as plot1.png
#
# Created By  : Subrat Kumar Sahu
#------------------------------------------------------------------------------

  RawFileName <- "exdata-data-household_power_consumption.zip"
  if(!file.exists(RawFileName)) {		
    download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",RawFileName)
    RawFile <- unzip(RawFileName)
  } else {
    RawFile <- unzip(RawFileName)
  }

# Load the unziped file
  PowerData <- read.table(RawFile, sep = ";",header = TRUE,  na.strings = "?",  stringsAsFactors=FALSE, dec=".",strip.white = FALSE,blank.lines.skip = TRUE)
# Convert the Date column to proper Date data type
  PowerData$Date <- as.Date(PowerData$Date, format="%d/%m/%Y")

# Create Subset of the data that is required for plotting
  PowerDf <- subset(PowerData, PowerData$Date=="2007-02-01" | PowerData$Date=="2007-02-02")

# Convert the Data type as required
  PowerDf$Global_active_power <- as.numeric(PowerDf$Global_active_power)
  PowerDf$Global_reactive_power <- as.numeric(as.character(PowerDf$Global_reactive_power))
  PowerDf$Voltage <- as.numeric(as.character(PowerDf$Voltage))
  PowerDf <- transform(PowerDf, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")
  PowerDf$Sub_metering_1 <- as.numeric(as.character(PowerDf$Sub_metering_1))
  PowerDf$Sub_metering_2 <- as.numeric(as.character(PowerDf$Sub_metering_2))
  PowerDf$Sub_metering_3 <- as.numeric(as.character(PowerDf$Sub_metering_3))


plot1 <- function() {
  hist(PowerDf$Global_active_power, main = paste("Global Active Power"), col="red", xlab="Global Active Power (kilowatts)")
  dev.copy(png, file="plot1.png", width=480, height=480)
  dev.off()
  cat("plot1.png is saved at ", getwd())
}
plot1()

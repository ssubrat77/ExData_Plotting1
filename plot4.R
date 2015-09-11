#------------------------------------------------------------------------------
# Programe Name: plot4
# Description  : 
#     This programe will download the required file if not already downloaded.
#     By utilizing the subset of the data, plots the graph and saves the graph 
#     as plot4.png
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

plot4 <- function() {
  par(mfrow=c(2,2))
  
  #Plot Graph 1
  plot(PowerDf$timestamp,PowerDf$Global_active_power, type="l", xlab="", ylab="Global Active Power")
  
  #Plot Graph 2
  plot(PowerDf$timestamp,PowerDf$Voltage, type="l", xlab="datetime", ylab="Voltage")
  
  #Plot Graph 3
  plot(PowerDf$timestamp,PowerDf$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
  lines(PowerDf$timestamp,PowerDf$Sub_metering_2,col="red")
  lines(PowerDf$timestamp,PowerDf$Sub_metering_3,col="blue")
  legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), bty="n", cex=.5) #bty removes the box, cex shrinks the text, spacing added after labels so it renders correctly
  
  #Plot Graph 4
  plot(PowerDf$timestamp,PowerDf$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
  
  #Save the complete plot area
  dev.copy(png, file="plot4.png", width=480, height=480)
  dev.off()
  cat("plot4.png is saved at ", getwd())
}
plot4()

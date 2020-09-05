filename <- "exdata_data_household_power_consumption.zip"

if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HPC Dataset")) { 
        unzip(filename) 
}

HPC <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))

HPC$Date <- as.Date(HPC$Date, "%d/ %m/ %Y")
HPC <- subset(HPC, Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))
HPC <- HPC[complete.cases(HPC),]
dateTime <- paste(HPC$Date, HPC$Time)
dateTime <- setNames(dateTime, "DateTime")
HPC <- HPC[ ,!(names(HPC) %in% c("Date", "Time"))]
t <- cbind(dateTime, HPC)
HPC <- cbind(dateTime, HPC)
HPC$dateTime <- as.POSIXct(dateTime)

par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))
with(HPC, {
        plot(Global_active_power~dateTime, type = "l", ylab = "Global Active Power", xlab = "")
        plot(Voltage, type = "l", ylab = "Voltage", xlab = "")
        plot(Sub_metering_1~dateTime, type="l", 
             ylab="Global Active Power", xlab="")
        lines(Sub_metering_2~dateTime,col='Red')
        lines(Sub_metering_3~dateTime,col='Blue')
        legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n",
               legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
        plot(Global_reactive_power~dateTime, type = "l", ylab = "Global_reactive_power", xlab = "")
})

dev.copy(png, "plot4.png", width=480, height=480)
dev.off()


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

plot(HPC$Global_active_power~HPC$dateTime, type="l", ylab = "Global Active Power (Kilowatts)", xlab = "")

dev.copy(png, "plot2.png", width=480, height=480)
dev.off()
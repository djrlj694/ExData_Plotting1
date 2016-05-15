################################################################################
# FILE:   plot4.R
# AUTHOR: Robert L. Jones (RLJ)
#
# ABSTRACT:
# The overall goal here is simply to examine how household energy usage varies
# over a 2-day period in February, 2007. This particular task is to reconstruct
# Plot 4 ("plot4.png") using the base plotting system -- i.e., a 480x480 pixel,
# 2x2 trellis of line graphs of the following time series between 01FEB2007 and
# 02FEB2007:
# 1. Global active power;
# 2. Voltage;
# 3. Energy substation metering;
# 4. "Global_reactive_power".
#
# ARG(S): N/A
#
# RETURNS: plot4.png (output file)
#
# INSPIRATION(S): N/A
#
# NOTE:
# To load this file, run the following:
# > setwd(<PROJECTROOT>)
# > source(file.path(<CODEDIR>, "plot4.R"))
#
# EXAMPLE: N/A
#
# DATE:      AUTHOR:  COMMENT:
# 15MAY2016  RLJ      Initial creation.
################################################################################

################################################################################
# 1. Define script parameters.
################################################################################

print("Begin STEP 1.")

# File specifications
file.dsin <- "household_power_consumption.txt"
file.plot <- "plot4.png"

# Plot specifications
plot.width <- 480
plot.height <- 480

# Other specifications
colClasses <- c("character", "character", rep("numeric", 3), "NULL", rep("numeric", 3))
dates <- as.Date(c("2007-02-01", "2007-02-02"), "%Y-%m-%d")

################################################################################
# 2. Read source data.
################################################################################

print("Begin STEP 2.")

# Declare helper function for reading data from flat files.
readData <- function(dataFile, header=FALSE, sep="",
                     na.strings="NA", colClasses=NA,
                     stringsAsFactors=default.stringsAsFactors()) {
  path <- file.path("data", dataFile)
  if (file.exists(path)) {
    read.table(path, header=header, sep=sep,
               na.strings=na.strings, colClasses=colClasses,
               stringsAsFactors=stringsAsFactors)
  }
}

# Create data frame to plot.
df.source <- readData(file.dsin, header=TRUE, sep=";", na.strings="?",
                      colClasses=colClasses, stringsAsFactors=FALSE)
df.subset <- df.source[as.Date(df.source$Date, "%d/%m/%Y") %in% dates, ]

# Create new columns.
df.subset$DateTime = strptime(paste(df.subset$Date, df.subset$Time),
                              "%d/%m/%Y %H:%M:%S")

################################################################################
# 3. Create plot.
################################################################################

print("Begin STEP 3.")

# Identify variables to plot.
x <- df.subset$DateTime
y1 <- df.subset$Global_active_power
y2 <- df.subset$Voltage
y3a <- df.subset$Sub_metering_1
y3b <- df.subset$Sub_metering_2
y3c <- df.subset$Sub_metering_3
y4 <- df.subset$Global_reactive_power

# Specify plot colors.
plot.colors = c("black", "red", "blue")

# Start device.
png(file.path("eda", file.plot),
    width=plot.width, height=plot.height, bg="transparent")
par(mfrow=c(2,2))

# Plot variables (top-left).
print("Begin Plot 1 (top-left).")
plot(x, y1, type="l", col=plot.colors[1],
     xlab="",
     ylab="Global Active Power")

# Plot variables (top-right).
print("Begin Plot 2 (top-right).")
plot(x, y2, type="l", col=plot.colors[1],
     xlab="datetime",
     ylab="Voltage")

# Plot variables (bottom-left).
print("Begin Plot 3 (bottom-left).")
plot(x, y3a, type="l", col=plot.colors[1],
     xlab="",
     ylab="Energy sub metering")
lines(x, y3b, col=plot.colors[2])
lines(x, y3c, col=plot.colors[3])

# Create legend (bottom-left).
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=plot.colors, lty=1, box.lwd=0)

# Plot variables (bottom-right).
print("Begin Plot 4 (bottom-right).")
plot(x, y4, type="l", col=plot.colors[1],
     xlab="datetime",
     ylab="Global_reactive_power")

# Stop device.
dev.off()
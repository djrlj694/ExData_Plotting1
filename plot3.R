################################################################################
# FILE:   plot3.R
# AUTHOR: Robert L. Jones (RLJ)
#
# ABSTRACT:
# The overall goal here is simply to examine how household energy usage varies
# over a 2-day period in February, 2007. This particular task is to reconstruct
# Plot 3 ("plot3.png") using the base plotting system -- i.e., a 480x480 pixel
# line graph of energy substation metering as a set of time series between
# 01FEB2007 and 02FEB2007 for each substation, all plotted on the same graph.
#
# ARG(S): N/A
#
# RETURNS: plot3.png (output file)
#
# INSPIRATION(S): N/A
#
# NOTE:
# To load this file, run the following:
# > setwd(<PROJECTROOT>)
# > source(file.path(<CODEDIR>, "plot3.R"))
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
file.plot <- "plot3.png"

# Plot specifications
plot.width <- 480
plot.height <- 480

# Other specifications
colClasses <- c("character", "character", rep("NULL", 4), rep("numeric", 3))
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
y1 <- df.subset$Sub_metering_1
y2 <- df.subset$Sub_metering_2
y3 <- df.subset$Sub_metering_3

# Specify plot colors.
plot.colors = c("black", "red", "blue")

# Start device.
png(file.path("eda", file.plot),
    width=plot.width, height=plot.height, bg="transparent")

# Plot variables.
plot(x, y1, type="l", col=plot.colors[1],
     xlab="",
     ylab="Energy sub metering")
lines(x, y2, col=plot.colors[2])
lines(x, y3, col=plot.colors[3])

# Create legend.
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=plot.colors, lty=1)

# Stop device.
dev.off()
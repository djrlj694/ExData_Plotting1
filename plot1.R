################################################################################
# FILE:   plot1.R
# AUTHOR: Robert L. Jones (RLJ)
#
# ABSTRACT:
# The overall goal here is simply to examine how household energy usage varies
# over a 2-day period in February, 2007. This particular task is to reconstruct
# Plot 1 ("plot1.png") using the base plotting system -- i.e., a 480x480 pixel
# histogram of global active power between 01FEB2007 and 02FEB2007.
#
# ARG(S): N/A
#
# RETURNS: plot1.png (output file)
#
# INSPIRATION(S): N/A
#
# NOTE:
# To load this file, run the following:
# > setwd(<PROJECTROOT>)
# > source(file.path(<CODEDIR>, "plot1.R"))
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
file.plot <- "plot1.png"

# Plot specifications
plot.width <- 480
plot.height <- 480

# Other specifications
colClasses <- c("character", "NULL", "numeric", rep("NULL", 6))
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

################################################################################
# 3. Create plot.
################################################################################

print("Begin STEP 3.")

# Identify variables to plot.
y <- df.subset$Global_active_power

# Specify plot colors.
plot.colors = c("red")

# Start device.
png(file.path("eda", file.plot),
    width=plot.width, height=plot.height, bg="transparent")

# Plot variables.
hist(y, col=plot.colors[1],
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)")

# Stop device.
dev.off()

# Tailor to download a subset of the data for the lab

library(data.table)

# 1. Download the data
stations <- fread(
  "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/isd-history.csv",
  check.names = TRUE
  )

# continental US only, remove AK, HI, territories and weather stations with missing WBAN numbers
st_us <- stations[
  CTRY=="US" &
    !(STATE %in% c("AK", "HI", "", "PR", "VI")) & 
    WBAN < 99999 &
    USAF < 999999 # This comparison may be wrong b/c USAF is str.
  ] 
  
#check which states are included
table(st_us$STATE)

# Remove Islands, platforms, and buoys
st_us <- st_us[!grep("BUOY|ISLAND|PLATFORM", STATION.NAME)]

# Extract year from station start and end date
st_us[, BEGIN_YR := floor(BEGIN/1e4)]
st_us[, END_YR   := floor(END/1e4)]

# If you check the main dataset, you will see that some USAF codes are not
# integers stations[which(stations[,grepl("[^0-9]", USAF)])] which is why
# data.table read it as a string.
st_us[, USAF     := as.integer(USAF)]

# Only take stations that have current data (>=2019)
st_us <- st_us[END_YR >= 2019]

# Extract data from downloaded files
# Need to define column widths, see ftp://ftp.ncdc.noaa.gov/pub/data/noaa/ish-format-document.pdf
column_widths <- c(4, 6, 5, 4, 2, 2, 2, 2, 1, 6, 7, 5, 5, 5, 4, 3, 1, 1, 4, 1, 5, 1, 1, 1, 6, 1, 1, 1, 5, 1, 5, 1, 5, 1)

column_names <- c(
  "ID","USAFID", "WBAN", "year", "month","day", "hour", "min","srcflag", "lat",
  "lon", "typecode","elev","callid","qcname","wind.dir", "wind.dir.qc", 
  "wind.type.code","wind.sp","wind.sp.qc", "ceiling.ht","ceiling.ht.qc",
  "ceiling.ht.method","sky.cond","vis.dist","vis.dist.qc","vis.var","vis.var.qc",
  "temp","temp.qc", "dew.point","dew.point.qc","atm.press","atm.press.qc"
  )

met_all <- NULL

for (y in 2019){
  
  y_list <- st_us[BEGIN_YR <= y & END_YR>=y]
  
  # Ways to download/read fixed-width-files is a common task. Other solutions
  # for R can be found here:
  # https://stackoverflow.com/a/34190156/2097171
  
  for (s in 317:nrow(y_list)) {
    # Building the URL
    uri <- sprintf(
      "ftp://ftp.ncdc.noaa.gov/pub/data/noaa/%i/%s-%05d-%1$i.gz",
      y, y_list$USAF[s], y_list$WBAN[s]
      )
    
    # Downloading the file
    tmpf <- tempfile(fileext = ".gz")
    download_try <- tryCatch(
      download.file(uri, destfile = tmpf, quiet = TRUE),
      error = function(e) e
    )
    
    if (inherits(download_try, "error")) {
      warning(
        sprintf(
          "The file:\n  %s\nWas not able to be downloaded (record: %i).",
          uri, s),
        immediate. = TRUE
        )
      
      # Skipping to the next
      next
    }
    
    
    # Reading the file
    message("Reading the data for recor ", s, " in year ", y, "... ", appendLF = FALSE)
    tmpdat <- suppressMessages(readr::read_fwf(
      file = tmpf,
      col_positions = readr::fwf_widths(
        widths    = column_widths,
        col_names = column_names
        ),
      progress = FALSE #,
      # col_types = "cciiiciicicciccicicccicccicicic"
      ))
    tmpdat <- data.table(tmpdat)
    
    # Right types
    tmpdat[,year      := as.integer(year)]
    tmpdat[,month     := as.integer(month)]
    tmpdat[,day       := as.integer(day)]
    tmpdat[,hour      := as.integer(hour)]
    tmpdat[,lat       := as.integer(lat)]
    tmpdat[,lon       := as.integer(lon)]
    tmpdat[,elev      := as.integer(elev)]
    tmpdat[,wind.sp   := as.integer(wind.sp)]
    tmpdat[,atm.press := as.integer(atm.press)]
    
    # change 9999, 99999, 999999 to NA
    tmpdat[,wind.dir   := ifelse(as.integer(wind.dir) == 999, NA, wind.dir)]
    tmpdat[,wind.sp    := ifelse(as.integer(wind.sp) == 9999, NA, wind.sp)]
    tmpdat[,ceiling.ht := ifelse(as.integer(ceiling.ht) == 99999, NA, ceiling.ht)]
    tmpdat[,vis.dist   := ifelse(as.integer(vis.dist) == 999999, NA, vis.dist)]
    tmpdat[,temp       := ifelse(as.integer(temp) == 9999, NA, temp)]
    tmpdat[,dew.point  := ifelse(as.integer(dew.point) == 9999, NA, dew.point)]
    tmpdat[,atm.press  := ifelse(as.integer(atm.press) == 99999, NA, atm.press)]
    
    # conversions and scaling factors
    tmpdat[,lat       := lat/1000]
    tmpdat[,lon       := lon/1000]
    tmpdat[,wind.sp   := wind.sp/10]
    tmpdat[,temp      := temp/10]
    tmpdat[,dew.point := dew.point/10]
    tmpdat[,atm.press := atm.press/10]
    tmpdat[,rh        := 100*((112-0.1*temp + dew.point)/(112+0.9 * temp))^8]
    
    #drop some variables
    tmpdat[,c("ID", "srcflag", "typecode", "callid", "qcname") := NULL]
    
    # keep august only for class example
    met_all <- rbind(met_all, tmpdat[month == 8])
    message("Record ", s,  "/", nrow(y_list)," for year ", y, " done.")
  }
  
}

fwrite(met_all, file = "met_all_dt.gz", compress = "gzip")

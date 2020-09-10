library(data.table)

dat <- fread("static/slides/05-data-wrangling/met_all.gz")

# We will work with a sample of 200 stations, there are about 1,600
stations <- dat[, list(count = .N), by = "USAFID"]$USAFID
set.seed(114)
selected_stations <- sample(stations, 200)

dat <- dat[USAFID %in% selected_stations]

# Writing the data in compressed format
fwrite(
  dat, file = "static/slides/05-data-wrangling/met_200.gz",
  compress = "gzip"
  )

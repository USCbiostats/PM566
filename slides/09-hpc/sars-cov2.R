# Some constants
codes      <- c(susceptible = 1, infected = 2, recovered = 3, deceased = 4)
probs_sick <- c(deceased = .1, infected=.4, recovered=.5)

# Rows is the current individual, cols is its neighbor.
probs_susc <- matrix(
  0, ncol=2, nrow = 2, 
  dimnames = list(c("i doesn't wear", "i wears"), c("j doesn't wear", "j wears"))
  )

probs_susc[1, 1] <- .9
probs_susc[2, 2] <- .05
probs_susc[1, 2] <- .2
probs_susc[2, 1] <- .5

# Initializes the simulation
init <- function(nsick, nwear, pop_size, nsteps, store = FALSE) {
  
  # Parameters
  nc <- sqrt(pop_size)
  nr <- nc
  
  status      <- matrix(1, nrow = nr, ncol = nc)
  status_prev <- status
  wears       <- matrix(FALSE, nrow = nr, ncol = nc)
  
  # Sampling infected and which wears/doesn't wear a mask
  status_prev[sample.int(n = pop_size, size = nsick, replace = FALSE)] <- codes["infected"]
  if (length(nwear) == 1)
    wears[sample.int(n = pop_size, size = nwear, replace = FALSE)]  <- TRUE
  else
    wears[nwear] <- TRUE
  
  # Statistics
  statistics <- matrix(
    NA_integer_, nrow = nsteps + 1L, ncol = length(codes),
    dimnames = list(0:nsteps, names(codes))
  )
  
  # Checking if we need to make space for stored
  if (store) {
    temporal <- array(NA, dim = c(nr, nc, nsteps + 1L))
    temporal[,,1L] <- status_prev
  }
  
  # This will return all the data created
  current_step <- 1L
  return(environment())
}

# Function to figure out the 8 neighbors of any given coordinate
get_neighbors <- function(i, j, data.) {
  
  left <- cbind(
    if (i == 1) c(data.$nr, 1, 2)
    else if (i == data.$nr) c(data.$nr - 1, data.$nr, 1)
    else (i - 1 + 0:2),
    if (j == 1) rep(data.$nc, 3)
    else rep(j - 1, 3)
  )
  
  middle <- cbind(
    if (i == 1) c(data.$nr, 2)
    else if (i == data.$nr) c(i - 1, 1)
    else c(i - 1, i + 1),
    rep(j, 2)
  )
  
  right <- cbind(
    if (i == 1) c(data.$nr, 1, 2)
    else if (i == data.$nr) c(data.$nr - 1, data.$nr, 1)
    else (i - 1 + 0:2),
    if (j == data.$nc) rep(1, 3)
    else rep(j + 1, 3)
  )
  
  rbind(left, middle, right)
}

# Test
dat <- init(10, 100, 100, 100)
get_neighbors(1,1,dat)
get_neighbors(4,4,dat)
get_neighbors(2,2,dat)

# # We can save time by pre-computing neighbors
# neighbors <- vector("list", n)
# counter <- 1L
# for (i in 1:nr)
#   for (j in 1:nc) {
#     neighbors[[counter]] <- get_neighbors(i, j)
#     counter <- counter + 1L
#   }

update_status <- function(i, j, data.) {
  
  # Diseased and recovered have no effect on the model
  if (data.$status_prev[i, j] %in% codes[c("deceased", "recovered")])
    return()
  
  # Is it getting better?
  if (data.$status_prev[i, j] == codes["infected"]) {
    
    data.$status[i,j] <- sample(
      codes[names(probs_sick)], 1,
      prob = probs_sick
      )
    
  } else {
    
    # Getting the neighbors
    local <- get_neighbors(i,j,data.)
    
    # Each infected neighbor is an independent chance of getting infected
    local <- local[which(data.$status_prev[local] == codes["infected"]), drop=FALSE]
    
    # No neighbor infected, nothing happens
    if (length(local) == 0L)
      return()
    
    # Otherwise, depending on whether they wear or not, there will be different
    # probabilities of getting the disease.
    p <- probs_susc[cbind(data.$wears[i,j], data.$wears[local]) + 1L]
    if (any(runif(length(p)) < p))
      data.$status[i,j] <- codes["infected"]
    
  }
  
  return()
  
}

# Computing states
calc_stats <- function(data.) {
  res <- structure(table(data.$status_prev)[as.character(codes)], names = names(codes))
  res[is.na(res)] <- 0
  data.$statistics[data.$current_step, ] <- res
  return()
}

# Update the entire system's status
update_status_all <- function(data.) {
  
  data.$current_step <- data.$current_step + 1L
  
  for (i in 1L:data.$nr)
    for (j in 1L:data.$nc)
      update_status(i, j, data.)

  # Recording the state
  if (data.$store)
    data.$temporal[,,data.$current_step] <- data.$status
    
  # Updating the statistics
  data.$status_prev <- data.$status
  calc_stats(data.)
  
  return()
}

simulate_covid <- function(pop_size, nsick, nwears_mask, nsteps, store = FALSE) {
  
  # Initializing
  dat <- init(
    nsick = nsick, nwear = nwears_mask, pop_size = pop_size,
    nsteps = nsteps, store = store
    )
  
  # Initial calculation
  calc_stats(dat)
  
  # Recording the state
  if (dat$store)
    dat$temporal[,,dat$current_step] <- dat$status_prev
  
  # Iterating
  for (t. in 1L:nsteps)
    update_status_all(dat)
  
  return(dat)
  
}

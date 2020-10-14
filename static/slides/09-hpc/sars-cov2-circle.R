# Some constants
codes      <- c(deceased = -1, susceptible = 0, infected = 1, recovered = 2)
probs_sick <- c(dies = .1, nochange=.4, recovers=.5)

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
init <- function(nsick, nwear, pop_size, nsteps) {
  
  status      <- integer(pop_size)
  status_prev <- status
  wears       <- logical(pop_size)
  wears[]     <- FALSE
  
  # Sampling infected and which wears/doesn't wear a mask
  status_prev[sample.int(n = pop_size, size = nsick, replace = FALSE)] <- codes["infected"]
  wears[sample.int(n = pop_size, size = nwear, replace = FALSE)]  <- TRUE
  
  # Statistics
  statistics <- matrix(
    NA_integer_, nrow = nsteps, ncol = length(codes),
    dimnames = list(1:nsteps, names(codes))
  )
  
  # This will return all the data created
  current_step <- 0L
  return(environment())
}

# Function to figure out the 8 neighbors of any given coordinate
get_neighbors <- function(i, data.) {
  
  left <- if (i == 1) data.$pop_size
    else {i - 1}
  
  right <- if (i == data.$pop_size) 1L
    else {i + 1}
  
  c(left, right)
}

# Test
dat <- init(10, 100, 100, 100)
get_neighbors(1,dat)
get_neighbors(100,dat)
get_neighbors(4,dat)
get_neighbors(2,dat)

update_status <- function(i, data.) {
  
  # Diseased and recovered have no effect on the model
  if (data.$status_prev[i] %in% codes[c("deceased", "recovered")])
    return()
  
  # Is it getting better?
  if (data.$status_prev[i] == codes["infected"]) {
    
    data.$status[i] <- sample(codes[-2], 1, prob = probs_sick)
    
  } else {
    
    # Getting the neighbors
    local <- get_neighbors(i, data.)
    
    # Each infected neighbor is an independent chance of getting infected
    local <- local[which(data.$status_prev[local] == codes["infected"])]
    
    # No neighbor infected, nothing happens
    if (length(local) == 0L)
      return()
    
    # Otherwise, depending on whether they wear or not, there will be different
    # probabilities of getting the disease.
    p <- probs_susc[cbind(data.$wears[i], data.$wears[local]) + 1L]
    data.$status[i] <- any(runif(length(p)) < p)
    
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
  
  for (i in 1L:data.$pop_size)
      update_status(i, data.)
  
  # Recording the new state, and updating the statistics
  data.$status_prev <- data.$status
  calc_stats(data.)
  
  return()
}

simulate_covid <- function(pop_size, nsick, nwears_mask, nsteps) {
  
  # Initializing
  dat <- init(nsick = nsick, nwear = nwears_mask, pop_size = pop_size, nsteps = nsteps)
  
  # Iterating
  for (t. in 1L:nsteps)
    update_status_all(dat)
  
  return(dat)
  
}

# ans <- replicate(
#   1000, {
#     simulate_covid(100, nsick = 10, nwears_mask = 0, 20)$statistics
#   })
# 

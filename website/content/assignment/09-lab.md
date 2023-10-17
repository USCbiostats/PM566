---
title: "Lab 9 - HPC"
output: tufte::tufte_html
link-citations: yes
---

# Learning goals

In this lab, you are expected to learn/put in practice the following skills:

- Evaluate whether a problem can be parallelized or not.
- Practice with the parallel package.


## Problem 1: Vectorization

The following functions can be written to be more efficient without using parallel. Write a faster version of each function and show that (1) the outputs are the same as the slow version, and (2) your version is faster.

1. This function generates an `n x k` dataset with all its entries drawn from a Poission distribution with mean `lambda`.


```r
fun1 <- function(n = 100, k = 4, lambda = 4) {
  x <- NULL
  
  for (i in 1:n){
    x <- rbind(x, rpois(k, lambda))    
  }
  
  return(x)
}

fun1alt <- function(n = 100, k = 4, lambda = 4) {
  # YOUR CODE HERE
}
```

Show that `fun2` generates a matrix with the same dimensions as `fun1` and that the values inside the two matrices follow similar distributions. Then check the speed of the two functions with the following code:


```r
# Benchmarking
microbenchmark::microbenchmark(
  fun1(),
  fun1alt()
)
```

2.  This function finds the maximum value of each column of a matrix (hint: check out the `max.col()` function).


```r
# Data Generating Process (10 x 10,000 matrix)
set.seed(1234)
x <- matrix(rnorm(1e4), nrow=10)

# Find each column's max value
fun2 <- function(x) {
  apply(x, 2, max)
}

fun2alt <- function(x) {
  # YOUR CODE HERE
}
```

Show that both functions return the same output for a given input matrix, `x`. Then check the speed of the two functions.


## Problem 3: Parallelization

We will now turn our attention to the statistical concept of
[bootstrapping](https://en.wikipedia.org/wiki/Bootstrapping_(statistics)). Among its many uses, non-parametric bootstrapping allows us to obtain confidence intervals for parameter estimates without relying on parametric assumptions. Don't worry if these concepts are unfamiliar, we only care about the computation methods in this lab, not the statistics.

The main assumption is that we can approximate the results of many repeated experiments by resampling observations from our original dataset, which reflects the population. 

1. This function implements a serial version of the bootstrap. Edit this function to parallelize the `lapply` loop, using whichever method you prefer. Rather than specifying the number of cores to use, use the number given by the `ncpus` argument, so that we can test it with different numbers of cores later.


```r
my_boot <- function(dat, stat, R, ncpus = 1L) {
  
  # Getting the random indices
  n <- nrow(dat)
  idx <- matrix(sample.int(n, n*R, TRUE), nrow=n, ncol=R)
  
  # THIS FUNCTION NEEDS TO BE PARALELLIZED
  # EDIT THIS CODE:
  ans <- lapply(seq_len(R), function(i) {
    stat(dat[idx[,i], , drop=FALSE])
  })
  
  # Converting the list into a matrix
  ans <- do.call(rbind, ans)

  return(ans)
}
```


2. Once you have a version of the `my_boot()` function that runs on multiple cores, check that it provides accurate results by comparing it to a parametric model:


```r
# Bootstrap of an OLS
my_stat <- function(d) coef(lm(y ~ x, data=d))

# DATA SIM
set.seed(1)
n <- 500; R <- 1e4

x <- cbind(rnorm(n)); y <- x*5 + rnorm(n)

# Checking if we get something similar as lm
ans0 <- confint(lm(y~x))
ans1 <- my_boot(dat = data.frame(x, y), my_stat, R = R, ncpus = 2L)

# You should get something like this
t(apply(ans1, 2, quantile, c(.025,.975)))
##                   2.5%      97.5%
## (Intercept) -0.1372435 0.05074397
## x            4.8680977 5.04539763
ans0
##                  2.5 %     97.5 %
## (Intercept) -0.1379033 0.04797344
## x            4.8650100 5.04883353
```

3. Check whether your version actually goes faster when it's run on multiple cores (since this might take a little while to run, we'll use `system.time` and just run each version once, rather than `microbenchmark`, which would run each version 100 times, by default):


```r
system.time(my_boot(dat = data.frame(x, y), my_stat, R = 4000, ncpus = 1L))
system.time(my_boot(dat = data.frame(x, y), my_stat, R = 4000, ncpus = 2L))
```


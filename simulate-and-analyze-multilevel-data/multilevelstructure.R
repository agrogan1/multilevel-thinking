# Simulate Data with a Multilevel Structure

library(haven) # write to Stata

set.seed(3846) # random seed

e <- rnorm(10, 0, 1) # error

# group 1

country1 <- rep(1, 10)

x1 <- seq(1,10)

y1 <- 50 + 1 * x1 + e

# group 2

country2 <- rep(2, 10)

x2 <- seq(11, 20)

y2 <- 30 + 1 * x2 + e

# group 3

country3 <- rep(3, 10)

x3 <- seq(21, 30)

y3 <- 10 + 1 * x3 + e

# combine into a dataframe

x <- c(x1, x2, x3)

y <- c(y1, y2, y3)

country <- factor(c(country1, country2, country3))

multilevelstructure <- data.frame(x, y, country) 

write_dta(multilevelstructure,
          "./simulate-and-analyze-multilevel-data/multilevelstructure.dta")

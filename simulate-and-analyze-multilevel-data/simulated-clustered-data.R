# create simulated clustered data

library(haven) # read and write Stata

set.seed(3846) # random seed

g <- seq(1, 5) # number of groups

xA <- rnorm(5, 100, 10) # group x

yA <- rnorm(5, 100, 10) # group y

# 5 obs / group

idA <- seq(1, 25) 

group_numA <- rep(g, 1, each=5)

x_groupA <- rep(xA, each = 5) # x for the group

y_groupA <- rep(yA, each = 5) # y for the group

x_noiseA <- rnorm(25, 0, 1) # random noise

y_noiseA <- rnorm(25, 0, 1) # random noise

x_individualA <- x_groupA + x_noiseA # individual = group + noise

y_individualA <- y_groupA + y_noiseA # individual = group + noise

simulated_clustered_data <- data.frame(idA, 
                                       group_numA,
                                       x_groupA, 
                                       y_groupA, 
                                       x_individualA, 
                                       y_individualA)

write_dta(simulated_clustered_data,
          "./simulate-and-analyze-multilevel-data/simulated_clustered_data.dta")

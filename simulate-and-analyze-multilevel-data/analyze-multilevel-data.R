# analyze multilevel data for *Multilevel Thinking* using R

library(haven) # import Stata

library(lme4) # MLM

library(sjPlot) # nice tables

simulated_multilevel_data <- read_dta("./simulate-and-analyze-multilevel-data/simulated_multilevel_data.dta")

simulated_multilevel_data$group <- 
  factor(simulated_multilevel_data$group)

cross_sectional <- lmer(outcome ~ warmth + physical_punishment + 
               group + HDI +
               (1 + warmth || country),
             data = simulated_multilevel_data)

tab_model(cross_sectional, digits = 3)

cross_sectional2 <- lmer(outcome ~ warmth + physical_punishment + 
                          group + HDI +
                          (1 + warmth | country),
                        data = simulated_multilevel_data)

tab_model(cross_sectional2, digits = 3)










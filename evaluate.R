library(survival)
args <- commandArgs(TRUE)
y <- read.csv(args[1])
s <- survConcordance(formula = Surv(time, status) ~ x, data = y)
s$concordance

sdf <- survdiff(Surv(time, status) ~ x, y)
1 - pchisq(sdf$chisq, length(sdf$n) - 1)

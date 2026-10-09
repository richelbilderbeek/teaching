
# Imagine a dice
expected_probabilities <- rep(1 / 6, 6)
found_probabilities <- seq(1, 6) / sum(seq(1, 6))

variance <- sum((expected_probabilities - found_probabilities) ^ 2) / length(expected_probabilities)
# 0.006613757

# var(expected_probabilities, found_probabilities)

"Nheads <- replicate(10000, {
  coins <- sample(c("H", "T"), size=20, replace=TRUE)
  sum(coins == "H")
})
sum(Nheads >= 15)
"?dbinom
dbinom(x = 15, size =20 , prob = 0.5)

#
p_1 <- dbinom(x = 1, size = 20 , prob = 0.5) +
dbinom(x = 2, size = 20 , prob = 0.5) +
dbinom(x = 3, size = 20 , prob = 0.5) +
dbinom(x = 4, size = 20 , prob = 0.5) +
dbinom(x = 5, size = 20 , prob = 0.5) +
dbinom(x = 6, size = 20 , prob = 0.5) # 0.0576582


p_2 <- pbinom(q = 6, size = 20, prob = 0.5) # 0.05765915


pbinom(q = 5, size = 20, prob = 0.5)

## Exercise 5

if (1 == 2) {
  # Off by one error
  set.seed(42)
  n_trials <- 10000000
  n_people_per_trial <- 20
  tally_n_controls_in_trial <- rep(0, n_people_per_trial)
  for (i in seq_len(n_trials))
  {
    people <- sample(x = c("C", "T"), size = 20, replace = TRUE)
    n_controls <- sum(people == "C")
    tally_n_controls_in_trial[n_controls] <- tally_n_controls_in_trial[n_controls] + 1
  }

  p_n_control_per_trail <- tally_n_controls_in_trial /
    tally_n_controls_in_trial

}

set.seed(42)
n_trials <- 100000
n_controls <- replicate(n = n_trials,
  sum(sample(x = c("C", "T"), size = 20, replace = TRUE) == "C")
)
sum(n_controls == 15) / n_trials # 0.015

sum(n_controls < 7) / n_trials # 0.05698


n_controls_freq <- tibble::as_tibble(n_controls) |> dplyr::count(value)
most_often_n_controls <- n_controls_freq[n_controls_freq$n == max(n_controls_freq$n), ]$value # 10


# From answers
hist(n_controls, breaks = seq(0.5, 19.5, by = 1.0))
# From answers
table(n_controls)


sum(n_controls >= 15) / n_trials # 0.02013

sum(n_controls >= 19) / n_trials # 1e-05

## Exercise 6

# In a bacterial sample, 1/6 are antibiotic resistant.
# From bacterial colonies on an agar plate,
# you randomly pick 10 colonies and investigate
# how many that are antibiotic resistant.

# Define the random variable of interest
p_resistant <- 1.0 / 6.0
n_colonies_sampled <- 10

# What are the possible outcomes?
set.seed(42)
n_trials <- 100000
n_resistant <- replicate(
  n = n_trials,
  sum(
    sample(
      x = c("R", "W"),
      size = n_colonies_sampled,
      replace = TRUE,
      prob = c(p_resistant, 1.0 - p_resistant)
    ) == "R"
  )
)

# Using simulation, estimate the probability mass function
p_to_find_n_resistant <- table(n_resistant) / n_trials
testthat::expect_equal(1.0, sum(p_to_find_n_resistant))

# what is the probability to get at least 5 antibiotic resistant colonies?
use_col <- as.numeric(names(p_to_find_n_resistant)) >= 5
testthat::expect_equal(0.01503, sum(p_to_find_n_resistant[use_col]))

# Which is the most likely number of antibiotic resistant colonies?
plot(p_to_find_n_resistant) # 1
testthat::expect_equal("1", names(p_to_find_n_resistant[p_to_find_n_resistant == max(p_to_find_n_resistant)]))


# What is the probability to get exactly 2 antibiotic resistant colonies?
use_col <- as.numeric(names(p_to_find_n_resistant)) == 2
testthat::expect_equal(0.28914, sum(p_to_find_n_resistant[use_col]))

# On average how many antibiotic resistant colonies would you
# get if the experiment is repeated many times?
testthat::expect_equal(1.66124, mean(n_resistant))

## Question 7

# 30% of a large population is allergic to pollen. If you randomly select 3 people to participate in your study, what is the probability that none of them will be allergic to pollen?

p_allergic <- 0.3
p_non_allergic <- 1.0 - p_allergic

p_3_non_allergic <- p_non_allergic ^ 3
testthat::expect_equal(p_3_non_allergic, 0.343)

# Ah, it needs to be a simulation again
set.seed(42)
n_trials <- 100000
n_non_allergic <- replicate(
  n = n_trials,
  sum(
    sample(
      x = c(rep("N", 7), rep("A", 3)),
      size = 3,
      replace = TRUE
    ) == "N"
  )
)
testthat::expect_equal(0.34336, sum(n_non_allergic == 3) / n_trials)

## 7b. In a class of 20 students, 6 are allergic to pollen.
# If you randomly select 3 of the students to participate
# in your study, what is the probability that none of them
# will be allergic to pollen?

set.seed(42)
n_replicates <- 100000
n_students <- 20
n_students_picked <- 3
n_non_allergic <- replicate(
  n = n_replicates,
  sum(
    sample(
      x = c(rep("N", 14), rep("A", 6)),
      size = n_students_picked,
      replace = FALSE
    ) == "N"
  )
)
testthat::expect_equal(0.31914, sum(n_non_allergic == 3) / n_replicates)

## 7c. Of the 200 persons working at a company,
# 60 are allergic to pollen.
# If you randomly select 3 people to participate in your study,
# what is the probability that none of them are allergic to pollen?

set.seed(42)
n_replicates <- 100000
n_students <- 20
n_people_picked <- 3
n_non_allergic <- replicate(
  n = n_replicates,
  sum(
    sample(
      x = c(rep("N", 140), rep("A", 60)),
      size = n_people_picked,
      replace = FALSE
    ) == "N"
  )
)
testthat::expect_equal(0.34495, sum(n_non_allergic == 3) / n_replicates)

# 7d. Compare your results in a, b and c. Did you get the same results? Why/why not?

# a is and c are most similar, as a assumes an infinite
# population, where c is reasonably big.

# ===========================================================================
# Exercise 8 (Pollen). Do Exercise 7 again,
# but using parametric distributions. Compare your results.
# ==========================================================================
# 8.a.
p_allergic <- 0.3
p_non_allergic <- 1.0 - p_allergic

p_3_non_allergic <- p_non_allergic ^ 3
testthat::expect_equal(p_3_non_allergic, 0.343)


testthat::expect_equal(dbinom(x = 3, size = 3 , prob = 0.7), 0.343)

# ------------------------------------------------------------
## 8b. In a class of 20 students, 6 are allergic to pollen.
# If you randomly select 3 of the students to participate
# in your study, what is the probability that none of them
# will be allergic to pollen?
# Exercise 8 (Pollen). Do Exercise 7 again,
# but using parametric distributions. Compare your results.
# ------------------------------------------------------------

# 'dhyper' gives the density
# dhyper(x, m, n, k, log = FALSE)
# x: vector of quantiles representing the number of white balls drawn without replacement from an urn which contains both black and white balls.
# m: the number of white balls in the urn.
# n: the number of black balls in the urn.
# k: the number of balls drawn from the urn, hence must be in
#   0,1,...,m+n

n_people_picked <- 3
n_non_allergic <- 14
n_allergic <- 6
n_people <- n_non_allergic + n_allergic
none <- 0

# Estimate
my_estimate <- (14/20)^3

p_none_allergic <- dhyper(
  x = none,
  m = n_allergic,
  n = n_non_allergic,
  k = n_people_picked
)
testthat::expect_equal(p_none_allergic, 0.3192982, tolerance = 0.00001)
testthat::expect_equal(p_none_allergic, my_estimate, tolerance = 0.03)


# ------------------------------------------------------------
# Exercise 8 (Pollen). Do Exercise 7 again,
# but using parametric distributions. Compare your results.
## 7c. Of the 200 persons working at a company,
# 60 are allergic to pollen.
# If you randomly select 3 people to participate in your study,
# what is the probability that none of them are allergic to pollen?

n_people_picked <- 3
n_people <- 200
n_allergic <- 60
n_non_allergic <- n_people - n_allergic
none <- 0

# Estimate
my_estimate <- (140/200)^3

p_none_allergic <- dhyper(
  x = none,
  m = n_allergic,
  n = n_non_allergic,
  k = n_people_picked
)
testthat::expect_equal(p_none_allergic, 0.3407797, tolerance = 0.00001)
testthat::expect_equal(p_none_allergic, my_estimate, tolerance = 0.003)

# ----------------------------------------------------------------------
# 8d. Compare your results in a, b and c. Did you get the same results? Why/why not?
#
# a is and c are most similar, as a assumes an infinite
# population, where c is reasonably big.


# =====================================================================
# Exercise 9 (Gene set enrichment analysis)
# You have analyzed 20000 genes
n_genes_analyzed <- 20000
# and a bioinformatician you are collaborating with
# has sent you a list of 1000 genes that she says are important.
n_genes_in_importance_list <- 1000
# You are interested in a particular pathway A.
# 200 genes in pathway A are represented among the 20000 genes,
n_genes_analyzed_in_pathway_a <- 200
# 20 of these are in the bioinformaticians important list.
n_genes_analyzed_in_importance_list <- 20

# If the bioinformatician selected the 1000 genes at random,
# what is the probability to see 20 or more genes
# from pathway A in this list?
p_gene_is_in_pathway_a <- n_genes_analyzed_in_pathway_a / n_genes_analyzed
p_gene_is_not_in_pathway_a <- 1.0 - p_gene_is_in_pathway_a
# GIVE UP HERE: twenty of more!
n_to_observer_or_more <- 20

# What is in the pot:
# - total number of ball: 20000
# - total number of balls drawn: 1000
# - white: gene present in pathway a: 200
# - black: gene not present in pathway a: 20000 - 200 = 19800

# OK, this needs a geometric distribution, here is my first estimate:
p_20_or_more_genes_from_pathway_a <- dhyper(
  x = n_to_observer_or_more,
  m = n_genes_analyzed_in_pathway_a,
  n = n_genes_analyzed - n_genes_analyzed_in_pathway_a,
  k = n_genes_in_importance_list
)
# However, it is 20 **or more**, hence, I need to use phyper:
#
p_20_or_more_genes_from_pathway_a <- phyper(
  q = n_to_observer_or_more - 1, # 1 one, a P[X > x]
  m = n_genes_analyzed_in_pathway_a,
  n = n_genes_analyzed - n_genes_analyzed_in_pathway_a,
  k = n_genes_in_importance_list,
  lower.tail = FALSE # X > x
)

testthat::expect_equal(p_20_or_more_genes_from_pathway_a, 0.002530188)

# If this is correct,
# p_10_or_more_genes_from_pathway_a will be bigger:
p_10_or_more_genes_from_pathway_a <- phyper(
  q = n_to_observer_or_more - 10 - 1, # 1 one, a P[X > x]
  m = n_genes_analyzed_in_pathway_a,
  n = n_genes_analyzed - n_genes_analyzed_in_pathway_a,
  k = n_genes_in_importance_list,
  lower.tail = FALSE # X > x
)
testthat::expect_true(p_10_or_more_genes_from_pathway_a > p_20_or_more_genes_from_pathway_a )




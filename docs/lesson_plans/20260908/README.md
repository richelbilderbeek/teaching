# Lesson plan

- 2026-09-07 to and including 2026-09-11
- [Statistical Methods for Life Sciences](https://nbisweden.github.io/ML4Life/)

## 2026-08-31

This is when I teach:
> Would you be able to join as a TA on Monday and Tuesday (Sept 7-8)? We
> mainly need TAs for the morning sessions on probability and
> distributions (Mon) and Linear regression (Tues). I hope you can join
> the course lunch (at Bikupan, BMC) as well!

Hence, that is the course materials

- [Probability Theory](https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-probability/)
  parts 1-4
- [Linear Regression](https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/)
  sections 13-15

Both of these have exercises. I will just go through the exercises
and see what happens :-) . I predict most problems will be because
of R.

## 2026-09-01

At '1.3 Conditional probability' I could use an example for this:

> Given E and F are subsets of S be two events with 
> P(E) > 0, then the conditional probability of F
> given that E occurs is defined as...

I assume I will find it in the exercises.
From [Wikipedia](https://en.wikipedia.org/wiki/Conditional_probability)

> For example, the probability that any given person has a cough
> on any given day may be only 5%.
> But if we know or assume that the person is sick,
> then they are much more likely to be coughing.
> For example, the conditional probability that someone
> sick is coughing might be 75%,
> in which case we would have that P(Cough) = 5%
> and P(Cough|Sick) = 75%.
> Although there is a relationship between A and B in this example,
> such a relationship or dependence between A and B is not necessary,
> nor do they have to occur simultaneously.

- E: coughing
- F: being sick

So:

P(E) = 0.05
P(E | F) = 0.75
P(E | F) = P(E and F) / P(F) = 0.75 = unknown/unknown

Hmmm, maybe the examples have something I can solve :-)

- probability mass function (PMF): the chance something happens,
  e.g. the chance to roll a 3.
- cumulative distribution function (CDF): the chance to find a value
  or less than that value,
  e.g. the chance to roll a 3 or less

```r
# Imagine a dice
expected_probabilities <- rep(1 / 6, 6)
found_probabilities <- seq(1, 6) / sum(seq(1, 6))

variance <- sum((expected_probabilities - found_probabilities) ^ 2) /
  length(expected_probabilities)
# 0.006613757
```

Blimey, this works:

```
Nheads <- replicate(10000, {
  coins <- sample(c("H", "T"), size=20, replace=TRUE)
  sum(coins == "H")
})
sum(Nheads >= 15)
```

`replicate` is a function name to remember :-)

While going through this, I miss a stated goal. Nor section 1, nor 2
starts with telling us which problem we are going to solve.

In the LOs I find:

- understand the concept of random variables
- understand the concept of probability
- understand and learn to use resampling to compute probabilities
- understand the concept probability mass function
- understand the concept probability density function
- understand the concept cumulative distribution functions
- ...

But nowhere I find what problems this solves.

The theory I fail to understand most is at 
[section 2.3.3](https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-probability/prob_02discrv.html#binomial):
I find it hard to even agree with the equations I see.

## [Exercises: Discrete random variables](https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-probability/prob_exr1_discrv_solutions.html)

### Exercise 1 (BRCA) 

> The probability of carrying one or more mutations in the breast cancer gene BRCA1 is 0.01. What is the probability of not carrying any mutations in BRCA1?

Yes and no are mutatually exclusive, hence p_yes + p_no = 1.0.
p_yes = 0.01
hence p_no = 1.0 - p_yes = 0.99

### Exercise 2 (A coin toss) 

> When tossing a fair coin
> what is the probability of heads?
> what is the probability of tails?

0.5 and 0.5
P(H) = 0.5
P(T) = 0.5

### Exercise 3 (Number of children)

In a region in Sweden with many children the number of children per household is between 0 and 6. The probability mass function is as follows;

```text
x	0	1	2	3	4	5	6
p(x)	0.14	0.20	0.27	0.19	0.13	0.05	0.02
```

> In a randomly chosen household
> 
> what is the probability of exactly 3 children?

P(X = 3) = 0.19

> what is the probability of less than 3 children?

P(X < 3) = 0.14 + 0.20 + 0.27 = 0.61

> what is the probability of 3 or less children?

P(X <= 3) = 0.14 + 0.20 + 0.27 + 0.19 = 0.8

> what is the probability of an even number of children?

P(X % 2 == 0) = P(X == 0 || X == 2 || X == 4 || X == 6) =
0.14 + 0.27 + 0.13 + 0.02 = 0.56



### Exercise 4 (Rolling dice) 

When tossing a fair six-sided die

> what is the probability of getting 6?

P(X = 6) = 1/6

> what is the probability of an even number?

P(X is even) = 3/6

> what is the probability of getting 3 or more?

P(X >= 3) = 4/6

> what is the expected value of dots on the dice?

Q: Why P(X) and E[X], i.e. why E[X] has square brackets?
Ah, this is just social. So, why did the teacher pick
E[X] over E(X) ?

E[X] = mu = sum(of each element x in set S)(x * p(x))
where 
- x is the value of x
- p(x) is the probability of finding x

E(X) = (1 * 1/6) * + (2 * 1/6) + (3 * 1/6) + ... / 6 = 21 / 6 = 3.5

### Exercise 5 (Randomization) 

> In a clinical trial, enrolled patients are randomly assigned to treatment or control group with equal probability.
>
> For a single patient, what is the probability of being assigned to
>
> the treatment group?

0.5

> the control group?

0.5

> If 20 patients are enrolled in the study;
> what is the probability of exactly 15 in the treatment group?

Need the probability mass function of the Bernouilli/Binomial distribution.

```
             (n)                    (20)
P(X = 15) =  (k) p^k (1-p)^(n -k) = (15) * 0.5^15 * 0.5^5 = (20! / (5! * 15!)) * 0.5^20 = 0.014785767
```

In R:

```r
dbinom(x = 15, size = 20 , prob = 0.5) # 0.01478577
```

> what is the probability of less than 7 in the treatment group?

```r
# Sum the single probabilities
dbinom(x = 1, size = 20 , prob = 0.5) +
dbinom(x = 2, size = 20 , prob = 0.5) +
dbinom(x = 3, size = 20 , prob = 0.5) +
dbinom(x = 4, size = 20 , prob = 0.5) +
dbinom(x = 5, size = 20 , prob = 0.5) +
dbinom(x = 6, size = 20 , prob = 0.5) # 0.0576582

# Check that pbinom does that same. It does
pbinom(q = 6, size = 20, prob = 0.5) # 0.05765915
```

> What is the most probable number of patients in the treatment group?

No equation for this, but n_trials * p_success = 20 * 0.5 = 10


> what is the probability of 5 or fewer patients in the control group?

```
pbinom(q = 5, size = 20, prob = 0.5) # 0.02069473
```

> what is the probability of 2 or fewer patients in the treatment group?

```
pbinom(q = 2, size = 20, prob = 0.5) # 0.0002012253
```

Checking the answers, I think what is missing in the question:

> Simulate 10000 clinical trials
> and count how many people are in the control group in each trail,
> so that you are able to conclude how often a trail
> will have 1 or 2 or 3 ... people in the control group

my answer:

```
set.seed(42)
n_trials <- 10000000
n_controls <- replicate(n = n_trials,
  sum(sample(x = c("C", "T"), size = 20, replace = TRUE) == "C")
)
```

Let's do the questions again

> If 20 patients are enrolled in the study; what is the probability of exactly 15 in the treatment group?

sum(n_controls == 15) / n_trials # 0.015



> what is the probability of less than 7 in the treatment group?

```r
sum(n_controls < 7) / n_trials # 0.05698
```

> What is the most probable number of patients in the treatment group?

```r
n_controls_freq <- tibble::as_tibble(n_controls) |> dplyr::count(value)
most_often_n_controls <- n_controls_freq[n_controls_freq$n == max(n_controls_freq$n), ]$value # 10
```

Answer: 

> what is the probability of 5 or fewer patients in the control group?

```r
sum(n_controls >= 15) / n_trials # 0.02013
```

what is the probability of 2 or fewer patients in the treatment group?

```r
sum(n_controls >= 19) / n_trials # 1e-05
```

```
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
```

Aha, I simulated using `prob`, in the exercise
they use 6 balls.

I switch to using the R code as a guideline...





## 2026-09-04

I struggle with getting through the course material.
I consider cancelling to help. Here I write down my thoughts,
to get them out of my head:

- The Bloom level of learning outcomes and exercises are disjointed:
  the learning outcomes are phrased in 'understand' terms,
  the exercises are at the 'apply' level
- The course material seems disjointed with the exercises
  too often. When a plot is shown, only sometimes
  can one see the code. Sometimes, this is incomplete
  code. An example is
  https://nbisweden.github.io/workshop-mlbiostatistics/docs/SM4LS-book/SM4LS-lm/lm-intro.html#why-linear-models
  where a plot of 'the diabetes data' is shown,
  but it is never shown how to get that data.
  You need that data later in the exercise.
  The code how to get that data is hidden.

Well, there are so many choices made that I do not understand,
that I avoid reading the course material, but try to
read the code behind the course material. I fail to understand the answers
when it does not provide a reasoning behind it.

OK, back to work...


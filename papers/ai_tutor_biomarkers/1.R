set.seed(42)

n_samples <- 100
n_genes   <- 1000
n_true    <- 10

# Outcome: 0 = healthy, 1 = sick
group <- rep(c(0, 1), each = n_samples / 2)

# Expression matrix: pure noise
X <- matrix(rnorm(n_samples * n_genes), nrow = n_samples)
colnames(X) <- paste0("gene", 1:n_genes)

# Make genes 1-10 higher in sick patients
X[group == 1, 1:n_true] <- X[group == 1, 1:n_true] + 1

dim(X)
table(group)

# Generate a random sample of size 100 from Binomial(25, 0.4) distribution
set.seed(1234) # Set seed for reproducibility
sample_data <- rbinom(100, 25, 0.4)
sample_data
# Define the method of moments estimator of n and p
moment_estimator <- function(data) {
  # Calculate the sample mean and variance
  sample_mean <- mean(data) # Estimate the sample mean
  sample_variance <- var(data) # Estimate the sample variance
  # Solve the equations for n and p using method of moments
  estimated_n <- sample_mean^2 / (sample_mean - sample_variance)
  estimated_p <- sample_mean / estimated_n
  # Return a list of n and p as the estimator result
  list(n = estimated_n, p = estimated_p)
}
moment_estimator
# Apply the estimator to the sample
estimation_result <- moment_estimator(sample_data)
# Check if the estimator is unbiased by comparing the expected value and the true value
expected_n <- mean(replicate(1000, moment_estimator(rbinom(100, 25, 0.4))$n)) # Expected value of n
expected_p <- mean(replicate(1000, moment_estimator(rbinom(100, 25, 0.4))$p)) # Expected value of p
true_n <- 25 # True value of n
true_p <- 0.4 # True value of p
bias_n <- expected_n - true_n # Calculate the bias of n
bias_p <- expected_p - true_p # Calculate the bias of p
# Print the results
# Comment: Display the analysis results
cat("Method of Moments Estimator for n:", estimation_result$n, "\n")
cat("Method of Moments Estimator for p:", estimation_result$p, "\n")
cat("Expected Value of n:", expected_n, "\n")
cat("Expected Value of p:", expected_p, "\n")
cat("Bias of n:", bias_n, "\n")
cat("Bias of p:", bias_p, "\n")
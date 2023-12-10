# Define the maximum likelihood estimator (MLE) function for population mean and
variance of a normal distribution
mle_normal <- function(data) {
  # Calculate the sample mean and standard deviation
  sample_mean <- mean(data)
  sample_std <- sd(data)
  # Return a list of mean and variance estimates
  list(mean_estimate = sample_mean, variance_estimate = sample_std^2)
}
mle_normal
# Generate random samples from N(2, 25) with different sample sizes
set.seed(123) # Set seed for reproducibility
sample_sizes <- c(20, 75, 150, 300, 600) # Different sample sizes
generated_samples <- lapply(sample_sizes, function(size) rnorm(size, 2, 5)) # List of
generated samples
# Apply the MLE estimator to each sample
estimates_list <- lapply(generated_samples, mle_normal) # List of MLE estimates
estimates_list
# Check the consistency of MLE for both parameters by plotting estimates against sample
sizes
par(mfrow = c(1, 2)) # Set the layout for two plots
# Plot MLE of mean
plot(sample_sizes, sapply(estimates_list, "[[", "mean_estimate"), type = "b", xlab = "Sample
size", ylab = "Estimated mean", main = "MLE of mean")
abline(h = 2, col = "green") # Add a horizontal line for the true mean
# Plot MLE of variance
plot(sample_sizes, sapply(estimates_list, "[[", "variance_estimate"), type = "b", xlab =
       "Sample size", ylab = "Estimated variance", main = "MLE of variance")
abline(h = 25, col = "blue") # Add a horizontal line for the true variance
# Plot MLE of mean with Confidence Intervals
plot(sample_sizes, sapply(estimates_list, "[[", "mean_estimate"), type = "b", xlab = "Sample
size", ylab = "Estimated mean", main = "MLE of mean with 95% CI")
abline(h = 2, col = "green") # Add a horizontal line for the true mean
# Calculate 95% confidence intervals for the mean estimates
mean_ci <- t(sapply(estimates_list, function(est) {
  est_mean <- est[["mean_estimate"]]
  est_std <- sqrt(est[["variance_estimate"]])
  margin_error <- qnorm(0.975) * (est_std / sqrt(length(est_mean)))
  c(est_mean - margin_error, est_mean + margin_error)
}))
mean_ci
# Add error bars representing 95% confidence intervals
arrows(sample_sizes, mean_ci[, 1], sample_sizes, mean_ci[, 2], angle = 90, code = 3, length =
         0.1, col = "red")
# Plot MLE of variance with Confidence Intervals
plot(sample_sizes, sapply(estimates_list, "[[", "variance_estimate"), type = "b", xlab =
       "Sample size", ylab = "Estimated variance", main = "MLE of variance with 95% CI")
abline(h = 25, col = "blue") # Add a horizontal line for the true variance
# Calculate 95% confidence intervals for the variance estimates
variance_ci <- t(sapply(estimates_list, function(est) {
  est_variance <- est[["variance_estimate"]]
  chi_square_quantiles <- qchisq(c(0.025, 0.975), df = length(est_variance) - 1)
  margin_error <- sqrt((length(est_variance) - 1) * est_variance / chi_square_quantiles)
  c(est_variance - margin_error[1], est_variance + margin_error[2])
}))
variance_ci
# Add error bars representing 95% confidence intervals
arrows(sample_sizes, variance_ci[, 1], sample_sizes, variance_ci[, 2], angle = 90, code = 3,
       length = 0.1, col = "red")
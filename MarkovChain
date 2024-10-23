library(ggplot2)
library(markovchain)

# Transition matrices 
# Early period transition matrix (8am to 4pm)
early_chain <- new("markovchain", states = c("Light", "Heavy", "Gridlock"),
                  transitionMatrix = matrix(c(0.4, 0.4, 0.2,
                                             0.3, 0.5, 0.2,
                                             0.0, 0.1, 0.9),
                                           nrow = 3, byrow = TRUE))

# Rush hour period transition matrix (4pm to 6pm)
rush_hour_chain <- new("markovchain", states = c("Light", "Heavy", "Gridlock"),
                      transitionMatrix = matrix(c(0.1, 0.5, 0.4,
                                                 0.1, 0.3, 0.6,
                                                 0.0, 0.1, 0.9),
                                               nrow = 3, byrow = TRUE))

# Late period transition matrix (6pm to 8pm)
late_chain <- new("markovchain", states = c("Light", "Heavy", "Gridlock"),
                 transitionMatrix = matrix(c(0.6, 0.3, 0.1,
                                            0.4, 0.4, 0.2,
                                            0.2, 0.4, 0.4),
                                          nrow = 3, byrow = TRUE))

# Define initial state probabilities. Assume starting with light traffic)
# Light = 1, Heavy and Gridlock are 0
initial_state <- c(1, 0, 0)  
names(initial_state) <- c("Light", "Heavy", "Gridlock")

# Set up simulation parameters. 72 steps = 72, 10 min increments from 8am to 8pm
time_steps <- 72  
state_probabilities <- matrix(0, nrow = time_steps, ncol = 3)
state_probabilities[1, ] <- initial_state
colnames(state_probabilities) <- c("Light", "Heavy", "Gridlock")

# Simulate 
for (t in 2:time_steps) {  # Loop through each time step starting from 2
  if (t <= 48) {  # Early period (8am to 4pm)
    state_probabilities[t, ] <- initial_state %*% early_chain@transitionMatrix
  } else if (t <= 60) {  # Rush hour period (4pm to 6pm)
    state_probabilities[t, ] <- initial_state %*% rush_hour_chain@transitionMatrix
  } else {  # Late period (6pm to 8pm)
    state_probabilities[t, ] <- initial_state %*% late_chain@transitionMatrix
  }
  initial_state <- state_probabilities[t, ]  # Update the initial state for the next iteration
}

traffic_df <- data.frame(  # Create a data frame to store the results
  Time = rep(seq(from = 8, to = 20, length.out = time_steps), each = 3),  
  State = factor(rep(c("Light", "Heavy", "Gridlock"), times = time_steps)),
  Probability = as.vector(t(state_probabilities))  
)

# Plot the results
# Time = X-axis, Probability on Y-axis
traffic_plot <- ggplot(traffic_df, aes(x = Time, y = Probability, color = State, linetype = State)) +  
  geom_line(linewidth = 1) +  # Plot lines with specified linewidth
  labs(title = "Traffic State Probabilities from 8 am to 8 pm",  # Set the plot title
       x = "Time (hours)",  
       y = "Probability",  
       color = "Traffic State", 
       linetype = "Traffic State") + 
  theme_minimal() +  # Use a minimal theme for the plot
  theme(legend.position = "top",  # Place the legend at the top of the plot
        plot.title = element_text(hjust = 0.5))  # Center-align the plot title

# Display the plot in Visual Studio Code 
# I am using VSC instead of R studio. Trying to learn how to use, so it's good practice
print(traffic_plot)  
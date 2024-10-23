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

# Calculate steady state probabilities for each period
steady_state_early <- steadyStates(early_chain)
steady_state_rush_hour <- steadyStates(rush_hour_chain)
steady_state_late <- steadyStates(late_chain)

# Print the steady state probabilities for each period
print("Steady State Probabilities for Early Period (8 am to 4 pm):")
print(steady_state_early)

print("Steady State Probabilities for Rush Hour (4 pm to 6 pm):")
print(steady_state_rush_hour)

print("Steady State Probabilities for Late Period (6 pm to 8 pm):")
print(steady_state_late)

# Plot the results
# Time = X-axis, Probability on Y-axis
traffic_plot <- ggplot(traffic_df, aes(x = Time, y = Probability, color = State, linetype = "Simulation")) +  
  geom_line(linewidth = 1.2) +  # Plot lines with specified linewidth for better visibility
  labs(title = "Traffic State Probabilities from 8 am to 8 pm",  # Set the plot title
       x = "Time (hours)",  
       y = "Probability",  
       color = "Traffic State", 
       linetype = "Line Type") + 
  scale_color_manual(values = c("red", "green", "blue")) + # Set custom colors for the states
  theme_minimal() +  # Use a minimal theme for the plot
  theme(legend.position = "top",  # Place the legend at the top of the plot
        plot.title = element_text(hjust = 0.5),
        plot.background = element_rect(fill = "white", color = NA), # Set the plot background to white
        panel.background = element_rect(fill = "white", color = NA)) # Set the panel background to white

# Add steady state lines to the plot using annotate with a distinct line type and thinner line
traffic_plot <- traffic_plot +
  # Early period steady state
  annotate("segment", x = 8, xend = 16, y = steady_state_early[1], yend = steady_state_early[1],
           color = "black", linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 8, xend = 16, y = steady_state_early[2], yend = steady_state_early[2],
           color = "darkgray", linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 8, xend = 16, y = steady_state_early[3], yend = steady_state_early[3],
           color = "gray", linetype = "dashed", linewidth = 0.8) + 
  
  # Rush hour steady state
  annotate("segment", x = 16, xend = 18, y = steady_state_rush_hour[1], yend = steady_state_rush_hour[1],
           color = "purple", linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 16, xend = 18, y = steady_state_rush_hour[2], yend = steady_state_rush_hour[2],
           color = "darkblue", linetype = "dashed", linewidth = 0.8) +
  annotate("segment", x = 16, xend = 18, y = steady_state_rush_hour[3], yend = steady_state_rush_hour[3],
           color = "lightblue", linetype = "dashed", linewidth = 0.8) + 
  
  # Late period steady state
  annotate("segment", x = 18, xend = 20, y = steady_state_late[1], yend = steady_state_late[1],
           color = "brown", linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 18, xend = 20, y = steady_state_late[2], yend = steady_state_late[2],
           color = "orange", linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 18, xend = 20, y = steady_state_late[3], yend = steady_state_late[3],
           color = "yellow", linetype = "dashed", linewidth = 0.8)

# Add annotations for steady state lines to differentiate from simulation
traffic_plot <- traffic_plot +
  annotate("text", x = 12, y = steady_state_early[1] + 0.05, label = "Steady State Early - Light", color = "black", size = 3, angle = 0) +
  annotate("text", x = 12, y = steady_state_early[2] + 0.05, label = "Steady State Early - Heavy", color = "darkgray", size = 3, angle = 0) +
  annotate("text", x = 12, y = steady_state_early[3] - 0.05, label = "Steady State Early - Gridlock", color = "gray", size = 3, angle = 0) +
  
  annotate("text", x = 17, y = steady_state_rush_hour[1] + 0.05, label = "Steady State Rush Hour - Light", color = "purple", size = 3, angle = 0) +
  annotate("text", x = 17, y = steady_state_rush_hour[2] + 0.05, label = "Steady State Rush Hour - Heavy", color = "darkblue", size = 3, angle = 0) +
  annotate("text", x = 17, y = steady_state_rush_hour[3] - 0.05, label = "Steady State Rush Hour - Gridlock", color = "lightblue", size = 3, angle = 0) +
  
  annotate("text", x = 19, y = steady_state_late[1] + 0.05, label = "Steady State Late - Light", color = "brown", size = 3, angle = 0) +
  annotate("text", x = 19, y = steady_state_late[2] + 0.05, label = "Steady State Late - Heavy", color = "orange", size = 3, angle = 0) +
  annotate("text", x = 19, y = steady_state_late[3] - 0.05, label = "Steady State Late - Gridlock", color = "yellow", size = 3, angle = 0)

# Save the improved plot
ggsave("traffic_plot_improved_v4.png", plot = traffic_plot, bg = "white")
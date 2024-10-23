library(ggplot2)
library(markovchain)

# Transition matrices 
early_chain <- new("markovchain", states = c("Light", "Heavy", "Gridlock"),
                   transitionMatrix = matrix(c(0.4, 0.4, 0.2,
                                               0.3, 0.5, 0.2,
                                               0.0, 0.1, 0.9),
                                             nrow = 3, byrow = TRUE))

rush_hour_chain <- new("markovchain", states = c("Light", "Heavy", "Gridlock"),
                       transitionMatrix = matrix(c(0.1, 0.5, 0.4,
                                                   0.1, 0.3, 0.6,
                                                   0.0, 0.1, 0.9),
                                                 nrow = 3, byrow = TRUE))

late_chain <- new("markovchain", states = c("Light", "Heavy", "Gridlock"),
                  transitionMatrix = matrix(c(0.6, 0.3, 0.1,
                                              0.4, 0.4, 0.2,
                                              0.2, 0.4, 0.4),
                                            nrow = 3, byrow = TRUE))

initial_state <- c(1, 0, 0)  
names(initial_state) <- c("Light", "Heavy", "Gridlock")

time_steps <- 72  
state_probabilities <- matrix(0, nrow = time_steps, ncol = 3)
state_probabilities[1, ] <- initial_state
colnames(state_probabilities) <- c("Light", "Heavy", "Gridlock")

for (t in 2:time_steps) {  
  if (t <= 48) {  
    state_probabilities[t, ] <- initial_state %*% early_chain@transitionMatrix
  } else if (t <= 60) {  
    state_probabilities[t, ] <- initial_state %*% rush_hour_chain@transitionMatrix
  } else {  
    state_probabilities[t, ] <- initial_state %*% late_chain@transitionMatrix
  }
  initial_state <- state_probabilities[t, ]  
}

# Create a time sequence from 8 to 20 with 72 steps
Time <- seq(from = 8, to = 20, length.out = time_steps)

# Adjust the data frame creation to use the correct Time values
traffic_df <- data.frame(
  Time = rep(Time, each = 3),  # Corrected Time sequence from 8 to 20 hours
  State = factor(rep(c("Light", "Heavy", "Gridlock"), times = time_steps)),
  Probability = as.vector(t(state_probabilities))  
)


steady_state_early <- steadyStates(early_chain)
steady_state_rush_hour <- steadyStates(rush_hour_chain)
steady_state_late <- steadyStates(late_chain)

# Plot the results
traffic_plot <- ggplot(traffic_df, aes(x = Time, y = Probability, color = State)) +  
  geom_line(linewidth = 1.2) +  
  labs(title = "Traffic State Probabilities from 8 am to 8 pm",  
       x = "Time (hours)",  
       y = "Probability",  
       color = "Traffic State") + 
  scale_color_manual(values = c("red", "green", "blue")) + 
  scale_x_continuous(limits = c(8, 20), breaks = seq(8, 20, by = 1)) +  # Set x-axis limits and breaks
  theme_minimal() +  
  theme(legend.position = "top",  
        plot.title = element_text(hjust = 0.5),
        plot.background = element_rect(fill = "white", color = NA), 
        panel.background = element_rect(fill = "white", color = NA))

# Add steady state lines with consistent color but different line types
steady_colors <- c("black")
traffic_plot <- traffic_plot +
  annotate("segment", x = 8, xend = 16, y = steady_state_early[1], yend = steady_state_early[1],
           color = steady_colors, linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 8, xend = 16, y = steady_state_early[2], yend = steady_state_early[2],
           color = steady_colors, linetype = "dotted", linewidth = 0.8) + 
  annotate("segment", x = 8, xend = 16, y = steady_state_early[3], yend = steady_state_early[3],
           color = steady_colors, linetype = "dotdash", linewidth = 0.8) + 
  
  annotate("segment", x = 16, xend = 18, y = steady_state_rush_hour[1], yend = steady_state_rush_hour[1],
           color = steady_colors, linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 16, xend = 18, y = steady_state_rush_hour[2], yend = steady_state_rush_hour[2],
           color = steady_colors, linetype = "dotted", linewidth = 0.8) +
  annotate("segment", x = 16, xend = 18, y = steady_state_rush_hour[3], yend = steady_state_rush_hour[3],
           color = steady_colors, linetype = "dotdash", linewidth = 0.8) + 
  
  annotate("segment", x = 18, xend = 20, y = steady_state_late[1], yend = steady_state_late[1],
           color = steady_colors, linetype = "dashed", linewidth = 0.8) + 
  annotate("segment", x = 18, xend = 20, y = steady_state_late[2], yend = steady_state_late[2],
           color = steady_colors, linetype = "dotted", linewidth = 0.8) + 
  annotate("segment", x = 18, xend = 20, y = steady_state_late[3], yend = steady_state_late[3],
           color = steady_colors, linetype = "dotdash", linewidth = 0.8)

# Dynamic annotations for better positioning
traffic_plot <- traffic_plot +
  annotate("text", x = 12, y = steady_state_early[1] + 0.05, label = "Steady State Early - Light", color = steady_colors, size = 3) +
  annotate("text", x = 12, y = steady_state_early[2] + 0.05, label = "Steady State Early - Heavy", color = steady_colors, size = 3) +
  annotate("text", x = 12, y = steady_state_early[3] - 0.05, label = "Steady State Early - Gridlock", color = steady_colors, size = 3) +
  
  annotate("text", x = 17, y = steady_state_rush_hour[1] + 0.05, label = "Steady State Rush Hour - Light", color = steady_colors, size = 3) +
  annotate("text", x = 17, y = steady_state_rush_hour[2] + 0.05, label = "Steady State Rush Hour - Heavy", color = steady_colors, size = 3) +
  annotate("text", x = 17, y = steady_state_rush_hour[3] - 0.05, label = "Steady State Rush Hour - Gridlock", color = steady_colors, size = 3) +
  
  annotate("text", x = 19, y = steady_state_late[1] + 0.05, label = "Steady State Late - Light", color = steady_colors, size = 3) +
  annotate("text", x = 19, y = steady_state_late[2] + 0.05, label = "Steady State Late - Heavy", color = steady_colors, size = 3) +
  annotate("text", x = 19, y = steady_state_late[3] - 0.05, label = "Steady State Late - Gridlock", color = steady_colors, size = 3)

# Save the plot
ggsave("traffic_plot.png", plot = traffic_plot, bg = "white")

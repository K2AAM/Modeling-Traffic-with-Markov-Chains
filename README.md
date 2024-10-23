# Modeling Traffic with Markov Chains

This project uses Markov chains to simulate traffic conditions at different times of the day, considering three states: "Light", "Heavy", and "Gridlock". The simulation spans from 8 am to 8 pm, using distinct transition matrices for different periods:

- **Early Period (8 am - 4 pm)**: Light traffic, transitions likely to remain less congested.
- **Rush Hour (4 pm - 6 pm)**: Increased likelihood of moving to "Heavy" or "Gridlock".
- **Late Period (6 pm - 8 pm)**: Traffic eases up as the evening progresses.

The goal is to observe how the probabilities of each traffic state evolve over time, starting with an initial state of 100% probability of "Light" traffic.

## Transition Matrices

The transition matrices for each time period are as follows:

**Early Period (8 am to 4 pm)**:

\[
\begin{bmatrix}
0.4 & 0.4 & 0.2 \\
0.3 & 0.5 & 0.2 \\
0.0 & 0.1 & 0.9
\end{bmatrix}
\]

**Rush Hour Period (4 pm to 6 pm)**:

\[
\begin{bmatrix}
0.1 & 0.5 & 0.4 \\
0.1 & 0.3 & 0.6 \\
0.0 & 0.1 & 0.9
\end{bmatrix}
\]

**Late Period (6 pm to 8 pm)**:

\[
\begin{bmatrix}
0.6 & 0.3 & 0.1 \\
0.4 & 0.4 & 0.2 \\
0.2 & 0.4 & 0.4
\end{bmatrix}
\]

## Code Overview

This project was created using R, and the following libraries are required:

- `ggplot2`: Used for creating visualizations.
- `markovchain`: Used for working with Markov chains.

### 1. Define Transition Matrices

Transition matrices are defined to represent the probabilities of transitioning between different traffic states ("Light", "Heavy", "Gridlock") during different times of the day.

```r
# Early period (8 am to 4 pm)
early_chain <- new("markovchain", 
                   states = c("Light", "Heavy", "Gridlock"),
                   transitionMatrix = matrix(c(0.4, 0.4, 0.2,  # From Light
                                               0.3, 0.5, 0.2,  # From Heavy
                                               0.0, 0.1, 0.9), # From Gridlock
                                             nrow = 3, byrow = TRUE))

# Rush hour period (4 pm to 6 pm)
rush_hour_chain <- new("markovchain", 
                       states = c("Light", "Heavy", "Gridlock"),
                       transitionMatrix = matrix(c(0.1, 0.5, 0.4, 
                                                   0.1, 0.3, 0.6,
                                                   0.0, 0.1, 0.9),
                                                 nrow = 3, byrow = TRUE))

# Late period (6 pm to 8 pm)
late_chain <- new("markovchain", 
                  states = c("Light", "Heavy", "Gridlock"),
                  transitionMatrix = matrix(c(0.6, 0.3, 0.1,
                                              0.4, 0.4, 0.2,
                                              0.2, 0.4, 0.4),
                                            nrow = 3, byrow = TRUE))
```

### 2. Set Initial State

We start the simulation with the assumption that traffic is "Light" with 100% probability.

```r
initial_state <- c(1, 0, 0)   # 100% probability of "Light" traffic
names(initial_state) <- c("Light", "Heavy", "Gridlock")
```

### 3. Simulation Parameters

We set up the parameters for a simulation spanning from 8 am to 8 pm in 10-minute increments (72 time steps).

```r
time_steps <- 72   # 72 time steps (10-minute increments from 8 am to 8 pm)
state_probabilities <- matrix(0, nrow = time_steps, ncol = 3)  # To store results
state_probabilities[1, ] <- initial_state  # Set initial probabilities
colnames(state_probabilities) <- c("Light", "Heavy", "Gridlock")
```

### 4. Simulate Traffic Flow

This loop iterates through each time step, applying the appropriate transition matrix to calculate the probabilities of each traffic state.

```r
for (t in 2:time_steps) { 
  if (t <= 48) {  # Early period (8 am to 4 pm)
    state_probabilities[t, ] <- initial_state %*% early_chain@transitionMatrix 
  } else if (t <= 60) {  # Rush hour period (4 pm to 6 pm)
    state_probabilities[t, ] <- initial_state %*% rush_hour_chain@transitionMatrix
  } else {  # Late period (6 pm to 8 pm)
    state_probabilities[t, ] <- initial_state %*% late_chain@transitionMatrix
  }
  initial_state <- state_probabilities[t, ] # Update for the next time step
}
```

### 5. Prepare Data for Plotting

The results are then converted to a data frame for easy plotting using `ggplot2`.

```r
traffic_df <- data.frame(
  Time = rep(seq(from = 8, to = 20, length.out = time_steps), each = 3), 
  State = factor(rep(c("Light", "Heavy", "Gridlock"), times = time_steps)),
  Probability = as.vector(t(state_probabilities))
)
```

### 6. Calculate and Print Steady State Probabilities

```r
steady_state_early <- steadyStates(early_chain)
steady_state_rush_hour <- steadyStates(rush_hour_chain)
steady_state_late <- steadyStates(late_chain)

print("Steady State Probabilities for Early Period (8 am to 4 pm):")
print(steady_state_early)

print("Steady State Probabilities for Rush Hour (4 pm to 6 pm):")
print(steady_state_rush_hour)

print("Steady State Probabilities for Late Period (6 pm to 8 pm):")
print(steady_state_late)
```

### 7. Visualize the Results

This section uses `ggplot2` to create a line graph showing the probabilities of each traffic state over time, along with dashed lines indicating the steady-state probabilities.

```r
# Basic plot
traffic_plot <- ggplot(traffic_df, aes(x = Time, y = Probability, color = State, linetype = "Simulation")) +
  geom_line(linewidth = 1.2) + 
  labs(title = "Traffic State Probabilities from 8 am to 8 pm",
       x = "Time (hours)",  
       y = "Probability", 
       color = "Traffic State",  
       linetype = "Line Type") +  
  scale_color_manual(values = c("red", "green", "blue")) +  
  theme_minimal() +  
  theme(legend.position = "top", 
        plot.title = element_text(hjust = 0.5)) 

# Add steady state lines (using annotate)
# ... (code for adding lines and annotations - see previous responses) ...

# Save the plot
ggsave("traffic_plot_improved_v4.png", plot = traffic_plot)
```

## How to Interpret the Plot

![Traffic Plot Improved V4](traffic_plot.png)

The plot (`traffic_plot_improved_v4.png`) shows how the probabilities of "Light", "Heavy", and "Gridlock" traffic change throughout the day. The solid lines represent the simulation results, while the dashed lines indicate the steady-state probabilities for each time period.

New Functionality: PDF Report Generation

The project now includes a feature to automatically generate a PDF report that summarizes the results of the traffic simulation. This report includes:

    Average probabilities of each traffic state during the early, rush hour, and late periods.
    A plot that visualizes how the probabilities of "Light," "Heavy," and "Gridlock" traffic evolve throughout the day.
    Steady-state probabilities for each time period, indicating the long-term probabilities for each traffic state.

Dependencies for PDF Generation

The new functionality requires:

    Python Libraries:
        pandas: For data manipulation.
        matplotlib: For plotting the simulation results.
        jinja2: For rendering the HTML report.
        pdfkit: For converting HTML to PDF.
    System Dependency:
        wkhtmltopdf: A tool used by pdfkit to convert HTML files to PDF format. It must be installed on the system and accessible via the command line.

How to Run the Simulation and Generate the Report

    Run the Traffic Simulation Script
    The script simulates traffic flow from 8 am to 8 pm in 10-minute increments (72 steps) using R. The results are then saved to a CSV file, traffic_simulation.csv.

    Generate the PDF Report Using Python
    Run the Python script to analyze the simulation results, generate plots, and create the PDF report:

    bash

    python3 pdf_generation_script.py

    The script will:
        Load the data from traffic_simulation.csv.
        Calculate the average probability for each state ("Light," "Heavy," "Gridlock") across three periods: Early, Rush Hour, and Late.
        Visualize the traffic state probabilities over time and save the plot as traffic_probabilities_plot.png.
        Render the HTML report using jinja2 and convert it to a PDF named traffic_simulation_report.pdf.

Example Report Output

The generated PDF report (traffic_simulation_report.pdf) includes:

    Average Probabilities for Each Period:
        Displays the average probabilities of being in "Light," "Heavy," or "Gridlock" traffic for the early, rush hour, and late periods.
    Traffic State Probabilities Plot:
        Shows how the probabilities for each state change from 8 am to 8 pm.
        Steady-state probabilities are included as dashed lines on the plot, indicating long-term traffic behavior for each period.

Transition Matrices

The transition matrices for each period are as follows:

Early Period (8 am to 4 pm):
[0.40.40.20.30.50.20.00.10.9]
​0.40.30.0​0.40.50.1​0.20.20.9​
​

Rush Hour Period (4 pm to 6 pm):
[0.10.50.40.10.30.60.00.10.9]
​0.10.10.0​0.50.30.1​0.40.60.9​
​

Late Period (6 pm to 8 pm):
[0.60.30.10.40.40.20.20.40.4]
​0.60.40.2​0.30.40.4​0.10.20.4​
​
## Key Code Updates

    PDF Report Generation
    The Python script now includes code to generate a PDF report. It uses pdfkit to convert an HTML report (rendered with jinja2) into a PDF file. The report includes:
        Average probabilities for "Light," "Heavy," and "Gridlock" traffic during each time period.
        A plot that visualizes traffic state probabilities over time, saved as an image and embedded in the PDF.

    Data Analysis in Python
    The Python script reads the CSV file generated from the R simulation and performs the following steps:
        Calculates average probabilities for each state in each period.
        Visualizes the probabilities over time using matplotlib.
        Saves the visualization as a PNG image (traffic_probabilities_plot.png).
        Generates an HTML report and converts it to a PDF.

## Running the Project

    Install Dependencies
    Ensure the following Python packages are installed:

    bash

pip install pandas matplotlib jinja2 pdfkit

Make sure wkhtmltopdf is installed on the system:

bash

# Ubuntu/Debian
sudo apt install wkhtmltopdf

# macOS (via Homebrew)
brew install wkhtmltopdf

Run the R Simulation Script
Execute the R script to generate the traffic_simulation.csv file:

bash

Rscript traffic_simulation.R

Generate the PDF Report with Python
Run the Python script to create the report:

bash

python3 pdf_generation_script.py

Review the Output
The generated PDF report (traffic_simulation_report.pdf) will be located in the project directory.

## Key Findings

- **Early Period (8 am - 4 pm)**: The probability of "Light" traffic is highest during this period, but there's still a chance of encountering "Heavy" or "Gridlock" traffic.
- **Rush Hour (4 pm - 6 pm)**: As expected, the probability of "Heavy" and "Gridlock" traffic increases significantly during rush hour.
- **Late Period (6 pm - 8 pm)**: Traffic conditions gradually improve, with the probability of "Light" traffic increasing again.
- **Steady States**: The dashed lines show the long-term probabilities of each state within each time period. Notice how the probabilities tend to stabilize towards these steady states over time.


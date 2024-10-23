Modeling Traffic with Markov Chains

This project simulates traffic conditions throughout the day using Markov chains to model transitions between different traffic states. The simulation covers three distinct periods: early (8 am to 4 pm), rush hour (4 pm to 6 pm), and late (6 pm to 8 pm). The states modeled are "Light", "Heavy", and "Gridlock" traffic. The markovchain and ggplot2 libraries in R are used to create and visualize the results.

Overview

The traffic states are modeled using different transition matrices for each time period:

Early Period (8 am to 4 pm): Transition matrix captures normal working hours traffic behavior, typically lighter traffic overall.

Rush Hour (4 pm to 6 pm): Represents the period of heaviest traffic, transitioning more frequently to heavier congestion and gridlock.

Late Period (6 pm to 8 pm): Represents a reduction in traffic as the evening progresses, with traffic slowly easing up.

The project simulates the probabilities of being in one of these states at 10-minute intervals over the course of a day from 8 am to 8 pm, producing a plot that allows easy visualization of how traffic evolves.

How It Works

Initial State: The initial traffic state is set to "Light".

Transition Matrices: Different transition matrices are used for each specific time period to determine the probability of changing from one state to another.

Simulation: The simulation runs for 72 time steps (representing 10-minute increments from 8 am to 8 pm), updating the state probabilities at each time step.

Plotting: The results are plotted using ggplot2 to show how the probabilities of each traffic state evolve over time, with steady state probabilities overlaid for easy reference.

Requirements

R: This project is implemented in R.

Libraries:

ggplot2: Used for creating the plot.

markovchain: Used for modeling and simulating Markov chains.

How to Run

Install the necessary libraries:

install.packages("ggplot2")
install.packages("markovchain")

Run the script:

Use RStudio or Visual Studio Code with an R extension to run the script.

The script will simulate the traffic conditions and save a plot of traffic state probabilities over time.

Visualize the Results:

The plot (traffic_plot_improved_v4.png) will display the probabilities of each state ("Light", "Heavy", "Gridlock") over time, helping visualize how traffic evolves throughout the day.

Code Highlights

Transition Matrices: Defined for each period to control how traffic states evolve based on the time of day.

Markov Chain Modeling: The markovchain library is used to manage state transitions, making the code more readable and easier to maintain.

Plotting with ggplot2: The results are plotted with ggplot2 to provide a clear visual representation of traffic dynamics, with steady state probabilities overlaid for better understanding.

Example Output

The simulation results in a line plot showing the probability of each traffic state over time from 8 am to 8 pm. This helps understand how traffic congestion changes during the day, especially during rush hours.



The plot includes annotations for steady state probabilities during each time period, making it easy to see the expected long-term behavior in each segment of the day.

Different line styles and colors are used to differentiate between dynamic evolution and steady state lines.

Usage

This project is useful for understanding traffic flow dynamics using stochastic modeling techniques like Markov chains. It can be adapted to simulate other systems where states change over time based on probabilities, such as weather conditions or market trends.

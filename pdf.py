import os
import pandas as pd
import matplotlib.pyplot as plt
from jinja2 import Template
import pdfkit

# Step 1: Load the CSV data into a pandas DataFrame
df = pd.read_csv('traffic_simulation.csv')

# Step 2: Data Analysis
early_period = df[(df['Time'] >= 8) & (df['Time'] < 16)]
rush_hour_period = df[(df['Time'] >= 16) & (df['Time'] < 18)]
late_period = df[(df['Time'] >= 18) & (df['Time'] <= 20)]

avg_prob_early = early_period.groupby('State')['Probability'].mean().fillna(0)
avg_prob_rush_hour = rush_hour_period.groupby('State')['Probability'].mean().fillna(0)
avg_prob_late = late_period.groupby('State')['Probability'].mean().fillna(0)

# Visualization
plt.figure(figsize=(12, 6))
for state in df['State'].unique():
    state_data = df[df['State'] == state]
    plt.plot(state_data['Time'], state_data['Probability'], label=state)

plt.title('Traffic State Probabilities from 8 AM to 8 PM')
plt.xlabel('Time (hours)')
plt.ylabel('Probability')
plt.legend(title='Traffic State')
plt.grid()

plot_filename = 'traffic_probabilities_plot.png'
plt.savefig(plot_filename)
plt.close()

# Get the absolute path for the image file
plot_path = os.path.abspath(plot_filename)

# HTML template
html_template = """
<!DOCTYPE html>
<html>
<head>
    <title>Traffic Simulation Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { text-align: center; }
        .section { margin-bottom: 30px; }
    </style>
</head>
<body>
    <h1>Traffic Simulation Report</h1>

    <div class="section">
        <h2>Average Probabilities</h2>
        <p><strong>Early Period (8 AM - 4 PM):</strong></p>
        <ul>
            <li>Light: {{ avg_prob_early_light }}</li>
            <li>Heavy: {{ avg_prob_early_heavy }}</li>
            <li>Gridlock: {{ avg_prob_early_gridlock }}</li>
        </ul>

        <p><strong>Rush Hour Period (4 PM - 6 PM):</strong></p>
        <ul>
            <li>Light: {{ avg_prob_rush_hour_light }}</li>
            <li>Heavy: {{ avg_prob_rush_hour_heavy }}</li>
            <li>Gridlock: {{ avg_prob_rush_hour_gridlock }}</li>
        </ul>

        <p><strong>Late Period (6 PM - 8 PM):</strong></p>
        <ul>
            <li>Light: {{ avg_prob_late_light }}</li>
            <li>Heavy: {{ avg_prob_late_heavy }}</li>
            <li>Gridlock: {{ avg_prob_late_gridlock }}</li>
        </ul>
    </div>

    <div class="section">
        <h2>Probability Plot</h2>
        <img src="{{ plot_path }}" alt="Traffic State Probabilities">
    </div>
</body>
</html>
"""

# Render the HTML
template = Template(html_template)
html_content = template.render(
    avg_prob_early_light=avg_prob_early.get('Light', 0),
    avg_prob_early_heavy=avg_prob_early.get('Heavy', 0),
    avg_prob_early_gridlock=avg_prob_early.get('Gridlock', 0),
    avg_prob_rush_hour_light=avg_prob_rush_hour.get('Light', 0),
    avg_prob_rush_hour_heavy=avg_prob_rush_hour.get('Heavy', 0),
    avg_prob_rush_hour_gridlock=avg_prob_rush_hour.get('Gridlock', 0),
    avg_prob_late_light=avg_prob_late.get('Light', 0),
    avg_prob_late_heavy=avg_prob_late.get('Heavy', 0),
    avg_prob_late_gridlock=avg_prob_late.get('Gridlock', 0),
    plot_path=plot_path
)

with open('traffic_simulation_report.html', 'w') as f:
    f.write(html_content)

# PDF generation
options = {
    'enable-local-file-access': None  # Allow wkhtmltopdf to access local files
}

try:
    pdfkit.from_file('traffic_simulation_report.html', 'traffic_simulation_report.pdf', options=options)
    print("PDF report generated successfully!")
except Exception as e:
    print(f"Error generating PDF: {e}")

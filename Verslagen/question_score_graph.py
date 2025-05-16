import matplotlib.pyplot as plt
import pandas as pd

# Data
data = {
    "Category": [
        "Device pairing", "Profile creation", "Start measurement",
        "Result clarity", "Explanation helpfulness", "Visualization clarity",
        "Color coding", "Gauge helpfulness", "Info dialog", "History feature",
        "Date filtering", "Table min/max helpfulness", "Graph helpfulness",
        "Gauge settings ease", "Gauge settings usefulness", "App easy to use",
        "App complexity (reverse)", "Need tech support (reverse)", "Learnability",
        "Daily use intention", "Confidence using app"
    ],
    "Score": [
        3.6, 3.4, 3.8, 4.6, 3.7, 4.4, 5.0, 4.2, 4.4, 3.6,
        4.4, 2.6, 4.4, 4.8, 3.0, 3.6, 2.0, 1.4, 3.8, 2.6, 3.2
    ]
}

# Create DataFrame
df = pd.DataFrame(data)

# Plot
plt.figure(figsize=(10, 8))
bars = plt.barh(df["Category"], df["Score"], color='teal')
plt.xlabel("Average Score (1–5)")
plt.title("User Study: Average Ratings by Category")
plt.xlim(0, 5)
plt.grid(True, axis='x', linestyle='--', alpha=0.5)
plt.gca().invert_yaxis()  # highest on top
plt.tight_layout()
plt.show()

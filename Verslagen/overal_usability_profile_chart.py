import matplotlib.pyplot as plt
import numpy as np

# Usability categories with average scores (manually grouped)
labels = [
    "Setup & Onboarding",
    "Visual Clarity",
    "Data Interpretation",
    "Feature Usefulness",
    "Engagement & Motivation",
    "Learnability & Support"
]

scores = [
    (3.6 + 3.4 + 3.8)/3,        # Setup & Onboarding
    (4.6 + 5.0 + 4.4)/3,        # Visual Clarity
    (4.2 + 4.4 + 3.6 + 4.4)/4,  # Data Interpretation
    (3.0 + 2.6)/2,              # Feature Usefulness
    (2.6 + 3.2 + 2.6)/3,        # Engagement & Motivation
    ((5-1.4) + (5 - 2.0) + 3.6)/3   # Learnability & Support (reversing complexity score)
]

# Radar chart setup
angles = np.linspace(0, 2 * np.pi, len(labels), endpoint=False).tolist()
scores += scores[:1]  # close the loop
angles += angles[:1]

fig, ax = plt.subplots(figsize=(6, 6), subplot_kw=dict(polar=True))
ax.plot(angles, scores, color='teal', linewidth=2)
ax.fill(angles, scores, color='teal', alpha=0.25)

ax.set_yticks([1, 2, 3, 4, 5])
ax.set_yticklabels(['1', '2', '3', '4', '5'])
ax.set_ylim(0, 5)
ax.set_xticks(angles[:-1])
ax.set_xticklabels(labels)
ax.set_title("Overall Usability Profile", fontsize=14, pad=20)
plt.tight_layout()
plt.show()

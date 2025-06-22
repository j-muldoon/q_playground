import pandas as pd
import matplotlib.pyplot as plt

# Load CSV
df = pd.read_csv("vwap.csv")

# Convert 'minute' to datetime (assuming today’s date just for plotting)
df['minute'] = pd.to_datetime(df['minute'], format='%H:%M')

# Set up subplots: 3 rows, 1 col, one for each company
companies = ['aapl', 'goog', 'ibm']
fig, axes = plt.subplots(nrows=len(companies), ncols=1, figsize=(7, 7), sharex=True)

# Plot each company in its own subplot
for ax, company in zip(axes, companies):
    ax.plot(df['minute'], df[company], marker='.', label=company)
    ax.set_title(f'VWAP Over Time: {company}')
    ax.set_ylabel('VWAP')
    ax.grid(True)
    ax.legend()

# X axis label only on bottom subplot
axes[-1].set_xlabel('Time')

plt.tight_layout()
plt.show()

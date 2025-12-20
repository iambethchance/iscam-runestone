import matplotlib.pyplot as plt
import numpy as np
from scipy import stats

# Create figure with two subplots side by side
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 4))

# First plot: SD = 5
x1 = np.linspace(-15, 20, 1000)
null1 = stats.norm.pdf(x1, 0, 5)
alt1 = stats.norm.pdf(x1, 4, 5)

ax1.plot(x1, null1, 'b-', linewidth=2, label='Null (centered at 0)')
ax1.plot(x1, alt1, 'r-', linewidth=2, label='Alternative (centered at 4)')
ax1.axvline(x=0, color='gray', linestyle='--', alpha=0.5)
ax1.axvline(x=4, color='gray', linestyle='--', alpha=0.5)
ax1.fill_between(x1, 0, null1, alpha=0.2, color='blue')
ax1.fill_between(x1, 0, alt1, alpha=0.2, color='red')
ax1.set_xlabel('Difference in Means', fontsize=11)
ax1.set_ylabel('Density', fontsize=11)
ax1.set_title('SD = 5 (More Overlap)', fontsize=12, fontweight='bold')
ax1.legend(fontsize=9)
ax1.grid(True, alpha=0.3)

# Second plot: SD = 3
x2 = np.linspace(-12, 16, 1000)
null2 = stats.norm.pdf(x2, 0, 3)
alt2 = stats.norm.pdf(x2, 4, 3)

ax2.plot(x2, null2, 'b-', linewidth=2, label='Null (centered at 0)')
ax2.plot(x2, alt2, 'r-', linewidth=2, label='Alternative (centered at 4)')
ax2.axvline(x=0, color='gray', linestyle='--', alpha=0.5)
ax2.axvline(x=4, color='gray', linestyle='--', alpha=0.5)
ax2.fill_between(x2, 0, null2, alpha=0.2, color='blue')
ax2.fill_between(x2, 0, alt2, alpha=0.2, color='red')
ax2.set_xlabel('Difference in Means', fontsize=11)
ax2.set_ylabel('Density', fontsize=11)
ax2.set_title('SD = 3 (Less Overlap)', fontsize=12, fontweight='bold')
ax2.legend(fontsize=9)
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('assets/images/Inv4.8power.png', dpi=150, bbox_inches='tight')
print('Created Inv4.8power.png showing two normal distributions')

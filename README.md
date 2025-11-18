# Simple-Aquarium-Simulation
This project is an interactive aquarium simulation built in Processing. It features
15 fish that wander, chase food, and avoid predators with realistic behavior.
## Features
- 15 fish with unique colors, sizes, and random movement
- Wall avoidance with smooth turning
- Interactive food system (click to drop food)
- Fish chase food when hungry
- Predator avoidance (fish flee from cursor)
- Hunger bars with color-coded status
- Day/night mode toggle
## How to Run
1. Open the .pde file in Processing IDE.
2. Click the Run button.
3. Click to drop food and watch the fish interact.
## Controls
- Mouse click: Drop food particles
- D: Toggle day/night mode
- Mouse movement: Fish avoid cursor (predator effect)
## Code Structure
* Fish class: Handles fish movement, behavior, and rendering
* Food class: Handles food particles that sink
* ArrayList<Fish>: Stores all fish objects
* ArrayList<Food>: Stores all food particles

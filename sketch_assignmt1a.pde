// Aquarium Simulation with Fish and Food, Day/Night Cycle

ArrayList<Fish> fishes = new ArrayList<Fish>(); // List of all fish objects
ArrayList<Food> foods = new ArrayList<Food>(); // List of all food particles
boolean isDay = true; // Track day (true) or night (false)

float transition = 0; // Smooth background transition between day and night

// Gradient colors for day and night
color dayTop = color(135, 206, 255);    // Light sky blue
color dayBottom = color(30, 160, 220);  // Deep ocean blue
color nightTop = color(10, 20, 50);     // Dark navy
color nightBottom = color(5, 10, 30);   // Near-black blue

void setup() {
  size(800, 600); // Window size
  // Initialize 15 fish at random positions
  for (int i = 0; i < 15; i++) {
    fishes.add(new Fish(random(width), random(height)));
  }
}

void draw() {
  // Smoothly transition background between day and night
  float target = isDay ? 0 : 1;
  transition = lerp(transition, target, 0.02);

  // Interpolate top and bottom gradient colors
  color topColor = lerpColor(dayTop, nightTop, transition);
  color bottomColor = lerpColor(dayBottom, nightBottom, transition);
  drawGradient(topColor, bottomColor);
  
  // Update and draw all food particles
  for (int i = foods.size() - 1; i >= 0; i--) {
    Food f = foods.get(i);
    f.move();
    f.show();
    
    // Check if any fish eats the food
    for (Fish fish : fishes) {
      if (dist(fish.x, fish.y, f.x, f.y) < 15) {
        fish.hunger = min(100, fish.hunger + 20); // Increase fish hunger
        foods.remove(i);
        break;
      }
    }
  }
  
  // Update and draw all fish
  for (Fish fish : fishes) {
    fish.move();
    fish.show();
  }
  
  // Display instructions
  fill(255);
  textSize(16);
  text("Click to drop food", 10, 25);
  text("Press D for day/night", 10, 50);
}

// Draw vertical gradient background
void drawGradient(color c1, color c2) {
  noFill();
  for (int y = 0; y < height; y++) {
    float t = map(y, 0, height, 0, 1);
    stroke(lerpColor(c1, c2, t));
    line(0, y, width, y);
  }
}

// Add food at mouse click position
void mousePressed() {
  foods.add(new Food(mouseX, mouseY));
}

// Toggle day/night cycle
void keyPressed() {
  if (key == 'd' || key == 'D') {
    isDay = !isDay;
  } 
}

// Fish class
class Fish {
  float x, y;        // Position
  float speedX, speedY; // Movement speed
  float size;        // Size of fish
  color col;         // Fish color
  float hunger;      // Hunger level (0-100)
  
  Fish(float x, float y) {
    this.x = x;
    this.y = y;
    speedX = random(-1, 1);
    speedY = random(-1, 1);
    size = random(20, 30);
    col = color(random(150, 255), random(100, 200), random(100, 255));
    hunger = random(50, 100);
  }
  
  // Update fish position and behavior
  void move() {
    hunger = max(0, hunger - 0.05); // Decrease hunger gradually
    speedX += random(-0.2, 0.2);    // Random horizontal wandering
    speedY += random(-0.2, 0.2);    // Random vertical wandering
    
    // Chase nearest food if hungry
    if (hunger < 60 && foods.size() > 0) {
      Food closest = foods.get(0);
      for (Food f : foods) {
        if (dist(x, y, f.x, f.y) < dist(x, y, closest.x, closest.y)) closest = f;
      }
      speedX += (closest.x - x) * 0.01;
      speedY += (closest.y - y) * 0.01;
    }
    
    // Avoid mouse cursor
    float d = dist(x, y, mouseX, mouseY);
    if (d < 80) {
      speedX += (x - mouseX) * 0.05;
      speedY += (y - mouseY) * 0.05;
    }
    
    // Wall avoidance
    if (x < 15) speedX += 0.5;
    if (x > width - 15) speedX -= 0.5;
    if (y < 15) speedY += 0.5;
    if (y > height - 15) speedY -= 0.5;
    
    // Limit maximum speed
    float speed = sqrt(speedX * speedX + speedY * speedY);
    if (speed > 2) {
      speedX = (speedX / speed) * 2;
      speedY = (speedY / speed) * 2;
    }
    
    // Apply movement
    x += speedX;
    y += speedY;
    
    // Keep fish within canvas bounds
    x = constrain(x, 10, width - 10);
    y = constrain(y, 10, height - 10);
  }
  
  // Draw fish on screen
  void show() {
    fill(col);
    noStroke();
    ellipse(x, y, size, size * 0.7); // Body
    
    // Draw tail based on movement direction
    float angle = atan2(speedY, speedX);
    pushMatrix();
    translate(x, y);
    rotate(angle);
    triangle(-size/2, 0, -size, -size/3, -size, size/3);
    popMatrix();
    
    // Draw eye
    fill(255);
    circle(x + size/4, y - size/6, size/5);
    fill(0);
    circle(x + size/4, y - size/6, size/10);
    
    // Draw hunger bar
    fill(0, 100);
    rect(x - 15, y - size - 5, 30, 3);
    if (hunger > 50) fill(0, 200, 0);
    else if (hunger > 25) fill(255, 200, 0);
    else fill(255, 0, 0);
    rect(x - 15, y - size - 5, 30 * (hunger/100), 3);
  }
}

// Food class
class Food {
  float x, y;        // Position
  float vy = random(0.3, 0.8); // Sinking speed
  float drift = random(-0.2, 0.2); // Horizontal drift
  
  Food(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  // Update food position
  void move() {
    x += drift;
    y += vy;
    drift += random(-0.01, 0.01);
    drift = constrain(drift, -0.3, 0.3);
    if (y > height - 15) y = height - 15;
  }
  
  // Draw food particle
  void show() {
    fill(255, 150, 0);
    stroke(150, 80, 0);
    strokeWeight(2);
    circle(x, y, 8);
  }
}

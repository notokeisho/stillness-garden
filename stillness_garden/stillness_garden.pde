// Stillness Garden - Main file
// A meditative experience where stillness nurtures growth

// ========== TEST CODE FOR TASK 2.2.1 ==========
// This code will be removed after testing

Plant testPlant;

void setup() {
  size(800, 800, P2D);
  frameRate(60);
  background(0);
  testPlant = null;
}

void draw() {
  background(0);

  // Enable additive blending for glow effect
  blendMode(ADD);

  if (testPlant != null) {
    // Update and display plant
    testPlant.update();
    testPlant.display();
  }

  // Reset blend mode
  blendMode(BLEND);

  // Display instructions
  fill(255);
  textSize(14);
  text("Click to spawn a new plant", 20, 30);
  text("Press SPACE to clear", 20, 50);

  if (testPlant != null) {
    text("Branches: " + testPlant.branches.size(), 20, 80);
    text("Flowers: " + testPlant.flowers.size(), 20, 100);
    text("Particles: " + testPlant.particles.size(), 20, 120);

    // Show first few branch point counts
    int yOffset = 150;
    int showCount = min(testPlant.branches.size(), 8);
    for (int i = 0; i < showCount; i++) {
      Branch b = testPlant.branches.get(i);
      String status = b.growing ? "growing" : "stopped";
      text("Branch " + i + ": " + b.points.size() + " pts (" + status + ")", 20, yOffset);
      yOffset += 18;
    }
  } else {
    text("No plant yet. Click to create one.", 20, 80);
  }
}

void mousePressed() {
  // Create a new plant at mouse position
  testPlant = new Plant(mouseX, mouseY);
}

void keyPressed() {
  if (key == ' ') {
    // Clear plant
    testPlant = null;
  }
}

// ========== END TEST CODE ==========

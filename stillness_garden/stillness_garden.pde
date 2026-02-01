// Stillness Garden - Main file
// A meditative experience where stillness nurtures growth

// ========== TEST CODE FOR TASK 2.1.1 ==========
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
    // Update and display seed
    testPlant.seed.update();
    testPlant.seed.display();

    // Update and display all branches
    for (Branch b : testPlant.branches) {
      if (b.growing) {
        b.grow();
      }
      b.display();
    }
  }

  // Reset blend mode
  blendMode(BLEND);

  // Display instructions
  fill(255);
  textSize(14);
  text("Click to spawn a new plant", 20, 30);
  text("Press SPACE to clear", 20, 50);

  if (testPlant != null) {
    text("Branch count: " + testPlant.branches.size(), 20, 80);

    // Show branch info
    int yOffset = 100;
    for (int i = 0; i < testPlant.branches.size(); i++) {
      Branch b = testPlant.branches.get(i);
      float angleDeg = degrees(b.angle) % 360;
      if (angleDeg < 0) angleDeg += 360;
      text("Branch " + i + ": angle = " + nf(angleDeg, 1, 1) + " deg, points = " + b.points.size(), 20, yOffset);
      yOffset += 20;
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

// Stillness Garden - Main file
// A meditative experience where stillness nurtures growth

// ========== TEST CODE FOR TASK 1.4.3 ==========
// This code will be removed after testing

ArrayList<Flower> testFlowers;

void setup() {
  size(800, 800, P2D);
  frameRate(60);
  background(0);
  testFlowers = new ArrayList<Flower>();
}

void draw() {
  background(0);

  // Enable additive blending for glow effect
  blendMode(ADD);

  // Update and display all flowers
  for (int i = testFlowers.size() - 1; i >= 0; i--) {
    Flower f = testFlowers.get(i);

    // Progress bloom or dying animation
    if (f.dying) {
      f.updateDying();
      // Remove fully dead flowers
      if (f.isDead()) {
        testFlowers.remove(i);
        continue;
      }
    } else {
      f.bloom();
    }

    // Display flower
    f.display();
  }

  // Reset blend mode
  blendMode(BLEND);

  // Display instructions
  fill(255);
  textSize(14);
  text("Click to spawn a blooming flower", 20, 30);
  text("Press 'D' to start dying for all flowers", 20, 50);
  text("Press SPACE to clear all flowers", 20, 70);
  text("Flower count: " + testFlowers.size(), 20, 90);

  // Show flower status
  int yOffset = 110;
  for (int i = 0; i < min(testFlowers.size(), 15); i++) {
    Flower f = testFlowers.get(i);
    String status;
    if (f.dying) {
      status = "dying (" + nf(f.dyingProgress, 1, 2) + ")";
    } else if (f.isFullyBloomed()) {
      status = "fully bloomed";
    } else {
      status = "blooming (" + nf(f.bloomProgress, 1, 2) + ")";
    }
    String type = f.flowerType == 0 ? "pink" : "white";
    text("Flower " + i + " [" + type + "]: " + status, 20, yOffset);
    yOffset += 20;
  }
}

void mousePressed() {
  // Spawn a flower at mouse position
  testFlowers.add(new Flower(mouseX, mouseY));
}

void keyPressed() {
  if (key == ' ') {
    // Clear all flowers
    testFlowers.clear();
  } else if (key == 'd' || key == 'D') {
    // Start dying for all fully bloomed flowers
    for (Flower f : testFlowers) {
      if (f.isFullyBloomed() && !f.dying) {
        f.startDying();
      }
    }
  }
}

// ========== END TEST CODE ==========

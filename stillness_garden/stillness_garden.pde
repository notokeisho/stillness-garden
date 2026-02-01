// Stillness Garden - Main file
// A meditative experience where stillness nurtures growth

// ========== TEST CODE FOR TASK 1.4.1 ==========
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
  for (int i = 0; i < testFlowers.size(); i++) {
    Flower f = testFlowers.get(i);

    // Progress bloom animation
    f.bloom();

    // Display flower
    f.display();
  }

  // Reset blend mode
  blendMode(BLEND);

  // Display instructions
  fill(255);
  textSize(14);
  text("Click to spawn a blooming flower", 20, 30);
  text("Press SPACE to clear all flowers", 20, 50);
  text("Flower count: " + testFlowers.size(), 20, 70);

  // Show flower status
  int yOffset = 90;
  for (int i = 0; i < testFlowers.size(); i++) {
    Flower f = testFlowers.get(i);
    String status = f.isFullyBloomed() ? "fully bloomed" : "blooming";
    text("Flower " + i + ": " + status + " (petals: " + f.petalCount + ", progress: " + nf(f.bloomProgress, 1, 2) + ")", 20, yOffset);
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
  }
}

// ========== END TEST CODE ==========

// Stillness Garden - Main file
// A meditative experience where stillness nurtures growth

// ========== TEST CODE FOR TASK 2.3.1 ==========
// This code will be removed after testing

Plant testPlant;
boolean drawBranches = true;
boolean drawFlowers = true;
boolean drawParticles = true;
boolean useBlendMode = true;

void setup() {
  size(800, 800, P2D);
  frameRate(60);
  background(0);
  testPlant = null;
}

void draw() {
  background(0);

  // Enable additive blending for glow effect
  if (useBlendMode) {
    blendMode(ADD);
  }

  if (testPlant != null) {
    // Update plant
    testPlant.update();

    // Display with toggles for debugging
    if (drawBranches) {
      for (Branch b : testPlant.branches) {
        b.display();
      }
    }
    if (drawFlowers) {
      for (Flower f : testPlant.flowers) {
        f.display();
      }
    }
    if (testPlant.seed.alive) {
      testPlant.seed.display();
    }
    if (drawParticles) {
      for (Particle p : testPlant.particles) {
        p.display();
      }
    }

    // Remove plant if fully dead
    if (testPlant.isFullyDead()) {
      testPlant = null;
    }
  }

  // Reset blend mode
  blendMode(BLEND);

  // Display FPS and instructions
  fill(255);
  textSize(14);
  text("FPS: " + nf(frameRate, 1, 1), 20, 15);
  text("Click to spawn a new plant", 20, 30);
  text("Press 'D' to start dying", 20, 50);
  text("Press SPACE to clear", 20, 70);
  text("Toggle: 1=Branches(" + drawBranches + ") 2=Flowers(" + drawFlowers + ") 3=Particles(" + drawParticles + ") 4=BlendMode(" + useBlendMode + ")", 20, 85);

  if (testPlant != null) {
    String status = testPlant.dying ? "DYING" : "ALIVE";
    text("Status: " + status, 20, 100);
    text("Branches: " + testPlant.branches.size(), 20, 120);
    text("Flowers: " + testPlant.flowers.size(), 20, 140);
    text("Particles: " + testPlant.particles.size(), 20, 160);

    // Debug: show total branch points
    int totalPoints = 0;
    for (Branch b : testPlant.branches) {
      totalPoints += b.points.size();
    }
    text("Total branch points: " + totalPoints, 20, 220);

    if (testPlant.dying) {
      // Show dying progress
      int deadBranches = 0;
      int deadFlowers = 0;
      for (Branch b : testPlant.branches) {
        if (b.isFullyDead()) deadBranches++;
      }
      for (Flower f : testPlant.flowers) {
        if (f.isDead()) deadFlowers++;
      }
      text("Dead branches: " + deadBranches + "/" + testPlant.branches.size(), 20, 180);
      text("Dead flowers: " + deadFlowers + "/" + testPlant.flowers.size(), 20, 200);
    }
  } else {
    text("No plant. Click to create one.", 20, 100);
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
  } else if ((key == 'd' || key == 'D') && testPlant != null && !testPlant.dying) {
    // Start dying
    testPlant.startDying();
  } else if (key == '1') {
    drawBranches = !drawBranches;
  } else if (key == '2') {
    drawFlowers = !drawFlowers;
  } else if (key == '3') {
    drawParticles = !drawParticles;
  } else if (key == '4') {
    useBlendMode = !useBlendMode;
  }
}

// ========== END TEST CODE ==========

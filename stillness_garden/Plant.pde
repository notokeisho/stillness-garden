// Plant class - Manages the entire plant lifecycle

class Plant {
  Seed seed;
  ArrayList<Branch> branches;
  ArrayList<Flower> flowers;
  ArrayList<Particle> particles;
  boolean alive;
  boolean dying;
  int pollenSpawnTimer;  // Timer for pollen generation

  // Constructor
  Plant(float x, float y) {
    seed = new Seed(x, y);
    branches = new ArrayList<Branch>();
    flowers = new ArrayList<Flower>();
    particles = new ArrayList<Particle>();
    alive = true;
    dying = false;
    pollenSpawnTimer = 0;

    // Initialize branches radiating from seed
    initBranches();
  }

  // Initialize branches with random directions (5-8 branches)
  void initBranches() {
    int branchCount = int(random(5, 9));  // 5 to 8 branches

    // Distribute branches roughly evenly around the seed
    float baseAngle = random(TWO_PI);  // Random starting angle
    float angleStep = TWO_PI / branchCount;

    for (int i = 0; i < branchCount; i++) {
      // Add some randomness to the angle for natural look
      float angle = baseAngle + (i * angleStep) + random(-0.3, 0.3);
      Branch branch = new Branch(seed.position.x, seed.position.y, angle);
      branches.add(branch);
    }
  }

  // Update plant state (growth or dying)
  void update() {
    if (dying) {
      // Will be implemented in Task 2.3
      return;
    }

    // Update seed
    seed.update();

    // Update branches and check for flower spawning
    for (Branch b : branches) {
      if (b.growing) {
        b.grow();

        // Check if branch is ready for a flower
        if (b.isReadyForFlower() && !hasBranchFlower(b)) {
          // Spawn flower at branch tip
          PVector tip = b.getTip();
          Flower f = new Flower(tip.x, tip.y);
          flowers.add(f);
        }
      }
    }

    // Update flowers
    for (Flower f : flowers) {
      if (!f.dying) {
        f.bloom();
      }
    }

    // Update particles and remove dead ones
    for (int i = particles.size() - 1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.update();
      if (p.isDead()) {
        particles.remove(i);
      }
    }

    // Spawn pollen from bloomed flowers periodically
    pollenSpawnTimer++;
    if (pollenSpawnTimer >= 30) {  // Every 30 frames (0.5 seconds)
      spawnPollen();
      pollenSpawnTimer = 0;
    }
  }

  // Check if a branch already has a flower
  boolean hasBranchFlower(Branch b) {
    PVector tip = b.getTip();
    for (Flower f : flowers) {
      // Check if flower is near branch tip (within 5 pixels)
      if (dist(f.position.x, f.position.y, tip.x, tip.y) < 5) {
        return true;
      }
    }
    return false;
  }

  // Display all plant elements (layer order: branches -> flowers -> seed -> particles)
  void display() {
    // Draw branches first (bottom layer)
    for (Branch b : branches) {
      b.display();
    }

    // Draw flowers
    for (Flower f : flowers) {
      f.display();
    }

    // Draw seed
    seed.display();

    // Draw particles (top layer)
    for (Particle p : particles) {
      p.display();
    }
  }

  // Spawn pollen particles from bloomed flowers
  void spawnPollen() {
    for (Flower f : flowers) {
      if (f.isFullyBloomed() && !f.dying) {
        // Spawn 1-2 pollen particles per flower
        int pollenCount = int(random(1, 3));
        for (int i = 0; i < pollenCount; i++) {
          // Spawn near flower position with slight offset
          float offsetX = random(-f.size, f.size);
          float offsetY = random(-f.size, f.size);
          Particle pollen = new Particle(
            f.position.x + offsetX,
            f.position.y + offsetY,
            0  // type 0 = pollen
          );
          particles.add(pollen);
        }
      }
    }
  }

  // Start the dying process
  void startDying() {
    // Will be implemented in Task 2.3
  }

  // Check if plant has fully withered
  boolean isFullyDead() {
    // Will be implemented in Task 2.3
    return false;
  }
}

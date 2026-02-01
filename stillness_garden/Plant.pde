// Plant class - Manages the entire plant lifecycle

class Plant {
  Seed seed;
  ArrayList<Branch> branches;
  ArrayList<Flower> flowers;
  ArrayList<Particle> particles;
  boolean alive;
  boolean dying;

  // Constructor
  Plant(float x, float y) {
    seed = new Seed(x, y);
    branches = new ArrayList<Branch>();
    flowers = new ArrayList<Flower>();
    particles = new ArrayList<Particle>();
    alive = true;
    dying = false;

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
    // Will be implemented in Task 2.2
  }

  // Display all plant elements
  void display() {
    // Will be implemented in Task 2.2
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

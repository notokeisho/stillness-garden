// Plant class - Manages the entire plant lifecycle

class Plant {
  Seed seed;
  ArrayList<Branch> branches;
  ArrayList<Flower> flowers;
  ArrayList<Particle> particles;
  boolean alive;
  boolean dying;
  int pollenSpawnTimer;  // Timer for pollen generation
  int ashSpawnTimer;     // Timer for ash generation
  int maxFlowers = 40;   // Maximum number of flowers per plant

  // Constructor
  Plant(float x, float y) {
    seed = new Seed(x, y);
    branches = new ArrayList<Branch>();
    flowers = new ArrayList<Flower>();
    particles = new ArrayList<Particle>();
    alive = true;
    dying = false;
    pollenSpawnTimer = 0;
    ashSpawnTimer = 0;

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
      updateDying();
      return;
    }

    // Update seed
    seed.update();

    // Update branches and check for flower spawning
    for (Branch b : branches) {
      if (b.growing) {
        b.grow();

        // Check if branch is ready for a new flower (and under limit)
        if (b.isReadyForFlower() && flowers.size() < maxFlowers) {
          // Spawn flower at current branch tip position
          PVector tip = b.getTip();
          Flower f = new Flower(tip.x, tip.y);
          flowers.add(f);
          // Record that flower was spawned at this point count
          b.flowerSpawned();
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

  // Update dying state
  void updateDying() {
    // Update branches (dying process)
    for (Branch b : branches) {
      if (b.dying) {
        b.updateDying();
      }
    }

    // Update flowers (dying process)
    for (Flower f : flowers) {
      if (f.dying) {
        f.updateDying();
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

    // Spawn ash particles periodically
    ashSpawnTimer++;
    if (ashSpawnTimer >= 10) {  // Every 10 frames
      spawnAsh();
      ashSpawnTimer = 0;
    }
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

    // Draw seed (only if alive)
    if (seed.alive) {
      seed.display();
    }

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

  // Spawn ash particles from dying branches and flowers
  void spawnAsh() {
    // Spawn ash from dying branches
    for (Branch b : branches) {
      if (b.dying && !b.isFullyDead()) {
        PVector ashPos = b.getAshPosition();
        // Spawn 1-2 ash particles
        int ashCount = int(random(1, 3));
        for (int i = 0; i < ashCount; i++) {
          float offsetX = random(-3, 3);
          float offsetY = random(-3, 3);
          Particle ash = new Particle(
            ashPos.x + offsetX,
            ashPos.y + offsetY,
            1  // type 1 = ash
          );
          particles.add(ash);
        }
      }
    }

    // Spawn ash from dying flowers
    for (Flower f : flowers) {
      if (f.dying && !f.isDead()) {
        // Spawn 1-2 ash particles from flower
        int ashCount = int(random(1, 3));
        for (int i = 0; i < ashCount; i++) {
          float offsetX = random(-f.size, f.size);
          float offsetY = random(-f.size, f.size);
          Particle ash = new Particle(
            f.position.x + offsetX,
            f.position.y + offsetY,
            1  // type 1 = ash
          );
          particles.add(ash);
        }
      }
    }
  }

  // Start the dying process
  void startDying() {
    dying = true;
    alive = false;

    // Kill seed
    seed.die();

    // Start dying for all branches
    for (Branch b : branches) {
      b.startDying();
    }

    // Start dying for all flowers
    for (Flower f : flowers) {
      f.startDying();
    }
  }

  // Check if plant has fully withered
  boolean isFullyDead() {
    if (!dying) return false;

    // Check if all branches are dead
    for (Branch b : branches) {
      if (!b.isFullyDead()) {
        return false;
      }
    }

    // Check if all flowers are dead
    for (Flower f : flowers) {
      if (!f.isDead()) {
        return false;
      }
    }

    // Check if all particles are gone
    if (particles.size() > 0) {
      return false;
    }

    return true;
  }
}

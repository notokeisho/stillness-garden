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
  int maxParticles = 300; // Maximum number of particles
  boolean reachedFlowerLimit = false;  // Flag for when flower limit is reached
  PVector windDirection;   // Wind direction (set when flower limit reached)
  float windStrength = 0.05;  // Wind strength

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

    // Check if flower limit is reached and stop branch growth
    if (!reachedFlowerLimit && flowers.size() >= maxFlowers) {
      reachedFlowerLimit = true;

      // Stop all branch growth
      for (Branch b : branches) {
        b.growing = false;
      }

      // Add flowers to branches without tip flowers (completion phase)
      for (Branch b : branches) {
        PVector tip = b.getTip();

        // Check if any flower is near the tip (within 10 pixels)
        boolean hasTipFlower = false;
        for (Flower f : flowers) {
          if (dist(f.position.x, f.position.y, tip.x, tip.y) < 10) {
            hasTipFlower = true;
            break;
          }
        }

        // Add flower if tip doesn't have one
        if (!hasTipFlower) {
          PVector flowerPos;

          if (isOnScreen(tip.x, tip.y)) {
            // Tip is on-screen: spawn at tip
            flowerPos = tip;
          } else {
            // Tip is off-screen: spawn at random on-screen position
            flowerPos = getRandomOnScreenPosition(b);
          }

          if (flowerPos != null) {
            Flower f = new Flower(flowerPos.x, flowerPos.y, b);
            flowers.add(f);
          }
        }
      }

      // Set random wind direction (mainly horizontal, slight vertical)
      windDirection = new PVector(random(-1, 1), random(-0.3, 0.3));
      windDirection.normalize();
    }

    // Update branches and check for flower spawning
    for (Branch b : branches) {
      if (b.growing) {
        b.grow();

        // Check if branch is ready for a new flower
        if (b.isReadyForFlower()) {
          if (flowers.size() < maxFlowers) {
            // 1/3 chance to spawn a flower
            if (random(1) < 0.33) {
              PVector tip = b.getTip();
              PVector flowerPos;

              if (isOnScreen(tip.x, tip.y)) {
                // Tip is on-screen: spawn at tip
                flowerPos = tip;
              } else {
                // Tip is off-screen: spawn at random on-screen position
                flowerPos = getRandomOnScreenPosition(b);
              }

              if (flowerPos != null) {
                Flower f = new Flower(flowerPos.x, flowerPos.y, b);
                flowers.add(f);
              }
            }
          }
          // Record point count regardless of whether flower was spawned
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
      // Apply wind to pollen after flower limit reached
      if (reachedFlowerLimit && p.particleType == 0) {
        p.applyWind(windDirection, windStrength);
      }
      if (p.isDead()) {
        particles.remove(i);
      }
    }

    // Spawn pollen from bloomed flowers (each flower has its own timer)
    spawnPollen();
  }

  // Update dying state
  void updateDying() {
    // Update branches (dying process)
    for (Branch b : branches) {
      if (b.dying) {
        b.updateDying();

        // Check if ash has reached any flowers on this branch
        PVector ashPos = b.getAshPosition();
        for (Flower f : flowers) {
          if (f.parentBranch == b && !f.dying) {
            if (dist(ashPos.x, ashPos.y, f.position.x, f.position.y) < 15) {
              spawnPetals(f);  // Spawn petal particles
              f.startDying();  // Mark flower as dying (will be hidden)
            }
          }
        }
      }
    }

    // Update flowers (dying process) - now just for tracking, not visual
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

  // Spawn pollen particles from bloomed flowers (individual timer per flower)
  void spawnPollen() {
    // Check particle limit
    if (particles.size() >= maxParticles) return;

    for (Flower f : flowers) {
      if (particles.size() >= maxParticles) break;

      // Each flower has its own timer
      if (f.shouldSpawnPollen()) {
        float offsetX = random(-f.size, f.size);
        float offsetY = random(-f.size, f.size);
        Particle pollen = new Particle(
          f.position.x + offsetX,
          f.position.y + offsetY,
          0  // type 0 = pollen
        );
        particles.add(pollen);

        // After flower limit: spawn extra pollen for more dramatic effect
        if (reachedFlowerLimit && particles.size() < maxParticles) {
          offsetX = random(-f.size, f.size);
          offsetY = random(-f.size, f.size);
          Particle extraPollen = new Particle(
            f.position.x + offsetX,
            f.position.y + offsetY,
            0
          );
          particles.add(extraPollen);
        }
      }
    }
  }

  // Spawn ash particles from dying branches and flowers (optimized)
  void spawnAsh() {
    // Check particle limit
    if (particles.size() >= maxParticles) return;

    // Collect dying branches
    ArrayList<Branch> dyingBranches = new ArrayList<Branch>();
    for (Branch b : branches) {
      if (b.dying && !b.isFullyDead()) {
        dyingBranches.add(b);
      }
    }

    // Collect dying flowers
    ArrayList<Flower> dyingFlowers = new ArrayList<Flower>();
    for (Flower f : flowers) {
      if (f.dying && !f.isDead()) {
        dyingFlowers.add(f);
      }
    }

    // Randomly select 1-2 branches to spawn ash from
    int branchSpawnCount = min(int(random(1, 3)), dyingBranches.size());
    for (int i = 0; i < branchSpawnCount && particles.size() < maxParticles; i++) {
      int index = int(random(dyingBranches.size()));
      Branch b = dyingBranches.get(index);
      PVector ashPos = b.getAshPosition();

      // Spawn 2-4 ash particles (increased for crumbling effect)
      int particleCount = int(random(2, 5));
      for (int j = 0; j < particleCount && particles.size() < maxParticles; j++) {
        float offsetX = random(-5, 5);  // Wider spread
        float offsetY = random(-5, 5);
        Particle ash = new Particle(
          ashPos.x + offsetX,
          ashPos.y + offsetY,
          1  // type 1 = ash
        );
        particles.add(ash);
      }
    }

    // Randomly select 1-3 flowers to spawn ash from
    int flowerSpawnCount = min(int(random(1, 4)), dyingFlowers.size());
    for (int i = 0; i < flowerSpawnCount && particles.size() < maxParticles; i++) {
      int index = int(random(dyingFlowers.size()));
      Flower f = dyingFlowers.get(index);

      // Spawn 1 ash particle
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

  // Spawn petal particles when a flower scatters
  void spawnPetals(Flower f) {
    for (int i = 0; i < f.petalCount; i++) {
      // Calculate burst direction for each petal
      float angle = TWO_PI / f.petalCount * i + f.rotation;
      float speed = random(1.5, 3.0);  // Burst speed
      float vx = cos(angle) * speed;
      float vy = sin(angle) * speed;

      // Create petal particle
      Particle petal = new Particle(
        f.position.x,
        f.position.y,
        2,  // type 2 = petal
        vx,
        vy,
        f.petalColor
      );
      particles.add(petal);
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

    // Flowers will start dying when ash reaches them (in updateDying)
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

  // Check if position is on screen
  boolean isOnScreen(float x, float y) {
    return x >= 0 && x <= width && y >= 0 && y <= height;
  }

  // Get a random on-screen position from a branch
  PVector getRandomOnScreenPosition(Branch b) {
    ArrayList<PVector> onScreenPoints = new ArrayList<PVector>();
    for (PVector p : b.points) {
      if (isOnScreen(p.x, p.y)) {
        onScreenPoints.add(p);
      }
    }
    if (onScreenPoints.size() == 0) {
      return null;  // All points are off-screen
    }
    return onScreenPoints.get(int(random(onScreenPoints.size())));
  }
}

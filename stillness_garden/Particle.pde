// Particle class - Manages pollen and ash particles

class Particle {
  PVector position;
  PVector velocity;
  float lifespan;
  float maxLifespan;
  int particleType;  // 0: pollen, 1: ash, 2: petal
  float size;
  color particleColor;
  int fadeInDuration = 90;  // 1.5 seconds fade-in

  // Constructor for pollen and ash
  Particle(float x, float y, int type) {
    position = new PVector(x, y);
    particleType = type;

    // Lifespan: 180-300 frames (3-5 seconds at 60fps)
    maxLifespan = random(180, 300);
    lifespan = maxLifespan;

    // Size: small particles
    size = random(2, 5);

    if (particleType == 0) {
      // Pollen: white to pale color, floats randomly
      particleColor = color(255, 255, 240);
      velocity = new PVector(random(-0.3, 0.3), random(-0.3, 0.3));
    } else {
      // Ash: gray color, falls with gravity
      particleColor = color(180, 180, 180);
      velocity = new PVector(random(-0.2, 0.2), random(0.5, 1.0));
    }
  }

  // Constructor for petals (with initial velocity and color)
  Particle(float x, float y, int type, float vx, float vy, color c) {
    position = new PVector(x, y);
    particleType = type;
    velocity = new PVector(vx, vy);
    particleColor = c;

    // Petals have shorter lifespan
    maxLifespan = random(90, 150);  // 1.5-2.5 seconds
    lifespan = maxLifespan;

    // Petal size
    size = random(4, 8);
  }

  // Update position and lifespan
  void update() {
    if (particleType == 0) {
      // Pollen: apply random wandering force (no gravity)
      velocity.x += random(-0.05, 0.05);
      velocity.y += random(-0.05, 0.05);
      // Limit velocity for gentle floating (will be increased when wind applied)
      velocity.limit(0.5);
    } else if (particleType == 1) {
      // Ash: apply gravity and slight horizontal drift
      velocity.y += 0.02;  // gravity
      velocity.x += random(-0.02, 0.02);  // horizontal drift
    } else if (particleType == 2) {
      // Petal: gravity + gentle swaying
      velocity.y += 0.03;  // gravity
      velocity.x += random(-0.02, 0.02);  // swaying
      velocity.x *= 0.99;  // air resistance
    }

    position.add(velocity);
    lifespan -= 1;
  }

  // Apply wind force to particle
  void applyWind(PVector windDir, float strength) {
    velocity.x += windDir.x * strength;
    velocity.y += windDir.y * strength;
    // Allow higher velocity when wind is applied
    velocity.limit(1.0);
  }

  // Draw particle with glow effect and fade-in
  void display() {
    // Calculate age (frames since creation)
    float age = maxLifespan - lifespan;

    // Petals: no fade-in, just fade-out
    if (particleType == 2) {
      float alpha = map(lifespan, 0, maxLifespan, 0, 200);

      noStroke();

      // Draw petal as ellipse (elongated shape)
      pushMatrix();
      translate(position.x, position.y);
      rotate(velocity.heading());  // Rotate based on movement direction

      // Glow layer
      fill(particleColor, alpha * 0.3);
      ellipse(0, 0, size * 1.5, size * 0.8);

      // Main petal
      fill(particleColor, alpha);
      ellipse(0, 0, size, size * 0.5);

      popMatrix();
      return;
    }

    // Pollen and Ash: fade-in effect
    float fadeInProgress = min(1.0, age / fadeInDuration);
    float growthFactor = easeOutCubic(fadeInProgress);

    // Calculate alpha based on remaining lifespan, then apply fade-in
    float baseAlpha = map(lifespan, 0, maxLifespan, 0, 255);
    float alpha = baseAlpha * growthFactor;

    // Apply fade-in to size
    float displaySize = size * growthFactor;

    noStroke();

    // Glow effect: draw larger transparent circles first
    for (int i = 3; i > 0; i--) {
      fill(particleColor, alpha / (i * 2));
      ellipse(position.x, position.y, displaySize * i, displaySize * i);
    }

    // Core of particle
    fill(particleColor, alpha);
    ellipse(position.x, position.y, displaySize * 0.5, displaySize * 0.5);
  }

  // Ease-out cubic for smooth fade-in animation
  float easeOutCubic(float t) {
    return 1 - pow(1 - t, 3);
  }

  // Check if particle should be removed
  boolean isDead() {
    return lifespan <= 0;
  }
}

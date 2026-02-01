// Particle class - Manages pollen and ash particles

class Particle {
  PVector position;
  PVector velocity;
  float lifespan;
  float maxLifespan;
  int particleType;  // 0: pollen, 1: ash
  float size;
  color particleColor;

  // Constructor
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

  // Update position and lifespan
  void update() {
    if (particleType == 0) {
      // Pollen: apply random wandering force (no gravity)
      velocity.x += random(-0.05, 0.05);
      velocity.y += random(-0.05, 0.05);
      // Limit velocity for gentle floating
      velocity.limit(0.5);
    } else {
      // Ash: apply gravity and slight horizontal drift
      velocity.y += 0.02;  // gravity
      velocity.x += random(-0.02, 0.02);  // horizontal drift
    }

    position.add(velocity);
    lifespan -= 1;
  }

  // Draw particle with glow effect
  void display() {
    // Calculate alpha based on remaining lifespan
    float alpha = map(lifespan, 0, maxLifespan, 0, 255);

    noStroke();

    // Glow effect: draw larger transparent circles first
    for (int i = 3; i > 0; i--) {
      fill(particleColor, alpha / (i * 2));
      ellipse(position.x, position.y, size * i, size * i);
    }

    // Core of particle
    fill(particleColor, alpha);
    ellipse(position.x, position.y, size * 0.5, size * 0.5);
  }

  // Check if particle should be removed
  boolean isDead() {
    return lifespan <= 0;
  }
}

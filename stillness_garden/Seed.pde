// Seed class - Manages the seed position and glowing effect

class Seed {
  PVector position;
  boolean alive;
  float glowSize;
  float maxGlowSize;
  float pulsePhase;  // For subtle pulsing animation
  color seedColor;

  // Constructor
  Seed(float x, float y) {
    position = new PVector(x, y);
    alive = true;
    maxGlowSize = 20;
    glowSize = 0;  // Start small and grow
    pulsePhase = 0;
    seedColor = color(255, 255, 255);  // White, glowing
  }

  // Update seed state
  void update() {
    if (!alive) return;

    // Grow glow size smoothly when first appearing
    if (glowSize < maxGlowSize) {
      glowSize += 0.5;
    }

    // Subtle pulsing animation
    pulsePhase += 0.05;
  }

  // Draw seed with glow effect
  void display() {
    if (!alive) return;

    float pulse = sin(pulsePhase) * 2;  // Subtle size variation
    float currentSize = glowSize + pulse;

    noStroke();

    // Outer glow layers (larger, more transparent)
    for (int i = 5; i > 0; i--) {
      float layerSize = currentSize * (1 + i * 0.5);
      float alpha = 30.0 / i;
      fill(seedColor, alpha);
      ellipse(position.x, position.y, layerSize, layerSize);
    }

    // Core glow
    fill(seedColor, 150);
    ellipse(position.x, position.y, currentSize, currentSize);

    // Bright center
    fill(seedColor, 255);
    ellipse(position.x, position.y, currentSize * 0.3, currentSize * 0.3);
  }

  // Kill the seed
  void die() {
    alive = false;
  }
}

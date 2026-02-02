// Seed class - Manages the seed position and glowing effect

class Seed {
  PVector position;
  boolean alive;
  float glowSize;
  float maxGlowSize;
  float pulsePhase;  // For subtle pulsing animation
  color seedColor;
  int germinationTime = 600;    // 10 seconds at 60fps
  int germinationTimer = 0;     // Timer for germination
  boolean sprouted = false;     // Whether seed has sprouted
  float sizeMultiplier = 0.8;   // Start at 80% size

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

    // Germination phase: wait before sprouting
    if (!sprouted) {
      germinationTimer++;

      // Grow size from 80% to 100%
      float progress = (float)germinationTimer / germinationTime;
      progress = constrain(progress, 0, 1);
      sizeMultiplier = lerp(0.8, 1.0, progress);

      if (germinationTimer >= germinationTime) {
        sprouted = true;
      }
    }

    // Grow glow size smoothly when first appearing
    if (glowSize < maxGlowSize) {
      glowSize += 0.5;
    }

    // Subtle pulsing animation
    pulsePhase += 0.05;
  }

  // Check if seed is ready to sprout branches
  boolean isReadyToSprout() {
    return sprouted;
  }

  // Draw seed with glow effect
  void display() {
    if (!alive) return;

    float pulse = sin(pulsePhase) * 2;  // Subtle size variation
    float currentSize = (glowSize + pulse) * sizeMultiplier;  // Apply size multiplier

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

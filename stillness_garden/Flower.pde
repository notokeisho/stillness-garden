// Flower class - Manages flower blooming and fading

class Flower {
  PVector position;
  int petalCount;
  float size;
  float maxSize;
  float bloomProgress;  // 0.0 to 1.0
  boolean dying;
  float rotation;
  color petalColor;
  float bloomSpeed;

  // Constructor
  Flower(float x, float y) {
    position = new PVector(x, y);
    petalCount = int(random(5, 7));  // 5 or 6 petals
    maxSize = random(15, 25);
    size = 0;
    bloomProgress = 0;
    dying = false;
    rotation = random(TWO_PI);
    bloomSpeed = 0.02;

    // Pale pink color
    petalColor = color(255, 180, 200);
  }

  // Progress the blooming animation
  void bloom() {
    if (bloomProgress < 1.0) {
      bloomProgress += bloomSpeed;
      if (bloomProgress > 1.0) {
        bloomProgress = 1.0;
      }
      // Ease-out animation for size
      size = maxSize * easeOutCubic(bloomProgress);
    }
  }

  // Ease-out cubic function for smooth animation
  float easeOutCubic(float t) {
    return 1 - pow(1 - t, 3);
  }

  // Draw flower with glow effect
  void display() {
    if (size < 1) return;

    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);

    noStroke();

    // Draw glow layers
    for (int layer = 3; layer > 0; layer--) {
      float glowSize = size * (1 + layer * 0.3);
      float alpha = 20.0 / layer;
      fill(petalColor, alpha);
      drawPetals(glowSize);
    }

    // Draw main petals
    fill(petalColor, 180);
    drawPetals(size);

    // Draw bright center
    fill(255, 255, 200, 200);
    ellipse(0, 0, size * 0.3, size * 0.3);

    popMatrix();
  }

  // Draw petal shapes
  void drawPetals(float petalSize) {
    float angleStep = TWO_PI / petalCount;

    for (int i = 0; i < petalCount; i++) {
      float angle = i * angleStep;
      pushMatrix();
      rotate(angle);

      // Draw petal as ellipse
      float petalLength = petalSize * 0.8;
      float petalWidth = petalSize * 0.5;
      ellipse(petalLength * 0.5, 0, petalLength, petalWidth);

      popMatrix();
    }
  }

  // Check if flower is fully bloomed
  boolean isFullyBloomed() {
    return bloomProgress >= 1.0;
  }
}

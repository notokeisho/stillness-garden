// Flower class - Manages flower blooming and fading

class Flower {
  PVector position;
  int petalCount;
  float size;
  float maxSize;
  float bloomProgress;  // 0.0 to 1.0
  boolean dying;
  float dyingProgress;  // 0.0 to 1.0
  float rotation;
  color petalColor;
  color centerColor;
  float bloomSpeed;
  float dyingSpeed;
  int flowerType;  // 0: pink, 1: white
  int pollenTimer;     // Pollen spawn timer (individual per flower)
  int pollenInterval;  // Pollen spawn interval (varies per flower)

  // Constructor
  Flower(float x, float y) {
    position = new PVector(x, y);
    petalCount = int(random(5, 7));  // 5 or 6 petals
    maxSize = random(15, 25);
    size = 0;
    bloomProgress = 0;
    dying = false;
    dyingProgress = 0;
    rotation = random(TWO_PI);
    bloomSpeed = 0.02;
    dyingSpeed = 0.015;  // Slightly slower than bloom for graceful fade

    // Randomly choose flower type
    flowerType = int(random(2));  // 0 or 1

    // Initialize pollen timer with random offset (stagger spawn times)
    pollenTimer = int(random(60));
    pollenInterval = int(random(40, 80));  // 40-80 frames between spawns

    if (flowerType == 0) {
      // Pale pink flower
      petalColor = color(255, 180, 200);
      centerColor = color(255, 255, 200);  // Yellow center
    } else {
      // White flower with slight blue tint
      petalColor = color(230, 240, 255);
      centerColor = color(255, 255, 220);  // Warm yellow center
    }
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
    if (dying && dyingProgress >= 1.0) return;  // Fully dead, don't draw

    pushMatrix();
    translate(position.x, position.y);
    rotate(rotation);

    noStroke();

    // Calculate fade factor for dying flowers (1.0 = alive, 0.0 = dead)
    float fadeFactor = dying ? (1.0 - dyingProgress) : 1.0;

    // Calculate color transition to gray when dying
    color currentPetalColor = petalColor;
    color currentCenterColor = centerColor;
    if (dying) {
      // Lerp towards gray as flower dies
      color grayColor = color(100, 100, 100);
      currentPetalColor = lerpColor(petalColor, grayColor, dyingProgress);
      currentCenterColor = lerpColor(centerColor, grayColor, dyingProgress);
    }

    // Draw glow layers
    for (int layer = 3; layer > 0; layer--) {
      float glowSize = size * (1 + layer * 0.3);
      float alpha = (20.0 / layer) * fadeFactor;
      fill(currentPetalColor, alpha);
      drawPetals(glowSize);
    }

    // Draw main petals
    fill(currentPetalColor, 180 * fadeFactor);
    drawPetals(size);

    // Draw bright center
    fill(currentCenterColor, 200 * fadeFactor);
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

  // Check if this flower should spawn pollen (individual timer)
  boolean shouldSpawnPollen() {
    if (!isFullyBloomed() || dying) return false;

    pollenTimer++;
    if (pollenTimer >= pollenInterval) {
      pollenTimer = 0;
      return true;
    }
    return false;
  }

  // Start the dying (withering) process
  void startDying() {
    dying = true;
    dyingProgress = 0;
  }

  // Update the dying process (fade to gray and disappear)
  void updateDying() {
    if (!dying) return;

    dyingProgress += dyingSpeed;
    if (dyingProgress > 1.0) {
      dyingProgress = 1.0;
    }
  }

  // Check if flower has fully withered
  boolean isDead() {
    return dying && dyingProgress >= 1.0;
  }
}

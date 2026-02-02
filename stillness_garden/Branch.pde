// Branch class - Manages branch growth and withering

class Branch {
  ArrayList<PVector> points;
  boolean growing;
  boolean dying;
  float ashProgress;
  float angle;
  float noiseOffset;
  float growthSpeed;
  color baseColor;
  int flowerInterval;       // Points between each flower
  int lastFlowerPointCount; // Point count when last flower was spawned
  int dyingTimer;           // Frames since dying started
  int colorTransitionTime = 60;  // 1 second at 60fps

  // Constructor
  Branch(float startX, float startY, float initialAngle) {
    points = new ArrayList<PVector>();
    points.add(new PVector(startX, startY));

    growing = true;
    dying = false;
    ashProgress = 0;

    angle = initialAngle;
    noiseOffset = random(1000);  // Unique noise offset for each branch
    growthSpeed = 2.0;  // 2.0 px per frame
    flowerInterval = 25;  // Flower blooms every 25 points
    lastFlowerPointCount = 0;

    // Green color (vivid green)
    baseColor = color(80, 200, 80);
  }

  // Grow the branch using Perlin noise for organic curves
  void grow() {
    if (!growing) return;

    // Get current tip position
    PVector tip = getTip();

    // Use Perlin noise to smoothly vary the angle (gentle curves)
    float noiseValue = noise(noiseOffset);
    angle += map(noiseValue, 0, 1, -0.08, 0.08);
    noiseOffset += 0.02;

    // Calculate new point position
    float newX = tip.x + cos(angle) * growthSpeed;
    float newY = tip.y + sin(angle) * growthSpeed;

    // Add new point to the branch
    points.add(new PVector(newX, newY));
  }

  // Draw branch with glow effect
  void display() {
    if (points.size() < 2) return;

    if (dying) {
      displayDying();
    } else {
      displayAlive();
    }
  }

  // Display alive branch (optimized: vertex instead of curveVertex, 1 glow layer, point decimation)
  void displayAlive() {
    // Draw single glow layer
    stroke(baseColor, 30);
    strokeWeight(3);
    noFill();

    beginShape();
    for (int i = 0; i < points.size(); i += 2) {
      PVector p = points.get(i);
      vertex(p.x, p.y);
    }
    // Ensure last point is drawn
    if (points.size() % 2 == 0 && points.size() > 0) {
      PVector last = points.get(points.size() - 1);
      vertex(last.x, last.y);
    }
    endShape();

    // Draw main branch line
    stroke(baseColor, 200);
    strokeWeight(1.5);
    noFill();

    beginShape();
    for (int i = 0; i < points.size(); i += 2) {
      PVector p = points.get(i);
      vertex(p.x, p.y);
    }
    // Ensure last point is drawn
    if (points.size() % 2 == 0 && points.size() > 0) {
      PVector last = points.get(points.size() - 1);
      vertex(last.x, last.y);
    }
    endShape();
  }

  // Display dying branch (ash spreading from root to tip with color gradient)
  void displayDying() {
    // Find the point index where ash has reached
    float traveled = 0;
    int ashIndex = 0;

    for (int i = 1; i < points.size(); i++) {
      PVector p1 = points.get(i - 1);
      PVector p2 = points.get(i);
      float segmentLength = dist(p1.x, p1.y, p2.x, p2.y);

      if (traveled + segmentLength >= ashProgress) {
        ashIndex = i;
        break;
      }
      traveled += segmentLength;
      ashIndex = i;
    }

    // Draw the remaining alive part (from ash position to tip) with time-based color
    if (ashIndex < points.size() - 1) {
      // Calculate color based on time (0 = green, 3 seconds = gray)
      float t = (float)dyingTimer / colorTransitionTime;
      t = constrain(t, 0, 1);
      color decayColor = color(100, 100, 100);  // Gray color for decay
      color currentColor = lerpColor(baseColor, decayColor, t);
      int lastIndex = points.size() - 1;

      // Single glow layer for decaying part
      stroke(currentColor, 30);
      strokeWeight(3);
      noFill();

      beginShape();
      for (int i = ashIndex; i < points.size(); i += 2) {
        PVector p = points.get(i);
        vertex(p.x, p.y);
      }
      // Ensure last point is drawn
      if ((lastIndex - ashIndex) % 2 != 0) {
        vertex(points.get(lastIndex).x, points.get(lastIndex).y);
      }
      endShape();

      // Main line for decaying part
      stroke(currentColor, 200);
      strokeWeight(1.5);
      noFill();

      beginShape();
      for (int i = ashIndex; i < points.size(); i += 2) {
        PVector p = points.get(i);
        vertex(p.x, p.y);
      }
      // Ensure last point is drawn
      if ((lastIndex - ashIndex) % 2 != 0) {
        vertex(points.get(lastIndex).x, points.get(lastIndex).y);
      }
      endShape();
    }

    // Draw small bright point at ash position (only while branch exists)
    if (!isFullyDead()) {
      PVector ashPos = getAshPosition();
      noStroke();
      // Small glow
      fill(180, 180, 180, 80);
      ellipse(ashPos.x, ashPos.y, 6, 6);
      // Bright center point
      fill(220, 220, 220, 200);
      ellipse(ashPos.x, ashPos.y, 3, 3);
    }
  }

  // Get the tip (last point) of the branch
  PVector getTip() {
    if (points.size() == 0) {
      return new PVector(0, 0);
    }
    return points.get(points.size() - 1);
  }

  // Check if branch is ready for a new flower to bloom
  boolean isReadyForFlower() {
    int currentPoints = points.size();
    // Check if we've grown enough since last flower
    return (currentPoints - lastFlowerPointCount) >= flowerInterval;
  }

  // Record that a flower was spawned at current position
  void flowerSpawned() {
    lastFlowerPointCount = points.size();
  }

  // Start the dying (withering) process
  void startDying() {
    growing = false;
    dying = true;
    ashProgress = 0;
    dyingTimer = 0;  // Reset color transition timer
  }

  // Update the dying process (ash spreads from root to tip)
  void updateDying() {
    if (!dying) return;

    // Ash progress speed: 1.5x growth speed
    float ashSpeed = growthSpeed * 1.5;
    ashProgress += ashSpeed;

    // Update color transition timer
    if (dyingTimer < colorTransitionTime) {
      dyingTimer++;
    }
  }

  // Check if branch has fully withered
  boolean isFullyDead() {
    if (!dying) return false;

    // Calculate total length of branch
    float totalLength = 0;
    for (int i = 1; i < points.size(); i++) {
      PVector p1 = points.get(i - 1);
      PVector p2 = points.get(i);
      totalLength += dist(p1.x, p1.y, p2.x, p2.y);
    }

    return ashProgress >= totalLength;
  }

  // Get the position where ash has reached (for spawning ash particles)
  PVector getAshPosition() {
    float traveled = 0;
    for (int i = 1; i < points.size(); i++) {
      PVector p1 = points.get(i - 1);
      PVector p2 = points.get(i);
      float segmentLength = dist(p1.x, p1.y, p2.x, p2.y);

      if (traveled + segmentLength >= ashProgress) {
        // Interpolate position within this segment
        float t = (ashProgress - traveled) / segmentLength;
        return new PVector(lerp(p1.x, p2.x, t), lerp(p1.y, p2.y, t));
      }
      traveled += segmentLength;
    }
    // Return last point if ash has passed the end
    return getTip();
  }
}

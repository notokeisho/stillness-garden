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
  int flowerThreshold;  // Points needed before flower can bloom

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
    flowerThreshold = 25;  // Flower blooms after 25 points

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

    // Draw glow layers (larger, more transparent)
    for (int layer = 3; layer > 0; layer--) {
      float weight = layer * 2;
      float alpha = 30.0 / layer;
      stroke(baseColor, alpha);
      strokeWeight(weight);
      noFill();

      beginShape();
      for (int i = 0; i < points.size(); i++) {
        PVector p = points.get(i);
        curveVertex(p.x, p.y);
        // Duplicate first and last points for curveVertex
        if (i == 0 || i == points.size() - 1) {
          curveVertex(p.x, p.y);
        }
      }
      endShape();
    }

    // Draw main branch line
    stroke(baseColor, 200);
    strokeWeight(1.5);
    noFill();

    beginShape();
    for (int i = 0; i < points.size(); i++) {
      PVector p = points.get(i);
      curveVertex(p.x, p.y);
      if (i == 0 || i == points.size() - 1) {
        curveVertex(p.x, p.y);
      }
    }
    endShape();
  }

  // Get the tip (last point) of the branch
  PVector getTip() {
    if (points.size() == 0) {
      return new PVector(0, 0);
    }
    return points.get(points.size() - 1);
  }

  // Check if branch is ready for a flower to bloom
  boolean isReadyForFlower() {
    return points.size() >= flowerThreshold;
  }
}

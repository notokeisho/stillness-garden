// Stillness Garden - Main file
// A meditative experience where stillness nurtures growth

// Global variables
Plant currentPlant;              // Currently growing plant (only one)
ArrayList<Plant> dyingPlants;    // List of dying plants
PVector lastMousePos;            // Previous frame mouse position
int stillFrames;                 // Frames mouse has been still
int stillThreshold = 30;         // Threshold for stillness detection (0.5 seconds)
float moveThreshold = 2.0;       // Distance threshold for movement detection (pixels)

void setup() {
  size(800, 800, P2D);
  frameRate(60);
  currentPlant = null;
  dyingPlants = new ArrayList<Plant>();
  lastMousePos = new PVector(mouseX, mouseY);
  stillFrames = 0;
}

void draw() {
  background(0);

  // Enable additive blending for glow effect
  blendMode(ADD);

  // Update mouse state and control plants
  updateMouseState();

  // Update and display current plant
  if (currentPlant != null) {
    currentPlant.update();
    currentPlant.display();
  }

  // Update, display, and remove dying plants
  for (int i = dyingPlants.size() - 1; i >= 0; i--) {
    Plant p = dyingPlants.get(i);
    p.update();
    p.display();
    if (p.isFullyDead()) {
      dyingPlants.remove(i);
    }
  }

  // Reset blend mode
  blendMode(BLEND);
}

// Update mouse state and control plant lifecycle
void updateMouseState() {
  float mouseDist = dist(mouseX, mouseY, lastMousePos.x, lastMousePos.y);

  if (mouseDist < moveThreshold) {
    // Mouse is still
    stillFrames++;
    if (stillFrames >= stillThreshold && currentPlant == null) {
      // Spawn new plant at mouse position
      currentPlant = new Plant(mouseX, mouseY);
    }
  } else {
    // Mouse is moving
    stillFrames = 0;
    if (currentPlant != null) {
      // Move current plant to dying list
      currentPlant.startDying();
      dyingPlants.add(currentPlant);
      currentPlant = null;
    }
  }

  lastMousePos.set(mouseX, mouseY);
}

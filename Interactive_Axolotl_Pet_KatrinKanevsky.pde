// Here is my interactive axolotl pet :) -Katrin Kanevsky

float axolotlWidth = 120;
float axolotlHeight = 150;
boolean isHovering = false;
boolean isJumping = false;
boolean isDragging = false;
boolean goingUp = true;
float jumpHeight = 0;
float earOffset = 0;
float earBounceSpeed = 0.2;

// Movement and tracking
PVector pos, target;
boolean followMouseTrigger = false;
int moveTimer = 0;

// Mouse shake detection
int shakeCount = 0;
float lastMouseX = 0;
boolean movingRight = true;
int shakeTimeout = 0;

void setup() {
  size(600, 400);
  pos = new PVector(width / 2, height / 2 + 50);
  target = new PVector(random(width), random(height - 100, height - 60));
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(180, 220, 255);
  drawBackgroundDecorations();
  handleMouseShake();
  handleStates();
  moveAxolotl();
  drawAxolotl();
}

void handleStates() {
  isHovering = dist(mouseX, mouseY, pos.x, pos.y) < 80;

  if (isJumping) {
    if (goingUp) {
      jumpHeight += 4;
      if (jumpHeight >= 40) goingUp = false;
    } else {
      jumpHeight -= 4;
      if (jumpHeight <= 0) {
        isJumping = false;
        goingUp = true;
        jumpHeight = 0;
      }
    }
  }

  earOffset = sin(frameCount * earBounceSpeed) * 4;
}

void moveAxolotl() {
  pos.x = lerp(pos.x, target.x, 0.01);
  pos.y = lerp(pos.y, target.y, 0.01);

  if (followMouseTrigger) {
    moveTimer++;
    if (moveTimer > 120) {
      followMouseTrigger = false;
      moveTimer = 0;
    }
  }

  if (!followMouseTrigger && frameCount % 150 == 0) {
    target = new PVector(random(80, width - 80), random(150, height - 60));
  }
}

void handleMouseShake() {
  float dx = mouseX - lastMouseX;

  if (abs(dx) > 5) {
    boolean currentDirection = dx > 0;
    if (currentDirection != movingRight) {
      shakeCount++;
      movingRight = currentDirection;
      shakeTimeout = frameCount;
    }
  }

  if (frameCount - shakeTimeout > 20) {
    shakeCount = 0;
  }

  if (shakeCount >= 4) {
    target = new PVector(mouseX, mouseY);
    followMouseTrigger = true;
    shakeCount = 0;
  }

  lastMouseX = mouseX;
}

void drawAxolotl() {
  pushMatrix();
  translate(pos.x, pos.y - jumpHeight);

  // Body
  noStroke();
  if (isJumping) {
    fill(255, 170, 200);
    ellipse(0, 0, axolotlWidth + 20, axolotlHeight - 20);
  } else {
    fill(255, 180, 180);
    ellipse(0, 0, axolotlWidth, axolotlHeight);
  }

  // Gills (frilly ears)
  fill(200, 100, 150);
  ellipse(-axolotlWidth / 2 + 10, -axolotlHeight / 2 - 10 + earOffset, 30, 30);
  ellipse(axolotlWidth / 2 - 10, -axolotlHeight / 2 - 10 - earOffset, 30, 30);

  drawFace();
  popMatrix();
}

void drawFace() {
  fill(0);
  float eyeY = -20;

  if (isJumping) {
    ellipse(-25, eyeY, 12, 12);
    ellipse(25, eyeY, 12, 12);
    noFill();
    stroke(0);
    strokeWeight(3);
    arc(0, 10, 40, 20, 0, PI);
  } else if (isDragging) {
    stroke(0);
    strokeWeight(4);
    line(-30, eyeY - 5, -20, eyeY + 5);
    line(30, eyeY - 5, 20, eyeY + 5);
    fill(0);
    ellipse(-25, eyeY + 10, 12, 12);
    ellipse(25, eyeY + 10, 12, 12);
    noFill();
    strokeWeight(3);
    arc(0, 20, 40, 10, PI, TWO_PI);
  } else if (isHovering) {
    fill(0);
    ellipse(-25, eyeY, 10, 10);
    ellipse(25, eyeY, 10, 10);
    noFill();
    stroke(0);
    strokeWeight(2);
    ellipse(0, 15, 20, 20);
  } else {
    fill(0);
    ellipse(-25, eyeY, 10, 10);
    ellipse(25, eyeY, 10, 10);
    stroke(0);
    strokeWeight(2);
    line(-10, 20, 10, 20);
  }
}

void drawBackgroundDecorations() {
  // Sand
  fill(240, 220, 180);
  rect(0, height - 50, width, 50);

  // Rocks
  fill(120, 120, 130);
  ellipse(100, height - 30, 50, 30);
  ellipse(180, height - 35, 40, 25);
  ellipse(400, height - 28, 60, 35);
  ellipse(520, height - 38, 35, 22);

  // Pebbles
  fill(100);
  for (int i = 0; i < 10; i++) {
    float x = random(width);
    float y = random(height - 20, height - 5);
    ellipse(x, y, 6, 4);
  }

  // Plants
  for (int i = 0; i < width; i += 60) {
    drawSeaweed(i + 10, height - 50, 3);
  }
}

void drawSeaweed(float baseX, float baseY, int blades) {
  stroke(30, 160, 90);
  strokeWeight(3);
  noFill();
  for (int i = 0; i < blades; i++) {
    float offset = i * 5;
    beginShape();
    for (int y = 0; y < 40; y++) {
      float x = sin(radians(y * 10 + frameCount)) * 5;
      curveVertex(baseX + x + offset, baseY - y * 2);
    }
    endShape();
  }
}

// Interaction
void mousePressed() {
  if (isHovering) {
    isJumping = true;
  }
}

void mouseDragged() {
  isDragging = true;
}

void mouseReleased() {
  isDragging = false;
}

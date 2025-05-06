import controlP5.*; //<>//

double G = 6.67430e-11;
double m1 = 2e30;
double m2 = 0.7e30;
double M = m1+m2;
double rdist = 2e10;
double scale = 2e-8;
int t = 0;
int dt = 10000;

ControlP5 cp5;
Slider massSlider1, massSlider2, timestepSlider;
boolean reset = false;

// Initial distance
double r1;
double r2;

// Create stars
Star star1;
Star star2;

// Determine center of mass
PVectorD com;

void setup(){
  size(850, 850);
  
  cp5 = new ControlP5(this);
  
  // Create mass sliders
  massSlider1 = cp5.addSlider("Mass 1")
                   .setPosition(20, height - (height/30)*2 - 30)
                   .setSize(width/3, height/30)
                   .setRange(1, 300)
                   .setValue(200);
  
  massSlider2 = cp5.addSlider("Mass 2")
                   .setPosition(20, height - (height/30) - 20)
                   .setSize(width/3, height/30)
                   .setRange(1, 300)
                   .setValue(70);
                   
  timestepSlider = cp5.addSlider("Timestep")
                   .setPosition(20, height - (height/30)*3 - 40)
                   .setSize(width/3, height/30)
                   .setRange(1, 5)
                   .setValue(4)
                   .setNumberOfTickMarks(5)
                   .snapToTickMarks(true)
                   .showTickMarks(false);
                   
  initialize();
}

void initialize() {
  // Initial distance
  //M = m1 + m2; //Uncomment for circular orbits
  r1 = m2*rdist/(M);
  r2 = rdist*(1-m2/M);

  // Create stars
  star1 = new Star(m1, new PVectorD(-r1, 0), new PVectorD(0, 0), color(255, 0, 0));
  star2 = new Star(m2, new PVectorD(r2, 0), new PVectorD(0, 0), color(0, 0, 255));

  // Set initial velocity
  double v1init = Math.sqrt(G*Math.pow(star2.mass, 2)/(rdist*M));
  star1.p.y = star1.mass*v1init;
  star2.p.y = -star1.p.y;
  
  // Center stars
  star1.pos.add((width/2) / scale, (height/2) / scale);
  star2.pos.add((width/2) / scale, (height/2) / scale);
  
  // Update center of mass
  com = addV(multV(star1.pos, star1.mass), multV(star2.pos, star2.mass)).div(star1.mass + star2.mass);
}

void draw(){
  double newMass1 = massSlider1.getValue() * 1e28;
  double newMass2 = massSlider2.getValue() * 1e28;
  int newDt = (int)Math.pow(10, timestepSlider.getValue());

  if (newMass1 != star1.mass || newMass2 != star2.mass || newDt != dt || reset) {
    m1 = newMass1;
    m2 = newMass2;
    dt = newDt;
    initialize();
    reset = false;
  }
  
  // Clear
  background(0);
  
  // Calculate relative position vector and force
  PVectorD r = subV(star2.pos, star1.pos);
  PVectorD f2 = divV(multV(r.copy().normalize(), -G * star1.mass * star2.mass), Math.pow(r.mag(), 2)); 

  // Update velocities and positions
  star1.update(multV(multV(f2, dt), -1));
  star2.update(multV(f2, dt));
  
  // Draw center of mass
  stroke(0);
  fill(100);
  circle((float)(com.x*scale), (float)(com.y*scale), 10);
  
  // Draw stars
  star1.display();
  star2.display();
  
  // Increment time
  t += 1;
}

PVectorD addV(PVectorD v1, PVectorD v2) {
  return new PVectorD(v1.x + v2.x, v1.y + v2.y);
}

PVectorD subV(PVectorD v1, PVectorD v2) {
  return new PVectorD(v1.x - v2.x, v1.y - v2.y);
}

PVectorD multV(PVectorD v, double n) {
  return new PVectorD(v.x * n, v.y * n);
}

PVectorD divV(PVectorD v, double n) {
  return new PVectorD(v.x / n, v.y / n);
}

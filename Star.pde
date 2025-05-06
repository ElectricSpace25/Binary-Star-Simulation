class Star{
  PVectorD pos;
  PVectorD p;
  double mass;
  float radius;
  color c;
  ArrayList<PVectorD> trail = new ArrayList<PVectorD>();
  
  Star(double mass, PVectorD pos, PVectorD p, color c){
    this.mass = mass;
    this.pos = pos;
    this.p = p;
    this.c = c;
    
    radius = (float)(mass * 2.5e-29); //This uses arbitrary scaling to get a radius from the mass
  }
  
  void update(PVectorD v){
    // Update velocity and position
    p.add(v);
    pos.add(multV(p, dt).div(mass));
    
    // Add trail point
    trail.add(pos.copy().mult(scale));
    
    // Clean trail list
    if (trail.size() > 500) {
      trail.remove(0);
    }
  }
  
  void display(){
    // Draw star
    stroke(0);
    fill(c);
    circle((float)(pos.x * scale), (float)(pos.y * scale), radius);
    
    // Draw trail
    stroke(c);
    noFill();
    beginShape();
    for (PVectorD pos : trail) {
      vertex((float) pos.x, (float) pos.y);
    }
    endShape();
  }
}

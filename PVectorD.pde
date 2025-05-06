public class PVectorD{
  public double x;
  public double y;
  
  public PVectorD(double x, double y){
    this.x = x;
    this.y = y;
  }
  
  public double mag() {
    return Math.sqrt(x*x + y*y);
  }
  
  public PVectorD add(PVectorD v) {
    x += v.x;
    y += v.y;
    return this;
  }
  
  public PVectorD add(double x, double y) {
    this.x += x;
    this.y += y;
    return this;
  }
  
  public PVectorD sub(PVectorD v) {
    x -= v.x;
    y -= v.y;
    return this;
  }
  
  public PVectorD sub(double x, double y) {
    this.x -= x;
    this.y -= y;
    return this;
  }
  
  public PVectorD mult(double n) {
    x *= n;
    y *= n;
    return this;
  }
  
  public PVectorD div(double n) {
    x /= n;
    y /= n;
    return this;
  }
  
  public PVectorD normalize() {
    double m = mag();
    if (m != 0 && m != 1) {
      div(m);
    }
    return this; 
  }
  
  public PVectorD copy() {
    return new PVectorD(x, y);
  }
  
  public String toString() {
   return "[" + x + ", " + y + "]";
  }
  
}

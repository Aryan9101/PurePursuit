public class Line {
  private Point p1, p2;
  private double angle;
  private double sin, cos;
  private float slope;
  private float yIntercept;

  public Line(Point p1, Point p2){
    this.p1 = p1;
    this.p2 = p2;
    this.slope = (p2.getY() - p1.getY())/(p2.getX() - p1.getX());
    this.yIntercept = p1.getY() - this.slope*p1.getX();
    this.angle = atan((float)slope);
    this.sin = abs((p2.getY() - p1.getY()));
    this.cos = abs((p2.getX() - p1.getX()));
  }

  public double getAngle() {return angle; }

  public double getAngleDeg() {return 180/PI*angle; }
  
  public float getSlope(){ return this.slope; }
  
  public float getYIntercept() { return this.yIntercept; }

  public void changeRobotCoords(double x, double y){
    double xTranslated = x - p1.getX();
    double yTranslated = y - p2.getY();
    x = (xTranslated * cos) + (yTranslated * sin);
    y = -(xTranslated * sin) + (yTranslated * cos);
  }

  public void drawPath(){
    line(p1.getX(), p1.getY(), p2.getX(), p2.getY());
  }

}

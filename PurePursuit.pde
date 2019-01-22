float h, k;
float velocity = 0.50;
final float lookAhead = 100;
final float tolerance = 8.7;
PVector robot;

Point targetPoint;
Line targetLine;
int targetIndex;
ArrayList<Point> targets;
ArrayList<Line> paths;
//PrintWriter logger;

void setup(){
  size(800, 800);
  
  //logger = createWriter("angle1.csv");
  
  robot = new PVector(00, 00);
  
  targets = new ArrayList<Point>();
  targets.add(new Point(0, 80));
  targets.add(new Point(60, 180));
  targets.add(new Point(0, 60));
  targets.add(new Point(200, 240));
  targets.add(new Point(240, 540));
  targets.add(new Point(400, 480));
  targets.add(new Point(600, 280));
  targets.add(new Point(700, 500));
  //targets.add(new Point(0, 80));
  //targets.add(new Point(200, 300));
  //targets.add(new Point(600, 300));
  //targets.add(new Point(800, 0));
  
  paths = new ArrayList<Line>();
  paths.add(null); //placeholder. targetIndex needs to start at 1. Lets start using javascript
  
  for(int i = 0; i < targets.size()-1; i++){
    paths.add(new Line(targets.get(i), targets.get(i+1)));
  }
  
  targetIndex = 1;
  targetPoint = targets.get(targetIndex);
  targetLine = paths.get(targetIndex);
  
  h = robot.x;
  k = robot.y;
}

void draw() {
  //Flip the y-axis to get the traditional and more useful cartesian coordinate plane
  scale(1, -1);
  translate(0, -height);
  
  //Initial Setup of the graphics. Mark all the targets on the field
  background(255);
  fill(255, 0);
  for(Point x : targets){
    ellipse(x.getX(), x.getY(), 10, 10);
  }
  
  //draw current path
  targetLine.drawPath();
  
  //show the robot's lookahead range
  ellipse(h, k, 2 * lookAhead, 2 * lookAhead);

  //Equation for the path
  // y = a * x + b
  float a = targetLine.getSlope();
  float b = targetLine.getYIntercept();
  // (x - h)^2 + (y - k)^2 = radius ^2
  // y = a * x + b
  //Quadratic Formula; Finds the points of intersection of the line of vision (circle) with the line connecting two adjacent targets
  float A = (1 + a * a);
  float B = (2 * a * ( b - k) - 2 * h);
  float C = (h * h) + ((b - k) * (b - k)) - (lookAhead * lookAhead);
  float delta = B * B - 4 * A * C;
  float x1 = 0;
  float y1 = 0;
  if (delta >= 0) {
    //Assumption: Robot is only moving forward, so only display the larger solution
    x1 = (-B + sqrt(delta)) / (2 * A);
    y1 = a * x1 + b;
  }
   
  //Find the vector tht points towards the target 
  PVector temp = PVector.sub(new PVector(x1, y1), robot);
  float angle = atan(temp.y/temp.x);
  robot = robot.add(new PVector(velocity*cos(angle), velocity*sin(angle)));
  println(angle*180/PI);
  
  h = robot.x;
  k = robot.y;

  float distance = dist(robot.x, robot.y, targetPoint.getX(), targetPoint.getY());
  //println(distance);
  ellipse(h, k, 10, 10);
  line(h, k, x1, y1);
  //line(robot.x, robot.y, robot.x + lookAhead * cos(PI/4), robot.y + lookAhead * sin(PI/4));
  //line(robot.x, robot.y, robot.x + lookAhead * cos(3*PI/4), robot.y + lookAhead * sin(3*PI/4));
  //line(robot.x, robot.y, robot.x - lookAhead * cos(PI/4), robot.y - lookAhead * sin(PI/4));
  //line(robot.x, robot.y, robot.x - lookAhead * cos(3*PI/4), robot.y - lookAhead * sin(3*PI/4));
  //line(robot.x, robot.y, robot.x + lookAhead, robot.y);
  //line(robot.x, robot.y, robot.x, robot.y + lookAhead);
  //line(robot.x, robot.y, robot.x - lookAhead, robot.y);
  //line(robot.x, robot.y, robot.x, robot.y - lookAhead);
  ellipse(x1, y1, 15, 15);

  if((distance <= lookAhead) && (targetIndex != targets.size())){
    if (targetIndex + 1 == targets.size()){
      velocity = (distance)/lookAhead;
      if (distance <= tolerance){
        noLoop();
      }  
    }
    else {
      targetIndex++;
      targetPoint = targets.get(targetIndex);
      targetLine = paths.get(targetIndex);
    }
  }

}

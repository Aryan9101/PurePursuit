float velocity = 0.50;
final float lookAhead = 100;
final float tolerance = 8.7;
PVector robot;

Point targetPoint;
Line targetLine;
int targetIndex;
ArrayList<Point> targets;
ArrayList<Line> paths;
ArrayList<Point> traversed;
PrintWriter logger = createWriter("angle1.csv");

int test_path = 2;
PVector start = new PVector(0, 0);

void setup(){
  size(800, 800);
    
  robot = start;
  
  targets = new ArrayList<Point>();
  
  if (test_path == 1) {
    targets.add(new Point(0, 80));
    targets.add(new Point(200, 240));
    targets.add(new Point(240, 540));
    targets.add(new Point(400, 480));
    targets.add(new Point(600, 280));
    targets.add(new Point(700, 500));
  } else {
    targets.add(new Point(0, 80));
    targets.add(new Point(200, 300));
    targets.add(new Point(600, 300));
    targets.add(new Point(800, 0));
  }
  
  paths = new ArrayList<Line>();
  paths.add(null); // Placeholder
  
  for(int i = 0; i < targets.size()-1; i++){
    paths.add(new Line(targets.get(i), targets.get(i+1)));
  }
  
  targetIndex = 1;
  targetPoint = targets.get(targetIndex);
  targetLine = paths.get(targetIndex);
  
  traversed = new ArrayList<Point>();
}

void draw() {
  scale(1, -1);
  translate(0, -height);
  
  background(255);
  fill(255, 0);
  for(Point target : targets){
    ellipse(target.getX(), target.getY(), 10, 10);
  }
  
  targetLine.drawPath();
  ellipse(robot.x, robot.y, 2 * lookAhead, 2 * lookAhead);

  // Equation of a path segment: y = a * x + b
  float a = targetLine.getSlope();
  float b = targetLine.getYIntercept();
  // Equation of the robot's lookAhead range: (x - robot.x)^2 + (y - robot.y)^2 = lookAhead^2
  // Quadratic Formula: Find the intersection of the robot's line of vision (circle) with a path segment
  float A = (1 + a * a);
  float B = (2 * a * ( b - robot.y) - 2 * robot.x);
  float C = (robot.x * robot.x) + ((b - robot.y) * (b - robot.y)) - (lookAhead * lookAhead);
  float delta = B * B - 4 * A * C;
  
  float x1 = 0;
  float y1 = 0;
  if (delta >= 0) {
    //Assumption: Robot is only moving forward, so display the larger solution
    x1 = (-B + sqrt(delta)) / (2 * A);
    y1 = a * x1 + b;
  }
   
  PVector direction = PVector.sub(new PVector(x1, y1), robot);
  direction.normalize();
  robot = robot.add(direction);
  traversed.add(new Point(robot.x, robot.y));
  println(degrees(atan2(direction.y, direction.x)));
  
  for(Point point : traversed){
    ellipse(point.x, point.y, 1, 1);
  }
  
  float distance = dist(robot.x, robot.y, targetPoint.getX(), targetPoint.getY());
  ellipse(robot.x, robot.y, 10, 10);
  line(robot.x, robot.y, x1, y1);
  
  
  //line(robot.x, robot.y, robot.x + lookAhead * cos(PI/4)  , robot.y + lookAhead * sin(PI/4));
  //line(robot.x, robot.y, robot.x + lookAhead * cos(3*PI/4), robot.y + lookAhead * sin(3*PI/4));
  //line(robot.x, robot.y, robot.x - lookAhead * cos(PI/4)  , robot.y - lookAhead * sin(PI/4));
  //line(robot.x, robot.y, robot.x - lookAhead * cos(3*PI/4), robot.y - lookAhead * sin(3*PI/4));
  //line(robot.x, robot.y, robot.x + lookAhead              , robot.y);
  //line(robot.x, robot.y, robot.x                          , robot.y + lookAhead);
  //line(robot.x, robot.y, robot.x - lookAhead              , robot.y);
  //line(robot.x, robot.y, robot.x                          , robot.y - lookAhead);
  
  ellipse(x1, y1, 15, 15);

  if ((distance <= lookAhead) && (targetIndex != targets.size())) {
    if (targetIndex + 1 == targets.size()){
      velocity = (distance)/lookAhead;
      if (distance <= tolerance) {
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

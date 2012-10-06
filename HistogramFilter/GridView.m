#import "GridView.h"
#import "Color.h"
#import "Robot.h"

#import <QuartzCore/QuartzCore.h>

@implementation GridView

- (id)initWithFrame:(CGRect)frame
{
   return [self initWithFrame:frame andCellSize:CGSizeMake(20, 20) andNumberOfColors:4];
}

- (id) initWithFrame:(CGRect)frame andCellSize:(CGSize)aSize andNumberOfColors:(int)n
{
   self = [super initWithFrame:frame];
   if (self) {
      cellSize = aSize;
      
      numOfRows = self.frame.size.height / aSize.height;
      numOfCols = self.frame.size.width  / aSize.width;
      
      overlayView = [[UIView alloc] initWithFrame:self.frame];
      [overlayView setBackgroundColor:[UIColor clearColor]];

      float cellHalfWidth = cellSize.width / 2.0f;
      float cellHalfHeight= cellSize.height/ 2.0f;
      
      // Setup the cells
      cells = malloc(numOfRows * sizeof(struct Color *));
      int y = 0;
      for (int row = 0; row < numOfRows; row++) {
         cells[row] = malloc(numOfCols * sizeof(struct Color));
         int x = 0;
         for (int col = 0; col < numOfCols; col++) {
            
            // Get a random color from the first "n" colors.
            struct Color c = [self randomColorWithMax:n];
            
            // Create a cell view
            UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(x, y, aSize.width, aSize.height)];
            [cell setBackgroundColor:[UIColor colorWithRed:c.red/255.0f green:c.green/255.0f blue:c.blue/255.0f alpha:255.0/255.0f]];
            [self addSubview:cell];
            [cell release];
            
            // Save this color
            cells[row][col] = c;
            
            // Set a belief circle with a zero size
            UIView *circle = [[UIView alloc] initWithFrame:CGRectZero];
            circle.center  = CGPointMake(x + cellHalfWidth, y + cellHalfHeight);
            [overlayView addSubview:circle];
            [circle release];
            
            x += aSize.width;
         }
         y += aSize.height;
      }
            
      [self addSubview:overlayView];
      
      robot = nil;
      robotView = nil;
   }
   return self;
}

- (void) dealloc
{
   for (int row = 0; row < numOfRows; row++) {
      free(cells[row]);
   }
   free(cells);
   
   [robot release];
   [robotView release];
   [overlayView release];
   [super dealloc];
}

- (void)addRobot:(Robot *)obj
{
   if (robot) {
      [robot release];
   }
   robot = [obj retain];
   
   int xPos = arc4random() % numOfCols;
   int yPos = arc4random() % numOfRows;
   robotLocation = CGPointMake(xPos, yPos);
   
   [self updateRobotView];
   
   [self updateRobotBeliefView];
}

- (void)letRobotSense
{
   int i = robotLocation.y;
   int j = robotLocation.x;
   
   [robot senseLocation:cells[i][j] inWorld:cells];
   
   [self updateRobotBeliefView];
}

- (void)letRobotMoveVertically:(int)v andHorizontally:(int)h
{
   [robot moveVerticalDistance:v andHorizontalDistance:h];
   int x = robotLocation.x;
   int y = robotLocation.y;
   
   int newXPos = (x + h);
   int newYPos = (y + v);
   
   if (newXPos < 0)
      newXPos = numOfCols + newXPos;
   else if (newXPos >= numOfCols)
      newXPos = newXPos % numOfCols;
   
   if (newYPos < 0)
      newYPos = numOfRows + newYPos;
   else if (newYPos >= numOfRows)
      newYPos = newYPos % numOfRows;
   
   robotLocation = CGPointMake(newXPos, newYPos);
   
   [self updateRobotView];
   [self updateRobotBeliefView];
}

- (void)updateRobotBeliefView
{
   // Modify the diameters of the circles based on the robot's current belief
   float **belief = [robot getBelief];
   
   float maxDiameter = MIN(cellSize.width, cellSize.height);
   NSArray *circles = [overlayView subviews];
   
   float biggestBelief = 0.0f;
   int indexForMaxBelief = -1;
   
   for (int i = 0; i < numOfRows; i++) {
      for (int j = 0; j < numOfCols; j++) {
         
         int cIndex = (i * numOfCols + j);
         
         UIView *c = [circles objectAtIndex:cIndex];
         [c setBackgroundColor:BeliefColor];
         CGPoint cCenter = c.center;
         float newDiameter = maxDiameter * belief[i][j];
         [c setFrame:CGRectMake(0, 0, newDiameter, newDiameter)];
         c.layer.cornerRadius = newDiameter / 2.0;
         c.center = cCenter;
         
         if (belief[i][j] > biggestBelief) {
            biggestBelief = belief[i][j];
            indexForMaxBelief = cIndex;
         }         
      }
   }
   
   if (indexForMaxBelief != -1) {
      [[circles objectAtIndex:indexForMaxBelief] setBackgroundColor:MaxBeliefColor];
   }
}

- (void)updateRobotView
{
   // Convert the robot's position from the cell coordinates to the screen coordinates
   CGPoint newCenter = CGPointMake(robotLocation.x * cellSize.width + (cellSize.width / 2.0f), robotLocation.y * cellSize.height + (cellSize.height / 2.0f));
   
   if (!robotView) {
      robotView = [[UIImageView alloc] initWithImage:[robot image]];
      robotView.center = newCenter;
      [self addSubview:robotView];
      [self updateRobotBeliefView];
   }
   else {
      [UIView animateWithDuration:0.3
                            delay:0.0
                          options:UIViewAnimationCurveEaseInOut
                       animations:^{
                          robotView.center = newCenter;
                       }
                       completion:^(BOOL finished){
                       }
       ];
   }
}

- (struct Color) randomColorWithMax:(int)n
{
   ColorName cName = arc4random_uniform(n);
   short r, g, b;
   
   switch (cName)
   {
      case Green:
         r = 46;  g = 139; b = 87;  break;
      case Brown:
         r = 210; g = 180; b = 140; break;
      case Orange:
         r = 255; g = 140; b = 0;   break;
      case Black:
         r = 0;   g = 0;   b = 0;   break;
      case Gray:
         r = 85;  g = 85;  b = 85;  break;
      case Blue:
         r = 70;  g = 130; b = 180; break;
   }
   
   struct Color c = {.name=cName, .red=r, .green=g, .blue=b};
   return c;
}

@end

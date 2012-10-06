@class Color;
@class Robot;

@interface GridView : UIView {
   struct Color **cells;
   CGSize cellSize;
   int numOfRows;
   int numOfCols;
   
   UIView *overlayView; // Contains the belief circles
   
   Robot *robot;
   CGPoint robotLocation; // Maintains the position of the object in terms of cells, not the view's frame
   UIImageView *robotView;
}

- (id) initWithFrame:(CGRect)frame andCellSize:(CGSize)aSize andNumberOfColors:(int)n;

- (void)addRobot:(Robot *)obj;

- (void)letRobotSense;
- (void)letRobotMoveVertically:(int)v andHorizontally:(int)h;

@end
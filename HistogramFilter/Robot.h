#import "Color.h"

@interface Robot : NSObject {
   int world_y_max;
   int world_x_max;
   float **belief;
   float **beliefsCopy; // we need it when the robot moves because the world is circular.
   float p_move;
   float p_not_move;
   float sensor_right;
   float sensor_not_right;
}

- (id)initWithWorldSize:(CGSize)aSize andMovingProbability:(float)pMove andSensorAccuracy:(float)sensorRight;

- (float **)getBelief;
- (void)senseLocation:(struct Color)sensedLocation inWorld:(struct Color **)world;
- (void)moveVerticalDistance:(int)vd andHorizontalDistance:(int)hd;

- (UIImage *)image;

@end

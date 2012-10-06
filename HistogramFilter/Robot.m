#import "Robot.h"

@implementation Robot

- (id)initWithWorldSize:(CGSize)aSize andMovingProbability:(float)pMove andSensorAccuracy:(float)sensorRight
{
   self = [super init];
   if (self) {
      world_y_max = aSize.height;
      world_x_max = aSize.width;
      
      p_move     = pMove;
      p_not_move = 1.0f - pMove;
      
      sensor_right     = sensorRight;
      sensor_not_right = 1.0f - sensorRight;
      
      // initialize the probabilities with a uniform distribution
      float totalGridCells = world_y_max * world_x_max;
      float value = 1.0f / totalGridCells;
      
      belief = malloc(world_y_max * sizeof(float *));
      beliefsCopy = malloc(world_y_max * sizeof(float *));
      
      for (int i = 0; i < world_y_max; i++) {
         belief[i] = malloc(world_x_max * sizeof(float));
         beliefsCopy[i] = malloc(world_x_max * sizeof(float));
      
         for (int j = 0; j < world_x_max; j++) {
            belief[i][j] = value;
            beliefsCopy[i][j] = value;
         }
      }
   }
   return self;
}

- (void)dealloc
{
   for (int i = 0; i < world_y_max; i++) {
      free(belief[i]);
      free(beliefsCopy[i]);
   }
   free(belief);
   free(beliefsCopy);
   
   [super dealloc];
}

- (float **)getBelief
{
   return belief;
}

- (void)senseLocation:(struct Color)sensedLocation inWorld:(struct Color **)world
{
   float sum = 0.0;
   int hit;
   for (int i = 0; i < world_y_max; i++)
   {
      for (int j = 0; j < world_x_max; j++)
      {
         hit = sensedLocation.name == world[i][j].name;
         belief[i][j] = belief[i][j] * (hit * sensor_right + (1.0f - hit) * sensor_not_right);
         sum += belief[i][j];
      }
   }
   
   // Normalize
   for (int i = 0; i < world_y_max; i++)
   {
      for (int j = 0; j < world_x_max; j++)
      {
         belief[i][j] = belief[i][j] / sum;
         beliefsCopy[i][j] = belief[i][j];
      }
   }
}

- (void)moveVerticalDistance:(int)vd andHorizontalDistance:(int)hd
{
   if (vd < 0 || hd < 0) {
      // Start from top-left
      for (int i = 0; i < world_y_max; i++)
      {
         int toI = i - vd;
         if (toI >= world_y_max)
            toI = 0;
         
         for (int j = 0; j < world_x_max; j++)
         {
            int toJ = j - hd;
            if (toJ >= world_x_max)
               toJ = 0;

            // When we reach a cell at either the bottom or right edge, toI or toJ will point to the new belief that has been set when i=0 or j=0, and so we need to use the copy to multiply by the old probability
            belief[i][j] = beliefsCopy[toI][toJ] * p_move + belief[i][j] * p_not_move;
         }
      }   
   }
   else {
      // Start from bottom-right
      for (int i = world_y_max - 1; i >= 0; i--)
      {
         int toI = i - vd;
         if (toI < 0)
            toI = world_y_max - 1;
         
         for (int j = world_x_max - 1; j >= 0; j--)
         {
            int toJ = j - hd;
            if (toJ < 0)
               toJ = world_x_max - 1;

            belief[i][j] = beliefsCopy[toI][toJ] * p_move + belief[i][j] * p_not_move;
         }
      }
   }
   
   for (int i = 0; i < world_y_max; i++)
   {
      for (int j = 0; j < world_x_max; j++)
      {
         beliefsCopy[i][j] = belief[i][j];
      }
   }
   
}

- (UIImage *) image
{
   return [UIImage imageNamed:@"robot.png"];
}

@end

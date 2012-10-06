#import "ViewController.h"
#import "GridView.h"
#import "Color.h"
#import "Robot.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
   self.settingsView.hidden = YES;
   
   // Default values.
   numOfColors = 3;
   motion_rate = 0.8f;
   sensor_accuracy_rate = 0.7f;
   
   self.numColorsSlider.minimumValue = 1;
   self.numColorsSlider.maximumValue = MAX_NUM_OF_COLORS;
   
   self.motionSlider.minimumValue = 0.01;
   self.motionSlider.maximumValue = 0.99;
   
   self.sensorSlider.minimumValue = 0.01;
   self.sensorSlider.maximumValue = 0.99;
   
   grid = nil;
   [self initGrid];
}

- (void)viewDidUnload
{
   [super viewDidUnload];
   
   [grid release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) initGrid
{
   if (grid) {
      [grid removeFromSuperview];
      [grid release];
   }
   
   CGSize gridCellSize = CGSizeMake(40, 40);
   CGRect gridFrame    = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 80); // 80 for the controls view
   CGSize worldSize = CGSizeMake(gridFrame.size.width / gridCellSize.width, gridFrame.size.height / gridCellSize.height);
   
   // Init a grid view with the numOfColors and gridCellSize parameters
   grid = [[GridView alloc] initWithFrame:gridFrame andCellSize:gridCellSize andNumberOfColors:numOfColors];
   
   // Init a robot with the motion_success & sensor_success parameters
   Robot *obj = [[Robot alloc] initWithWorldSize:worldSize andMovingProbability:motion_rate andSensorAccuracy:sensor_accuracy_rate];
   
   // Add the robot to the grid.
   [grid addRobot:obj];
   [obj release];
   
   // Display the grid.
   [self.view addSubview:grid];
}

- (IBAction)sense:(id)sender
{
   [grid letRobotSense];
}
- (IBAction)goUP:(id)sender
{
   [grid letRobotMoveVertically:-1 andHorizontally:0];
}
- (IBAction)goDown:(id)sender
{
   [grid letRobotMoveVertically:1 andHorizontally:0];   
}
- (IBAction)goLeft:(id)sender
{
   [grid letRobotMoveVertically:0 andHorizontally:-1];
}
- (IBAction)goRight:(id)sender
{
   [grid letRobotMoveVertically:0 andHorizontally:1];
}

- (IBAction)showSettings:(id)sender
{
   [self.numColorsLabel setText:[NSString stringWithFormat:@"%d", numOfColors]];
   [self.motionLabel setText:[NSString stringWithFormat:@"%.2f", motion_rate]];
   [self.sensorLabel setText:[NSString stringWithFormat:@"%.2f", sensor_accuracy_rate]];
   [self.numColorsSlider setValue:numOfColors];
   [self.motionSlider setValue:motion_rate];
   [self.sensorSlider setValue:sensor_accuracy_rate];
   self.settingsView.hidden = NO;
   [self.view bringSubviewToFront:self.settingsView];
}

- (IBAction)saveSettings:(id)sender
{
   [self initGrid];
   self.settingsView.hidden = YES;
}
- (IBAction)numberOfColorsChanged:(id)sender
{
   numOfColors = (int) ((UISlider *)sender).value;
   [self.numColorsLabel setText:[NSString stringWithFormat:@"%d", numOfColors]];
}
- (IBAction)motionRateChanged:(id)sender
{
   motion_rate = ((UISlider *)sender).value;
   [self.motionLabel setText:[NSString stringWithFormat:@"%.2f", motion_rate]];
}
- (IBAction)sensorAccuracyChanged:(id)sender
{
   sensor_accuracy_rate = ((UISlider *)sender).value;
   [self.sensorLabel setText:[NSString stringWithFormat:@"%.2f", sensor_accuracy_rate]];
}

@end

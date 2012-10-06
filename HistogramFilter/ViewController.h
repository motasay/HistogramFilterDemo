@class GridView;

@interface ViewController : UIViewController {
   GridView *grid;
   
   int numOfColors;
   float motion_rate;
   float sensor_accuracy_rate;
}

@property (retain, nonatomic) IBOutlet UIView *settingsView;
@property (retain, nonatomic) IBOutlet UILabel *numColorsLabel;
@property (retain, nonatomic) IBOutlet UILabel *motionLabel;
@property (retain, nonatomic) IBOutlet UILabel *sensorLabel;
@property (retain, nonatomic) IBOutlet UISlider *numColorsSlider;
@property (retain, nonatomic) IBOutlet UISlider *motionSlider;
@property (retain, nonatomic) IBOutlet UISlider *sensorSlider;

- (IBAction)sense:(id)sender;
- (IBAction)goUP:(id)sender;
- (IBAction)goDown:(id)sender;
- (IBAction)goLeft:(id)sender;
- (IBAction)goRight:(id)sender;

- (IBAction)showSettings:(id)sender;
- (IBAction)saveSettings:(id)sender;
- (IBAction)numberOfColorsChanged:(id)sender;
- (IBAction)motionRateChanged:(id)sender;
- (IBAction)sensorAccuracyChanged:(id)sender;

@end

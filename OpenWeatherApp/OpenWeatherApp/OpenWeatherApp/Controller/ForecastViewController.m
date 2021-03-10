//
//  ForecastViewController.m
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/4/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

#import "ForecastViewController.h"
#import "LocationManagerSingleton.h"
#import "ForcastRequestManager.h"
#import "QTForcastModel.h"
#import "ForecastCellTableViewCell.h"

@interface ForecastViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;

@end

@implementation ForecastViewController

@synthesize isLocationUpdated = _isLocationUpdated;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isLocationUpdated = YES;
    [LocationManagerSingleton sharedSingleton].delegate = self;
    //[[self tableView] registerClass:[ForecastCellTableViewCell class] forCellReuseIdentifier:@"ForecastCellTableViewCell"];

}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)backButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)locationFetching {
    CLLocation *currentLocation = [LocationManagerSingleton sharedSingleton].locationManager.location;
    //NSLog(@"currentLocation %@",currentLocation.coordinate.latitude);
    NSString *latitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    if (self.isLocationUpdated) {
        self.isLocationUpdated = NO;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //load your data here.
            ForcastRequestManager *forcastRequestManager = [[ForcastRequestManager alloc]init];
            
            [forcastRequestManager getForcastDataWithCurrentLocation:latitude :longitude completed:^(BOOL status, QTForcastModel *forcastModel){
                if (status) {
                    NSLog(@"Success");
                    // NSLog(@"Success Model %@", forcastModel);
                    forcastData = forcastModel;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //update UI in main thread.
                        [self updateUI];
                    });
                } else {
                    NSLog(@"Error");
                    self.isLocationUpdated = YES;
                }
            }];
        });
        
        
    }
}

- (void)updateUI {
    self.cityName.text = forcastData.city.name;
    [self updateHeaderInfo: forcastData.list.firstObject];
    [self.tableView reloadData];
}

- (void) updateHeaderInfo:(QTList*)selectedForecast {
    self.minLabel.text = [NSString stringWithFormat:@"%f.1",selectedForecast.main.tempMin];
    self.maxLabel.text = [NSString stringWithFormat:@"%f.1",selectedForecast.main.tempMax];
    self.windSpeedLabel.text = [NSString stringWithFormat:@"%f.1",selectedForecast.wind.speed];
    NSLog(@"%@",selectedForecast.weather.firstObject.theDescription.value);
    self.descriptionLabel.text = selectedForecast.weather.firstObject.theDescription.value; //[NSString stringWithFormat:@"%@",];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [forcastData.list count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath

{
    static NSString *cellIdentifier = @"ForecastCellTableViewCell";
    
    //ForecastCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    ForecastCellTableViewCell *cell;

  //  cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    QTList *list = (forcastData.list)[indexPath.row];
    
    UILabel *temperatureLabel = (UILabel *)[cell viewWithTag:22];
    temperatureLabel.text = [NSString stringWithFormat:@"%f.1 - %@",list.main.tempMax,list.weather.firstObject.theDescription.value];

    UILabel *dateTimeLabel = (UILabel *)[cell viewWithTag:23];
    dateTimeLabel.text = list.dtTxt;
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self updateHeaderInfo: (forcastData.list)[indexPath.row]];
}


@end

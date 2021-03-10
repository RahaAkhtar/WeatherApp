//
//  ForecastViewController.h
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/4/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationManagerSingleton.h"
#import "QTForcastModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForecastViewController : UIViewController <LocationFetchingProtocolDelegate, UITableViewDelegate, UITableViewDataSource> {
     QTForcastModel *forcastData;
     QTList *selectedForecast;
}
@property (assign) BOOL isLocationUpdated;

@end

NS_ASSUME_NONNULL_END

//
//  LocationManagerSingleton.h
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/4/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol LocationFetchingProtocolDelegate <NSObject>
@required
- (void) locationFetching;
@end

@interface LocationManagerSingleton : NSObject <CLLocationManagerDelegate>{
    id <LocationFetchingProtocolDelegate> _delegate;
}

@property (nonatomic,strong) id delegate;
@property (nonatomic, strong) CLLocationManager* locationManager;

+ (LocationManagerSingleton*)sharedSingleton;

@end

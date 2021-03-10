//
//  ForcastRequestManager.h
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/4/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTForcastModel.h"

@interface ForcastRequestManager : NSObject
    //Create a block property
    typedef void(^getRequestBlock)(BOOL status, QTForcastModel *forcastModel);

    //-(void) getContentInBackgroundWithMemberId: (int) memberId completed:(postRequestBlock)completed;

  -(void) getForcastDataWithCurrentLocation:(NSString* ) latitude :(NSString* ) longtitude completed:(getRequestBlock)completed;

@end

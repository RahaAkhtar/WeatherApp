//
//  ForcastRequestManager.m
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/4/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

#import "ForcastRequestManager.h"


@implementation ForcastRequestManager

//-(void) getContentInBackgroundWithMemberId: (int) memberId completed:(postRequestBlock)completed{
//    NSDictionary * params = [NSDictionary dictionary];
//    params = @ {
//        @ "member_id": [NSNumber numberWithInt: memberId]
//    };
//    [self postRequestWithParams: params completed:^(BOOL status){
//        completed(status);
//    }];
//}
//
////Add completion block.
//-(void) postRequestWithParams: (NSDictionary * ) params completed:(postRequestBlock)completed{
//    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler: ^ (NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if (!connectionError) {
//            NSDictionary * serverData = [NSJSONSerialization JSONObjectWithData: data options: 0 error: nil];
//            NSArray * result = [NSArray array];
//            result = [serverData objectForKey: @ "result"];
//            completed(YES);
//        } else {
//            completed(NO);
//        }
//
//    }];
//}

-(void) getForcastDataWithCurrentLocation:(NSString* ) latitude :(NSString* ) longtitude completed:(getRequestBlock)completed {
    
    NSString *API_Key = @"5d4ca40f008c7f9f0594ec16ed677365";
    NSString *URLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%@&lon=%@&appid=%@",latitude, longtitude, API_Key];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];


        //create the Method "GET" or "POST"
        [urlRequest setHTTPMethod:@"GET"];

        //Convert the String to Data
        //NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];

        //Apply the data to the body
        //[urlRequest setHTTPBody:data1];

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode == 200)
            {
                
                NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                // To parse this JSON:
                
                if (![jsonString length]) {
                    completed(false, nil);
                } else {
                    NSError *error;
                    QTForcastModel *forCastModel = [QTForcastModel fromJSON:jsonString encoding:NSUTF8StringEncoding error:&error];
                    completed(true, forCastModel);
                }
                
                // To parse this JSON:
                //
                   
                
                /*
                NSError *parseError = nil;
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                NSLog(@"The response is - %@",responseDictionary);
                if (responseDictionary == nil) {
                    completed(NO);
                } else {
                    completed(YES);
                }*/
            }
            else
            {
                completed(false, nil);
            }
        }];
        [dataTask resume];
}


@end

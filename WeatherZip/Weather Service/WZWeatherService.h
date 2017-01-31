//
//  WZWeatherService.h
//  WeatherZip
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WZWeather.h"

typedef void (^WZForcastCompletionBlock)(WZWeather *weather, NSError *error);

@interface WZWeatherService : NSObject

- (void)forcastForZipCode:(NSString *)zipCode completion:(WZForcastCompletionBlock)completion;

@end

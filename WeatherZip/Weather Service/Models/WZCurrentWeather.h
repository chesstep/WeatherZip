//
//  WZCurrentWeather.h
//  WeatherZip
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZCurrentWeather : NSObject

@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *precipType;
@property (nonatomic, strong) NSString *temperatureString;
@property (nonatomic, strong) NSString *precipProbabilityString;
@property (nonatomic, strong) NSString *humidityString;
@property (nonatomic, strong) NSString *windSpeedString;

@end

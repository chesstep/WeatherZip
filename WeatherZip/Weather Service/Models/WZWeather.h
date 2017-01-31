//
//  WZWeather.h
//  WeatherZip
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WZCurrentWeather.h"

@interface WZWeather : NSObject

@property (nonatomic, strong) WZCurrentWeather *currently;

@end

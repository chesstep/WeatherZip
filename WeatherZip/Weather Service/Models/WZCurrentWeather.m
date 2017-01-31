//
//  WZCurrentWeather.m
//  WeatherZip
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import "WZCurrentWeather.h"

@interface WZCurrentWeather()

@property (nonatomic, assign) double temperature;
@property (nonatomic, assign) double precipProbability;
@property (nonatomic, assign) double humidity;
@property (nonatomic, assign) double windSpeed;

@end

@implementation WZCurrentWeather

- (void)setTemperature:(double)temperature {
    _temperature = temperature;
    self.temperatureString = [NSString stringWithFormat:@"%.0f\u00B0", _temperature];
}

- (void)setPrecipProbability:(double)precipProbability {
    _precipProbability = precipProbability;
    self.precipProbabilityString = [NSString stringWithFormat:@"%.0f%%", _precipProbability * 100];
}

- (void)setHumidity:(double)humidity {
    _humidity = humidity;
    self.humidityString = [NSString stringWithFormat:@"%.0f%%", _humidity * 100];
}

- (void)setWindSpeed:(double)windSpeed {
    _windSpeed = windSpeed;
    self.windSpeedString = [NSString stringWithFormat:@"%.2f mph", _windSpeed];
}

@end

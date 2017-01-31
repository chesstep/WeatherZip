//
//  WZWeatherService.m
//  WeatherZip
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import "WZWeatherService.h"

#import "ObjectMapper.h"
#import <CoreLocation/CoreLocation.h>

NSString *const BaseURL = @"https://api.darksky.net/forecast/";
NSString *const ApiKey = @"67fa93a4e200881d6251473398d97d23";

typedef void (^WZLatLongCompletionBlock)(NSString *latitude, NSString *longitude, NSError *error);

@interface WZWeatherService ()

@property (nonatomic, strong) NSString *forcastURLString;
@property (nonatomic, strong) NSURLSession *urlSession;

@end

@implementation WZWeatherService

- (instancetype)init {
    if (self = [super init]) {
        _forcastURLString = [NSString stringWithFormat:@"%@%@/", BaseURL, ApiKey];
        _urlSession = [NSURLSession sharedSession];
    }
    
    return self;
}

- (void)forcastForZipCode:(NSString *)zipCode completion:(WZForcastCompletionBlock)completion {
    if (zipCode == nil || zipCode.length == 0) {
        if (completion != nil) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Invalid zip code.", nil)};
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
            completion(nil, error);
        }
        return;
    }
    
    [self latLongFromZipCode:zipCode completion:^(NSString *latitude, NSString *longitude, NSError *error) {
        if (error == nil) {
            [self forcastForLatitude:latitude longitude:longitude completion:completion];
        } else if (completion != nil) {
            completion(nil, error);
        }
    }];
}

- (void)forcastForLatitude:(NSString *)latitude longitude:(NSString *)longitude completion:(WZForcastCompletionBlock)completion {
    NSURL *forcastURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@,%@", self.forcastURLString, latitude, longitude]];
    NSURLSessionDataTask *task = [self.urlSession dataTaskWithURL:forcastURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSError *JSONError = nil;
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&JSONError];
        
            WZWeather *weather = nil;
            if (dictionary != nil && JSONError == nil) {
                weather = [[ObjectMapper sharedInstance] objectFromSource:dictionary toInstanceOfClass:[WZWeather class]];
            }
            
            if (completion != nil) {
                dispatch_async(dispatch_get_main_queue(), ^(){
                    completion(weather, JSONError);
                });
            }
        } else if (completion != nil) {
            dispatch_async(dispatch_get_main_queue(), ^(){
                completion(nil, error);
            });
        }
    }];
    
    [task resume];
}

- (void)latLongFromZipCode:(NSString *)zipCode completion:(WZLatLongCompletionBlock)completion {
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:zipCode completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString *latitude = nil;
        NSString *longitude = nil;
        if (error == nil) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
        
            latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
        }
        
        if (completion != nil) {
            completion(latitude, longitude, error);
        }
    }];
}

@end

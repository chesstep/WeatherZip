//
//  WeatherZipTests.m
//  WeatherZipTests
//
//  Created by Chesley Stephens on 1/30/17.
//  Copyright © 2017 Nibbis. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WZWeatherService.h"

@interface WZWeatherService (UnitTests)

typedef void (^WZLatLongCompletionBlock)(NSString *latitude, NSString *longitude, NSError *error);

- (void)latLongFromZipCode:(NSString *)zipCode completion:(WZLatLongCompletionBlock)completion;
- (void)forcastForLatitude:(NSString *)latitude longitude:(NSString *)longitude completion:(WZForcastCompletionBlock)completion;

@end

@interface WZWeatherServiceTests : XCTestCase

@property (nonatomic, strong) WZWeatherService *weatherService;

@end

@implementation WZWeatherServiceTests

- (void)setUp {
    [super setUp];
    
    self.weatherService = [[WZWeatherService alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testForcastForZipCode_EmptyZip {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve zip code"];
    
    [self.weatherService forcastForZipCode:@"" completion:^(WZWeather *weather, NSError *error) {
        XCTAssertNotNil(error, @"Should have received an error");
        XCTAssertNil(weather, @"Weather object should be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testForcastForZipCode_ValidZipCode {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve zip code"];
    
    [self.weatherService forcastForZipCode:@"78731" completion:^(WZWeather *weather, NSError *error) {
        XCTAssertNil(error, @"Should NOT have received an error");
        XCTAssertNotNil(weather, @"Weather object should not be nil");
        XCTAssertNotNil(weather.currently.temperatureString, @"Temperature object should not be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testLatLongFromZipCode_EmptyZip {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve zip code"];
    
    [self.weatherService latLongFromZipCode:@"" completion:^(NSString *latitude, NSString *longitude, NSError *error) {
        XCTAssertNotNil(error, @"Should have received an error");
        XCTAssertNil(latitude, @"Latitude object should be nil");
        XCTAssertNil(longitude, @"Longitude object should be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testLatLongFromZipCode_ValidZipCode {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve zip code"];
    
    [self.weatherService latLongFromZipCode:@"78731" completion:^(NSString *latitude, NSString *longitude, NSError *error) {
        XCTAssertNil(error, @"Should NOT have received an error");
        XCTAssertTrue([latitude isEqualToString:@"30.344967"], @"Latitude object should be equal");
        XCTAssertTrue([longitude isEqualToString:@"-97.770337"], @"Longitude object should be equal");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testForcastForLatitudeLongitude_EmptyLatLong {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve zip code"];
    
    [self.weatherService forcastForLatitude:@"" longitude:@"" completion:^(WZWeather *weather, NSError *error) {
        XCTAssertNotNil(error, @"Should have received an error");
        XCTAssertNil(weather, @"Weather object should be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testForcastForLatitudeLongitude_ValidLatLong {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retrieve zip code"];
    
    [self.weatherService forcastForLatitude:@"30.344967" longitude:@"-97.770337" completion:^(WZWeather *weather, NSError *error) {
        XCTAssertNil(error, @"Should NOT have received an error");
        XCTAssertNotNil(weather, @"Weather object should not be nil");
        XCTAssertNotNil(weather.currently.temperatureString, @"Temperature object should not be nil");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end

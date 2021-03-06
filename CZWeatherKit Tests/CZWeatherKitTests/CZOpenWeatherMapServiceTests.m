//
// CZOpenWeatherMapServiceTests.m
// Copyright (c) 2014, Comyar Zaheri, http://comyar.io
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#pragma mark - Imports

#import "CZWeatherServiceTestCase.h"
#import "CZOpenWeatherMapService.h"


#pragma mark - Macros

#if !(TARGET_OS_IPHONE)
#define valueWithCGPoint valueWithPoint
#endif


#pragma mark - Constants

// JSON outputs from API
static NSString * const currentJSONFilename                 = @"current_openweathermap";
static NSString * const forecastLightJSONFilename           = @"forecastLight_openweathermap";
static NSString * const forecastFullJSONFilename            = @"forecastFull_openweathermap";


#pragma mark - CZOpenWeatherMapServiceTests Interface

@interface CZOpenWeatherMapServiceTests : CZWeatherServiceTestCase

// JSON output data
@property (nonatomic) NSData *currentData;
@property (nonatomic) NSData *forecastLightData;
@property (nonatomic) NSData *forecastFullData;

@end


#pragma mark - CZOpenWeatherMapServiceTests Implementation

@implementation CZOpenWeatherMapServiceTests

#pragma mark Setup and Teardown

- (void)setUp
{
    [super setUp];
    self.service            = [CZOpenWeatherMapService serviceWithKey:@"1234567890123456"];
    self.currentData        = [[self loadFile:currentJSONFilename       extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastLightData  = [[self loadFile:forecastLightJSONFilename extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
    self.forecastFullData   = [[self loadFile:forecastFullJSONFilename  extension:@"json"]dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)loadFile:(NSString *)filename extension:(NSString *)extension
{
    NSString *path      = [[NSBundle bundleForClass:[self class]]pathForResource:filename ofType:extension];
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark urlForRequest: Tests

- (void)test_urlForRequest_forecastLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel = CZWeatherRequestLightDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/hourly?lat=%.4f&lon=%.4f&mode=json&units=imperial&appid=%@", latitude, longitude, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast light detail");
}

- (void)test_urlForRequest_forecastFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%.4f&lon=%.4f&mode=json&units=imperial&appid=%@", latitude, longitude, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for forecast full detail");
}

- (void)test_urlForRequest_conditionsLightDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestLightDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%.4f&lon=%.4f&mode=json&units=imperial&appid=%@", latitude, longitude, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions light detail");
}

- (void)test_urlForRequest_conditionsFullDetail
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%.4f&lon=%.4f&mode=json&units=imperial&appid=%@", latitude, longitude, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for conditions full detail");
}

- (void)test_urlForRequest_locationCoordinate
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%.4f&lon=%.4f&mode=json&units=imperial&appid=%@", latitude, longitude, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with coordinates");
}

- (void)test_urlForRequest_locationStateCity
{
    NSString * const stateCity = @"Austin,TX";
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCity:@"Austin" state:@"TX"];
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&mode=json&units=imperial&appid=%@", stateCity, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with state/city");
}

- (void)test_urlForRequest_locationCountryCity
{
    NSString * const countryCity = @"London,UK";
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCity:@"London" country:@"UK"];
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSURL *url = [self.service urlForRequest:request];
    NSString *expected = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&mode=json&units=imperial&appid=%@", countryCity, self.service.key];
    XCTAssertEqualObjects(url, [NSURL URLWithString:expected], @"Invalid URL for request with country/city");
}

#pragma mark weatherDataForResponseData Tests

- (void)test_weatherDataForResponseData_current
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    CZWeatherCondition *currentCondition = [self.service weatherDataForResponseData:self.currentData request:request];
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(currentCondition.temperature.f, 83.61, 0.01, @"Current fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(currentCondition.temperature.c, 28.67, 0.01, @"Current celsius temperature not equal");
    XCTAssertEqualObjects(currentCondition.description, @"few clouds", @"Current description not equal");
    XCTAssertEqualObjects(currentCondition.date, [NSDate dateWithTimeIntervalSince1970:1401055200], @"Current date not equal");
    XCTAssertEqual(currentCondition.climaconCharacter, ClimaconCloud, @"Climacon character not equal");
    XCTAssertEqualWithAccuracy(currentCondition.humidity, 75.0, 0.01, @"Humidity not equal");
    XCTAssertEqualWithAccuracy(currentCondition.windDegrees, 99.0, 0.01, @"Wind degrees not equal");
    XCTAssertEqualWithAccuracy(currentCondition.windSpeed.kph, 1.7702784, 0.01, @"Wind speed kph not equal");
    XCTAssertEqualWithAccuracy(currentCondition.windSpeed.mph, 1.1, 0.01, @"Wind speed mph not equal");
}

- (void)test_weatherDataForResponseData_forecastLight
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel   = CZWeatherRequestLightDetail;
    request.service = self.service;
    
    NSArray *data = [self.service weatherDataForResponseData:self.forecastLightData request:request];
    
    XCTAssertEqual([data count], 39, @"Forecast light count not equal");
    
    CZWeatherCondition *firstCondition = [data firstObject];
    XCTAssertEqualObjects(firstCondition.date, [NSDate dateWithTimeIntervalSince1970:1401051600], @"First condition date not equal");
    XCTAssertEqualObjects(firstCondition.description, @"few clouds", @"First condition description not equal");
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.f, 83.25, 0.01, @"First condition high fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.c, 28.47, 0.01, @"First condition high celsius temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.f, 83.24, 0.01, @"First condition low fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.c, 28.46, 0.01, @"First condition low celsius temperature not equal");
    XCTAssertEqual(firstCondition.climaconCharacter, ClimaconCloud, @"Climacon character not equal");
    
    XCTAssertEqualWithAccuracy(firstCondition.humidity, 75.0, 0.01, @"Humidity not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windDegrees, 155.5, 0.01, @"Wind degrees not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windSpeed.kph, 22.77, 0.01, @"Wind speed kph not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windSpeed.mph, 14.15, 0.01, @"Wind speed mph not equal");
}

- (void)test_weatherDataForResponseData_forecastFull
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZForecastRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel   = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    NSArray *data = [self.service weatherDataForResponseData:self.forecastFullData request:request];
    
    XCTAssertEqual([data count], 7, @"Forecast full count not equal");
    
    CZWeatherCondition *firstCondition = [data firstObject];
    XCTAssertEqualObjects(firstCondition.date, [NSDate dateWithTimeIntervalSince1970:1401040800], @"First condition date not equal");
    XCTAssertEqualObjects(firstCondition.description, @"broken clouds", @"First condition description not equal");
    
    // Account for floating point rounding errors
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.f, 86.72, 0.01, @"First condition high fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.highTemperature.c, 30.40, 0.01, @"First condition high celsius temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.f, 78.37, 0.01, @"First condition low fahrenheit temperature not equal");
    XCTAssertEqualWithAccuracy(firstCondition.lowTemperature.c, 25.76, 0.01, @"First condition low celsius temperature not equal");
    XCTAssertEqual(firstCondition.climaconCharacter, ClimaconCloud, @"Climacon character not equal");
    
    XCTAssertEqualWithAccuracy(firstCondition.humidity, 75.0, 0.01, @"Humidity not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windDegrees, 156.0, 0.01, @"Wind degrees not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windSpeed.kph, 21.629, 0.01, @"Wind speed kph not equal");
    XCTAssertEqualWithAccuracy(firstCondition.windSpeed.mph, 13.44, 0.01, @"Wind speed mph not equal");
}

#pragma mark OpenWeatherMap Request Tests

- (void)test_openWeatherMapRequest_full
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    [request performRequestWithHandler:^(id data, NSError *error) {
        XCTAssertTrue([data isKindOfClass:[CZWeatherCondition class]], @"Data is not CZWeatherCondition instance");
    }];
}

- (void)test_openWeatherMapRequest_configurationError
{
    const CGFloat latitude  = 30.2500;
    const CGFloat longitude = -97.7500;
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.location = [CZWeatherLocation locationWithCLLocationCoordinate2D:CLLocationCoordinate2DMake(latitude, longitude)];
    request.detailLevel  = CZWeatherRequestFullDetail;
    request.service = nil;
    
    [request performRequestWithHandler:^(id data, NSError *error) {
        XCTAssertNil(data, @"Data should be nil");
        XCTAssertEqualObjects(error, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                         code:CZWeatherRequestConfigurationError
                                                     userInfo:nil], @"Error should be configuration error");
    }];
}

- (void)test_openWeatherMapRequest_URLError
{
    CZWeatherRequest *request = [CZWeatherRequest requestWithType:CZCurrentConditionsRequestType];
    request.detailLevel = CZWeatherRequestFullDetail;
    request.service = self.service;
    
    [request performRequestWithHandler:^(id data, NSError *error) {
        XCTAssertNil(data, @"Data should be nil");
        XCTAssertEqualObjects(error, [NSError errorWithDomain:CZWeatherRequestErrorDomain
                                                         code:CZWeatherRequestServiceURLError
                                                     userInfo:nil], @"Error should be URL error");
    }];
}

@end

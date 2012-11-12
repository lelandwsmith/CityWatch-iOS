//
//  ApplicationSettings.m
//  CityWatch
//
//  Copyright 2012 Intrepid Pursuits & Kinvey, Inc
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "ApplicationSettings.h"

NSString *const kApplicationSettingsUserLocationCoordinateKey = @"kApplicationSettingsUserLocationCoordinateKey";

@implementation ApplicationSettings

static ApplicationSettings *applicationSettings = nil;

+ (ApplicationSettings *)sharedSettings {
    if (!applicationSettings) {
        applicationSettings = [[ApplicationSettings alloc] init];
    }
    return applicationSettings;
}

- (NSArray *)currentUserCoordinates {
    return [self objectForKey:kApplicationSettingsUserLocationCoordinateKey];
}

- (void)setCurrentUserCoordinates:(NSArray *)currentUserCoordinates {
    [self setObject:currentUserCoordinates forKey:kApplicationSettingsUserLocationCoordinateKey];
}

@end

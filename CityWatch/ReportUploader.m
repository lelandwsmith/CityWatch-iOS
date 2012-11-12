//
//  ReportUploader.m
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

#import "ReportUploader.h"
#import <KinveyKit/KinveyKit.h>


@interface ReportUploader() {
    BOOL imageFinished;
    BOOL entityFinished;
    BOOL imageSucceeded;
    BOOL entitySucceeded;
}
- (void) notifyDelegateIfReady;
@property (strong, nonatomic) KCSAppdataStore* kinveyStore;
@property (strong, nonatomic) KCSResourceResponse *result;
@end

@implementation ReportUploader

- (id) initWithReport:(ReportModel *)report
{
    if (self = [super init]) {
        self.report = report;
        KCSCollection* collection = [KCSCollection collectionFromString:@"Reports" ofClass:[ReportModel class]];
        _kinveyStore = [KCSCachedStore storeWithCollection:collection options:@{ KCSStoreKeyCachePolicy : @(KCSCachePolicyNetworkFirst)}];
    }
    
    return self;
}

- (void) upload
{
    //Save a report to the Reports collection and its image to the Resource service
    
    NSString* imagePath = self.report.imagePath;
    NSString* imageName = self.report.objectId;
    [KCSResourceService saveLocalResource:imagePath toResource:imageName completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            NSLog(@"resourceService completed.");
            imageSucceeded = YES;
        } else {
            imageSucceeded = NO;
            NSLog(@"resourceService failed with error %@.", errorOrNil);
        }
        imageFinished = YES;
        [self notifyDelegateIfReady];

    } progressBlock:nil];
    
    [_kinveyStore saveObject:self.report withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            NSLog(@" entity:(id)%@ save error: (NSError *)%@", self.report, errorOrNil);
            entityFinished = true;
            entitySucceeded = true;
            [self notifyDelegateIfReady];
        } else {
            NSLog(@" entity:(id)%@ completed", self.report);
            entityFinished = true;
            [self notifyDelegateIfReady];
        }
    } withProgressBlock:nil];
}

#pragma mark - delegate stuff

- (void) notifyDelegateIfReady
{
    if (entityFinished && imageFinished) {        
        self.report.isUploaded = imageSucceeded && entitySucceeded;
        [self.delegate reportUploaderDidFinish:self];
    }
}

@end
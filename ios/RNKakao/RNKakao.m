//
//  RNKakao.m
//  RNKakao
//
//  Created by elicie on 2017. 6. 9..
//  Copyright © 2017년 byandus. All rights reserved.
//

#import "RNKakao.h"

@implementation RNKakao

RCT_EXPORT_MODULE();


- (NSDictionary *)constantsToExport
{
    return @{ @"KOAuthTypeTalk" : @(KOAuthTypeTalk),
              @"KOAuthTypeAccount" : @(KOAuthTypeAccount) };
};



/**
 Login or Signup
 @param authTypes array consists in KOAuthType.
 */

RCT_REMAP_METHOD(login,
                 authTypes: (NSArray* )authTypes
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[KOSession sharedSession] close];
        [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
            NSLog(@"MYLOG: openWithCompletionHandler");
            
            if(error) {
                NSLog(@"Error: %@", error.description);
                NSLog(@"%@", error.description);
                
                reject(@"RNKakao", @"login error", error);
                return;
            }
            
            if ([[KOSession sharedSession] isOpen]) {
                NSLog(@"sharedSession is open");
                
                [self userInfoRequestResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject];
                return;
            } else {
                reject(@"RNKakao", @"login canceled", nil);
                return;
            }
        } authParams:nil authTypes:(authTypes != nil) ? authTypes : @[@(KOAuthTypeTalk), @(KOAuthTypeStory), @(KOAuthTypeAccount)]];
    });
}



RCT_REMAP_METHOD(logout,
                 resolver1:(RCTPromiseResolveBlock)resolve
                 rejecter1:(RCTPromiseRejectBlock)reject)
{
    [[KOSession sharedSession] close];
    NSDictionary *status = @{ @"success": @"true"};
    resolve(status);
}


@end

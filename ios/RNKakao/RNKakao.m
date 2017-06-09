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
        } authParams:nil authTypes:(authTypes != nil) ? authTypes : @[@(KOAuthTypeTalk), @(KOAuthTypeAccount)]];
    });
}

/**
 Get userInfo
 */
RCT_REMAP_METHOD(userInfo,
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self userInfoRequestResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject];
}

- (void) userInfoRequestResolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {
    [KOSessionTask meTaskWithCompletionHandler:^(KOUser* result, NSError *error) {
        if (result) {
            // success
            
            NSNumber *id = result.ID;
            NSString *nickName = [result propertyForKey:KOUserNicknamePropertyKey];
            NSString *email = [result propertyForKey:KOUserEmailPropertyKey];
            NSString *profileImage = [result propertyForKey:KOUserProfileImagePropertyKey];
            NSString *profileImageThumnail = [result propertyForKey:KOUserThumbnailImagePropertyKey];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setValue:id forKey:@"id"];
            [userInfo setValue:[KOSession sharedSession].accessToken forKey:@"accessToken"];
            
            if (nickName != nil) {
                [userInfo setValue:nickName forKey:@"nickName"];
            }
            
            if (email != nil) {
                [userInfo setValue:email forKey:@"email"];
            }
            
            if (profileImage != nil) {
                [userInfo setValue:profileImage forKey:@"profileImage"];
            }
            
            if (profileImageThumnail != nil) {
                [userInfo setValue:profileImageThumnail forKey:@"profileImageThumnail"];
            }
            
            resolve(userInfo);
        } else {
            // failed
            reject(@"RNKakao", @"userInfo error", error);
        }
    }];
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

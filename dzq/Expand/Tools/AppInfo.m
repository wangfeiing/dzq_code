//
//  AppInfo.m
//  dzq
//
//  Created by chentianyu on 16/3/30.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "AppInfo.h"

@implementation AppInfo
@synthesize usermodel = _usermodel;
@synthesize token = _token;
@synthesize userId = _userId;
@synthesize theNavHeight = _theNavHeight;
@synthesize version = _version;

+(id)getInstance
{
    static AppInfo *appInfo = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        appInfo = [[AppInfo alloc] init];
        
     
    });
    return appInfo ;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return self;
}

-(void)setToken:(NSString *)token
{
    _token = token;
}
- (void)setUsermodel:(UserModel *)theUsermodel
{
    _usermodel = theUsermodel;
    _userId = _usermodel.id;
    _token = _usermodel.token;

}

- (void)saveUsername:(NSString *)username withPassword:(NSString *)password
{
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"password"];
}

- (void)deleteUsernamewithPassword
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] length]>0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"password"];
        
    }else{
        
    }
}

- (void)setTheNavHeight:(CGFloat)theNavHeight
{
    _theNavHeight = theNavHeight;
}


@end

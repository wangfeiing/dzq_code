//
//  AppInfo.h
//  dzq
//
//  Created by chentianyu on 16/3/30.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UserModel.h"
@interface AppInfo : NSObject

@property(nonatomic,readonly)NSString *token;
@property(nonatomic,readonly)UserModel *usermodel;
@property(nonatomic,readonly)NSInteger userId;
@property(nonatomic,readonly)CGFloat theNavHeight;
@property(nonatomic,readonly)NSString *version;

+(id)getInstance;
- (void)setUsermodel:(UserModel *)theUsermodel;
-(void)setToken:(NSString *)token;
- (void)saveUsername:(NSString *)username withPassword:(NSString *)password;
- (void)deleteUsernamewithPassword;
- (void)setTheNavHeight:(CGFloat)theNavHeight;
@end

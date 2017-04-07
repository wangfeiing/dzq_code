//
//  RegularJudge.m
//  dzq
//
//  Created by chentianyu on 16/3/28.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "RegularJudge.h"

@implementation RegularJudge


+(id)shareInstance
{
    static RegularJudge *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[RegularJudge alloc] init];
    });
    return instance;
}

- (BOOL)matchMobilephoneNumber:(NSString *)number
{
    NSString *pattern = @"^1(3|5|8)\\d{9}$";
    
    return [self matchString:number withPattern:pattern];
}

- (BOOL)matchPassword:(NSString *)password
{
    NSString *pattern = @"^[A-Za-z0-9]{6,18}$";
    return [self matchString:password withPattern:pattern];
}

-(BOOL)matchString:(NSString *)str withPattern:(NSString *)pattern
{
    NSError *error;
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (!error) {
        NSTextCheckingResult *result = [regularExpression firstMatchInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
        if (result) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)contentIsNil:(NSString *)str
{
    if ([str isEqualToString:@""] || str == nil || str == NULL) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
@end

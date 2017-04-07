//
//  AppDelegate.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "RootViewController.h"
#import "HomeViewController.h"
/*
 
 微信---------
 AppID：wx8367546f16edf261
 AppSecret：859b01e77f455d001b9e1d73e0157c7c
 ---------------
 新浪
 App Key：1912204051
 App Secret：6f3aed3174e9749a73552d6347afbc51
 ------------------
 QQ
 APP ID:1105354668
 APP KEY:PKVwX13etx0O1Lfd
 */
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    
//    HomeViewController *home = [[HomeViewController alloc] init];
//    RootViewController *root = [[RootViewController alloc] initWithRootViewController:home];
//    root.navigationBarHidden = YES;
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = root;
//    [self.window makeKeyAndVisible];
    
    
    
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];//初始化DDLog日志输出，在这里，我们仅仅希望在Xcode控制台输出
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];//启用颜色区分
    
    
    [SMSSDK registerApp:@"110bd66d110a2" withSecret:@"162648aac45c8c20b0797f5604e0dea3"];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"username"] length]>0){
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        RequestApi *request = [RequestApi shareInstance];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:username,@"account",password,@"password", nil];
        [request userLoginWithApi:Public_User_Login method:GET parameters:dic successBlock:^(id result) {
            if (request.msgCode == 1) {
                AppInfo *info = [AppInfo getInstance];
                UserModel *model = [[UserModel alloc] initWithDic:result];
                [info setUsermodel:model];
                [info setToken:model.token];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SetAvatarImage" object:nil];
            }
        } failureBlock:^(NSString *message) {
            
        }];
    }
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerApp:@"iosv1101" activePlatforms:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeQQ)] onImport:^(SSDKPlatformType platformType) {
        if (platformType == SSDKPlatformTypeWechat) {
            [ShareSDKConnector connectWeChat:[WXApi class]];
        }
        else if (platformType == SSDKPlatformTypeSinaWeibo){
            [ShareSDKConnector connectWeibo:[WeiboSDK class]];
        }
        else if (platformType == SSDKPlatformTypeQQ){
            [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
        }
 
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        if (platformType == SSDKPlatformTypeWechat) {
            [appInfo SSDKSetupWeChatByAppId:@"wx8367546f16edf261" appSecret:@"859b01e77f455d001b9e1d73e0157c7c"];
        }
        else if (platformType == SSDKPlatformTypeSinaWeibo){
//            [appInfo SSDKSetupSinaWeiboByAppKey:@"1912204051"
//                                      appSecret:@"6f3aed3174e9749a73552d6347afbc51"
//                                    redirectUri:@"http://marchsoft.cn"
//                                       authType:SSDKAuthTypeBoth];
            [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                      appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                    redirectUri:@"http://www.sharesdk.cn"
                                       authType:SSDKAuthTypeBoth];
        }
        else if (platformType == SSDKPlatformTypeQQ){
            [appInfo SSDKSetupQQByAppId:@"1105354668" appKey:@"PKVwX13etx0O1Lfd" authType:SSDKAuthTypeBoth];
        }

    }];
    
    return YES;
}
#if __IPAD_OS_VERSION_MAX_ALLOWED>=_IPAD_6_0
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return UIInterfaceOrientationMaskLandscape;
}

#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

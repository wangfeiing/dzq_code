//
//  HomeViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/24.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingViewController.h"


@interface HomeViewController (){
    UIButton *avatarButton;
}

@end


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    
//    DDLogError(@"错误");
//    DDLogWarn(@"警告");
//    DDLogInfo(@"信息");
    
//    NSLog(@"%f",[[UIApplication sharedApplication] statusBarFrame].size.height);
//
//        NSLog(@"%f",[[UIApplication sharedApplication] statusBarFrame].size.width);
    self.allChilds = [NSMutableDictionary dictionary];
    __unsafe_unretained HomeViewController *home = self;
    
    //添加dock
    self.dock = [[Dock alloc] init];

    self.dock.dockItemClickBlock = ^(DockItem *item){
        //切换控制器
        [home selectChildWithItem:item];
    };
    [self.view addSubview:self.dock];
    

    //默认选中状态
    [home selectChildWithItem:[DockItem itemWithIcon:@"personal" className:@"SLViewController"]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickAvatarViewNotification:) name:@"NSClickAvatarViewBackNotification" object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)clickAvatarViewNotification:(NSNotification *)notification
//{
//    UIButton *button = (UIButton *)[[notification userInfo] objectForKey:@"clickView"];
//    avatarButton = button;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectChildWithItem:(DockItem *)item
{
    UINavigationController *nav = self.allChilds[item.className];
    if (nav == nil) {
        Class c = NSClassFromString(item.className);
        
        if(c==[SettingViewController class]){

            SettingViewController *setting = [[SettingViewController alloc] init];
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setting];
            nav.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:nav animated:YES completion:^{
                
            }];
            return;
        }
//        if (c == [AvatarViewController class]) {    //点击头像视图
//            AvatarViewController *avatar = [[AvatarViewController alloc] init];
//            avatar.modalPresentationStyle = UIModalPresentationPopover;
//            dispatch_queue_t bac = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//            dispatch_async(bac, ^{
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NSClickAvatarViewNotification" object:nil];
//            });
//            
//            avatar.popoverPresentationController.sourceView = avatarButton;
//            avatar.popoverPresentationController.sourceRect  = avatarButton.bounds;
////            [avatar.popoverPresentationController setPermittedArrowDirections:UIPopoverArrowDirectionRight];//preferredContentSize  = CGSizeMake(CGFLOAT_MAX, 100);
////            self.popoverPresentationController
////            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:avatar];
//            
//            [self presentViewController:avatar animated:YES completion:^{
//                
//            }];
//            return;
//        }
        
        
        UIViewController *vc = [[c alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:vc];


        [self addChildViewController:nav];
        [self.allChilds setObject:nav forKey:item.className];
    }
    
    if (self.currentChild == nav) return;
    
    
    //移除旧的控制器的view
    [self.currentChild.view removeFromSuperview];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width-DOCK_WIDTH;
    nav.view.frame = CGRectMake(DOCK_WIDTH, 0, width, DOCK_HEIGHT);
    [self.view addSubview:nav.view];
    
    //新的当前
    self.currentChild = nav;
}

@end

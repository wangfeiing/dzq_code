//
//  PersonalInfoViewController.m
//  dzq
//
//  Created by chentianyu on 16/4/13.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "PersonalInfoPopView.h"
#import "UIImage+ResizeImage.h"

@interface PersonalInfoViewController ()<PopViewDelegate>
{
    UIImage *initialAvatarImage;
}

@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIButton  *avatarImageView;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UIButton *settingButton;

//UIImagePicker;
@property(nonatomic,strong)NSArray *array;
@property BOOL isShow;
@property(nonatomic,strong)PersonalInfoPopView *popView;

@end

@implementation PersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化头像
    AppInfo *appInfo = [AppInfo getInstance];
    NSString *avatarStr = appInfo.usermodel.avatar;
    if ((NSObject*)avatarStr == [NSNull null] || avatarStr == nil) {
        initialAvatarImage = [UIImage imageNamed:@"defaultAvatar"];
    }else{
        NSString *URLString = [IMAGEDOMAIN stringByAppendingString:avatarStr];
        NSURL *URL = [NSURL URLWithString:URLString];
        initialAvatarImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
    }
    
    //PopView
    [self addsubView];
    self.array = [[NSArray alloc] initWithObjects:@"拍照",@"从相册选择", nil];
    
    
    self.isShow = false;
    


    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addsubView
{
    __weak typeof(self) weakSelf = self;
    self.headerView = [[UIView alloc] init];
    UIColor *back_color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_background"]];
    self.headerView.backgroundColor = back_color;

    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(0);
        make.left.equalTo(weakSelf.view.mas_left).with.offset(0);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(0);
        make.height.mas_equalTo(@300);
    }];
   
    //头像视图
    self.avatarImageView = [[UIButton alloc] init];
    
    [self.headerView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.headerView.mas_centerY).with.offset(0);
        make.width.mas_equalTo(@120);
        make.height.mas_equalTo(@120);
    }];
    self.avatarImageView.layer.cornerRadius = 120/2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.avatarImageView.layer.borderWidth = 1.0f;
    [self.avatarImageView setBackgroundImage:initialAvatarImage forState:UIControlStateNormal];
    [self.avatarImageView addTarget:self action:@selector(alertAvatar) forControlEvents:UIControlEventTouchUpInside];
    
    //昵称
    self.nickNameLabel = [[UILabel alloc] init];
    [self.headerView addSubview:self.nickNameLabel];
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).with.offset(10);
        make.left.equalTo(self.headerView.mas_left).with.offset(0);
        make.right.equalTo(self.headerView.mas_right).with.offset(0);
        make.height.mas_equalTo(@40);
    }];
    self.nickNameLabel.text = @"Hello World!";
    self.nickNameLabel.textAlignment = NSTextAlignmentCenter;
    
    //修改设置
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headerView addSubview:self.settingButton];
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_top).with.offset(20);
        make.right.equalTo(self.headerView.mas_right).with.offset(-20);
        make.height.mas_equalTo(@30);
        make.width.mas_equalTo(@30);
    }];
    [self.settingButton setBackgroundImage:[UIImage imageNamed:@"personal_setting"] forState:UIControlStateNormal];
    [self.settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    
    //PopView
    
    
}

- (void)clickSettingButton:(UIButton *)sender
{
    NSLog(@"开始设置");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
 
}
- (void)alertAvatar
{
//    AvatarViewController *avatar = [[AvatarViewController alloc] init];
//    avatar.modalPresentationStyle = UIModalPresentationPopover;
//    avatar.preferredContentSize = CGSizeMake(self.view.frame.size.width/2, 44*2);
//    avatar.popoverPresentationController.sourceView = self.avatarImageView;
//    avatar.popoverPresentationController.sourceRect  = self.avatarImageView.bounds;
//    avatar.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
//    [self presentViewController:avatar animated:YES completion:^(void){
////        [avatar dismissViewControllerAnimated:YES completion:nil];
//        
//    }];
    if (!self.isShow) {
        self.isShow = true;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.popView =  [[PersonalInfoPopView alloc] initWithFrame:CGRectMake(0, 0, 200, 44*self.array.count+15) direction:Bottom stachView:self.avatarImageView items:self.array];
            self.popView.backgroundColor = [UIColor whiteColor];
            self.popView.delegate = self;//实现委托
            [self.headerView addSubview:self.popView];
        });
        
        
        

    }else{
        self.isShow = false;
        [self.popView removeFromSuperview];
    }
}

- (void)itemSelected:(int)index
{
    
    NSLog(@"%@",[self.array objectAtIndex:(NSUInteger)index]);
    if ([[self.array objectAtIndex:(NSUInteger)index] isEqualToString:@"拍照"]) {   //相机
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;

            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
            
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:imagePicker animated:YES completion:^(void){
                [self alertAvatar];
            }];
        }else{
            [self baseHUDWithOnlyLabel:[[UIApplication sharedApplication] keyWindow] withText:@"照相机不可用"];
        }
        
    }else if ([[self.array objectAtIndex:(NSUInteger)index] isEqualToString:@"从相册选择"]){  //相簿
        
        UIImagePickerController *imagePicker;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            imagePicker.showsCameraControls = YES;
            imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
            
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:imagePicker animated:YES completion:^(void){
                [self alertAvatar];
            }];
            
        }else{
            [self baseHUDWithOnlyLabel:[[UIApplication sharedApplication] keyWindow] withText:@"相簿无法访问"];
        }
    }
}
#pragma mark - 选择头像后编辑
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *resizeImage = [UIImage resizeImage:image toSize:CGSizeMake(DOCK_ITEM_WIDTH, DOCK_ITEM_HEIGHT)];
    NSData *imageData = UIImagePNGRepresentation(resizeImage);
    NSString *base64StrContent = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength | NSDataBase64EncodingEndLineWithLineFeed];
    NSString *base64Str  = [@"data:image/png;base64," stringByAppendingString:base64StrContent];
    
    RequestApi *request = [RequestApi shareInstance];
    AppInfo *appInfo = [AppInfo getInstance];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:appInfo.token,@"token",base64Str,@"photo", nil];
    [request user_avatarWithURLString:USER_avatar method:POST parameters:dic successBlock:^(id result) {
        if (request.msgCode == 1) {
            NSString *backImageURL = [result objectForKey:@"url"];
            NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEDOMAIN,backImageURL]];
            
            DDLogInfo(@"the photo url:%@",URL);
            appInfo.usermodel.avatar = backImageURL;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SetAvatarImage" object:nil];
            
            [self.avatarImageView setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:URL]] forState:UIControlStateNormal];
        }else if (request.msgCode == 0){
            [self baseHUDWithOnlyLabel:[UIApplication sharedApplication].keyWindow withText:@"请向我们反馈"];
        }else if (request.msgCode == 2){
            [self baseHUDWithOnlyLabel:[[UIApplication sharedApplication] keyWindow] withText:@"用户token有误"];
        }
    } failureBlock:^(NSString *message) {
        [self baseHUDWithOnlyLabel:[UIApplication sharedApplication].keyWindow withText:@"请向我们反馈"];
    }];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) { //如果是相机，保存图片到本地
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

//用户取消选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"图像选择器将要显示");
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"图像选择器显示结束");
    
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [self baseHUDWithOnlyLabel:[[UIApplication sharedApplication] keyWindow] withText:@"保存图片失败"];
    }else{
        [self baseHUDWithOnlyLabel:[[UIApplication sharedApplication] keyWindow] withText:@"保存图片成功"];
    }
}

//- (BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
//}

@end

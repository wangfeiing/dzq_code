//
//  ListenPracticeViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "ListenPracticeViewController.h"


@interface ListenPracticeViewController ()
@property (nonatomic, assign)RangeType range;
@property (nonatomic, assign)PolyphoneType polyphone;

@end

@implementation ListenPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _range = RangeTypeC4;
    _polyphone = PolyphoneTypeMonophone;
    
}


#pragma mark - Action Event

- (IBAction)selectRange:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    [self selectRangeWithButtonTag:button.tag];
    
}

- (void)selectRangeWithButtonTag:(NSInteger)tag{
    
    UIButton *button = [self.view viewWithTag:tag];
    
    if (button.selected) {
        return;
    }
    
    UIButton *selectButton = [self.view viewWithTag:_range+5];
    selectButton.selected = !selectButton.selected;
    [selectButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Range%lu",_range]] forState:UIControlStateNormal];

    _range = tag - 5;
    
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"RangeSelect%lu",_range]] forState:UIControlStateNormal];
    

    
}

- (IBAction)selectPolyphone:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    [self selectPolyphoneWithButtonTag:button.tag];
    
}



//-(void)clickStartPractice:(UIButton * )startPractice{
//    PracticeViewController * pvc = [[PracticeViewController alloc] init];
//
//
//     [self.prtViewController presentViewController:pvc animated:YES completion:nil];
//
//}
- (void)selectPolyphoneWithButtonTag:(NSInteger)tag{
    
    UIButton *button = [self.view viewWithTag:tag];
    
    if (button.selected) {
        return;
    }
    
    UIButton *selectButton = [self.view viewWithTag:_polyphone+1];
    selectButton.selected = !selectButton.selected;
    [selectButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Polyphone%lu",_polyphone]] forState:UIControlStateNormal];
    
    _polyphone = tag - 1;
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"PolyphoneSelect%lu",_polyphone]] forState:UIControlStateNormal];
    
    

}

- (IBAction)startPractice:(id)sender {
    
    PracticeViewController *practiceVC = [[PracticeViewController alloc] init];
    practiceVC.polyphone = self.polyphone;
    practiceVC.range = self.range;
    [self.superViewController presentViewController:practiceVC animated:YES completion:nil];
    
}

@end

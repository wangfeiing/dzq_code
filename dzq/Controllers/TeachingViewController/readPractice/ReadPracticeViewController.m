//
//  ReadPracticeViewController.m
//  dzq
//
//  Created by chentianyu on 16/1/25.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "ReadPracticeViewController.h"

@interface ReadPracticeViewController ()
@property (nonatomic, assign) PolyphoneType polyphoneType;//复音
@property (nonatomic, assign) StaffType staffType;
@property (nonatomic, assign) NSInteger keySignatureNumber;
@end

@implementation ReadPracticeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    
    //谱表 staff
    self.staffType = StaffTypeTreble;
    
    
    //调号
    self.keySignatureNumber = 1;
    
    
    //复音 polyphone
    self.polyphoneType = PolyphoneTypeMonophone;


    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





// 选择复音

- (void)selectPolyphoneWithButtonTag:(NSInteger)tag{
    UIButton *button = [self.view viewWithTag:tag];
    
    if (button.selected) {
        return;
    }

    
    UIButton *selectButton = [self.view viewWithTag:self.polyphoneType+1];
    selectButton.selected = !selectButton.selected;
    [selectButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Polyphone%lu",(unsigned long)self.polyphoneType]] forState:UIControlStateNormal];
    
    
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"PolyphoneSelect%lu",(unsigned long)tag-1]] forState:UIControlStateNormal];
    self.polyphoneType = tag - 1;
    
}

- (void)selectWithPolyphoneType:(PolyphoneType)polyphoneType{
    [self selectPolyphoneWithButtonTag:polyphoneType+1];
}

- (IBAction)selectPolyphone:(id)sender{
    UIButton *btn = sender;
    [self selectPolyphoneWithButtonTag:btn.tag];
}





// 选择谱表

- (void)selectStaffWithButtonTag:(NSInteger)tag{
    
    UIButton *button = [self.view viewWithTag:tag];
    
    if (button.selected) {
        return;
    }

    
    
    UIButton *selectedButton = [self.view viewWithTag:self.staffType+5];
    selectedButton.selected = !selectedButton.selected;
    [selectedButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"StaffImage%lu",(unsigned long)self.staffType]] forState:UIControlStateNormal];
    
    
    button.selected = !button.selected;
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"StaffSelectImage%lu",(unsigned long)tag-5]] forState:UIControlStateNormal];
    self.staffType = tag - 5;
}

- (void)selectWithStaffType:(StaffType)staffType{
    
    [self selectStaffWithButtonTag:staffType+5];
    
}

- (IBAction)selectStaff:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    [self selectStaffWithButtonTag:button.tag];
    
}






// 选择调号

- (void)selectKeySignatureWithButtonTag:(NSInteger)tag{
    
    UIButton *button = [self.view viewWithTag:tag];
    
    if (button.selected) {
        
        if (self.keySignatureNumber == 1) {
            return;
        }
        
        self.keySignatureNumber--;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"KeySignature%lu",(unsigned long)button.tag-8]] forState:UIControlStateNormal];
    }else{
        self.keySignatureNumber++;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"KeySignatureSelect%lu",(unsigned long)button.tag-8]] forState:UIControlStateNormal];
    }
    button.selected = !button.selected;

    
}

- (void)selectWithKeySignature:(KeySignatureType)type{
    
    [self selectStaffWithButtonTag:type + 8];
    
}

- (IBAction)selectKeySignature:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    [self selectKeySignatureWithButtonTag:button.tag];
    
}


// 选择所有调号
- (IBAction)selectAll:(id)sender {
    
    int keySignatureList[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 18, 23};
    
    for (int i=0; i<15; i++) {
        UIButton *button = [self.view viewWithTag:keySignatureList[i]+8];
        
        if (button.selected) {
            continue;
        }
        
        [self selectKeySignatureWithButtonTag:button.tag];
    }
}

// 取消全选
- (IBAction)deselect:(id)sender {
    
    int keySignatureList[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 18, 23};

    
    for (int i=14; i>=0; i--) {
        UIButton *btn = [self.view viewWithTag:keySignatureList[i]+8];

        if (!btn.selected) {
            continue;
        }
        
        [self selectKeySignatureWithButtonTag:btn.tag];
    }
    
}



// 开始练习
- (IBAction)startPractice:(id)sender {
    
    NSMutableArray *keySignatures = [[NSMutableArray alloc] init];
    int keySignatureList[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 18, 23};
    for (int i=0; i<15; i++) {
        UIButton *btn = [self.view viewWithTag:keySignatureList[i]+8];
        if (btn.selected) {
            [keySignatures addObject:[NSNumber numberWithInteger:btn.tag-8]];
        }
    }
    
    StartPracticeViewController *startPracticeVC = [[StartPracticeViewController alloc] init];

    startPracticeVC.staffType = self.staffType;
    startPracticeVC.polyphoneType = self.polyphoneType;
    startPracticeVC.keySignatures = keySignatures;
    
    
    [self.superController presentViewController:startPracticeVC animated:YES completion:nil];
}



@end

//
//  Key.m
//  dzq
//
//  Created by 梁伟 on 16/2/20.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#import "KeyboardScrollView.h"
//#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
//#define WHITE_KEY_WIDTH SCREEN_WIDTH/52
//#define WHITE_KEY_HEIGH 80
//#define BLACK_KEY_WIDTH WHITE_KEY_WIDTH*0.7
//#define BLACK_KEY_HEIGH 50


static const CGFloat whiteKeyHeigh = 80;
static const CGFloat blackKeyHeigh = 50;
static const CGFloat blackKeyMultiple = 0.7;
static const CGFloat whiteKeyNumber = 52;
static const CGFloat selectNumber = 14;


@interface Key : UIView
@property (strong, nonatomic) UIColor *color;
@end

@implementation Key

@end



@interface KeyboardScrollView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UICollectionView *maskView;

@end
@implementation KeyboardScrollView

- (instancetype)initWithFrame:(CGRect)frame keyNumber:(NSInteger)number{
    self.keyInScreen = number;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initMaskView];
        
    }
    return self;
}


- (void)initMaskView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    

    self.maskView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    [self initBackgroundView];
    self.maskView.backgroundView = self.bgView;
    self.maskView.bounces = NO;
    self.maskView.showsHorizontalScrollIndicator = NO;
    self.maskView.showsVerticalScrollIndicator = NO;
    
    
    [self.maskView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"centerCell"];
    [self.maskView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"maskCell"];
    self.maskView.delegate = self;
    self.maskView.dataSource = self;
    [self addSubview:self.maskView];
    
    
}


- (void)initBackgroundView{
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat whiteKeyWidth = screenWidth / whiteKeyNumber;
    CGFloat blackKeyWidth = whiteKeyWidth * blackKeyMultiple;
    
    
    self.bgView = [[UIView alloc] initWithFrame:self.maskView.bounds];
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PianoKeyNote.plist" ofType:nil] ];
    
    
    NSArray *whiteKeyNotes = [dic objectForKey:@"WhiteKeyNotes"];
    
    
    for (int i=0; i<whiteKeyNotes.count; i++) {
        
        Key *key = [[Key alloc] initWithFrame:CGRectMake(i*whiteKeyWidth, 0, whiteKeyWidth, whiteKeyHeigh)];
        key.backgroundColor = [UIColor whiteColor];
        key.layer.borderWidth = 0.5;
        key.layer.borderColor = [UIColor blackColor].CGColor;
        key.color = key.backgroundColor;
        key.tag = [whiteKeyNotes[i] integerValue];
        
        [self.bgView addSubview:key];
        

    }
    
    
    
    NSArray *blackKeyNotes = [dic objectForKey:@"BlackKeyNotes"];
    
    
    for (int i=0; i<blackKeyNotes.count; i++) {
        
        NSInteger tag = [blackKeyNotes[i] integerValue];

        Key *rightWhiteKeyView = [self.bgView viewWithTag:tag+1];
        

        CGRect frame = rightWhiteKeyView.frame;
        Key *key = [[Key alloc] initWithFrame:CGRectMake(frame.origin.x-blackKeyWidth/2, 0, blackKeyWidth, blackKeyHeigh)];
        key.backgroundColor = [UIColor blackColor];
        key.color = key.backgroundColor;
        key.tag = tag;

        
        [self.bgView addSubview:key];
        
    }
    
}

#pragma mark - Setter or Getter

- (CGFloat)maskViewOpacity{
    if (_maskView) {
        return 0.2;
    }
    return _maskViewOpacity;
}


#pragma mark - Scrolled

- (void)scrollTWidthPoint:(CGPoint)point{
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width/whiteKeyNumber;
    NSInteger index = round(point.x/width);
    [self scrollToIndex:index];
    
}

- (void)scrollToIndex:(NSInteger)index{
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat keyWidth = screenWidth/whiteKeyNumber;
    
    [self.maskView setContentOffset:CGPointMake(index*keyWidth, 0) animated:YES];
    // 该方法会触发 ScrollView 的代理方法
}

#pragma mark - TouchDown

-(void)touchWithViewTag:(NSInteger)tag touchDown:(BOOL)down{
    
    
    Key *keyView = [self.bgView viewWithTag:tag];

    
    if (down) {
        
        keyView.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:0.58 alpha:1];
        
    }else {
        
        [keyView setBackgroundColor:keyView.color];
        
    }
    
    
}


#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"centerCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
        
    }else{
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"maskCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor blackColor];
        cell.alpha = self.maskViewOpacity;
        return cell;
        
    }
    
}


#pragma mark - UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGFloat width = self.frame.size.width;
    CGFloat whiteKeyWidth = width / whiteKeyNumber;
    
    if (indexPath.row == 1) {
        return CGSizeMake(whiteKeyWidth * selectNumber, whiteKeyHeigh);
    }else{
        return CGSizeMake(width - whiteKeyWidth * selectNumber, whiteKeyHeigh);
    }
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    

    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardScrollViewDidScrolled:)]) {
        
        CGFloat whiteKeyWidth = self.frame.size.width / whiteKeyNumber;
        
        CGFloat offset_x = (whiteKeyNumber - selectNumber) * whiteKeyWidth - scrollView.contentOffset.x;
        
        [self.delegate keyboardScrollViewDidScrolled:CGPointMake(offset_x*whiteKeyNumber/selectNumber, 0)];
        
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    if (!decelerate) { // drag 后无减速动画
        
        [self scrollTWidthPoint:scrollView.contentOffset];
        
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 有减速动画,此时停止减速
    
    [self scrollTWidthPoint:scrollView.contentOffset];
    
}

@end

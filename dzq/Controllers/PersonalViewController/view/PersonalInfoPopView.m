//
//  PopView.m
//  PopView
//
//  Created by chentianyu on 15/12/11.
//  Copyright © 2015年 chentianyu. All rights reserved.
//

#import "PersonalInfoPopView.h"

@implementation PersonalInfoPopView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //矩形中三角形外为白色
    [[UIColor whiteColor] set];
    UIRectFill(self.bounds);
    
    
    //绘制三角形
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    NSDictionary *dic = [self trianglePoint];
    

    CGPoint startPoint = [[dic objectForKey:@"startPointKey"]CGPointValue];
    CGPoint nextPoint = [[dic objectForKey:@"nextPointKey"] CGPointValue];
    CGPoint endPoint = [[dic objectForKey:@"endPointKey"] CGPointValue];
    
    CGContextMoveToPoint(context, startPoint.x,startPoint.y);
    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextClosePath(context);
    

    
//    [[UIColor yellowColor] setStroke];//设置三角形的描边颜色

    [ThemeColor setFill];//设置三角形的填充颜色
    
    CGContextDrawPath(context, kCGPathFill);

}

//确定三角形的三个点的位置
- (NSDictionary *)trianglePoint
{
    NSDictionary *dic;
    NSString *startPointKey = @"startPointKey";
    NSString *nextPointKey = @"nextPointKey";
    NSString *endPointKey = @"endPointKey";
    CGPoint startPoint;
    CGPoint nextPoint;
    CGPoint endPoint;
    
    
    switch (self.direc) {
        case Top:
            startPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
            nextPoint = CGPointMake(startPoint.x-15, startPoint.y-15);
            endPoint = CGPointMake(startPoint.x+15, startPoint.y-15);
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithCGPoint:startPoint],startPointKey,[NSValue valueWithCGPoint:nextPoint],nextPointKey,[NSValue valueWithCGPoint:endPoint],endPointKey, nil];
            break;
        case Bottom:
            startPoint = CGPointMake(self.bounds.size.width/2, 0);
            nextPoint = CGPointMake(startPoint.x-15, startPoint.y+15);
            endPoint = CGPointMake(startPoint.x+15, startPoint.y+15);
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithCGPoint:startPoint],startPointKey,[NSValue valueWithCGPoint:nextPoint],nextPointKey,[NSValue valueWithCGPoint:endPoint],endPointKey, nil];
            
            break;
        case Left:
            startPoint = CGPointMake(self.bounds.size.width, 15);
            nextPoint = CGPointMake(startPoint.x-15, startPoint.y+15);
            endPoint = CGPointMake(startPoint.x-15, startPoint.y-15);
           dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithCGPoint:startPoint],startPointKey,[NSValue valueWithCGPoint:nextPoint],nextPointKey,[NSValue valueWithCGPoint:endPoint],endPointKey, nil];
            
            break;
        case Right:
            startPoint = CGPointMake(0, 15);
            nextPoint = CGPointMake(startPoint.x+15, 0);
            endPoint = CGPointMake(startPoint.x+15, startPoint.y+15);
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSValue valueWithCGPoint:startPoint],startPointKey,[NSValue valueWithCGPoint:nextPoint],nextPointKey,[NSValue valueWithCGPoint:endPoint],endPointKey, nil];
            
            break;
            
        default:
            break;
    }
    return dic;
}






- (instancetype)initWithFrame:(CGRect)frame direction:(UIPopViewDirection)direction stachView:(UIView *)stachView  items:(NSArray *)items
{

    self = [super initWithFrame:frame];
    if (self) {

        

        
        self.contentMode = UIViewContentModeRedraw;
//        self.backgroundColor = [UIColor whiteColor];
 
        self.startingView = stachView;
        self.item = items;
        self.direc = direction;
        self.frame = [self menuViewFrame:frame direction:direction view:stachView];
        
        
        self.tableView = [[UITableView alloc] init];
        self.tableView.tableHeaderView.frame = CGRectZero;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.tableFooterView.frame = CGRectZero;
//        self.tableView.backgroundColor = TABLEVIEWCOLOR;
        self.tableView.layer.cornerRadius = 5.0;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.frame = [self tableViewFrame:direction];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.scrollEnabled = [self scrollEnable:self.tableView.frame];
        [self addSubview:self.tableView];
        
    }

  
    return self;
}


//根据方向确定弹出视图的位置
- (CGRect)tableViewFrame:(UIPopViewDirection)direc
{
    CGRect temp;
    switch (direc) {
        case Top:
            temp = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-15);
            break;
        case Bottom:
            temp = CGRectMake(0, 15, self.bounds.size.width, self.bounds.size.height-15);
            break;
        case Left:
            temp = CGRectMake(0, 0, self.bounds.size.width-15, self.bounds.size.height);
            break;
        case Right:
            temp = CGRectMake(15, 0, self.bounds.size.width, self.bounds.size.height-15);
            break;
        default:
            break;
    }
    return temp;
}

//是否可以滚动
- (BOOL)scrollEnable:(CGRect) fra
{
    
    BOOL temp ;
    if(self.item.count*44.0>fra.size.height){
        temp = true;
    }else{
        temp = false;
    }
    return temp;
}

//MenuView
- (CGRect)menuViewFrame:(CGRect)frame direction:(UIPopViewDirection)direction view:(UIView *)startingView
{
    CGRect menuViewFrame;
    CGPoint center = startingView.center;
    CGSize size = startingView.bounds.size;
    CGFloat x;
    CGFloat y;
    
    switch (direction) {
        case Top:
            
            x = center.x - frame.size.width/2;
            y = center.y-size.height/2-frame.size.height;
            menuViewFrame = CGRectMake(x,y, frame.size.width, frame.size.height);
            break;

        case Bottom:
            x = center.x - frame.size.width/2;
            y = center.y+size.height/2;
            menuViewFrame = CGRectMake(x,y, frame.size.width, frame.size.height);
            break;
        case Left:
            x = center.x - frame.size.width-size.width/2;
            y = center.y-size.height/2;
            menuViewFrame = CGRectMake(x,y, frame.size.width, frame.size.height);
            break;
        case Right:
            x = center.x + size.width/2;
            y = center.y-size.height/2;
            menuViewFrame = CGRectMake(x,y, frame.size.width, frame.size.height);
            break;
    }
    return menuViewFrame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"cell";
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        
    }
    cell.backgroundColor = ThemeColor;///[UIColor whiteColor];//设置单元格的背景颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.item[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];//RGBA(58, 137, 244, 1.0f); //[UIColor whiteColor];
    [cell setNeedsDisplay];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate itemSelected:(int)indexPath.row];
}

@end

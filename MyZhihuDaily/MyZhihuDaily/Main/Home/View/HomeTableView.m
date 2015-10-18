//
//  HomeTableView.m
//  MyZhihuDaily
//
//  Created by oahgnehzoul on 15/9/7.
//  Copyright (c) 2015年 oahgnehzoul. All rights reserved.
//

#import "HomeTableView.h"
#import "HomeTableViewCell.h"
#import "storyModel.h"
#import "DetailViewController.h"
#import "HomeViewController.h"
#import "UIView+UIViewController.h"
#import "DataService.h"
#import "UIView+UIViewController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "HomeHeaderViewCell.h"
#import "HomeHeaderView.h"
@implementation HomeTableView
{
    NSMutableArray *rowArray;
//    int i;
    NSInteger i;
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initViews];
    }
    return self;
}



- (void)_initViews {
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[HomeTableViewCell class] forCellReuseIdentifier:@"cell"];
}



- (void)setDataDicArray:(NSArray *)dataDicArray {
    _dataDicArray = dataDicArray;
//    NSLog(@"%@",dataDicArray);
    rowArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dataDicArray) {
       
//        NSInteger count = dic[@"array"].count;
        NSArray *countArray = dic[@"array"];
        NSNumber *count = [NSNumber numberWithInteger:countArray.count];
        [rowArray addObject:count];
//        NSLog(@"%@",rowArray);
    }
    [self reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

//    return self.storyModelArray.count;
    NSArray *array = [self.dataDicArray[section] objectForKey:@"array"];
    return array.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.dataDicArray[indexPath.section] objectForKey:@"array"];
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    cell.model = array[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];


    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *vc = [[DetailViewController alloc] init];
    NSArray *modelArray = [self.dataDicArray[indexPath.section] objectForKey:@"array"];
    storyModel *model = modelArray[indexPath.row];
    vc.newsId = model.idStr;
    NSLog(@"%@",vc.newsId);
//    vc.dataArray = [self.dataDicArray[indexPath.section] objectForKey:@"array"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (storyModel *model in modelArray) {
        NSString *newsId = model.idStr;
        [array addObject:newsId];
    }
    vc.newsIdArray = array;
    vc.index = indexPath.row;
//    HomeViewController *homeVC = (HomeViewController *)self.nextResponder.nextResponder;
    HomeViewController *homeVC = (HomeViewController *)self.viewController;
    [homeVC presentViewController:vc animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (_dateArray) {
//        return _dateArray.count+1;
//    }
//    return 1;
    return self.dataDicArray.count;
}
//日期显示

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }else {
        UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 40)];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateView.bounds];
        dateLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mask_titlebar64@2x"]];
//        dateLabel.backgroundColor = [UIColor blueColor];
        NSString *date = [self.dataDicArray[section] objectForKey:@"date"];
        dateLabel.text = [self dateWithString:date];

        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor whiteColor];
        [dateView addSubview:dateLabel];

       
        
        return dateView;
    }
}


- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }else {
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (NSString *)dateWithString:(NSString *)string{
    NSString *formatStr = @"yyyyMMdd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatStr;
    NSDate *date = [formatter dateFromString:string];
//#warning 打印
//    NSLog(@"%@",[self weekdayStringFromDate:date]);
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM月dd日"];
    NSString *dateString = [formatter1 stringFromDate:date];
    NSString *fullStr = [dateString stringByAppendingString:[self weekdayStringFromDate:date]];
    return fullStr;
    
    
}
//得到要改变日期的偏移量数组
- (NSArray *)offYarray{
    
    NSInteger offy = 220-64-64;
    NSMutableArray *offyArray = [[NSMutableArray alloc] init];
    for (i = 0 ; i< rowArray.count; i++) {
        offy+= ([rowArray[i] integerValue]*80+40);
        [offyArray addObject:[NSNumber numberWithInteger:offy]];
    }
    
    return (NSArray *)offyArray;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
//    NSLog(@"%f",offY);
//    NSLog(@"count:%ld",rowArray.count);
//    NSLog(@"array:%@",[self offYarray]);
//    NSLog(@"%f",alpha);
    UIColor *color = [UIColor colorWithRed:0 green: 175/255.0 blue:240/255.0 alpha:1];
    CGFloat alpha = (offY + 64)/156;
    [self.viewController.navigationController.navigationBar hzl_setBackgourndColor:[color colorWithAlphaComponent:alpha]];
//    if (offY < 0) {
//        HomeHeaderView *view = self.tableHeaderView;
//        UIImageView *imgView = view.imgView;
//        NSLog(@"%@",imgView);
//        
//    }
//    if (offY <= -64) {
//        CGFloat newHeight = -offY - 64 +200;
////        self.tableHeaderView.frame = CGRectMake(0, 0, KWidth, newHeight);
//    }
//    self.tableHeaderView.bottom = self.top;
//    if (offY <= -64) {
//        self.tableHeaderView.frame = CGRectMake(0, 0, KWidth, -offY-64+200);
//    }
//    UIView *view = self.tableHeaderView;
//    NSLog(@"%f %f",view.frame.size.width,view.size.height);
    
    NSArray *offArray = [self offYarray];
    if (offArray.count > 1) {
        
        for ( i = 0; i < offArray.count - 1; i++) {
            if (offY >= [offArray[i] integerValue] && offY <= [offArray[i+1] integerValue]) {
//                if (offY >= ([offArray[0] integerValue]+[offArray[1] integerValue] )) {
//                    [self setNavigationBarTransformProgress:1];
//                }
                NSDictionary *dic = self.dataDicArray[i+1];
                NSString *date = dic[@"date"];
                NSString *text = [self dateWithString:date];
                self.viewController.navigationItem.title = text;
            }else if (offY <= [offArray[0] integerValue]) {
                self.viewController.navigationItem.title = @"今日热闻";
            }
        }
    

    }
}
- (void)setNavigationBarTransformProgress:(CGFloat)progress
{
    [self.viewController.navigationController.navigationBar hzl_setTranslationY:(-44 * progress)];
    [self.viewController.navigationController.navigationBar hzl_setEementsAlpha:(1-progress)];
}



@end

//
//  ZDHomeViewController.h
//  MyZhihuDaily
//
//  Created by oahgnehzoul on 16/9/17.
//  Copyright © 2016年 oahgnehzoul. All rights reserved.
//

#import "SBTableViewController.h"

@interface ZDHomeViewController : SBTableViewController

- (NSString *)getPreviousStoryIdWithCurrentId:(NSString *)currentId;

- (NSString *)getNextStoryIdWithCurrentId:(NSString *)currentId;


@end

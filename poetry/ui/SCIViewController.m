//
//  SCIViewController.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "SCIViewController.h"

@interface SCIViewController ()

@end

@implementation SCIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"宋词";
}

-(NSArray *)getByPage:(int)page withDBManager:(DBManager *)dbManager{
    return [dbManager getCiByPage:page];
}

- (NSArray *)searchBy:(NSString *)search withDBManager:(DBManager *)dbManager{
    return [dbManager searchCi:search];
}
@end

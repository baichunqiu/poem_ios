//
//  TagSearchViewController.m
//  poetry
//
//  Created by 白春秋 on 2019/9/26.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "TagSearchViewController.h"

@interface TagSearchViewController ()
@property (nonatomic, strong)UIButton *backBut;
@end

@implementation TagSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  self.tag;
    [self createBackButton];
}

-(void)createBackButton{
    self.backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, KTabBarHeight, 40, KNavBarHeight-KTabBarHeight)];
    [self.backBut setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBut addTarget:self action:@selector(backButClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnitem = [[UIBarButtonItem alloc] initWithCustomView:self.backBut];
    self.navigationItem.leftBarButtonItem = leftBtnitem;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}


-(void)backButClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSArray *)getByPage:(int)page withDBManager:(DBManager *)dbManager{
    return [dbManager searchByTag:self.tag];
}

- (NSArray *)searchBy:(NSString *)search withDBManager:(DBManager *)dbManager{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *temp = [dbManager searchByTag:self.tag];
    if (temp && temp.count > 0) {
        for (Base *base in temp) {
            if ([base.author containsString:search] || [base.title containsString:search] || [base.txt containsString:search]) {
                [result addObject:base];
            }
        }
    }
    return result;
}
@end

//
//  PoetryViewController.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "PoetryViewController.h"
#import "DBManager.h"
#import "Poem.h"
#import "BasePeomCell.h"
#import "DetailsViewController.h"
@interface PoetryViewController ()<UISearchBarDelegate>


@property(nonatomic,strong) NSMutableArray *data;
@property(nonatomic,assign) int page;
@property(nonatomic,strong) DBManager *dbManager;

@end

@implementation PoetryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"唐诗";
}

-(NSArray *)getByPage:(int)page withDBManager:(DBManager *)dbManager{
    return [dbManager getPoemByPage:page];
}

- (NSArray *)searchBy:(NSString *)search withDBManager:(DBManager *)dbManager{
    return [dbManager searchPoem:search];
}

@end

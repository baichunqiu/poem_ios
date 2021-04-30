//
//  HomeViewController.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "HomeViewController.h"
#import "PoetryViewController.h"
#import "SCIViewController.h"
#import "TagViewController.h"

//#define MAIN_COLOR   UICOLORFROMRGB(0x4195F8)

@interface HomeViewController()

@property(nonatomic,strong) PoetryViewController *poetryVC;
@property(nonatomic,strong) SCIViewController *sciVC;
@property(nonatomic,strong) TagViewController *tagVC;

@end

@implementation HomeViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self create];
}

-(void)create{
    NSArray *ncArr = @[ [[UINavigationController alloc] initWithRootViewController:self.poetryVC],
                        [[UINavigationController alloc] initWithRootViewController:self.sciVC],
                        [[UINavigationController alloc] initWithRootViewController:self.tagVC]
                    ];
    for (UINavigationController *tempNC in ncArr) {
        [self configNC:tempNC];
    }
    self.viewControllers = ncArr;
}

-(void)configNC:(UINavigationController *)tempNC{
    tempNC.tabBarItem = nil;
    tempNC.navigationBar.barTintColor = MAIN_COLOR;
    tempNC.navigationBar.translucent = NO;
    [tempNC.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:18],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (PoetryViewController *)poetryVC{
    if(!_poetryVC){
        _poetryVC = [[PoetryViewController alloc] init];
        UIImage *image = [UIImage imageNamed:@"home"];
        UIImage *selImage = [UIImage imageNamed:@"home_c"];
        _poetryVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"唐诗" image:image selectedImage:selImage];
        _poetryVC.title = @"唐诗";
    }
    return _poetryVC;
}

- (SCIViewController *)sciVC{
    if(!_sciVC){
        _sciVC = [[SCIViewController alloc] init];
        UIImage *image = [UIImage imageNamed:@"ResourceSelect"];
        UIImage *selImage = [UIImage imageNamed:@"ResourceSelect_c"];
        _sciVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"宋词" image:image selectedImage:selImage];
        _sciVC.title = @"宋词";
    }
    return _sciVC;
}

- (TagViewController *)tagVC{
    if(!_tagVC){
        _tagVC = [[TagViewController alloc] init];
        UIImage *image = [UIImage imageNamed:@"me"];
        UIImage *selImage = [UIImage imageNamed:@"me_c"];
        _tagVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"标注" image:image selectedImage:selImage];
        _tagVC.title = @"标注";
    }
    return _tagVC;
}

@end

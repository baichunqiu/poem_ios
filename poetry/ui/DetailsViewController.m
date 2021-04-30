//
//  DetailsViewController.m
//  poetry
//
//  Created by 白春秋 on 2019/9/26.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "DetailsViewController.h"
#import "Author.h"
#import "DBManager.h"

@interface DetailsViewController ()
@property (nonatomic, strong)UIButton *backBut;
@property (nonatomic, strong)UIButton *rightBut;
@property (nonatomic, strong)UIScrollView *scrollView;

@property (nonatomic,strong)UILabel *lbTag;
@property (nonatomic,strong)UILabel *lbTitle;
@property (nonatomic,strong)UILabel *lbTxt;
@property (nonatomic,strong)UILabel *lbAuthor;

@property(nonatomic,strong)Author *author;
@property(nonatomic,strong)DBManager *manager;

@end

@implementation DetailsViewController

- (DBManager *)manager{
    if (!_manager) {
        _manager = [[DBManager alloc] init];
        [_manager openDatabase];
    }
    return _manager;
}

- (Author *)author{
    if (!_author && [TYPE_CI isEqualToString:self.data.type]) {
        _author = [self.manager getAuthorByName:self.data.author];
    }
    return _author;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.data.title;
    
    [self createNavigationButton];
    //title
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, KScreenWidth - 40, 30)];
    self.lbTitle .textAlignment = NSTextAlignmentCenter;
    self.lbTitle .textColor = UIColor.blackColor;
    self.lbTitle .font = kFont(17);
    self.lbTitle.text = self.data.author;
    //tag
    self.lbTag = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, KScreenWidth - 40, 20)];
    self.lbTag .textAlignment = NSTextAlignmentRight;
    self.lbTag .textColor = UIColor.systemRedColor;
    self.lbTag .font = kFont(15);
    self.lbTag.text = @"无标签";
    
    //测量文字布局size
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 1000)];
    lable.text = [self formaTxtInfo];
    lable.font = kFont(17);
    lable.numberOfLines = 0;
    [lable sizeToFit];
    CGFloat height = lable.frame.size.height;
    CGFloat width = lable.frame.size.width;
    NSLog(@"tex height = %f",height);
    //    NSLog(@"cgrect width = %f",width);
    //txt
    CGFloat x = (KScreenWidth - width) /2;
    self.lbTxt = [[UILabel alloc] initWithFrame:CGRectMake(x, 60, width, height)];
    self.lbTxt.numberOfLines = 0;
    self.lbTxt.font = kFont(17);
    self.lbTxt.textColor = UIColor.systemBlueColor;
    self.lbTxt.textAlignment = NSTextAlignmentLeft;
    
    NSLog(@"type = %@",self.data.type);
    double totalHeitht = 60 + height + 20;
    //author info
    if ([self.data.type isEqualToString:TYPE_CI]) {
        UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(20, 60 + height + 20, KScreenWidth - 40, KScreenHeight)];
        author.font = kFont(14);
        author.numberOfLines = 0;
        author.text = [self formaAuthorInfo];
        [author sizeToFit];
        author.textColor = UIColor.systemGrayColor;
        self.lbAuthor = author;
        CGFloat aheight = author.frame.size.height;
        //        CGFloat awidth = author.frame.size.width;
        NSLog(@"author height = %f",aheight);
        totalHeitht += aheight;
    }
    
    NSLog(@"totalHeight = %f",totalHeitht);
    NSLog(@"KScreenHeight = %f",KScreenHeight);
    NSLog(@"KScreenWidth = %f",KScreenWidth);
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KTabBarHeight)];
    self.scrollView.contentSize = CGSizeMake( KScreenWidth,totalHeitht + KTabBarHeight);
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView addSubview:self.lbTitle];
    [self.scrollView addSubview:self.lbTag];
    [self.scrollView addSubview:self.lbTxt];
    if (self.lbAuthor) {
        [self.scrollView addSubview:self.lbAuthor];
    }
    [self.view addSubview:self.scrollView];
    [self refresh];
}


-(void)createNavigationButton{
    self.backBut = [[UIButton alloc] initWithFrame:CGRectMake(0, KTabBarHeight, 40, KNavBarHeight-KTabBarHeight)];
    [self.backBut setTitle:@"返回" forState:UIControlStateNormal];
    self.backBut.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [self.backBut addTarget:self action:@selector(backButClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnitem = [[UIBarButtonItem alloc] initWithCustomView:self.backBut];
    self.navigationItem.leftBarButtonItem = leftBtnitem;
    
    self.rightBut = [[UIButton alloc] initWithFrame:CGRectMake(0, KTabBarHeight, 50, KNavBarHeight-KTabBarHeight)];
    [self.rightBut setTitle:@"添加标签" forState:UIControlStateNormal];
     self.rightBut.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [self.rightBut addTarget:self action:@selector(rigtButClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnitem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBut];
    self.navigationItem.rightBarButtonItem = rightBtnitem;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
}


-(void)backButClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rigtButClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"添加标签" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^ void (UIAlertAction *action){
        NSString *tag = [[alertController textFields] objectAtIndex:0].text;
        NSLog(@"tag = %@",tag);
        [self.manager updateTag:tag forTable:[self.data.type isEqualToString:TYPE_CI] ? TAB_CI : TAB_POEM andId:self.data.bid];
        if (![tag isEqual:[NSNull null]] && ![@"" isEqualToString:tag]){
            self.data.tag = tag;
            self.lbTag.text = [NSString stringWithFormat:@"标签：%@",tag];
        }
    }];
    [alertController addAction:noAction];
    [alertController addAction: yesAction];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入你想添加的内容";
    }];
    [self presentViewController:alertController animated:true completion:nil];
}

-(void)refresh{
    if (![_data.tag isEqual:[NSNull null]] && ![@"" isEqualToString:_data.tag ]){
        self.lbTag.text = [NSString stringWithFormat:@"标签：%@",self.data.tag];
    }
    NSLog(@"txt = %@",self.data.txt);
    self.lbTxt.text = [self formaTxtInfo];
    if (_lbAuthor) {
        self.lbAuthor.text = [self formaAuthorInfo];
    }
}


-(NSString*)formaTxtInfo{
    NSString *txt = _data.txt;
    if ([self.data.type isEqualToString:TYPE_CI]) {
        txt = [txt stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([txt hasSuffix:@"\n>>\n词牌介绍"]) {
            txt = [txt stringByReplacingOccurrencesOfString:@"\n>>\n词牌介绍" withString:@""];
        }
        return [txt stringByReplacingOccurrencesOfString:@"，" withString:@"，\n"];
    }
    return txt;
}

-(NSString*)formaAuthorInfo{
    if ([self.data.type isEqualToString:TYPE_CI]) {
        NSLog(@"author = %@",self.author.name);
        NSLog(@"des = %@",self.author.describe);
        if(!self.author || [self.author.description isEqual:[NSNull null]] ){
            return [NSString stringWithFormat:@"%@:作者不详。",self.data.author];
        }
        NSString *des = [self.author.describe stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([@"--" isEqualToString:des]) {
            return [NSString stringWithFormat:@"%@:作者不详。",self.data.author];
        }
        if([des hasPrefix:@"--"]){
            des = [des stringByReplacingOccurrencesOfString:@"--" withString:self.author.name];
        }
        return [des stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return @"";
}
@end

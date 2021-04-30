//
//  BaseTableViewControler.m
//  poetry
//
//  Created by 白春秋 on 2019/9/25.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "BaseTableViewControler.h"


#import "Poem.h"
#import "BasePeomCell.h"
#import "DetailsViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "WHToast.h"
@interface BaseTableViewControler ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong) NSMutableArray *data;
@property(nonatomic,assign) int page;
@property(nonatomic,strong) DBManager *dbManager;

@end

@implementation BaseTableViewControler

//table refresh 事件
-(void)onRefresh{
    self.page = 0;
    [self getDataFromDB];
}

//table load more 事件
-(void)onLoad{
    self.page ++;
    [self getDataFromDB];
}

//获取数据
-(void)getDataFromDB{
    NSArray *curData = [self getByPage:self.page withDBManager:self.dbManager];
    [self refreshData:curData withStatue:self.page == 0];
    [self endRefresh];
}

//刷新数据
-(void)refreshData:(NSArray*)curData withStatue:(BOOL)refresh{
    if (nil == curData || curData.count == 0) {
        [WHToast showErrorWithMessage:@"没有数据" originY:0 duration
        :1 finishHandler:^{
          NSLog(@"省略n行代码");
        }];
        return;
    }
    if (refresh) {
      [self.data removeAllObjects];
    }
    [self.data addObjectsFromArray:curData];
    [self.tableView reloadData];
    
}

//终止刷新动画
-(void)endRefresh{
    if([self.tableView.mj_header isRefreshing]){
        [self.tableView.mj_header endRefreshing];
    }
    if([self.tableView.mj_footer isRefreshing]){
        [self.tableView.mj_footer endRefreshing];
    }
}

//设置SearchBar的背景色
-(void)resetSearchBar:(UISearchBar*) _searchBar forColor:(UIColor*)color{
    for(int i =  0;i <_searchBar.subviews.count;i++){
        UIView* backView =_searchBar.subviews[i];
        if([backView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] ==YES) {
            [backView removeFromSuperview];
            break;
        }else{
            NSArray* arr =_searchBar.subviews[i].subviews;
            for(int j =0;j < arr.count;j++){
                UIView* barView = arr[j];
                if([barView isKindOfClass:NSClassFromString(@"UISearchBarBackground")] ==YES) {
                    [barView removeFromSuperview];
                    break;
                }
            }
        }
    }
}

//SearchBar点击搜索事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchInfo = searchBar.text;
    searchBar.text = @"";
    NSLog(@"searchInfo = %@",searchInfo);
    [self.view endEditing:YES];
    NSArray *searchData = [self searchBy:searchInfo withDBManager:self.dbManager];
    [self refreshData:searchData withStatue:YES];
}


//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [activityView startAnimating];
//    return activityView;
//}

//- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
//    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, KScreenWidth - 40, 30)];
//    lbTitle.textAlignment = NSTextAlignmentCenter;
//    lbTitle.textColor = UIColor.blackColor;
//    lbTitle.textColor = UIColor.redColor;
//    lbTitle.text = @"没有数据";
//    lbTitle.font = kFont(14);
//    return lbTitle;
//}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    NSLog(@"点击了view");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar * bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    bar.placeholder = @"请输入搜索内容";
    [bar setBarStyle:UIBarStyleDefault];
    [bar setDelegate:self];
    
    self.tableView.rowHeight = 60;
    self.tableView.tableHeaderView = bar;
    WS(weakself);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself onRefresh];
    }];

//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [weakself onLoad];
//    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(onLoad)];
    
    self.dbManager = [[DBManager alloc] init];
    [self.dbManager openDatabase];
    self.data = [[NSMutableArray alloc] init];
    //加载数据
    [self onRefresh];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // 加上这行代码后，可以去除tableView多余的线
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark --data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_indentifier = @"cell_id";
    BasePeomCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_indentifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BasePeomCell" owner:nil options:nil] firstObject];
    }
    Base *base = self.data[indexPath.row];
    [cell setData:base];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *details = [[DetailsViewController alloc] init];
    details.data = self.data[indexPath.row];
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:NO];
}


- (NSArray *)getByPage:(int)page withDBManager:(DBManager *)dbManager{
    return nil;
}

- (NSArray *)searchBy:(NSString *)search withDBManager:(DBManager *)dbManager{
    return nil;
}
- (void)viewDidAppear:(BOOL)animated{
    [self onRefresh];
}
@end

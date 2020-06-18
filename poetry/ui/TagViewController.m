//
//  TagViewController.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "TagViewController.h"

#import "DBManager.h"
#import "Poem.h"
#import "BasePeomCell.h"
#import "DetailsViewController.h"
#import "TagSearchViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface TagViewController ()<UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property(nonatomic,strong) NSMutableArray *data;
@property(nonatomic,assign) int page;
@property(nonatomic,strong) DBManager *dbManager;

@end

@implementation TagViewController

-(void)onRefresh{
    self.page = 0;
    [self getDataFromDB];
}

-(void)getDataFromDB{
    //    NSArray *poems = [self.dbManager getPoemByPage:self.page];
    NSArray *tags = [self.dbManager getAllTag];
    [self refreshData:tags withStatue:self.page == 0];
    [self endRefresh];
}

//刷新数据
-(void)refreshData:(NSArray*)curData withStatue:(BOOL)refresh{
    if (refresh) {
        [self.data removeAllObjects];
    }
    [self.data addObjectsFromArray:curData];
    [self.tableView reloadData];
//    if(self.data.count == 0){
//        self.tableView.hidden = YES;
//    }else{
//        self.tableView.hidden = NO;
//    }
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
    _searchBar.backgroundColor = color;
}

//SearchBar点击搜索事件
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchInfo = searchBar.text;
    searchBar.text = @"";
    NSLog(@"searchInfo = %@",searchInfo);
    [self.view endEditing:YES];
    NSArray *tags = [self.dbManager searchTag:searchInfo];
    [self refreshData:tags withStatue:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UISearchBar * bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
//    [self resetSearchBar:bar forColor:RGB(0xef, 0xef, 0xf4)];
    
    bar.placeholder = @"请输入搜索内容";
    [bar setBarStyle:UIBarStyleDefault];
    [bar setDelegate:self];
    
    self.tableView.rowHeight = 60;
    self.tableView.tableHeaderView = bar;
    WS(weakself);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself onRefresh];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself onRefresh];
    }];
    
    self.title = @"标签";
    self.dbManager = [[DBManager alloc] init];
    [self.dbManager openDatabase];
    self.data = [[NSMutableArray alloc] init];
    //加载数据
    [self onRefresh];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    // 加上这行代码后，可以去除tableView多余的线
    self.tableView.tableFooterView = [UIView new];
//    [self.tableView setEditing:YES animated:YES];
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, KScreenWidth - 40, 30)];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.textColor = UIColor.blackColor;
    lbTitle.textColor = UIColor.redColor;
    lbTitle.text = @"NO DATA";
    lbTitle.font = kFont(14);
    return lbTitle;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    NSLog(@"点击了view");
    [self onRefresh];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//侧滑删除
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tag = self.data[indexPath.row];
    NSLog(@"删除 tag = %@",tag);
    BOOL ok = [self.dbManager deleteTag:tag];
    if (ok) {
        [self.data removeObjectAtIndex:indexPath.row];
        // 与reloadData不同,此方法带动画效果.(参数二为动画类型)
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }else{
        NSLog(@"删除失败： tag = %@",tag);
    }
}

//data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell_indentifier = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_indentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_indentifier];
    }
    NSString *tag  = self.data[indexPath.row];
    [cell.textLabel sizeToFit];
    cell.textLabel.text = @"标签：";
    cell.detailTextLabel.text = tag;
    cell.detailTextLabel.textColor = UIColor.systemRedColor;
    if (cell.gestureRecognizers.count == 0) {
        UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteTag:)];
        [cell addGestureRecognizer:lpress];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TagSearchViewController *details = [[TagSearchViewController alloc] init];
    details.tag = self.data[indexPath.row];
    details.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:details animated:NO];
}

-(void)deleteTag:(UILongPressGestureRecognizer *)longPre{
    
    if (longPre.state ==UIGestureRecognizerStateEnded) {
        UITableViewCell *cell = (UITableViewCell *)longPre.view;
        NSString *tag = cell.detailTextLabel.text;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"确定删除标签%@吗?",tag] preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^ void (UIAlertAction *action){
            NSLog(@"tag = %@",tag);
            [self.dbManager deleteTag:tag];
            //刷新
            [self onRefresh];
        }];
        [alertController addAction:noAction];
        [alertController addAction: yesAction];
        [self presentViewController:alertController animated:true completion:nil];
    }
}

@end


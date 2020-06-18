//
//  BaseTableViewControler.h
//  poetry
//
//  Created by 白春秋 on 2019/9/25.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewControler : UITableViewController

//搜索数据
-(NSArray*)searchBy:(NSString*)search withDBManager:(DBManager*)dbManager;

//分页获取数据
-(NSArray*)getByPage:(int)page withDBManager:(DBManager*)dbManager;
@end

NS_ASSUME_NONNULL_END

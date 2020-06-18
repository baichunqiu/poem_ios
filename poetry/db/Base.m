//
//  Base.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "Base.h"

@implementation Base

- (instancetype)initWithFMResul:(FMResultSet *)resultSet{
    self = [super init];
    if (self && [resultSet isKindOfClass:[FMResultSet class]]) {
        self.bid = [resultSet intForColumn:@"id"];
        self.title = [resultSet objectForColumn:@"title"];
        self.author =[resultSet objectForColumn:@"author"];
        self.txt = [resultSet objectForColumn:@"txt"];
        self.tag =[resultSet objectForColumn:@"tag"];
    }
    return self;
}
@end

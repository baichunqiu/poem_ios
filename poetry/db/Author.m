//
//  Author.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "Author.h"

@implementation Author

- (instancetype)initWithFMResul:(FMResultSet *)resultSet{
    self = [super init];
    if (self && [resultSet isKindOfClass:[FMResultSet class]]) {
        self.aid = [resultSet intForColumn:@"id"];
        self.name = [resultSet objectForColumn:@"name"];
        self.describe =[resultSet objectForColumn:@"describe"];
    }
    return self;
}

+ (instancetype)auhtorWithFMResult:(FMResultSet *)resultSet{
    return [[self alloc] initWithFMResul:resultSet];
}
@end

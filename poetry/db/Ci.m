//
//  Ci.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "Ci.h"

@implementation Ci

- (instancetype)initWithFMResul:(FMResultSet *)resultSet{
    self = [super initWithFMResul: resultSet];
    if (self) {
        self.type = TYPE_CI;
    }
    return self;
}

+(instancetype)ciWithFMResult:(FMResultSet *)resultSet{
    return [[self alloc] initWithFMResul:resultSet];
}

@end

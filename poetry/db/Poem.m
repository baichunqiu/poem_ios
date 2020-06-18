//
//  Poem.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "Poem.h"

@implementation Poem

- (instancetype)initWithFMResul:(FMResultSet *)resultSet{
    self = [super initWithFMResul: resultSet];
    if (self) {
        self.type = TYPE_POEM;
    }
    return self;
}

+ (instancetype)poemWithFMResult:(FMResultSet *)resultSet{
    return [[self alloc] initWithFMResul:resultSet];
}
@end

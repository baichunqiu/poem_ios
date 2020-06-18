//
//  Author.h
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

NS_ASSUME_NONNULL_BEGIN

@interface Author : NSObject

@property (nonatomic, assign) int aid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *describe;


-(instancetype)initWithFMResul:(FMResultSet*)resultSet;

+(instancetype)auhtorWithFMResult:(FMResultSet *)resultSet;

@end
NS_ASSUME_NONNULL_END

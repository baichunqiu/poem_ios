//
//  Base.h
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
NS_ASSUME_NONNULL_BEGIN

//#define String type_poem = "poem";
//const String type_songci = "songci";

#define TYPE_POEM @"poem"
#define TYPE_CI @"songci"

@interface Base : NSObject

@property (nonatomic, assign) int bid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *txt;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *type;

-(instancetype)initWithFMResul:(FMResultSet*)resultSet;

@end

NS_ASSUME_NONNULL_END

//
//  BasePeomCell.h
//  poetry
//
//  Created by 白春秋 on 2019/9/25.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Base.h"
NS_ASSUME_NONNULL_BEGIN

@interface BasePeomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbAuthor;
@property (weak, nonatomic) IBOutlet UILabel *lbTxt;
@property (weak, nonatomic) IBOutlet UILabel *lbTag;

@property(nonatomic,strong) Base* data;

@end

NS_ASSUME_NONNULL_END

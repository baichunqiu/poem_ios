//
//  BasePeomCell.m
//  poetry
//
//  Created by 白春秋 on 2019/9/25.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "BasePeomCell.h"

@implementation BasePeomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setData:(Base *)data{
    _data = data;
    if (_data) {
        self.lbTitle.text = [NSString stringWithFormat:@"名称：%@",_data.title];
        if (![_data.tag isEqual:[NSNull null]] && ![@"" isEqualToString:_data.tag]){
             self.lbTag.text = _data.tag;
        }
        self.lbAuthor.text = _data.author;
        self.lbTxt.text =[NSString stringWithFormat:@"诗文：%@",[_data.txt stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
}


@end

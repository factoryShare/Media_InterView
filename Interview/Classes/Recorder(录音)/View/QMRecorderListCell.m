//
//  QMRecorderListCell.m
//  Interview
//
//  Created by Mr.Right on 16/4/5.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "QMRecorderListCell.h"

@implementation QMRecorderListCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"QMRecorderListCell";
    QMRecorderListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QMRecorderListCell class]) owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setModel:(QMRecoderDBModel *)model {
    self.musicName.text = model.CustomName;
}

//- (void)setSelected:(BOOL)selected {
////    self.selected = selected;
//    self.cellPlayBtn.selected = selected;
//}

@end

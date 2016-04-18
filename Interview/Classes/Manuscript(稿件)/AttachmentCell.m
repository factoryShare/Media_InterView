//
//  AttachmentCell.m
//  Interview
//
//  Created by ChengFei on 16/4/16.
//  Copyright © 2016年 yonganbo. All rights reserved.
//

#import "AttachmentCell.h"

@implementation AttachmentCell


- (void)setModel:(AttachmentModel *)model {
    _model = model;
    NSString *type = model.attachmentType;
    if ([type isEqualToString:AttachmentTypeNo]) {
        self.imageView.image = [UIImage imageNamed:@"添加附件"];
    }
    if ([type isEqualToString:AttachmentTypeImage]) {
        self.imageView.image = [UIImage imageNamed:@"已添加的图片"];
    }
    if ([type isEqualToString:AttachmentTypeRecord]) {
        self.imageView.image = [UIImage imageNamed:@"已添加的录音"];
    }
    
    if (model.isEdit) {
        if ([type isEqualToString:AttachmentTypeNo]) {
            self.deleteBtn.hidden = YES;
        } else {
            self.deleteBtn.hidden = NO;
        }
    } else {
        self.deleteBtn.hidden = YES;
    }
    
}

- (IBAction)deleteBtnClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(attachmentCellDeleteItem:)]) {
        [self.delegate attachmentCellDeleteItem:_model];
    }
}

@end

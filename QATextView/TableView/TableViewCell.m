//
//  TableViewCell.m
//  TestProject
//
//  Created by Avery An on 2019/9/16.
//  Copyright © 2019 Avery An. All rights reserved.
//

#import "TableViewCell.h"
#import "QATextView.h"

@interface TableViewCell ()
@property (nonatomic) QATextView *textView;
@end

@implementation TableViewCell

#pragma mark - Life Cycle -
- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.textView];
        
        
        int gap_top = 6;
        int gap_left = 6;
        int gap_right = gap_left;
        NSInteger minHeight = TableViewCell_DefaultHeight - gap_top*2;
        UIView *superView = self.textView.superview;
        // 顶部的约束优先级最高这样就会先改变约束优先级高的、避免了底部在输入的换行自适应时的上下跳动问题
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView.mas_left).offset(gap_left);
            make.right.equalTo(superView.mas_right).offset(-gap_right);
            
            make.top.equalTo(superView.mas_top).offset(gap_top).priority(100);
            make.height.mas_greaterThanOrEqualTo(@(minHeight)).priority(99);
            make.bottom.equalTo(superView.mas_bottom).offset(-gap_top).priority(98);
        }];
        
        
        __weak typeof(self) weakSelf = self;
        self.textView.contentHeightChangedBlock = ^(QATextView * _Nonnull textView, NSInteger textHeight) {
            if (textHeight - minHeight >= 0) {
                [weakSelf.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_greaterThanOrEqualTo(@(textHeight)).priority(99);
                }];
                
                // cell到viewController的消息传递可以使用delegate也可以使用block:
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewCell:contentHeightChanged:)]) {
                    [weakSelf.delegate tableViewCell:weakSelf contentHeightChanged:textHeight];
                }
            }
        };
        
        self.textView.contentChangedBlock = ^(QATextView * _Nonnull textView, NSString * _Nullable text) {
            // cell到viewController的消息传递可以使用delegate也可以使用block:
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(tableViewCell:contentChanged:)]) {
                [weakSelf.delegate tableViewCell:weakSelf contentChanged:text];
            }
        };
        
    }
    
    return self;
}


#pragma mark - Property -
- (QATextView *)textView {
    if (!_textView) {
        _textView = [[QATextView alloc] init];
        _textView.backgroundColor = [UIColor brownColor];
    }
    return _textView;
}

@end

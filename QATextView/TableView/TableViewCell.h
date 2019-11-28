//
//  TableViewCell.h
//  TestProject
//
//  Created by Avery An on 2019/9/16.
//  Copyright © 2019 Avery An. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableViewCell;

static NSInteger TableViewCell_DefaultHeight = 128;

@protocol TableViewCellDelegate <NSObject>
- (void)tableViewCell:(TableViewCell * _Nonnull)cell contentHeightChanged:(NSInteger)contentHeight;
- (void)tableViewCell:(TableViewCell * _Nonnull)cell contentChanged:(NSString * _Nullable)content;
@end


NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (nonatomic, weak) id<TableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

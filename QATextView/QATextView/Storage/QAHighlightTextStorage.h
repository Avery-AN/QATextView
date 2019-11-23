//
//  QAHighlightTextStorage.h
//  TestProject
//
//  Created by Avery An on 2019/10/10.
//  Copyright © 2019 Avery An. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QAHighlightTextStorageDelegate <NSObject>
- (void)changeSelectedRange:(NSRange)range;
@end

NS_ASSUME_NONNULL_BEGIN

@interface QAHighlightTextStorage : NSTextStorage

@property (nonatomic, weak) id<QAHighlightTextStorageDelegate> qa_delegate;

@end

NS_ASSUME_NONNULL_END

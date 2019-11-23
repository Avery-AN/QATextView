//
//  QATextView.h
//  TestProject
//
//  Created by Avery An on 2019/11/22.
//  Copyright © 2019 Avery An. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAHighlightTextStorage.h"
#import "QAEmojiTextAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface QATextView : UITextView

/**
 返回QATextView所展示的文案的长度 (自定义emoji表情的长度为1)
 如果获取QATextView.text.length、那么自定义emoji表情的长度为其所对应image名称的字符串的长度。
*/
@property (nonatomic, assign, readonly) NSInteger contentLength;

@end

NS_ASSUME_NONNULL_END

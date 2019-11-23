//
//  QATextView.m
//  TestProject
//
//  Created by Avery An on 2019/11/22.
//  Copyright © 2019 Avery An. All rights reserved.
//

#import "QATextView.h"

@interface QATextView () <QAHighlightTextStorageDelegate, UITextViewDelegate>
@property (nonatomic, copy) QAHighlightTextStorage *qaTextStorage;
@property (nonatomic, copy) NSLayoutManager *qaTextLayoutManager;
@property (nonatomic, copy) NSTextContainer *qaTextContainer;
@end

@implementation QATextView

#pragma mark - Life Cycle -
- (void)dealloc {
    NSLog(@"%s",__func__);
}
- (instancetype)initWithFrame:(CGRect)frame {
    _qaTextStorage = [[QAHighlightTextStorage alloc] init];
    _qaTextLayoutManager = [[NSLayoutManager alloc] init];
    _qaTextContainer = [[NSTextContainer alloc] init];
    [_qaTextStorage addLayoutManager:_qaTextLayoutManager];
    [_qaTextLayoutManager addTextContainer:_qaTextContainer];
    
    if (self = [super initWithFrame:frame textContainer:_qaTextContainer]) {
        _qaTextStorage.qa_delegate = self;
        // self.delegate = self;
    }
    
    return self;
}


/*
#pragma mark - UITextView delegate -
- (void)textViewDidChange:(UITextView*)textView {
    UITextRange *markedTextRange = [textView markedTextRange];
    UITextPosition *textPosition = [textView positionFromPosition:markedTextRange.start offset:0];
    if (markedTextRange && textPosition) {
        NSLog(@" ------????????????????");
        return;
    }
}
*/


#pragma mark - QAHighlightTextStorage Delegate -
- (void)changeSelectedRange:(NSRange)range {
    self.selectedRange = range;
}


#pragma mark - Property -
- (NSString *)text {
    NSMutableString *string = [NSMutableString string];
    NSInteger length = self.textStorage.length;
    for (int i = 0; i < length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSAttributedString *attributedString = [self.textStorage attributedSubstringFromRange:range];
        
        id obj = [self.textStorage attribute:NSAttachmentAttributeName atIndex:i effectiveRange:&range];
        if (obj && [obj isKindOfClass:[QAEmojiTextAttachment class]]) {
            QAEmojiTextAttachment *attachment = (QAEmojiTextAttachment *)obj;
            [string appendString:attachment.emojiText];
        }
        else {
            [string appendString:attributedString.string];
        }
    }
    
    return string;
}
- (NSInteger)contentLength {
    return self.textStorage.length;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

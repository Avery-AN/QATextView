//
//  QATextView.m
//  TestProject
//
//  Created by Avery An on 2019/11/22.
//  Copyright © 2019 Avery An. All rights reserved.
//

#import "QATextView.h"

static NSInteger maxContentHeight = 100;

@interface QATextView () <QAHighlightTextStorageDelegate>
@property (nonatomic, copy) QAHighlightTextStorage *qaTextStorage;
@property (nonatomic, copy) NSLayoutManager *qaTextLayoutManager;
@property (nonatomic, copy) NSTextContainer *qaTextContainer;
@property (nonatomic, assign) NSInteger contentHeight_default;
@end

@implementation QATextView

#pragma mark - Life Cycle -
- (void)dealloc {
    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame {
    _qaTextStorage = [[QAHighlightTextStorage alloc] init];
    _qaTextLayoutManager = [[NSLayoutManager alloc] init];
    _qaTextContainer = [[NSTextContainer alloc] init];
    [_qaTextStorage addLayoutManager:_qaTextLayoutManager];
    [_qaTextLayoutManager addTextContainer:_qaTextContainer];
    
    if (self = [super initWithFrame:frame textContainer:_qaTextContainer]) {
        _qaTextStorage.qa_delegate = self;
        self.contentHeight_default = frame.size.height;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged) name:UITextViewTextDidChangeNotification object:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewBeginEditing) name:UITextViewTextDidBeginEditingNotification object:self];
    }
    
    return self;
}


#pragma mark - NSNotificationCenter Observer Methods -
- (void)textViewBeginEditing {
    if (fabs(self.contentHeight_default - 0.) <= 1) {
        [self layoutIfNeeded];
        self.contentHeight_default = self.frame.size.height;
    }
}
- (void)textValueChanged {
    UITextRange *markedTextRange = [self markedTextRange];
    UITextPosition *textPosition = [self positionFromPosition:markedTextRange.start offset:0];
    if (markedTextRange && textPosition) {
        return;
    }
    
    NSInteger textContentHeight = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);

    // 超过最大高度后设置其可以滚动:
    self.scrollEnabled = (textContentHeight - maxContentHeight > 0.) ? YES : NO;
    
    if (self.contentChangedBlock) {
        self.contentChangedBlock(self, self.text);
    }
    if (self.contentHeightChangedBlock && textContentHeight - self.contentHeight_default > 0 && self.scrollEnabled == NO) {
        self.contentHeightChangedBlock(self, textContentHeight);
    }
}


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

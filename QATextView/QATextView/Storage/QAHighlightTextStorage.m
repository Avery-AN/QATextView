//
//  QAHighlightTextStorage.m
//  TestProject
//
//  Created by Avery An on 2019/10/10.
//  Copyright © 2019 Avery An. All rights reserved.
//

#import "QAHighlightTextStorage.h"
#import "QAEmojiTextAttachment.h"
#import "NSString+SimpleModifier.h"
#import "QATextView.h"
#include <pthread.h>

typedef NS_ENUM(NSUInteger, QAHighlightTextStorage_HighlightStyle) {
    QAHighlightTextStorage_default = 1,
    QAHighlightTextStorage_highlight,
    QAHighlightTextStorage_link,
    QAHighlightTextStorage_at,
    QAHighlightTextStorage_topic,
    QAHighlightTextStorage_emoji
};
static NSString *HighlightPattern = @"(\\*\\w+(\\s*\\w+)*\\s*\\*)";
static NSString *EmojiTextPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";  // 匹配Emoji表情的正则表达式
static NSString *LinkPattern = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
static NSString *AtPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+";
static NSString *TopicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";

@interface QAHighlightTextStorage () <NSTextStorageDelegate> {
    NSMutableAttributedString *_mutableAttributedString;
    NSMutableAttributedString *_emojiAttributedStr;
    
    NSRegularExpression *_highlightExpression;  // 高亮正则表达式 (某特定格式的文本需要高亮显示、PS: *XXX*)
    NSRegularExpression *_linkExpression;       // 链接正则表达式
    NSRegularExpression *_atExpression;         // at正则表达式
    NSRegularExpression *_topicExpression;      // 话题正则表达式
    NSRegularExpression *_emojiExpression;      // 自定义Emoji正则表达式
    
    QAHighlightTextStorage_HighlightStyle _highlightStyle;
    BOOL _processingEmoji;
    pthread_mutex_t _mutex;
}
@end


@implementation QAHighlightTextStorage

#pragma mark - Life Cycle -
- (void)dealloc {
    NSLog(@"%s", __func__);
}
- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_mutex, NULL);
        
        _mutableAttributedString = [[NSMutableAttributedString alloc] init];
        _highlightExpression = [NSRegularExpression regularExpressionWithPattern:HighlightPattern options:0 error:NULL];
        _linkExpression = [NSRegularExpression regularExpressionWithPattern:LinkPattern options:0 error:NULL];
        _atExpression = [NSRegularExpression regularExpressionWithPattern:AtPattern options:0 error:NULL];
        _topicExpression = [NSRegularExpression regularExpressionWithPattern:TopicPattern options:0 error:NULL];
        _emojiExpression = [NSRegularExpression regularExpressionWithPattern:EmojiTextPattern options:0 error:NULL];
        
        self.delegate = self;
    }
    
    return self;
}


#pragma mark - Override Methods -
- (NSDictionary<NSString *,id> *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_mutableAttributedString attributesAtIndex:location effectiveRange:range];
}
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [self beginEditing];
    [_mutableAttributedString replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
    [self endEditing];
}
- (void)setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range {
    [self beginEditing];
    [_mutableAttributedString setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}
/*
 - (void)edited:(NSTextStorageEditActions)editedMask range:(NSRange)editedRange changeInLength:(NSInteger)delta {
     NSLog(@"editedRange: %@",NSStringFromRange(editedRange));
     NSLog(@"delta: %ld",delta);
 }
 */
- (void)processEditing {
    [super processEditing];
    
    @autoreleasepool {
        // 去除当前文本的颜色属性:
        NSRange paragaphRange = [self.string paragraphRangeForRange:self.editedRange];
        [self removeAttribute:NSForegroundColorAttributeName range:paragaphRange];
        
        // 高亮文案正则表达式匹配:
        [_highlightExpression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (!NSEqualRanges(result.range, NSMakeRange(0, 0))) {
                self->_highlightStyle = QAHighlightTextStorage_highlight;
                [self updateAttribute:result paragaphRange:result.range];
            }
        }];
        
        // link正则表达式匹配:
        [_linkExpression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (!NSEqualRanges(result.range, NSMakeRange(0, 0))) {
                self->_highlightStyle = QAHighlightTextStorage_link;
                [self updateAttribute:result paragaphRange:result.range];
            }
        }];
        
        // at正则表达式匹配:
        [_atExpression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (!NSEqualRanges(result.range, NSMakeRange(0, 0))) {
                self->_highlightStyle = QAHighlightTextStorage_at;
                [self updateAttribute:result paragaphRange:result.range];
            }
        }];
        
        // topic正则表达式匹配:
        [_topicExpression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (!NSEqualRanges(result.range, NSMakeRange(0, 0))) {
                self->_highlightStyle = QAHighlightTextStorage_topic;
                [self updateAttribute:result paragaphRange:result.range];
            }
        }];
        
        // emoji正则表达式匹配:
        [_emojiExpression enumerateMatchesInString:self.string options:NSMatchingReportProgress range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            if (!NSEqualRanges(result.range, NSMakeRange(0, 0))) {
                NSAttributedString *attributedString = [self attributedSubstringFromRange:result.range];
                NSString *emojiText = attributedString.string;
                UIImage *image = [[NSString retunRichTextDic] valueForKey:emojiText];
                if (image && _processingEmoji == NO) {
                    _processingEmoji = YES;
                    self->_highlightStyle = QAHighlightTextStorage_emoji;
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    [dic setValue:result forKey:@"result"];
                    [dic setValue:image forKey:@"image"];
                    [dic setValue:emojiText forKey:@"emojiText"];
                    pthread_mutex_lock(&_mutex);
                    [self performSelector:@selector(processDiyEmoji:) withObject:dic afterDelay:0];
                }
            }
        }];
    }
}


#pragma mark - Private Methods -
- (void)processDiyEmoji:(NSDictionary *)dic {
    @autoreleasepool {
        NSTextCheckingResult *result = [dic valueForKey:@"result"];
        UIImage *image = [dic valueForKey:@"image"];
        NSString *emojiText = [dic valueForKey:@"emojiText"];
        
        QAEmojiTextAttachment *atacchment = [[QAEmojiTextAttachment alloc] initWithData:nil ofType:nil];
        atacchment.image = image;
        atacchment.emojiText = emojiText;
        
        QATextView *textView = (QATextView *)self.qa_delegate;
        CGFloat fontSize = textView.font.pointSize;
        NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:atacchment];
        _emojiAttributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:emojiAttributedString];
        NSRange range = NSMakeRange(0, 1);
        [_emojiAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
        
        [self deleteCharactersInRange:result.range];
    }
}
- (void)updateAttribute:(NSTextCheckingResult *)result
          paragaphRange:(NSRange)paragaphRange {
    // 更新属性:
    UIColor *newColor = nil;
    if (self->_highlightStyle == QAHighlightTextStorage_highlight) {
        newColor = [UIColor redColor];
    }
    else if (self->_highlightStyle == QAHighlightTextStorage_link) {
        newColor = [UIColor cyanColor];
    }
    else if (self->_highlightStyle == QAHighlightTextStorage_at) {
        newColor = [UIColor orangeColor];
    }
    else if (self->_highlightStyle == QAHighlightTextStorage_topic) {
        newColor = [UIColor blueColor];
    }
    
    [self addAttribute:NSForegroundColorAttributeName value:newColor range:result.range];
}
- (void)changeSelectedRange:(NSString *)rangeString {
    NSRange range = NSRangeFromString(rangeString);
    [self.qa_delegate changeSelectedRange:range];
    
    pthread_mutex_unlock(&_mutex);
}


#pragma mark - NSTextStorageDelegate -
// Sent inside -processEditing right before fixing attributes.  Delegates can change the characters or attributes.
- (void)textStorage:(NSTextStorage *)textStorage
 willProcessEditing:(NSTextStorageEditActions)editedMask
              range:(NSRange)editedRange
     changeInLength:(NSInteger)delta {
    if (_processingEmoji == YES && _emojiAttributedStr) {
        if (delta < 0) {
            [self insertAttributedString:_emojiAttributedStr atIndex:editedRange.location];
            
            if (self.qa_delegate) {
                NSRange range = NSMakeRange(editedRange.location+1, 0);
                [self performSelector:@selector(changeSelectedRange:) withObject:NSStringFromRange(range) afterDelay:0];
            }
        }
        _emojiAttributedStr = nil;
        _processingEmoji = NO;
    }
}

// Sent inside -processEditing right before notifying layout managers.  Delegates can change the attributes.
- (void)textStorage:(NSTextStorage *)textStorage
  didProcessEditing:(NSTextStorageEditActions)editedMask
              range:(NSRange)editedRange
     changeInLength:(NSInteger)delta {
}


#pragma mark - Property -
- (NSString *)string {
    NSString *string = _mutableAttributedString.string;
    return string;
}

@end

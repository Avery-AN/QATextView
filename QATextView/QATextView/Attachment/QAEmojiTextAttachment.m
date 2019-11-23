//
//  QAEmojiTextAttachment.m
//  Avery
//
//  Created by Avery on 2018/8/17.
//  Copyright © 2018年 Avery. All rights reserved.
//

#import "QAEmojiTextAttachment.h"

@implementation QAEmojiTextAttachment

#pragma mark - Override Methods -
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer
                      proposedLineFragment:(CGRect)lineFrag
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)charIndex NS_AVAILABLE_IOS(7_0) {
    CGFloat emojiHeight = lineFrag.size.height;
    CGFloat emojiWidth = emojiHeight;
    return CGRectMake(0, -2, emojiWidth, emojiHeight);
}

@end

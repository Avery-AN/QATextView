//
//  QATextViewConfig.h
//  QATextView
//
//  Created by Avery An on 2019/12/11.
//  Copyright © 2019 Avery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QAEmojiTextAttachment.h"
#import "NSString+SimpleModifier.h"
#include <pthread.h>


static float wordSpace = 1.3;
static float lineSpace = 2.5;

static NSString *QAHighlightRegularExpression = @"(\\*\\w+(\\s*\\w+)*\\s*\\*)";
static NSString *QAEmojiRegularExpression = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";  // 匹配Emoji表情的正则表达式
static NSString *QALinkRegularExpression = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
static NSString *QAAtRegularExpression = @"@[0-9a-zA-Z\\u4e00-\\u9fa5\\-]+"; // @"@[0-9a-zA-Z\\u4e00-\\u9fa5]+"
static NSString *QATopicRegularExpression = @"#[0-9a-zA-Z\\u4e00-\\u9fa5\\-]+#";

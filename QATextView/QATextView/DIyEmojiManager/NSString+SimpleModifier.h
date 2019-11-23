//
//  NSString+SimpleModifier.h
//  Avery
//
//  Created by Avery on 2018/7/13.
//  Copyright © 2018年 Avery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SimpleModifier)

/**
 ”emoji的image-Name“ 与 ”emoji的text文案“的对应
 */
+ (NSMutableDictionary *)retunRichTextDic;

@end

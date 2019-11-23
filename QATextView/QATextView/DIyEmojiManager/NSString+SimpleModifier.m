//
//  NSString+SimpleModifier.m
//  Avery
//
//  Created by Avery on 2018/7/13.
//  Copyright © 2018年 Avery. All rights reserved.
//

#import "NSString+SimpleModifier.h"

@implementation NSString (SimpleModifier)

+ (NSMutableDictionary *)retunRichTextDic {
    NSMutableDictionary *mapper = [NSMutableDictionary dictionary];
    
    mapper[@"[微笑]"] = [UIImage imageNamed:@"emoji_1"];
    mapper[@"[害羞]"] = [UIImage imageNamed:@"emoji_2"];
    
    return mapper;
}

@end

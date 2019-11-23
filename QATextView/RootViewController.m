//
//  RootViewController.m
//  QATextView
//
//  Created by Avery An on 2019/11/23.
//  Copyright © 2019 Avery. All rights reserved.
//

#import "RootViewController.h"
#import "QATextView.h"

@interface RootViewController ()
@property (nonatomic, strong) QATextView *textView;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    button_1.backgroundColor = [UIColor orangeColor];
    button_1.frame = CGRectMake(30, 260, [UIScreen mainScreen].bounds.size.width - 30*2, 50);
    [button_1 setTitle:@"打印TextView.text的值" forState:UIControlStateNormal];
    [button_1 addTarget:self action:@selector(action_1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_1];
    
    UIButton *button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_2.titleLabel setFont:[UIFont systemFontOfSize:17]];
    button_2.backgroundColor = [UIColor orangeColor];
    button_2.frame = CGRectMake(30, 320, [UIScreen mainScreen].bounds.size.width - 30*2, 50);
    [button_2 setTitle:@"模拟自定义emoji键盘 - 输入emoji表情" forState:UIControlStateNormal];
    [button_2 addTarget:self action:@selector(action_2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_2];
    
    _textView = [[QATextView alloc] initWithFrame:CGRectMake(10, 90, [UIScreen mainScreen].bounds.size.width - 10*2, 160)];
    _textView.backgroundColor = [UIColor lightGrayColor];
    _textView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_textView];
}

- (void)action_1 {
    NSLog(@"textView.text: %@",_textView.text);
    NSLog(@"  textView.text.length: %ld",_textView.text.length);
    NSLog(@"textView.contentLength: %ld",_textView.contentLength);
}

/**
 模拟自定义的Emoji键盘输入Emoji表情
 */
- (void)action_2 {
    NSString *emojiText = @"[害羞]";
    UIImage *image = [UIImage imageNamed:@"emoji_2"];
    QAEmojiTextAttachment *atacchment = [[QAEmojiTextAttachment alloc] initWithData:nil ofType:nil];
    atacchment.image = image;
    atacchment.emojiText = emojiText;
    NSAttributedString *emojiAttributedString = [NSAttributedString attributedStringWithAttachment:atacchment];
    NSMutableAttributedString *emojiAttributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:emojiAttributedString];
    NSRange range = NSMakeRange(0, 1);
    CGFloat fontSize = self.textView.font.pointSize;
    [emojiAttributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:range];
    
    NSRange currentRange = self.textView.selectedRange;
    [self.textView.textStorage insertAttributedString:emojiAttributedStr atIndex:currentRange.location];
    self.textView.selectedRange = NSMakeRange(currentRange.location + 1, 0);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

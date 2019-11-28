//
//  RootViewController.m
//  QATextView
//
//  Created by Avery An on 2019/11/23.
//  Copyright © 2019 Avery. All rights reserved.
//

#import "RootViewController.h"
#import "BasicViewController.h"
#import "TableViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_1.titleLabel setFont:[UIFont systemFontOfSize:17]];
    button_1.backgroundColor = [UIColor orangeColor];
    button_1.frame = CGRectMake(60, 150, [UIScreen mainScreen].bounds.size.width - 60*2, 50);
    [button_1 setTitle:@"基础使用" forState:UIControlStateNormal];
    [button_1 addTarget:self action:@selector(action_1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_1];
    
    UIButton *button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_2.titleLabel setFont:[UIFont systemFontOfSize:17]];
    button_2.backgroundColor = [UIColor orangeColor];
    button_2.frame = CGRectMake(60, 220, [UIScreen mainScreen].bounds.size.width - 60*2, 50);
    [button_2 setTitle:@"在TableView中的使用" forState:UIControlStateNormal];
    [button_2 addTarget:self action:@selector(action_2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_2];
}

- (void)action_1 {
    BasicViewController *basicVC = [[BasicViewController alloc] init];
    [self.navigationController pushViewController:basicVC animated:YES];
}

- (void)action_2 {
    TableViewController *tableVC = [[TableViewController alloc] init];
    [self.navigationController pushViewController:tableVC animated:YES];
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

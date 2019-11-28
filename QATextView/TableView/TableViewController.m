//
//  TableViewController.m
//  QATextView
//
//  Created by Avery An on 2019/11/28.
//  Copyright © 2019 Avery. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"

#define UIHeight    [[UIScreen mainScreen] bounds].size.height
#define UIWidth     [[UIScreen mainScreen] bounds].size.width

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate>
@property (nonatomic) NSMutableArray *datas;
@property (nonatomic) UITableView *tableView;
@end

@implementation TableViewController

#pragma mark - Life Cycle -
- (void)dealloc {
    NSLog(@"%s", __func__);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.datas = [NSMutableArray arrayWithCapacity:0];
    [self.datas addObject:@"1"];
    [self.view addSubview:self.tableView];
}


#pragma mark - DataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdvancedCell"];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AdvancedCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    return cell;
}


#pragma mark - TableViewCell Delegate -
- (void)tableViewCell:(TableViewCell * _Nonnull)cell contentHeightChanged:(NSInteger)contentHeight {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}
- (void)tableViewCell:(TableViewCell * _Nonnull)cell contentChanged:(NSString * _Nullable)content {
    /**
     在此方法中更新Model中存储的内容
     */
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
}


#pragma mark - Property -
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, UIWidth, UIHeight - 88) style:UITableViewStylePlain];
        //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
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

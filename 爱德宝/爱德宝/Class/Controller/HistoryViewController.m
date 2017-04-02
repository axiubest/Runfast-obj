//
//  HistoryViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/8.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryGradeCell.h"
#import "HistoryHeaderView.h"
#import "HistorygradeModel.h"

static NSString *const HistoryGradeIdentifier  =@"HistoryGradeCell";
@interface HistoryViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSMutableArray <HistorygradeModel *>*dataSource;
@end

@implementation HistoryViewController

-(NSMutableArray<HistorygradeModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KHEIGHT / 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 100 : 0.00001;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        HistoryHeaderView *vc = [[NSBundle mainBundle] loadNibNamed:
                                 @"HistoryHeaderView" owner:nil options:nil].lastObject;
        vc.frame = CGRectMake(0, 0, KWIDTH, 200);
        return vc;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryGradeIdentifier];
    cell.model = self.dataSource[indexPath.section];
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"历史记录";
    [_tableView registerNib:[UINib nibWithNibName:HistoryGradeIdentifier bundle:nil] forCellReuseIdentifier:HistoryGradeIdentifier];
    [self request];
}

- (void)request {
    [[XIU_NetAPIManager sharedManager] request_HistoryGradeBlock:^(id data, NSError *error) {
        self.dataSource =data;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

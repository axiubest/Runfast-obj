//
//  WordGradeViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/9.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "WordGradeViewController.h"
#import "WordGradeHeaderView.h"
#import "WordGradeCell.h"
#import "WorldGradeModel.h"
#import "MJRefresh.h"

@interface WordGradeViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    int pageNum;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, strong) XIU_Login *login;
@end

@implementation WordGradeViewController


-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return  section == 0 ? 200 : 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        WordGradeHeaderView *vc = [[NSBundle mainBundle] loadNibNamed:
                                   @"WordGradeHeaderView" owner:nil options:nil].lastObject;
        vc.frame = CGRectMake(0, 0, KWIDTH, 200);
        [vc setvalue];
        return vc;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordGradeIdentifier"];
    [cell dataSource:self.dataSource[indexPath.section] count:indexPath.section];
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.login = [[XIU_Login alloc] init];
    [_tableView registerNib:[UINib nibWithNibName:@"WordGradeCell" bundle:nil] forCellReuseIdentifier:@"WordGradeIdentifier"];
    _tableView.sectionFooterHeight = 0.000001;
     pageNum = 0;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageNum++;
        [self requestWithPage:pageNum];
        
    }];

    [self requestWithPage:pageNum];
}



- (void)requestWithPage:(int)page {
    NSLog(@"%d", page);
    
    [[XIU_NetAPIManager sharedManager] request_WorldGrade_WithPath:@"http://112.74.28.179:8080/adbs/userbeancontrol/getallrankinglist?" Params:@{@"page": [NSNumber numberWithInt:page],@"size" :@"10",} andBlock:^(id data, NSError *error) {
        
        [self.dataSource addObjectsFromArray:data];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

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

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

@interface WordGradeViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WordGradeViewController


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 100;
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
        return vc;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WordGradeIdentifier"];
    return cell;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerNib:[UINib nibWithNibName:@"WordGradeCell" bundle:nil] forCellReuseIdentifier:@"WordGradeIdentifier"];
    _tableView.sectionFooterHeight = 0.000001;
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

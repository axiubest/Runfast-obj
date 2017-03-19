//
//  MoreViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/10.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "MoreViewController.h"
#import "SliderTableViewCell.h"
#import "AboutUsViewController.h"
#import "XIU_ShareView.h"
@interface MoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation MoreViewController

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithObjects:@"屏幕常亮",@"关于", @"分享",nil];
    }
    return _dataSource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SliderTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"SliderTableViewCell"];
        return cell;
    }

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    cell.textLabel.textColor  =[UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        AboutUsViewController *v = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
    }if (indexPath.row == 2) {
        [XIU_ShareView showShareView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多设置";
    // Do any additional setup after loading the view from its nib.
    [_tableView registerNib:[UINib nibWithNibName:@"SliderTableViewCell" bundle:nil] forCellReuseIdentifier:@"SliderTableViewCell"];
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

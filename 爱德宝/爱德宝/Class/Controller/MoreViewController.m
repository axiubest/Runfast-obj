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
@interface MoreViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation MoreViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SliderTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"SliderTableViewCell"];
        return cell;
    }

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.textLabel.text = @"关于";
    cell.textLabel.textColor  =[UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        AboutUsViewController *v = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:v animated:YES];
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

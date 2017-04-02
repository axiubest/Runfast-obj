//
//  XIU_HelpViewController.m
//  爱德宝
//
//  Created by XIUDeveloper on 2017/3/26.
//  Copyright © 2017年 杨岫峰. All rights reserved.
//

#import "XIU_HelpViewController.h"
#import "MJRefresh.h"
#import "QuestionModel.h"
#import "XIU_HelpDetialVC.h"
@interface XIU_HelpViewController ()
{
    int pageNum;
}
@property (nonatomic, copy) NSMutableArray *dataSource;

@end

@implementation XIU_HelpViewController


-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助";
    self.tableView.frame = CGRectMake(0, 64, KWIDTH, KHEIGHT - 64);
    UIImageView *i = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    i.frame  = CGRectMake(0, 0, KWIDTH, KHEIGHT);
    self.tableView.backgroundView = i;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    pageNum = 0;
    [self requestWithPage:pageNum];
    

    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        pageNum++;
        [self requestWithPage:pageNum];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (!cell) {
        cell  =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    cell.backgroundColor  =[UIColor clearColor];
    cell.textLabel.textColor  =[UIColor whiteColor];
    
    cell.textLabel.text = [self.dataSource[indexPath.row] quesTitle];
    NSLog(@"%@", self.dataSource[indexPath.row] );
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XIU_HelpDetialVC *vc = [[XIU_HelpDetialVC alloc] init];
    vc.str =  [self.dataSource[indexPath.row] quesAnswer];
    vc.title = [self.dataSource[indexPath.row] quesTitle];
    NSLog(@"%@", [self.dataSource[indexPath.row] quesAnswer]);
    
    [self.navigationController pushViewController:vc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)requestWithPage:(int)page {
    NSLog(@"%d", page);
    
    [[XIU_NetAPIManager sharedManager]request_QuestionWithPage:page Block:^(id data, NSError *error) {
        [self.dataSource addObjectsFromArray:data];
        NSLog(@"%@", data);
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];

    }];
}
@end

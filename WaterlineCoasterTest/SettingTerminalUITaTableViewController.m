//
//  SettingTerminalUITaTableViewController.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 16/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "SettingTerminalUITaTableViewController.h"
#import "SettingTableViewCell.h"

@interface SettingTerminalUITaTableViewController ()

@end

@implementation SettingTerminalUITaTableViewController{
    NSMutableArray *TableItemArray;
}
@synthesize commanddata;

- (void)viewDidLoad {
    [super viewDidLoad];
    TableItemArray = [[NSMutableArray alloc]init];
    commanddata = [CommandData sharedInstance];
    [commanddata DataBaseBtn];
    [self CommamdString];
}

- (void) CommamdString{
    int i;
    for (i = 0; i < 12; i++) {
        NSLog(@"%@",[commanddata ReturnTableArray:i]);
        [TableItemArray addObject:[commanddata ReturnTableArray:i]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 12;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView setSeparatorColor:[UIColor clearColor]];
    SettingTableViewCell *cell = [SettingTableViewCell cell];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell EditSize:indexPath.row];
    [cell EditKeyTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    if (indexPath.row + 1 > TableItemArray.count) {
        
    }
    else [cell Editplaceholder:[TableItemArray objectAtIndex:indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 200;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

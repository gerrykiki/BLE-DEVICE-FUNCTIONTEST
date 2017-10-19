//
//  ScanDeviceTableViewController.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 19/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "ScanDeviceTableViewController.h"
#import "ScanCoasterTableViewCell.h"
#import "WWLTermainalViewController.h"


@interface ScanDeviceTableViewController ()

@end

@implementation ScanDeviceTableViewController
@synthesize bluetoothobject,itemarray;

- (void)viewDidLoad {
    [super viewDidLoad];
    bluetoothobject = [BlueToothObject sharedInstance];
    itemarray = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStylePlain target:self action:@selector(ScanDevice)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DeviceArray:)
                                                 name:@"Device"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BLEState:)
                                                 name:@"ConnectState"
                                               object:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [bluetoothobject BLEDisConnect];
}

- (void)BLEState:(NSNotification *)BLEstate{
    NSDictionary *Connectstate = [BLEstate userInfo];
    NSString *connectstate = [Connectstate objectForKey:@"BLEState"];
    NSString *connactname = [Connectstate objectForKey:@"BLEName"];
    if ([connectstate isEqualToString:@"YES"]) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        WWLTermainalViewController *TerminalView = [storyboard instantiateViewControllerWithIdentifier:@"WWLTermainalViewController"];
        [self.navigationController pushViewController:TerminalView animated:YES];
    }
    else if ([connectstate isEqualToString:@"NO"]){
        
    }
    else NSLog(@"Error State");
}

- (void) DeviceArray:(NSNotification *)Device{
    NSDictionary * PP = [Device userInfo];
    itemarray = [PP objectForKey:@"devicearray"];
    [self.tableView reloadData];
}

- (void)ScanDevice{
    [bluetoothobject StartBLEDevice];
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
    return itemarray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //[tableView setSeparatorColor:[UIColor clearColor]];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //[cell EditSize:indexPath.row];
    //[cell EditKeyTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

    ScanCoasterTableViewCell *cell = [ScanCoasterTableViewCell cell];
    
    for (int i = 0; i<itemarray.count; i++) {
        [cell EditCellString:[itemarray objectAtIndex:i]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"select Row %ld",(long)indexPath.row);
    [bluetoothobject ConnectToDevice:indexPath.row];
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

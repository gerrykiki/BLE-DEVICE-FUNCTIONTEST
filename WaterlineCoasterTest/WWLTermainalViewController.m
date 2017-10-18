//
//  WWLTermainalViewController.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 14/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "WWLTermainalViewController.h"
#import "TerminalCollectionViewCell.h"
#import "SettingTerminalUITaTableViewController.h"
#import "CommandData.h"

@interface WWLTermainalViewController ()

@end

@implementation WWLTermainalViewController{
    NSArray *itemArray;
    UIView *navigationview;
    UILabel *titleLabel;
    UIView *blackview;
}
@synthesize RawDataTerminal,OutDataTermainal,cellitemarray,collectionView,bluetoothobject,RowDataTerminal,AnalysisDataTerminal,State,ConnectName;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  //  itemArray = @[@"Connect Device", @"DrinkWater", @"Power", @"Reset", @"Test",@"Remind",@"Set PingCode"];
  //  itemArray = @[@"Connect Device", @"DrinkWater", @"Power", @"Reset", @"Test",@"Remind",@"Set PingCode"];
    itemArray = [[CommandData sharedInstance]DataBaseBtn];
  //  bluetoothobject = [BlueToothObject sharedInstance];
    State = @"YES";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStylePlain target:self action:@selector(SettingTerminal)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DrinkDataAccept:) //接收到該Notification時要call的function
                                                 name:@"CoasterData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(RowData:) //接收到該Notification時要call的function
                                                 name:@"CoasterRowData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BLEState:) //接收到該Notification時要call的function
                                                 name:@"ConnectState"
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)AddblackView{
    if (blackview == nil) {
        blackview = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        blackview.backgroundColor = [UIColor blackColor];
        blackview.alpha = 0.4f;
        [blackview becomeFirstResponder];
    }
    [self.view addSubview:blackview];
}

- (void)removeblackview{
    [blackview removeFromSuperview];
}


- (void)viewDidAppear:(BOOL)animated{
    UIView *linetop = [[UIView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width,1)];
    [linetop setBackgroundColor:[UIColor blackColor]];
   // [self.view addSubview:linetop];
    [RowDataTerminal setFrame:CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height *210/600)];
    UIView *lineMid = [[UIView alloc]initWithFrame:CGRectMake(0, RowDataTerminal.bounds.size.height + 65, [UIScreen mainScreen].bounds.size.width,1)];
    [lineMid setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:lineMid];
    [AnalysisDataTerminal setFrame:CGRectMake(0, RowDataTerminal.bounds.size.height + 66 , [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height *210/600)];
    UIView *lineBot = [[UIView alloc]initWithFrame:CGRectMake(0, RowDataTerminal.bounds.size.height + 66 + AnalysisDataTerminal.bounds.size.height, [UIScreen mainScreen].bounds.size.width,1)];
    [lineBot setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:lineBot];
    [collectionView setFrame:CGRectMake(0, RowDataTerminal.bounds.size.height + 67 + AnalysisDataTerminal.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - (RowDataTerminal.bounds.size.height + 66 + AnalysisDataTerminal.bounds.size.height))];
    if ([State isEqualToString:@"NO"]) {
        [bluetoothobject StartBLEDevice];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if ([State isEqualToString:@"NO"]) {
        navigationview = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 150, 44)];
        titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0,0,300,44)];
        titleLabel.text=@"連線狀態：未連線";
        titleLabel.textColor=[UIColor blackColor];
        [navigationview addSubview:titleLabel];
        [self.navigationController.navigationBar addSubview:navigationview];
        [self AddblackView];
    }
    else{
        titleLabel.text = [NSString stringWithFormat:@"連線狀態：已連線 %@",ConnectName];
        [self.navigationController.navigationBar addSubview:navigationview];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [navigationview removeFromSuperview];
    [bluetoothobject TimeStop];
}

- (void)SettingTerminal{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SettingTerminalUITaTableViewController *SettingCommandView = [storyboard instantiateViewControllerWithIdentifier:@"SettingTerminalUITaTableViewController"];
    [self.navigationController pushViewController:SettingCommandView animated:YES];
}

#pragma program CollectionView Setting

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
            /*
        case 0:
            NSLog(@"select 0");
           [bluetoothobject StartBLEDevice];
            break;
             */
        case 0:
            [bluetoothobject SettingFunctionCode:@"DataDrink" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 1:
            [bluetoothobject SettingFunctionCode:@"PowerValue" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 2:
            [bluetoothobject SettingFunctionCode:@"ResetDevice" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 3:
            [bluetoothobject SettingFunctionCode:@"GetData" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 4:
            [bluetoothobject SettingFunctionCode:@"SetDeviceRemind" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 5:
            [bluetoothobject SettingFunctionCode:@"SettingPingCode" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 6:
            [bluetoothobject SettingFunctionCode:@"Checkpingcode" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 7:
            [bluetoothobject SettingFunctionCode:@"SettingDevice" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
            break;
        case 8:
            break;
        case 9:
            break;
        case 10:
            break;
        case 11:
            break;
        default:
            break;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 50);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{    // CGFloat top, left, bottom, right;
    UIEdgeInsets edge = UIEdgeInsetsMake(20,20,20,20);
    return edge;
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

#pragma mark - CollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *stringStaticIdentifier = @"TerminalCollectionViewCell";
    TerminalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:stringStaticIdentifier forIndexPath:indexPath];
    if (indexPath.row + 1 > itemArray.count) {
        [cell cellSetUpData:[NSString stringWithFormat:@"Key%ld",(long)indexPath.row + 1]];
    }
    else [cell cellSetUpData:[itemArray objectAtIndex:indexPath.row]];
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
}

- (void)DrinkDataAccept:(NSNotification *)CoasterData{
    NSDictionary * PP = [CoasterData userInfo];
    NSString *teststring = [PP objectForKey:@"Data"];
    NSLog(@"Data = %@",teststring);
    if ([teststring isEqualToString:@"MultipleDevice"]) {
        [self AlertMultipleDevice];
    }
    else [self WriteTerminal:teststring];
}

- (void)RowData:(NSNotification *)CoasterRowData{
    NSDictionary * PP = [CoasterRowData userInfo];
    NSString *RowData = [PP objectForKey:@"Data"];
    NSLog(@"RowData = %@",RowData);
    [self WriteRowTerminal:RowData];
}

- (void)BLEState:(NSNotification *)BLEstate{
    NSDictionary * Connectstate = [BLEstate userInfo];
    State = [Connectstate objectForKey:@"BLEState"];
    ConnectName = [Connectstate objectForKey:@"BLEName"];
    if ([State isEqualToString:@"YES"]) {
    //    titleLabel.text = @"連線狀態：已連線";
        titleLabel.text = [NSString stringWithFormat:@"連線狀態：已連線 %@",ConnectName];
        [self removeblackview];
    }
    else if ([State isEqualToString:@"NO"]){
        titleLabel.text = @"連線狀態：未連線";
    }
    else {
        titleLabel.text = @"Error";
    }
}


- (void)WriteTerminal:(NSString *)command{
    AnalysisDataTerminal.text=[AnalysisDataTerminal.text stringByAppendingFormat:@"%@\n",command];
}

- (void)WriteRowTerminal:(NSString *)command{
    RowDataTerminal.text=[RowDataTerminal.text stringByAppendingFormat:@"%@\n",command];
}

- (void)AlertMultipleDevice{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"偵測到多個杯套，請將其他不想配對之杯套倒置，或換至其他環境再重新一次"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"確定"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){
                                                         [bluetoothobject StartBLEDevice];
                                                     }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

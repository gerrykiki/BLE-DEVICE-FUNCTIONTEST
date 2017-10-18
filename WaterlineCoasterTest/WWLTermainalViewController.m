//
//  WWLTermainalViewController.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 14/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "WWLTermainalViewController.h"

@interface WWLTermainalViewController ()

@end

@implementation WWLTermainalViewController
@synthesize RawDataTerminal,OutDataTermainal;
- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    RawDataTerminal = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width - 10, ([UIScreen mainScreen].bounds.size.height - 64) /3)];
    RawDataTerminal.center = CGPointMake(self.view.center.x, RawDataTerminal.center.y);
    RawDataTerminal.layer.borderWidth = 1.0;
    RawDataTerminal.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:RawDataTerminal];
    
    OutDataTermainal = [[UITextView alloc]initWithFrame:CGRectMake(0, 64+RawDataTerminal.bounds.size.height + 5, [UIScreen mainScreen].bounds.size.width - 10,( [UIScreen mainScreen].bounds.size.height - 64)/3)];
    OutDataTermainal.center = CGPointMake(self.view.center.x, OutDataTermainal.center.y);
    OutDataTermainal.layer.borderWidth = 1.0;
    OutDataTermainal.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:OutDataTermainal];
    */
    // Do any additional setup after loading the view.
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

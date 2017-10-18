//
//  BlueToothObject.h
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 15/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothObject : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>{
    int startCode;
    int DeviceFunctionCode;
    int YearCode;
    int MonthCode;
    int DayCode;
    int HourCode;
    int MinuteCode;
    int SecondCode;
    int DrinkWaterCode1;
    int DrinkWaterCode2;
    int DrinkTime1;
    int DrinkTime2;
    int PowerCode;
    int EndCode;
}

@property (nonatomic, strong) CBCentralManager *CenterManage;
@property (nonatomic, strong) NSMutableArray *CenterManageArray;
@property (nonatomic, strong) CBCharacteristic *talkingCharacteristic;
@property (nonatomic, strong) CBCharacteristic *AcceptCharacteristic;
@property (nonatomic, strong) NSMutableArray *restServices;
@property (nonatomic, strong) CBPeripheral *ConnectPeripheral;

@property (nonatomic, strong) NSTimer *ConnectTime;


+ (instancetype)sharedInstance;
- (void)StartBLEDevice;
- (void)SettingFunctionCode:(NSString *)FunctionCodeKey RemindTime:(NSNumber *)remindtime PingCode:(NSString *)pingcode;
- (void)TimeStop;
- (void)BLEDisConnect;

@end

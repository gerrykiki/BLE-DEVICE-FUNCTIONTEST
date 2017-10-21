//
//  BlueToothObject.m
//  WaterlineCoasterTest
//
//  Created by Po wei Lin on 15/10/2017.
//  Copyright © 2017 Wistron. All rights reserved.
//

#import "BlueToothObject.h"

static BlueToothObject *sharedInstance = nil;
@implementation BlueToothObject
@synthesize CenterManage,CenterManageArray,talkingCharacteristic,AcceptCharacteristic,restServices,ConnectPeripheral,ConnectTime,DeviceInfoArray;
+ (BlueToothObject *)sharedInstance {
    if (sharedInstance != nil) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[BlueToothObject alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        //initialization environment
        CenterManageArray = [[NSMutableArray alloc]init];
        DeviceInfoArray = [[NSMutableArray alloc]init];
        restServices = [[NSMutableArray alloc]init];
        ChangeCupMode = NO;
    }
    return self;
}

- (void)StartBLEDevice{
    
    [CenterManageArray removeAllObjects];
    [DeviceInfoArray removeAllObjects];
    if (CenterManage == nil) {
        CenterManage = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    else [self StartScan];
    restServices = [NSMutableArray new];
    
    if (ConnectTime == nil) {
        ConnectTime =  [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(TimeUpaction:) userInfo:nil repeats:YES];
    }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOff:
            NSLog(@"BLE Power OFF");
            break;
        case CBManagerStateUnknown:
        case CBManagerStateResetting:
        case CBManagerStateUnsupported:
        case CBManagerStateUnauthorized:
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"BLE Power ON");
            [self StartScan];
            break;
        default:
            break;
    }
}

-(void) StartScan {
    NSDictionary * options = [NSDictionary dictionaryWithObject:@(NO) forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [CenterManage scanForPeripheralsWithServices:nil options:options];
}

-(void) StopScan {
    if (CenterManage.isScanning) {
        [CenterManage stopScan];
    }
    //NSLog(@"BlueTooth Scan Stop");
}

- (void)BLEDisConnect{
    if (ConnectPeripheral.state == CBPeripheralStateConnected) {
        [CenterManage cancelPeripheralConnection:ConnectPeripheral];
    }
}

- (void)ConnectToDevice:(NSInteger)index{
    [CenterManage connectPeripheral:[CenterManageArray objectAtIndex:index] options:nil];
}

- (void)TimeUpaction:(NSTimer *)sender {
    [self StopScan];
    NSLog(@"TimeUp");
    if (ConnectTime != nil) {
        [ConnectTime invalidate];
        ConnectTime = nil;
    }
    /*
    if (CenterManageArray.count == 1) {
        CBPeripheral *correctperipheral = [CenterManageArray firstObject];
        [CenterManage connectPeripheral:correctperipheral options:nil];
    }
    else [self NotifictionData:@"MultipleDevice"];
     */
    [self ScanDevice:DeviceInfoArray];
    //0:以連線 1:目前周邊沒有任何裝置 2:目前周邊有多個裝置 3:目前周邊沒有對應的裝置
    
}

- (void)TimeStop{
    if (ConnectTime != nil) {
        [ConnectTime invalidate];
        ConnectTime = nil;
    }
    [self StopScan];
}

#pragma mark BlueTooth Connect & Scane
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Peropheral Name = %@",peripheral.name);
    NSMutableDictionary *DeviceInfo = [[NSMutableDictionary alloc]init];
    
    if ([peripheral.name isEqualToString:@"Whala_Drink"]) {
        //需加入檢查連線狀態
        NSLog(@"name is whala_drink");
        [DeviceInfo setObject:peripheral.name forKey:@"devicename"];
        [DeviceInfo setObject:[peripheral.identifier UUIDString] forKey:@"deviceidentifier"];
        [DeviceInfo setObject:RSSI forKey:@"DevcieRSSI"];
        [DeviceInfoArray addObject:DeviceInfo];
        [CenterManageArray addObject:peripheral];
        //[CenterManageArray addObject:peripheral];
       // [CenterManage connectPeripheral:peripheral options:nil];
    }
    
    else if ([peripheral.name isEqualToString:@"Whala"]) {
        //需加入檢查連線狀態
        NSLog(@"name is whala");
        [DeviceInfo setObject:peripheral.name forKey:@"devicename"];
        [DeviceInfo setObject:[peripheral.identifier UUIDString] forKey:@"deviceidentifier"];
        [DeviceInfo setObject:RSSI forKey:@"DevcieRSSI"];
        [DeviceInfoArray addObject:DeviceInfo];
        [CenterManageArray addObject:peripheral];
        //[CenterManage connectPeripheral:peripheral options:nil];
    }
     
}

#pragma Connect Peripheral

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    [self StopScan];
    NSLog(@"peripheral:%@\n",peripheral.name);
    NSLog(@"peripheral server count:%lu\n",peripheral.services.count);
    peripheral.delegate = self;
    [restServices removeAllObjects];
    [peripheral discoverServices:nil];
    ConnectPeripheral = peripheral;
    [self BLEConnectState:@"YES"];
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    NSLog(@"Fail to Connect Peripheral: %@",error.description);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(nonnull CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    NSLog(@"Disconnected: %@",peripheral.name);
    [self BLEConnectState:@"NO"];
  [self StartScan];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    
    if(error) {
        NSLog(@"didDiscoverServices error: %@",error.description);
        [CenterManage cancelPeripheralConnection:peripheral];
       // [self StartScan];
        return;
    }
    NSLog(@"peripheral.services = %@",peripheral.services);
    NSLog(@"peripheral.services.count = %lu",peripheral.services.count);
    NSArray *allServices = peripheral.services;
    [restServices addObjectsFromArray:allServices];
    
    // Pick the first one to discover characteristic
    // discoverCharacteristics 觸發 didDiscoverCharacteristicsForService
    for (CBService *p in peripheral.services){
        NSLog(@"Service found with UUID: %@\n", p.UUID);
        [peripheral discoverCharacteristics:nil forService:p];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    
    if(error) {
        NSLog(@"didDiscoverCharacteristics error: %@",error.description);
        [CenterManage cancelPeripheralConnection:peripheral];
     //   [self StartScan];
        return;
    }
    
    NSLog(@"service characteristics = %@",service.characteristics);
    talkingCharacteristic = service.characteristics[1];
    
    for(CBCharacteristic *cbc in service.characteristics) {
        NSLog(@"service characteristic UUID = %@",cbc.UUID);
        //two service characteristics 6E400003-B5A3-F393-E0A9-E50E24DCCA9E read data
        if ([cbc.UUID.UUIDString isEqualToString:@"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"]){
            [peripheral setNotifyValue:YES forCharacteristic:cbc];
            NSLog(@"When bluetooth data update");
        }
    }
    [self SettingFunctionCode:@"SetTime" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
    if (ChangeCupMode) {
        [self SettingFunctionCode:@"SettingDevice" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
        ChangeCupMode = NO;
    }
}

// Invoked when a spec'd characteristic's state changes
-(void)peripheral:(CBPeripheral *)peripheral didUpdateStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"Peripheral State Changed");
}

// Invoked when you retrieve a spec'd characteristic's value, or when the peripheral device notifies the app that the characteristic's value has changed
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //NSLog(@"characteristic is %@",characteristic.value);
    [self getWaterCoasterDataupdate:characteristic];
    
}
//Accept device
- (void) getWaterCoasterDataupdate:(CBCharacteristic *)characteristic {
    [self DataAnalysis:characteristic.value];
}

- (void) DataAnalysis:(NSData *) Data{
    NSLog(@"Accept command is %@",Data);
    if (Data.length == 14){
        [Data getBytes:&startCode range:NSMakeRange(0, 1)];
        [Data getBytes:&DeviceFunctionCode range:NSMakeRange(1, 1)];
        [Data getBytes:&YearCode range:NSMakeRange(2, 1)];
        [Data getBytes:&MonthCode range:NSMakeRange(3, 1)];
        [Data getBytes:&DayCode range:NSMakeRange(4, 1)];
        [Data getBytes:&HourCode range:NSMakeRange(5, 1)];
        [Data getBytes:&MinuteCode range:NSMakeRange(6, 1)];
        [Data getBytes:&SecondCode range:NSMakeRange(7, 1)];
        [Data getBytes:&DrinkWaterCode1 range:NSMakeRange(8, 1)];
        [Data getBytes:&DrinkWaterCode2 range:NSMakeRange(9, 1)];
        [Data getBytes:&DrinkTime1 range:NSMakeRange(10, 1)];
        [Data getBytes:&DrinkTime2 range:NSMakeRange(11, 1)];
        [Data getBytes:&PowerCode range:NSMakeRange(12, 1)];
        [Data getBytes:&EndCode range:NSMakeRange(13, 1)];
        [self DateAnalysis];
    }
}

- (void) DateAnalysis{
    NSString *yearstring = [NSString stringWithFormat:@"%d",(YearCode+2000)];
    NSString *Monthstring = [NSString stringWithFormat:@"%d",MonthCode];
    NSString *Daystring = [NSString stringWithFormat:@"%d",DayCode];
    NSString *Hourstring = [NSString stringWithFormat:@"%d",HourCode];
    NSString *Minutestring = [NSString stringWithFormat:@"%d",MinuteCode];
    NSString *Secondstring = [NSString stringWithFormat:@"%d",SecondCode];
    NSString *Datestring = [NSString stringWithFormat:@"%@-%@-%@ %@:%@:%@",yearstring,Monthstring,Daystring,Hourstring,Minutestring,Secondstring];
//    NSLog(@"%@",Datestring);
    [self verification:Datestring];
}

- (void) verification :(NSString *)Date{
    [self NotifictionRowData:[NSString stringWithFormat:@"%02x%02x%02x%02x\t%02x%02x%02x%02x\t%02x%02x%02x%02x\t%02x%02x",startCode,DeviceFunctionCode,YearCode,MonthCode,DayCode,HourCode,MinuteCode,SecondCode,DrinkWaterCode1,DrinkWaterCode2,DrinkTime1,DrinkTime2,PowerCode,EndCode]];
    if (startCode == 65) {
        //NSLog(@"the return function code is -------- %d", FunctionCode);
        if (DeviceFunctionCode == 4){
            
        }
        else if (DeviceFunctionCode == 1){
            //Device time Setting
            NSLog(@"Time Set");
            [self NotifictionData:@"Setting Time Up"];
        }
        else if (DeviceFunctionCode == 2){
            //Device Remind time
            NSLog(@"Device Remind time Set");
            int LedRemindtimeSetting = YearCode;
            [self NotifictionData:[NSString stringWithFormat:@"Remind Time setting time is %d",LedRemindtimeSetting]];
        }
        else if (DeviceFunctionCode == 5){
            NSLog(@"Ping Code Incorrect");
            [self NotifictionData:@"PingCode Incorrect"];
        }
        else if (DeviceFunctionCode == 6){
            //DrinkWater Value
            int TotalDR = DrinkWaterCode1*DrinkWaterCode2;
            [self NotifictionData:[NSString stringWithFormat:@"Waterline Coaster Data is %d Time is %@",TotalDR,Date]];
            
        }
        else if (DeviceFunctionCode == 7){
            //DrinkWater Value
            //controltext.text = @"Finash the drink data";
            [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(TimeToDrinkData:) userInfo:nil repeats:NO];
            [self NotifictionData:@"Finish"];
        }
        else if (DeviceFunctionCode == 8){
            //PowerValue for Device
            //NSLog(@"Power Value = %d",PowerCode);
            [self NotifictionData:[NSString stringWithFormat:@"Waterline Coaster Power is %d",PowerCode]];

        }
        else if (DeviceFunctionCode == 9){
            //ChangeCup complete
        }
        else if (DeviceFunctionCode == 98){
            //Device Setting Done
            NSLog(@"Device Setting Done");
        }
        else if (DeviceFunctionCode == 99){
            //Device Reset
            NSLog(@"Device Reset");
            [self NotifictionData:@"Device Reset"];
        }
    }
    else{
        //NSLog(@"Fail");
    }
}

- (void)WriteBtn:(NSString *)Data{
    NSString *content =[NSString stringWithFormat:@"Data = %@\n",Data];
    
    //Get the file path
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"waterline.txt"];
    
    //create file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    //append text to file (you'll probably want to add a newline every write)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
    
}

//Write to device
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        //NSLog(@"%@", error);
    }
}

-(void)writeCharacteristic:(CBPeripheral *)peripheral
            characteristic:(CBCharacteristic *)characteristic
                     value:(NSData *)value{
    
    //NSLog(@"%lu", (unsigned long)characteristic.properties);
    
    if(characteristic.properties & CBCharacteristicPropertyWrite){
        
        [peripheral writeValue:value forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        //NSLog(@"可寫入字串");
    }else{
        //NSLog(@"该字段不可写！");
    }
    
}


- (void)SendData:(NSString *)DateTime Function:(NSString *)FunctionCode RemindTime:(NSString *)RemindTime PingCode:(NSString *)PingCode{
    
    NSString *pingCode = @"0c22";
    NSString *StartCode = @"41";
    NSString *PhoneEndCode = @"5a";
    NSString *command = [NSString stringWithFormat:@"%@%@%@%@%@%@",StartCode,FunctionCode,DateTime,RemindTime,pingCode,PhoneEndCode];
    command = [command stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    NSData *immutableData = [NSData dataWithData:commandToSend];
    NSLog(@"%@", immutableData);
    [self writeCharacteristic:ConnectPeripheral characteristic:talkingCharacteristic value:immutableData];
}

- (void) SettingSystemTime:(NSString *)FunctionCode RemindTime:(NSString *)RemindTime PingCode:(NSString *)PingCode{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSMutableDictionary *TimeDataDictionary = [[NSMutableDictionary alloc]init];
    NSString *TimeData;
    for (int i=0; i<7; i++) {
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        switch (i) {
            case 0:
                [dateFormatter setDateFormat:@"YY"];
                [TimeDataDictionary setObject:[NSString stringWithFormat:@"%02x",[[dateFormatter stringFromDate:date] intValue]] forKey:@"Year"];
                break;
            case 1:
                [dateFormatter setDateFormat:@"MM"];
                [TimeDataDictionary setObject:[NSString stringWithFormat:@"%02x",[[dateFormatter stringFromDate:date] intValue]] forKey:@"Month"];
                break;
            case 2:
                [dateFormatter setDateFormat:@"dd"];
                [TimeDataDictionary setObject:[NSString stringWithFormat:@"%02x",[[dateFormatter stringFromDate:date] intValue]] forKey:@"Day"];
                break;
            case 3:
                [dateFormatter setDateFormat:@"ee"];
                int weekday = [[dateFormatter stringFromDate:date] intValue] - 1;
                [TimeDataDictionary setObject:[NSString stringWithFormat:@"%02x",weekday] forKey:@"Weekday"];
                break;
            case 4:
                [dateFormatter setDateFormat:@"HH"];
                [TimeDataDictionary setObject:[NSString stringWithFormat:@"%02x",[[dateFormatter stringFromDate:date] intValue]] forKey:@"Hour"];
                break;
            case 5:
                [dateFormatter setDateFormat:@"mm"];
                [TimeDataDictionary setObject:[NSString stringWithFormat:@"%02x",[[dateFormatter stringFromDate:date] intValue]] forKey:@"Minute"];
                break;
            case 6:
                [dateFormatter setDateFormat:@"ss"];
                [TimeDataDictionary setObject:[NSString stringWithFormat:@"%02x",[[dateFormatter stringFromDate:date] intValue]] forKey:@"Second"];
                break;
            default:
                break;
        }
    }
 //   NSLog(@"%@",TimeDataDictionary);
    TimeData  = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                 [TimeDataDictionary objectForKey:@"Year"],
                 [TimeDataDictionary objectForKey:@"Month"],
                 [TimeDataDictionary objectForKey:@"Day"],
                 [TimeDataDictionary objectForKey:@"Weekday"],
                 [TimeDataDictionary objectForKey:@"Hour"],
                 [TimeDataDictionary objectForKey:@"Minute"],
                 [TimeDataDictionary objectForKey:@"Second"]];
 //   NSLog(@"%@",TimeData);
    [self SendData:TimeData Function:FunctionCode RemindTime:RemindTime PingCode:PingCode];
}

- (void) SettingFunctionCode:(NSString *)FunctionCodeKey RemindTime:(NSNumber *)remindtime PingCode:(NSString *)pingcode {
    
    NSString *SettingFunction;
    NSString *deviceremindtime;
    NSMutableDictionary *FunctionCodeMenu = [[NSMutableDictionary alloc]init];
    [FunctionCodeMenu setValue:@"1" forKey:@"SetTime"];
    [FunctionCodeMenu setValue:@"2" forKey:@"SetDeviceRemind"];
    [FunctionCodeMenu setValue:@"3" forKey:@"SettingPingCode"];
    [FunctionCodeMenu setValue:@"4" forKey:@"Checkpingcode"];
    [FunctionCodeMenu setValue:@"5" forKey:@"DataDrink"];
    [FunctionCodeMenu setValue:@"6" forKey:@"GetData"];
    [FunctionCodeMenu setValue:@"7" forKey:@"PowerValue"];
    [FunctionCodeMenu setValue:@"8" forKey:@"ChangeCup"];
    [FunctionCodeMenu setValue:@"9" forKey:@"DisconnectBLE"];
    [FunctionCodeMenu setValue:@"98" forKey:@"SettingDevice"];
    [FunctionCodeMenu setValue:@"99" forKey:@"ResetDevice"];
    SettingFunction = [NSString stringWithFormat:@"%02x",[[FunctionCodeMenu objectForKey:FunctionCodeKey]intValue]];
    deviceremindtime = [NSString stringWithFormat:@"%02x",[remindtime intValue]];
    [self SettingSystemTime:SettingFunction RemindTime:deviceremindtime PingCode:pingcode];
    NSLog(@"Settingfunction %@ RemindTime %@ PingCode %@",SettingFunction,remindtime,pingcode);
}

- (void)NotifictionData:(NSString *)Data{
    NSMutableDictionary *Coasteraccept = [[NSMutableDictionary alloc]init];
    [Coasteraccept setValue:Data forKey:@"Data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CoasterData"
                                                        object:self
                                                      userInfo:Coasteraccept];
}

- (void)NotifictionRowData:(NSString *)Data{
    NSMutableDictionary *CoasteracceptRowData = [[NSMutableDictionary alloc]init];
    [CoasteracceptRowData setValue:Data forKey:@"Data"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CoasterRowData" //Notification以一個字串(Name)下去辨別
                                                        object:self
                                                      userInfo:CoasteracceptRowData];
}

- (void)BLEConnectState:(NSString *)ConnectState{
    NSMutableDictionary *State = [[NSMutableDictionary alloc]init];
    [State setValue:ConnectState forKey:@"BLEState"];
    [State setValue:ConnectPeripheral.name forKey:@"BLEName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectState"
                                                        object:self
                                                      userInfo:State];
}

- (void)ScanDevice:(NSArray *)Device{
    NSMutableDictionary *devicearray = [[NSMutableDictionary alloc]init];
    [devicearray setObject:Device forKey:@"devicearray"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Device"
                                                        object:self
                                                      userInfo:devicearray];
}


- (void)TimeToDrinkData:(NSTimer *)sander{
    [self SettingFunctionCode:@"DataDrink" RemindTime:[NSNumber numberWithInt:20] PingCode:[NSString stringWithFormat:@"%d",20]];
}

@end

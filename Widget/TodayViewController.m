//
//  TodayViewController.m
//  Widget
//
//  Created by Mac on 2018/11/7.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (kCurrentSystemVersion >= 10) {
        // NCWidgetDisplayModeCompact, // 高度固定
        // NCWidgetDisplayModeExpanded, // 高度可变
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeCompact;
    }
    // 设置高度
    self.preferredContentSize = CGSizeMake(kScreenW, 100);
    
//    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // iOS9需要手动更新视图
    if (kCurrentSystemVersion < 9.9 && kCurrentSystemVersion > 8.9) {
        [self widgetPerformUpdateWithCompletionHandler:^(NCUpdateResult result) {}];
    }
}

// 更新视图
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // NCUpdateResultNewData   新的内容需要重新绘制视图
    // NCUpdateResultNoData    部件不需要更新
    // NCUpdateResultFailed    更新过程中发生错误
    completionHandler(NCUpdateResultNoData);
}

// iOS8下组件默认右移30单位，下面方法修改位置
//- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}

// 当模式为NCWidgetDisplayModeExpanded时，点击折叠和打开触发下面方法
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    } else {
        self.preferredContentSize = CGSizeMake(maxSize.width, 200);
    }
}

#pragma mark - Private
// 设置UI
- (void)setupUI {
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(150, 0, 40, 40)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"w01.png"] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 addTarget:self action:@selector(fun1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 37, 15)];
    label1.text = @"功能一";
    label1.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:label1];
}
// 存储数据
- (BOOL)saveDataByNSFileManager {
    // 使用 NSFileManager 存储数据
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_GROUPS_ID];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/Widget"];
    NSString *value = @"Test Value";
    BOOL result = [value writeToURL:containerURL atomically:YES encoding:NSUTF8StringEncoding error:&err];
    if (!result) {
        NSLog(@"%@",err);
    } else {
        NSLog(@"save value:%@ success.",value);
    }
    return result;
    // 使用 NSUserDefaults 存储数据
//    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUPS_ID];
//    [userDefaults setObject:self.textField.text forKey:@"widget"];
//    [userDefaults synchronize];
}
// 读取数据
- (NSString *)readDataByNSFileManager
{
    // 使用 NSFileManager 读取数据
    NSError *err = nil;
    NSURL *containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:APP_GROUPS_ID];
    containerURL = [containerURL URLByAppendingPathComponent:@"Library/Caches/Widget"];
    NSString *value = [NSString stringWithContentsOfURL:containerURL encoding: NSUTF8StringEncoding error:&err];
    return value;
    // 使用 NSUserDefaults 读取数据
//    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:APP_GROUPS_ID];
//    self.contentStr = [userDefaults objectForKey:@"widget"];
}

// 唤醒主程序
- (IBAction)fun1:(id)sender {
    DLog(@"功能1");
    [self openUrlTypes:URL_TYPES_1];
}
- (IBAction)fun2:(id)sender {
    DLog(@"功能2");
    [self openUrlTypes:URL_TYPES_2];
}
- (IBAction)fun3:(id)sender {
    DLog(@"功能3");
    [self openUrlTypes:URL_TYPES_3];
}
- (IBAction)fun4:(id)sender {
    DLog(@"功能4");
    [self openUrlTypes:URL_TYPES_4];
}
- (IBAction)fun5:(id)sender {
    DLog(@"功能5");
    [self openUrlTypes:URL_TYPES_5];
}
- (void)openUrlTypes:(NSString *)url {
    [self.extensionContext openURL:[NSURL URLWithString:url]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
    // 已禁止跳转到【设置】页面
    // iOS10
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"] options:@{} completionHandler:nil];
    // iOS9 8 7
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}

@end

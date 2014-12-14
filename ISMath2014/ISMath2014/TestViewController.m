//
//  TestViewController.m
//  ISMath2014
//
//  Created by 孙振东 on 14/12/11.
//  Copyright (c) 2014年 gbstudio. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (instancetype)init {
    if ((self = [super init])) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"gf28";
    [self buildGF28];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 建立页面
/**
 *  建立gf28四则运算界面
 */
- (void)buildGF28
{
    mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    gfArg1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 150, 40)];
    gfArg1.placeholder = @"参数1";
    gfArg1.keyboardType = UIKeyboardTypeNumberPad;
    gfArg1.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    gfArg1.delegate = self;
    [mainView addSubview:gfArg1];
    
    gfArg2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 150, 40)];
    gfArg2.placeholder = @"参数2";
    gfArg2.keyboardType = UIKeyboardTypeNumberPad;
    gfArg2.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    gfArg2.delegate = self;
    [mainView addSubview:gfArg2];
    
    add = [UIButton buttonWithType:UIButtonTypeCustom];
    [add setFrame:CGRectMake(20, 200, 50, 40)];
    [add setTitle:@"add" forState:UIControlStateNormal];
    [add setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    add.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    // 设置按钮边框
    add.layer.borderColor = [[UIColor blackColor] CGColor];
    add.layer.borderWidth = 1.0f;
    add.layer.cornerRadius = 8.0f;
    [mainView addSubview:add];
    
    mul = [UIButton buttonWithType:UIButtonTypeCustom];
    [mul setFrame:CGRectMake(120, 200, 50, 40)];
    [mul setTitle:@"mul" forState:UIControlStateNormal];
    [mul setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    mul.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    // 设置按钮边框
    mul.layer.borderColor = [[UIColor blackColor] CGColor];
    mul.layer.borderWidth = 1.0f;
    mul.layer.cornerRadius = 8.0f;
    [mainView addSubview:mul];
    
    [add addTarget:self action:@selector(gfAdd) forControlEvents:UIControlEventTouchUpInside];
    [mul addTarget:self action:@selector(gfMul) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = mainView;
}

#pragma mark - gf28四则运算
/**
 *  gf28加法运算
 */
- (void)gfAdd
{
    NSArray *arg1 = [[NSArray alloc] init];
    arg1 = [self getArgArray:gfArg1.text];
    NSArray *arg2 = [[NSArray alloc] init];
    arg2 = [self getArgArray:gfArg2.text];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSUInteger minlength = 0;
    NSUInteger maxlength = 0;
    if (arg1.count > arg2.count) {
        minlength = arg2.count;
        maxlength = arg1.count;
        
        for (int i = 0 ; i < (int)minlength; i++) {
            NSNumber *temp = [NSNumber numberWithInteger:[arg1 objectAtIndex:i] == [arg2 objectAtIndex:i] ? 0 : 1 ];
            [result addObject:temp];
        }
        
        for (int i = (int)minlength; i < (int)maxlength; i++) {
            [result addObject:[arg1 objectAtIndex:i]];
        }
            
    } else {
        minlength = arg1.count;
        maxlength = arg2.count;
        
        
        for (int i = 0 ; i < (int)minlength; i++) {
            NSNumber *temp = [NSNumber numberWithInteger:[arg1 objectAtIndex:i] == [arg2 objectAtIndex:i] ? 0 : 1 ];
            [result addObject:temp];
        }
        
        for (int i = (int)minlength; i < (int)maxlength; i++) {
            [result addObject:[arg2 objectAtIndex:i]];
        }
    }
    
    NSLog(@"%@", result);
    [self createResultLable:result];
}

/**
 *  gf28乘法运算
 */
- (void)gfMul
{
    NSArray *arg1 = [[NSArray alloc] init];
    arg1 = [self getArgArray:gfArg1.text];
    
}

/**
 *  显示结果
 *
 *  @param array 结果数组
 */
- (void)createResultLable:(NSArray*)array
{
    NSString *resultStr = @"result: ";
    for (int i = 0; i < array.count; i++) {
        if ([array objectAtIndex:i] != 0) {
            if (i != array.count - 1) {
                if (i == 0) {
                    resultStr = [resultStr stringByAppendingFormat:@"1 + "];
                } else {
                    resultStr = [resultStr stringByAppendingFormat:@"x^%d + ", i];
                }
            } else {
                resultStr = [resultStr stringByAppendingFormat:@"x^%d", i];
            }
        }
    }
    NSLog(@"%@", resultStr);
    
    lbresult = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 300, 50)];
    lbresult.text = resultStr;
    [lbresult setTextColor:[UIColor blackColor]];
    
    [self.view addSubview:lbresult];
}
/**
 *  获取数组形式的参数
 *  注意数组的顺序
 *
 *  @param string 参数字符串
 *
 *  @return 参数数组
 */
- (NSArray *)getArgArray:(NSString *)string
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = (int)string.length - 1; i > -1; i--) {
        [array addObject:[self getIntAtPlace:string withPlace:i]];
    }
    return array;
}

/**
 *  获取字符串指定位置的数字
 *
 *  @param string 字符串
 *  @param place  位置
 *
 *  @return 返回的数字
 */
- (NSNumber *)getIntAtPlace:(NSString*)string withPlace:(int)place
{
    return [NSNumber numberWithInt:[[string substringWithRange:NSMakeRange(place, 1)] intValue]];
}

#pragma mark - UITextField 代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > 7) {
        NSLog(@"不能超过8位");
        return NO;
    }
    if ([string isEqualToString:@"1"] || [string isEqualToString:@"0"]) {
        return YES;
    }
    NSLog(@"请输入0或1");
    return NO;
}
@end

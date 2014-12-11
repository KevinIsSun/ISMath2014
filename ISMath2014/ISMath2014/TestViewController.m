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

- (void)buildGF28
{
    mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    gfArg1 = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, 150, 40)];
    gfArg1.placeholder = @"参数1";
    gfArg1.keyboardType = UIKeyboardTypeNumberPad;
    gfArg1.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    [mainView addSubview:gfArg1];
    
    gfArg2 = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, 150, 40)];
    gfArg2.placeholder = @"参数2";
    gfArg2.keyboardType = UIKeyboardTypeNumberPad;
    gfArg2.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
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

- (void)gfAdd
{
    int arg1 = [gfArg1.text intValue];
    int arg2 = [gfArg2.text intValue];
    NSLog(@"%d", arg1);
}

- (void)gfMul
{
    int arg1 = [gfArg1.text intValue];
    int agr2 = [gfArg2.text intValue];
}
@end

//
//  TestViewController.h
//  ISMath2014
//
//  Created by 孙振东 on 14/12/11.
//  Copyright (c) 2014年 gbstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController
{
    UIView *mainView;
    UITextField *gfArg1;
    UITextField *gfArg2;
    
    UIButton *add;
    UIButton *mul;
}

@property(nonatomic, assign)int actionType;

@end

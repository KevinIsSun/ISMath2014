//
//  TestViewController.h
//  ISMath2014
//
//  Created by 孙振东 on 14/12/11.
//  Copyright (c) 2014年 gbstudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController<UITextFieldDelegate>
{
    UIView *mainView;
    UITextField *gfArg1;
    UITextField *gfArg2;
    
    int table[256];
    int arc_table[256];
    int inverse_table[256];
    
    UIButton *add;
    UIButton *mul;
    UIButton *inverse;
    UIButton *startCountNormal;
    UIButton *startCount;
    
    UILabel *lbresult;
}

@property(nonatomic, assign)int actionType;

@end

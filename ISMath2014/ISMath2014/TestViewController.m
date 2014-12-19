//
//  TestViewController.m
//  ISMath2014
//
//  Created by 孙振东 on 14/12/11.
//  Copyright (c) 2014年 gbstudio. All rights reserved.
//

#import "TestViewController.h"
#import "math.h"
#import "stdlib.h"
#import "time.h"

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
    
    [self initTables];
    
    switch (self.actionType) {
        case 0:
            self.title = @"gf28";
            [self buildGF28];
            break;
        case 1:
            self.title = @"CountTime";
            [self buildCountTime];
            break;
        case 2:
            [self calculateSbox];
            break;
        default:
            break;
    }
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

/**
 *  建立测算时间页面，测算100000个乘法和100000个求逆元的时间
 */
- (void)buildCountTime
{
    mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    startCount = [UIButton buttonWithType:UIButtonTypeCustom];
    [startCount setFrame:CGRectMake(20, 200, 100, 40)];
    [startCount setTitle:@"开始计算" forState:UIControlStateNormal];
    [startCount setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    startCount.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:20];
    // 设置按钮边框
    startCount.layer.borderColor = [[UIColor blackColor] CGColor];
    startCount.layer.borderWidth = 1.0f;
    startCount.layer.cornerRadius = 8.0f;
    [mainView addSubview:startCount];
    
    [startCount addTarget:self action:@selector(startCount) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = mainView;
}
#pragma mark - init action
/**
 *  初始化正表反表逆元表
 */
- (void)initTables
{
    int i;
    
    table[0] = 1;//g^0
    for(i = 1; i < 255; ++i)//生成元为x + 1
    {
        //下面是m_table[i] = m_table[i-1] * (x + 1)的简写形式
        table[i] = (table[i-1] << 1 ) ^ table[i-1];
        
        //最高指数已经到了8，需要模上m(x)
        if( table[i] & 0x100 )
        {
            table[i] ^= 0x11B;//用到了前面说到的乘法技巧
        }  
    }
    
    for(i = 0; i < 255; ++i)
        arc_table[ table[i] ] = i;
    
    for(i = 1; i < 256; ++i)//0没有逆元，所以从1开始
    {
        int k = arc_table[i];
        k = 255 - k;
        k %= 255;//m_table的取值范围为 [0, 254]
        inverse_table[i] = table[k];
    }
}

/**
 *  线性分析
 */
- (void)calculateSbox
{
    
    clock_t clockStart = clock();
    // 初始化SBOX
    unsigned char s[256] =
    {
        0x63, 0x7C, 0x77, 0x7B, 0xF2, 0x6B, 0x6F, 0xC5, 0x30, 0x01, 0x67, 0x2B, 0xFE, 0xD7, 0xAB, 0x76,
        0xCA, 0x82, 0xC9, 0x7D, 0xFA, 0x59, 0x47, 0xF0, 0xAD, 0xD4, 0xA2, 0xAF, 0x9C, 0xA4, 0x72, 0xC0,
        0xB7, 0xFD, 0x93, 0x26, 0x36, 0x3F, 0xF7, 0xCC, 0x34, 0xA5, 0xE5, 0xF1, 0x71, 0xD8, 0x31, 0x15,
        0x04, 0xC7, 0x23, 0xC3, 0x18, 0x96, 0x05, 0x9A, 0x07, 0x12, 0x80, 0xE2, 0xEB, 0x27, 0xB2, 0x75,
        0x09, 0x83, 0x2C, 0x1A, 0x1B, 0x6E, 0x5A, 0xA0, 0x52, 0x3B, 0xD6, 0xB3, 0x29, 0xE3, 0x2F, 0x84,
        0x53, 0xD1, 0x00, 0xED, 0x20, 0xFC, 0xB1, 0x5B, 0x6A, 0xCB, 0xBE, 0x39, 0x4A, 0x4C, 0x58, 0xCF,
        0xD0, 0xEF, 0xAA, 0xFB, 0x43, 0x4D, 0x33, 0x85, 0x45, 0xF9, 0x02, 0x7F, 0x50, 0x3C, 0x9F, 0xA8,
        0x51, 0xA3, 0x40, 0x8F, 0x92, 0x9D, 0x38, 0xF5, 0xBC, 0xB6, 0xDA, 0x21, 0x10, 0xFF, 0xF3, 0xD2,
        0xCD, 0x0C, 0x13, 0xEC, 0x5F, 0x97, 0x44, 0x17, 0xC4, 0xA7, 0x7E, 0x3D, 0x64, 0x5D, 0x19, 0x73,
        0x60, 0x81, 0x4F, 0xDC, 0x22, 0x2A, 0x90, 0x88, 0x46, 0xEE, 0xB8, 0x14, 0xDE, 0x5E, 0x0B, 0xDB,
        0xE0, 0x32, 0x3A, 0x0A, 0x49, 0x06, 0x24, 0x5C, 0xC2, 0xD3, 0xAC, 0x62, 0x91, 0x95, 0xE4, 0x79,
        0xE7, 0xC8, 0x37, 0x6D, 0x8D, 0xD5, 0x4E, 0xA9, 0x6C, 0x56, 0xF4, 0xEA, 0x65, 0x7A, 0xAE, 0x08,
        0xBA, 0x78, 0x25, 0x2E, 0x1C, 0xA6, 0xB4, 0xC6, 0xE8, 0xDD, 0x74, 0x1F, 0x4B, 0xBD, 0x8B, 0x8A,
        0x70, 0x3E, 0xB5, 0x66, 0x48, 0x03, 0xF6, 0x0E, 0x61, 0x35, 0x57, 0xB9, 0x86, 0xC1, 0x1D, 0x9E,
        0xE1, 0xF8, 0x98, 0x11, 0x69, 0xD9, 0x8E, 0x94, 0x9B, 0x1E, 0x87, 0xE9, 0xCE, 0x55, 0x28, 0xDF,
        0x8C, 0xA1, 0x89, 0x0D, 0xBF, 0xE6, 0x42, 0x68, 0x41, 0x99, 0x2D, 0x0F, 0xB0, 0x54, 0xBB, 0x16
    };
    
    int origin[256][8] = {0};
    int sbox[256][8] = {0};
    int func[65536][16] = {0};
    
    for (int i = 0; i < 256; i++) {
        int temp = i;
        for (int j = 7; j > -1; j--) {
            if (pow(2, j) <= temp) {
                origin[i][j] = 1;
                
                temp = temp - pow(2, j);
            }
        }
    }
    
    for (int i = 0; i < 256; i++) {
        for (int j = 7; j > -1; j--) {
            if (pow(2, j) <= s[i]) {
                sbox[i][j] = 1;
                
                s[i] = s[i] - pow(2, j);
            }
         }
    }

    for (int i = 0; i < 65536; i++) {
        int temp = i;
        for (int j = 15; j > -1; j--) {
            if (pow(2, j) <= temp) {
                func[i][j] = 1;
                
                temp = temp - pow(2, j);
            }
        }
    }
    
    int result[65536] = {0};
    result[0] = -1;
    
    for (int i = 1; i < 65536; i++) {
        for (int j = 0; j < 256; j++) {
            int temp = 0;
            BOOL firstFlag = NO;
            BOOL secondFlag = NO;
            for (int k = 0; k < 16; k++) {
                if (func[i][k] == 1) {
                    if (firstFlag == NO) {
                        if (k < 8) {
                            temp = origin[j][k];
                            firstFlag = YES;
                        }
                    } else {
                        if (k > 7) {
                            secondFlag = YES;
                            temp = temp ^ sbox[j][k - 8];
                        } else if (k < 8){
                            temp = temp ^ origin[j][k];
                        }
                    }
                }
            }
            if (secondFlag == YES && firstFlag == YES) {
                result[i] += temp;
            }
            else {
                result[i] = 128;
            }
            
        }
    }
    
    float bias[65536] = {0.0f};
    int record[65536] = {0};
    
    for (int i = 1; i < 65536; i++) {
//        bias[i] = fabs((float)result[i] / 256 - 0.5);
        bias[i] = (float)result[i] / 256;
        record[i] = i;
    }
    
    bubble(&bias[1], 65535, &record[1]);

    for (int i = 0; i < 300; i++) {
        NSLog(@"%f", bias[65535-i]);
        NSLog(@"%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d", func[record[65535-i]][0], func[record[65535-i]][1],func[record[65535-i]][2],func[record[65535-i]][3],func[record[65535-i]][4],func[record[65535-i]][5],func[record[65535-i]][6],func[record[65535-i]][7],func[record[65535-i]][8],func[record[65535-i]][9],func[record[65535-i]][10],func[record[65535-i]][11],func[record[65535-i]][12],func[record[65535-i]][13],func[record[65535-i]][14],func[record[65535-i]][15]);
    }
    clock_t clockEnd = clock();
    NSLog(@"time is %f", (clockEnd - clockStart)/(double)CLOCKS_PER_SEC);
}

/**
 *  冒泡排序
 *
 *  @param a      <#a description#>
 *  @param n      <#n description#>
 *  @param record <#record description#>
 */
void bubble(float *a,int n, int *record) /*定义两个参数：数组首地址与数组大小*/
{
    int i,j;
    float temp;
    float recordTemp;
    for(i=0;i<n-1;i++)
        for(j=i+1;j<n;j++) /*注意循环的上下限*/
            if(a[i]>a[j]) {
                temp=a[i];
                a[i]=a[j];
                a[j]=temp;
                recordTemp = record[i];
                record[i] = record[j];
                record[j] = recordTemp;
            }
}

#pragma mark - 测算时间
/**
 *  计算100000个乘法和100000个求逆元时间
 */
- (void)startCount
{
    int mulResult, inverseResult = 0;
    clock_t clockStart = clock();
    NSLog(@"mark start");
    for (int i = 0; i < 100000; i++) {
        int ran = random() % 254 + 1;
        mulResult =  table[ (arc_table[ran] + arc_table[ran]) % 255];
        inverseResult = inverse_table[ran];
    }
    clock_t clockEnd = clock();
    NSLog(@"%f", (clockEnd - clockStart)/(double)CLOCKS_PER_SEC);
    
    NSString *resultStr = @"";
    resultStr = [resultStr stringByAppendingFormat:@"result: %f s", (clockEnd - clockStart)/(double)CLOCKS_PER_SEC];
    lbresult = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 360, 80)];
    lbresult.text = resultStr;
    [lbresult setTextColor:[UIColor blackColor]];
    
    [self.view addSubview:lbresult];
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
    
    [self createResultLable:result];
}

/**
 *  gf28乘法运算
 */
- (void)gfMul
{
    NSArray *arg1 = [[NSArray alloc] init];
    arg1 = [self getArgArray:gfArg1.text];
    NSArray *arg2 = [[NSArray alloc] init];
    arg2 = [self getArgArray:gfArg2.text];
    
    int arg1Int, arg2Int = 0;
    for (int i = 0; i < arg1.count; i++) {
        arg1Int += [[arg1 objectAtIndex:i] intValue] * pow(2, i);
    }
    
    for (int i = 0 ; i < arg2.count; i++) {
        arg2Int += [[arg2 objectAtIndex:i] intValue] * pow(2, i);
    }
    
    int resultInt = table[ (arc_table[arg1Int] + arc_table[arg2Int]) % 255];
    
    [self createResultLableByInt:resultInt];
}

- (void)createResultLableByInt:(int)arg
{
    
    NSString *resultStr = @"result:";
    
    for (int i = 7; i > -1; i--) {
        if (pow(2, i) <= arg) {
            if (i != 0) {
                resultStr = [resultStr stringByAppendingFormat:@"x^%d + ", i];
            } else {
                resultStr = [resultStr stringByAppendingString:@"1 + "];
            }
            
            arg = arg - pow(2, i);
        }
    }
    
    resultStr = [resultStr substringToIndex:resultStr.length - 2];
    
    lbresult = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 360, 80)];
    lbresult.text = resultStr;
    [lbresult setTextColor:[UIColor blackColor]];
    
    [self.view addSubview:lbresult];
}

/**
 *  显示结果
 *
 *  @param array 结果数组
 */
- (void)createResultLable:(NSArray*)array
{
    NSString *resultStr = @"result:/n";
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
    
    lbresult = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 360, 80)];
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

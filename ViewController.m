//
//  ViewController.m
//  WDCalculator
//
//  Created by Blake on 15/2/27.
//  Copyright (c) 2015年 Blake. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorView.h"

@interface ViewController ()<CalculatorDelegate>
{
    CalculatorView* calculator;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    calculator = [[CalculatorView alloc]initWithFrame:CGRectMake(0, 64, WinSize.width, WinSize.height)];
    calculator.delegate = self;
    [self.view addSubview:calculator];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)collectButtonClickedWithMoneyStr:(NSString*)money{

    
    NSLog(@"%@",money);

}


@end

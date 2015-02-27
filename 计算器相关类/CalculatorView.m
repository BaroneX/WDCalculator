//
//  CalculatorView.m
//  MSHappyCollectSilver
//
//  Created by Blake on 14/8/15.
//  Copyright (c) 2014年 BLAKE. All rights reserved.
//

#import "CalculatorView.h"
#import "VENMoneyCalculator.h"
#import "UITextField+Insert.h"


@interface CalculatorView ()
{
    UIButton* collectButton;//收款和计算按钮
    
    UIImage* collImage;//收款image
    UIImage* equalImage;//计算image
    
    UIImageView* equlButImageView;//收款计算按钮的显示的图片
    
    UITextView* resultView;
    
    BOOL reset;
    
}
@property(nonatomic,strong)VENMoneyCalculator* moneyCalculator;

@end

@implementation CalculatorView
@synthesize inputTf;
@synthesize resultView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
#pragma mark -初始化界面
-(void)initView{
    float topHeight = 150;
    float butHeight = 88;
    if (WinSize.height<500) {
        topHeight = 128;
        butHeight = 71;
    }
    
    //初始化计算类
    self.moneyCalculator = [[VENMoneyCalculator alloc]init];
    
    
    UIImageView* topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, topHeight)];
    
    topImage.image = [[UIImage imageNamed:@"Calculator_TopBg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeTile];
    [self addSubview:topImage];
    
    //初始化textFiled
    inputTf = [[UITextField alloc]initWithFrame:CGRectMake(0, topHeight/2, 320, topHeight/2)];
    [self addSubview:inputTf];
    inputTf.textAlignment = NSTextAlignmentRight;
    inputTf.font = [UIFont systemFontOfSize:40];
    inputTf.backgroundColor = [UIColor clearColor];
    inputTf.textColor = DarkTextColor;
    UIView *inputView = [UIView new];
    inputView.frame = CGRectZero;
    inputTf.inputView = inputView;
    inputTf.text = @"0.00";
    [inputTf becomeFirstResponder];
    inputTf.userInteractionEnabled = NO;
    inputTf.tintColor = [UIColor clearColor];
    inputTf.selected = NO;
    
    
    resultView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, topHeight/2)];
    resultView.font = [UIFont systemFontOfSize:25];
    resultView.textAlignment = NSTextAlignmentRight;
    resultView.backgroundColor = [UIColor clearColor];
    resultView.tintColor = [UIColor clearColor];
    resultView.textColor = DarkTextColor;
    resultView.selectable = NO;
    [self addSubview:resultView];
    
    
    //中间粗线
    UIImageView* topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, topImage.bottom, 320, 4)];
    topLine.image = [UIImage imageNamed:@"MS_HCS_Line.png"];
    [self addSubview:topLine];
    //    UIImageView* backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, topLine.bottom, 320, butHeight*4)];
    //    backImage.image = [[UIImage imageNamed:@"Calculator_NumBg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeTile];
    //
    //    [self addSubview:backImage];
    
    
    
    //添加计算器按钮
    NSArray* imageArr = @[@"1",@"2",@"3",@"Delete",@"4",@"5",@"6",@"Clear",@"7",@"8",@"9",@"x",@"0",@"Point",@"Add"];
    
    for (int i = 0; i< imageArr.count; i++) {
        if (i == 11 ) {
            continue;
        }
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setTitle:imageArr[i] forState:UIControlStateNormal];
        but.tintColor = [UIColor blueColor];
        
        [but setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        but.frame = CGRectMake(81*i%4,i/4*(butHeight+1)+topLine.bottom,80, butHeight);
        
        [but setBackgroundImage:[UIImage imageNamed:@"Calculator_NumBg.png"] forState:UIControlStateNormal];
        [self addSubview:but];
        
        if (i%4 != 3 & i != 14) {
            [but addTarget:self action:@selector(userDidTapKey:) forControlEvents:UIControlEventTouchUpInside];
        }else if(i == 3|| i == 7){
            
            [but addTarget:self action:@selector(calculatorInputViewDidTapBackspace:) forControlEvents:UIControlEventTouchUpInside];
        }else if(i == 14){
            [but setTitle:@"+" forState:UIControlStateNormal];
            [but addTarget:self action:@selector(calculatorInputViewDidTapAdd:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIImage* currentImage = [UIImage imageNamed:imageArr[i]];
        
        UIImageView* currentView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, currentImage.size.width/3, currentImage.size.height/3)];
        currentView.image = currentImage;
        currentView.center = CGPointMake(i%4*80+40, i/4*(butHeight+1)+butHeight/2+topLine.bottom);
        
        [self addSubview:currentView];
        but.center = currentView.center;
        
    }

    //加载横线和竖线
    UIImageView* hline1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,topLine.bottom+butHeight, 320, 1)];
    hline1.image = [UIImage imageNamed:@"Her_line"];
    [self addSubview:hline1];
    
    
    UIImageView* hline2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,hline1.bottom+butHeight, 320, 1)];
    hline2.image = [UIImage imageNamed:@"Her_line"];
    [self addSubview:hline2];
    
    
    UIImageView* hline3 = [[UIImageView alloc]initWithFrame:CGRectMake(0,hline2.bottom+butHeight, 240, 1)];
    hline3.image = [UIImage imageNamed:@"Her_line"];
    [self addSubview:hline3];
    
    UIImageView* vline1 = [[UIImageView alloc]initWithFrame:CGRectMake(80,topLine.bottom, 1, butHeight*4)];
    vline1.image = [UIImage imageNamed:@"VERLIne.png"];
    [self addSubview:vline1];
    
    UIImageView* vline2 = [[UIImageView alloc]initWithFrame:CGRectMake(160,topLine.bottom,1, butHeight*4)];
    vline2.image = [UIImage imageNamed:@"VERLIne.png"];
    [self addSubview:vline2];
    
    UIImageView* vline3 = [[UIImageView alloc]initWithFrame:CGRectMake(240,topLine.bottom, 1, butHeight*4)];
    vline3.image = [UIImage imageNamed:@"VERLIne.png"];
    [self addSubview:vline3];
    
    //添加收款按钮
    collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(vline3.left+1, topLine.bottom+butHeight*2+2, 80, butHeight*2);
    collectButton.tag = 1;//标识区分收款还是等于
    [collectButton setBackgroundImage:[UIImage imageNamed:@"Calculator_CollectBg.png"] forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collButCilcked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:collectButton];

        collImage = [UIImage imageNamed:@"Calculator_Coll.png"];

    equalImage = [UIImage imageNamed:@"Calculator_Equl.png"];
    
    equlButImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, collImage.size.width/2, collImage.size.height/2)];
    equlButImageView.image = collImage;
    equlButImageView.center = collectButton.center;
    [self addSubview:equlButImageView];
    
}
#pragma mark - 收款/计算按钮点击
-(void)collButCilcked:(UIButton*)sender{
    
    if (sender.tag) {
        //tag == 1;收款点击
        
        if ([self.inputTf.text doubleValue]<=0) {
          UIAlertView* alert =   [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"收款额不能为0" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return;
        }
        
        if (!self.delegate) {
            return;
        }
        
        [self.delegate collectButtonClickedWithMoneyStr:[NSString stringWithFormat:@"%.2f",[self.inputTf.text doubleValue]]];
        
    }else{
        //tag == 0;计算按钮点击
        
        if (inputTf.text.length>1){
            NSString* last = [inputTf.text substringWithRange:NSMakeRange(inputTf.text.length-1, 1)];
            if ([last isEqualToString:@"."]||[last isEqualToString:@"+"]) {
                UIAlertView* alert =   [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输入格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                return;
            }
        }
        
        reset = YES;
        resultView.text = self.inputTf.text;
        resultView.contentOffset = CGPointMake(0, resultView.contentSize.height-resultView.height);
        NSString* calculatorString = [self.moneyCalculator evaluateExpression:self.inputTf.text];
       
        
        if ([calculatorString doubleValue]>99999999.99) {
            UIAlertView* alert =   [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"收款金额过大" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            resultView.text = nil;
            return;
        }
        
        sender.tag = 1;
        [self changeImageView:collectButton];
        inputTf.text = calculatorString;
        
    }
    
}
#pragma mark - 数字按钮点击输入
-(void)userDidTapKey:(UIButton*)sender{
//    [inputTf becomeFirstResponder];
    
    NSString* insert = nil;
    if ([sender.titleLabel.text isEqualToString:@"Point"]) {
        insert = @".";
    }else
        insert = sender.titleLabel.text;
    
    NSArray* arr = [inputTf.text componentsSeparatedByString:@"+"];
    NSString* last = [arr lastObject];
    
    if (last.length>=8) {
        if (!([insert isEqualToString:@"+"]||[insert isEqualToString:@"."])) {
            if ([last doubleValue]>=99999999.99) {
                return;
            }
            if ([last rangeOfString:@"."].length == 0) {
                return;
            }
        }
    }else if (last.length == 0){
        if ([insert isEqualToString:@"."]) {
            return;
        }
    }
    
    if ([insert isEqualToString:@"."]) {
        //不能同时输入多个小数点0.0.  0..0
        if ( [last rangeOfString:@"."].length) {
            return;
        }
    }else{
        //不能输入多个 00
        if ([last isEqualToString:@"0"]) {
            if ([insert isEqualToString:@"0"]) {
                return;
            }
        }
    }
    
    
    if ([inputTf.text isEqualToString:@"0.00"]) {
        inputTf.text = nil;
    }else if([inputTf.text isEqualToString:@"0"]){
        
        if (![insert isEqualToString:@"."]) {
            inputTf.text = insert;
            return;
        }
        
    }else{
        
        if (reset) {
            inputTf.text = nil;
            resultView.text = nil;
            reset = NO;
            [inputTf insertTexts:insert];
            return;
        }
        
        //小数点后只能输入两位
        if (last.length>=3) {
            NSString *secondToLastCharacterString = [last substringWithRange:NSMakeRange([last length] - 3, 1)];
            if ([secondToLastCharacterString isEqualToString:@"."]) {
                return;
            }
        }
    }
    
    //    inputTf.text = [inputTf.text stringByAppendingString:insert];
    [inputTf insertTexts:insert];
}
#pragma mark 退格清空按钮
- (void)calculatorInputViewDidTapBackspace:(UIButton*)sender{
//     [inputTf becomeFirstResponder];
    reset = NO;
    if ([sender.titleLabel.text isEqualToString:@"Delete"]) {
        if ([inputTf.text isEqualToString:@"0.00"]) {
            return;
        }
        [inputTf deleteBackwards];
        if ([inputTf.text rangeOfString:@"+"].length == 0) {
            collectButton.tag = 1;
            [self changeImageView:collectButton];
        }
        
        if (inputTf.text.length == 0) {
            inputTf.text = @"0.00";
            resultView.text = nil;
        }
    }else
    {
        resultView.text = nil;
        collectButton.tag = 1;
        [self changeImageView:collectButton];
        inputTf.text = @"0.00";
    }
}
#pragma mark 加法按钮
-(void)calculatorInputViewDidTapAdd:(UIButton*)sender{
//    [inputTf becomeFirstResponder];
    NSString* last = nil;
    if (inputTf.text.length>1){
        last = [inputTf.text substringWithRange:NSMakeRange(inputTf.text.length-1, 1)];
        if ([last isEqualToString:@"."]||[last isEqualToString:@"+"]) {
            return;
        }
    }
    
    if([inputTf.text isEqualToString:@"0.00"]){
        return;
    }
    
    [inputTf insertTexts:@"+"];
    reset = NO;
    
    if (collectButton.tag == 1)
    {
        collectButton.tag = 0;
        [self changeImageView:collectButton];
    }
    
}
#pragma mark - 改变收款背景图
-(void)changeImageView:(UIButton*)sender{
    
    if (!sender.tag) {
        equlButImageView.image = equalImage;
        equlButImageView.frame = CGRectMake(0, 0, equalImage.size.width/2, equalImage.size.height/2);
        equlButImageView.center = collectButton.center;
        [collectButton setBackgroundImage:[UIImage imageNamed:@"Calculator_EqualBg.png"] forState:UIControlStateNormal];
        
    }else{
        equlButImageView.image = collImage;
        equlButImageView.frame = CGRectMake(0, 0, collImage.size.width/2, collImage.size.height/2);
        equlButImageView.center = collectButton.center;
        [collectButton setBackgroundImage:[UIImage imageNamed:@"Calculator_CollectBg.png"] forState:UIControlStateNormal];
    }
}


@end

//
//  CalculatorView.h
//  MSHappyCollectSilver
//
//  Created by Blake on 14/8/15.
//  Copyright (c) 2014年 BLAKE. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CalculatorDelegate <NSObject>


-(void)collectButtonClickedWithMoneyStr:(NSString*)money;


@end

@interface CalculatorView : UIView
{
    UITextField* inputTf;
}
@property(nonatomic,strong)UITextField* inputTf;
@property(nonatomic,strong)UITextView* resultView;

@property(nonatomic,weak)id<CalculatorDelegate> delegate;
@property (nonatomic, strong) UIButton* collectButton;



@end

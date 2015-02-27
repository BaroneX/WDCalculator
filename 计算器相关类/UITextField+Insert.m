//
//  UITextField+Insert.m
//  MSHappyCollectSilver
//
//  Created by Blake on 15/1/28.
//  Copyright (c) 2015年 BLAKE. All rights reserved.
//

#import "UITextField+Insert.h"

@implementation UITextField (Insert)

-(void)insertTexts:(NSString *)text{
    self.text = [self.text stringByAppendingString:text];
}

-(void)deleteBackwards{
    
    self.text = [self.text substringToIndex:self.text.length-1];

}

@end

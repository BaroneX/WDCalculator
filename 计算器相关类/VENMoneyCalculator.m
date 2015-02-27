#import "VENMoneyCalculator.h"
#import <CoreGraphics/CoreGraphics.h>
@interface VENMoneyCalculator ()
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@end

@implementation VENMoneyCalculator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.locale = [NSLocale currentLocale];
    }
    return self;
}

- (NSString *)evaluateExpression:(NSString *)expressionString {
    if (!expressionString) {
        return nil;
    }
    
    NSString *floatString = [NSString stringWithFormat:@"1.0*%@", expressionString];
    NSString *sanitizedString = [self replaceOperandsInString:floatString];
    NSExpression *expression;
    id result;
    @try {
        expression = [NSExpression expressionWithFormat:sanitizedString];
        result = [expression expressionValueWithObject:nil context:nil];
    }
    @catch (NSException *exception) {
        if ([[exception name] isEqualToString:NSInvalidArgumentException]) {
            return nil;
        } else {
            [exception raise];
        }
    }
    if ([result isKindOfClass:[NSNumber class]]) {
        NSInteger integerExpression = [(NSNumber *)result integerValue];
        double floatExpression = [(NSNumber *)result doubleValue];
        if (floatExpression<0) {
            return @"0.00";
        }
        if (integerExpression == floatExpression) {
           
            return [NSString stringWithFormat:@"%.2f",floatExpression];
//            [(NSNumber *)result stringValue];
        } else if (floatExpression >= CGFLOAT_MAX || floatExpression <= CGFLOAT_MIN || isnan(floatExpression)) {
            return @"0.00";
        } else {
           
            
            NSString *moneyFormattedNumber = [NSString stringWithFormat:@"%.2f",floatExpression];
            
            return [moneyFormattedNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    } else {
        return nil;
    }
}


#pragma mark - Private

- (NSNumberFormatter *)numberFormatter {
//可转换为金融数字格式等
    if (!_numberFormatter) {
        _numberFormatter = [NSNumberFormatter new];
        [_numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        [_numberFormatter setCurrencySymbol:@""];
        [_numberFormatter setCurrencyDecimalSeparator:[self decimalSeparator]];
    }
    return _numberFormatter;
}

- (NSString *)replaceOperandsInString:(NSString *)string {
    NSString *subtractReplaced = [string stringByReplacingOccurrencesOfString:@"−" withString:@"-"];
    NSString *divideReplaced = [subtractReplaced stringByReplacingOccurrencesOfString:@"÷" withString:@"/"];
    NSString *multiplyReplaced = [divideReplaced stringByReplacingOccurrencesOfString:@"×" withString:@"*"];

    return [multiplyReplaced stringByReplacingOccurrencesOfString:[self decimalSeparator] withString:@"."];
}

- (NSString *)decimalSeparator {
    return [self.locale objectForKey:NSLocaleDecimalSeparator];
}

@end

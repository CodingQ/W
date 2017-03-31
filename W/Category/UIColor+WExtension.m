//
//  UIColor+WExtension.m
//  W
//
//  Created by harry.qian on 17/3/28.
//  Copyright © 2017年 harry.qian. All rights reserved.
//

#import "UIColor+WExtension.h"

@implementation UIColor (WExtension)
+ (UIColor *)mainColor {
//    return [UIColor colorWithRed:129 / 255.0 green:216 / 255.0 blue:206 / 255.0 alpha:1];
    return [UIColor colorWithRed:17 / 255.0 green:224 / 255.0 blue:250 / 255.0 alpha:1];
}

+ (UIColor *)textColor {

return [UIColor colorWithRed:74 / 255.0 green:74 / 255.0 blue:74 / 255.0 alpha:1];
   
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}
@end

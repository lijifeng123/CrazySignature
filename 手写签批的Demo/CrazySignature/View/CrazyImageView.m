//
//  CrazyImageView.m
//  手写签批的Demo
//
//  Created by MacBook on 2019/8/16.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "CrazyImageView.h"

@implementation CrazyImageView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *v1 = [self viewWithTag:10010];
    CGPoint point1 = [self convertPoint:point toView:v1];
    if ([v1 pointInside:point1 withEvent:event]) {
        return v1;
    }
    return nil;
}
@end

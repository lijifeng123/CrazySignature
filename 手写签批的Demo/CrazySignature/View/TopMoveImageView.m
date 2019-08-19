//
//  TopMoveButton.m
//  ZT_iOS
//
//  Created by MacBook on 2019/3/21.
//  Copyright © 2019 Brigitte. All rights reserved.
//

#import "TopMoveImageView.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface TopMoveImageView ()
{
    BOOL shouldPassEvent; // 是否需要传递事件 
}
@end

@implementation TopMoveImageView


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    // 当前触摸点
    CGPoint currentPoint = [touch locationInView:self.superview];
    // 上一个触摸点
    CGPoint previousPoint = [touch previousLocationInView:self.superview];
    
    // 当前view的中点
    CGPoint center = self.center;
    
    center.x += (currentPoint.x - previousPoint.x);
    center.y += (currentPoint.y - previousPoint.y);
    
    if (fabs((currentPoint.x - previousPoint.x)) < .5 && fabs((currentPoint.y - previousPoint.y)) < .5) {
        shouldPassEvent = YES;
    }else{
        shouldPassEvent = NO;
    }
    
    if (center.x > self.superview.frame.size.width - self.frame.size.width/2) {
         center.x = self.superview.frame.size.width - self.frame.size.width/2;
    }
    if (center.x < self.frame.size.width/2) {
        center.x = self.frame.size.width/2;
    }
    if (center.y < self.frame.size.height/2) {
        center.y = self.frame.size.height/2;
    }
    if (center.y > self.superview.frame.size.height - self.frame.size.height/2) {
        center.y = self.superview.frame.size.height - self.frame.size.height/2;
    }
    
    // 修改当前view的中点(中点改变view的位置就会改变)
    self.center = center;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    shouldPassEvent = YES;
    
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    if (shouldPassEvent) {//点击事件 需要传递点击
        [super touchesEnded:touches withEvent:event];
    }
    [self.superview insertSubview:self atIndex:0];
}


@end

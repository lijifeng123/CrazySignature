//
//  SignatureSelectListController.h
//  手写签批的Demo
//
//  Created by MacBook on 2019/8/19.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectDelegate <NSObject>

- (void)getSignaturePic:(UIImage *)image;

@end

@interface SignatureSelectListController : UIViewController

@property (nonatomic, weak) id<SelectDelegate>delegate;


@end

NS_ASSUME_NONNULL_END

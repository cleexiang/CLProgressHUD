//
//  CLProgressHUD.h
//  CLProgressHUDDemo
//
//  Created by lixiang on 13-12-30.
//  Copyright (c) 2013年 cleexiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLProgressHUDType) {
    CLProgressHUDTypeDarkForground,
    CLProgressHUDTypeDarkBackground
};

typedef NS_ENUM(NSUInteger, CLProgressHUDShape) {
    CLProgressHUDShapeLinear,
    CLProgressHUDShapeCircle
};

@interface CLProgressHUD : UIView {
    
}

@property (nonatomic, assign) CLProgressHUDType type;
@property (nonatomic, assign) CLProgressHUDShape shape;
@property (nonatomic, assign) CGFloat diameter;
@property (nonatomic, strong) NSString *text;

- (id)initWithView:(UIView *)view;
- (void)show;
- (void)showWithAnimation:(BOOL)animated;
- (void)showWithAnimation:(BOOL)animated duration:(NSTimeInterval)duration;
- (void)dismiss;
- (void)dismissWithAnimation:(BOOL)animated;

@end

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

+ (instancetype)shareInstance;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view withText:(NSString *)text;
- (void)showInView:(UIView *)view withText:(NSString *)text duration:(NSTimeInterval)duration;

+ (void)dismiss;
+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animate;
- (void)setLabelText:(NSString *)labelText;

@end

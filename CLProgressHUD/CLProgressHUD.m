//
//  CLProgressHUD.m
//  CLProgressHUDDemo
//
//  Created by lixiang on 13-12-30.
//  Copyright (c) 2013年 cleexiang. All rights reserved.
//

#import "CLProgressHUD.h"

#ifndef RGBA
    #define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#endif

static float const xMargin = 10;
float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }

@interface CLProgressHUD () {
    NSInteger   _animationIndex;
}

@property (nonatomic, weak) UIView              *hudView;
@property (nonatomic, weak) UILabel             *stringLabel;
@property (nonatomic, strong) NSArray           *ringsColor;
@property (nonatomic, strong) NSArray           *shapeLayers;

@end

@implementation CLProgressHUD

+ (instancetype)shareInstance {
    static CLProgressHUD *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return _instance;
}

- (void)dealloc {
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _type = CLProgressHUDTypeDarkForground;
        _shape = CLProgressHUDShapeLinear;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            _diameter = 10.0;
        } else {
            _diameter = 10.0;
        }
        [self initSubviews];
        NSArray *ringsColor = @[RGBA(238, 191, 0, 1),
                                RGBA(235, 94, 1, 1),
                                RGBA(220, 2, 75, 1),
                                RGBA(230, 24, 119, 1),
                                RGBA(198, 0, 129, 1),
                                RGBA(121, 21, 129, 1),
                                RGBA(15, 86, 166, 1),
                                RGBA(10, 170, 180, 1)];
        self.ringsColor = ringsColor;
    }
    return self;
}

- (void)showInView:(UIView *)view {
    [self showInView:view withText:@""];
}

- (void)showInView:(UIView *)view withText:(NSString *)text duration:(NSTimeInterval)duration {
    [self showInView:view withText:text];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
}

- (void)showInView:(UIView *)view withText:(NSString *)text {
    self.frame = view.bounds;
    if (_type == CLProgressHUDTypeDarkBackground) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
        _hudView.backgroundColor = [UIColor clearColor];
    } else {
        self.backgroundColor = [UIColor clearColor];
        _hudView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    }
    [view addSubview:self];
    self.stringLabel.text = text;
    [self layout];
    [self show];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}

- (void)layout {
    CGFloat hudWidth;
    CGFloat hudHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        hudWidth = 200.0;
        hudHeight = 80.0;
    } else {
        hudWidth = 210.0;
        hudHeight = 90.0;
    }
    self.hudView.frame = CGRectMake((CGRectGetWidth(self.bounds)-hudWidth)*0.5, (CGRectGetHeight(self.bounds)-hudHeight)*0.5, hudWidth, hudHeight);
    if (_shape == CLProgressHUDShapeLinear) {
        self.stringLabel.frame = CGRectMake(xMargin, 20, CGRectGetWidth(_hudView.bounds)-xMargin*2, 16);
    } else {
        self.stringLabel.frame = CGRectMake(xMargin, CGRectGetHeight(_hudView.bounds)-20, CGRectGetWidth(_hudView.bounds)-xMargin*2, 16);
    }
}

#pragma mark - init Method
- (void)initSubviews {
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectZero];
    _hudView = hudView;
    _hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_hudView];
    
    UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stringLabel.backgroundColor = [UIColor clearColor];
    stringLabel.font = [UIFont systemFontOfSize:16.0f];
    stringLabel.textColor = [UIColor whiteColor];
    stringLabel.textAlignment = NSTextAlignmentCenter;
    self.stringLabel = stringLabel;
    [self.hudView addSubview:_stringLabel];
}

#pragma mark - Private Method
- (void)setShape:(CLProgressHUDShape)shape {
    _shape = shape;
}

- (void)show {
    _animationIndex = 0;
    self.alpha = 1.0f;
    self.shapeLayers = [self createColorShapes:_ringsColor ofShape:_shape];
    for (CAShapeLayer *layer in _shapeLayers) {
        [_hudView.layer addSublayer:layer];
    }
    [self startAnimation];
}

- (void)dismiss {
    self.alpha = 0.0f;
    [_shapeLayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    [_shapeLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
	NSArray *huds = [CLProgressHUD allHUDsForView:view];
    [huds makeObjectsPerformSelector:@selector(dismiss)];
	return [huds count];
}

+ (NSArray *)allHUDsForView:(UIView *)view {
	NSMutableArray *huds = [NSMutableArray array];
	NSArray *subviews = view.subviews;
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:self]) {
			[huds addObject:aView];
		}
	}
	return [NSArray arrayWithArray:huds];
}


- (NSArray *)createColorShapes:(NSArray *)colors ofShape:(CLProgressHUDShape)shape {
    NSMutableArray *shapesArray = [NSMutableArray array];
    if (shape == CLProgressHUDShapeLinear) {
        CGFloat x = (CGRectGetWidth(_hudView.bounds)-_diameter*(_ringsColor.count*2-1))*0.5;
        CGFloat y;
        if ([_stringLabel.text isEqualToString:@""]) {
            y = CGRectGetHeight(_hudView.bounds)*0.5;
        } else {
            y = CGRectGetHeight(_hudView.bounds)*0.5+_diameter;
        }
        CGPoint lastPoint = CGPointMake(x, y);
        for (UIColor *color in colors) {
            CGRect rect = CGRectMake(lastPoint.x, lastPoint.y, self.diameter, self.diameter);
            CGPoint newPoint = [self nextPointFromPoint:lastPoint];
            lastPoint = newPoint;
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddEllipseInRect(path, NULL, rect);
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.fillColor = color.CGColor;
            shapeLayer.path = path;
            shapeLayer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerTopEdge | kCALayerBottomEdge;
            shapeLayer.allowsEdgeAntialiasing = YES;
            CGPathRelease(path);
            [shapesArray addObject:shapeLayer];
        }
    } else {
        CGFloat centerX = CGRectGetWidth(_hudView.bounds)*0.5;
        CGFloat centerY;
        if ([_stringLabel.text isEqualToString:@""]) {
            centerY = (CGRectGetHeight(_hudView.bounds)-_diameter)*0.5;
        } else {
            centerY = (CGRectGetHeight(_hudView.bounds)-_diameter*2)*0.5-5;
        }
        CGPoint center = CGPointMake(centerX, centerY);
        int i = 0;
        for (UIColor *color in colors) {
            CGFloat x = center.x + _diameter*2*sin(Degrees2Radians((2-i)*45));
            CGFloat y = center.y + _diameter*2*cos(Degrees2Radians((2-i)*45));
            CGRect rect = CGRectMake(x, y, self.diameter, self.diameter);
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathAddEllipseInRect(path, NULL, rect);
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.fillColor = color.CGColor;
            shapeLayer.path = path;
            shapeLayer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerTopEdge | kCALayerBottomEdge;
            shapeLayer.allowsEdgeAntialiasing = YES;
            CGPathRelease(path);
            [shapesArray addObject:shapeLayer];
            i++;
        }
    }

    return shapesArray;
}

- (CGPoint)nextPointFromPoint:(CGPoint)point {
    CGPoint newPoint = CGPointZero;
    newPoint.x = point.x + _diameter*2;
    newPoint.y = point.y;
    return newPoint;
}

- (void)startAnimation {
    NSTimeInterval interval = 0;
    for (CALayer *layer in [self shapeLayers]) {
        [self performSelector:@selector(addAnimationToLayer:)
                   withObject:layer afterDelay:interval];
        interval += 0.2;
    }
}

- (CALayer *)layerOfIndex:(NSInteger)index {
    return [_shapeLayers objectAtIndex:index];
}

- (void)addAnimationToLayer:(CALayer *)layer {
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.autoreverses = YES;
    fadeInAnimation.duration = 0.8f;
    fadeInAnimation.repeatCount = MAXFLOAT;
    fadeInAnimation.delegate = self;
    [layer addAnimation:fadeInAnimation forKey:nil];
}

#pragma mark - Show/Dismiss Method
+ (void)dismiss {
    [[CLProgressHUD shareInstance] dismiss];
}

- (void)setLabelText:(NSString *)labelText {
    self.stringLabel.text = labelText;
    [self layout];
}

@end


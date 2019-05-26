//
//  SAGuideView.m
//  TMKit
//
//  Created by 王士昌 on 2019/5/20.
//


#import <QuartzCore/QuartzCore.h>
#import "SAGuideView.h"

static const CGFloat kAnimationDuration = 0.25f;
static const CGFloat kCutoutRadius = 1.5f;

@interface SAGuideView ()

@property (nonatomic, weak) UIViewController *fromViewController;

@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, assign, readwrite) CGRect focusViewRect;

@end

@implementation SAGuideView {
    NSUInteger _focusIndex;
    UIView *_currentIntroView;
    BOOL _interactivePopGestureRecognizerEnable;
}

#pragma mark-
#pragma mark- View Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark-
#pragma mark- Event response

/*! 跳过 */
- (void)skip {
    [self cleanup];
}

- (void)userDidTap:(UITapGestureRecognizer *)recognizer {
    [self goToNextFocusIndex:(_focusIndex+1)];
}

- (void)showFromController:(UIViewController *)fromController {
    self.fromViewController = fromController;
    if ([fromController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)fromController;
        _interactivePopGestureRecognizerEnable = nav.interactivePopGestureRecognizer.enabled;
        nav.interactivePopGestureRecognizer.enabled = NO;
    }else {
        _interactivePopGestureRecognizerEnable = fromController.navigationController.interactivePopGestureRecognizer.enabled;
        fromController.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [fromController.view addSubview:self];
    self.frame = fromController.view.bounds;
    [self start];
}

#pragma mark-
#pragma mark- Private Methods

/*! 设置基础数据 */
- (void)setup {
    _maskColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:.7f];
    
    [self.layer addSublayer:self.maskLayer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userDidTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    self.hidden = YES;
}

- (void)start {
    self.alpha = 0.0f;
    self.hidden = NO;
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [self goToNextFocusIndex:0];
                     }];
}


/**
 跳到下一个 index
 
 @param index 下一个 index
 */
- (void)goToNextFocusIndex:(NSUInteger)index {
    if (_currentIntroView) {
        [_currentIntroView removeFromSuperview];
    }
    NSInteger max = [self.dataSource numberOfMarkItemsInMarksView:self];
    if (index >= max) {
        [self cleanup];
        return;
    }
    
    _focusIndex = index;
    
    UIView *targetView;
    CGRect rect = CGRectZero;
    if ([self.dataSource respondsToSelector:@selector(marksView:focusViewAtIndex:)]) {
        targetView = [self.dataSource marksView:self focusViewAtIndex:index];
        rect = [targetView.superview convertRect:targetView.frame toView:self];
    }
    _focusViewRect = rect;
    
    SAGuideOptionShapeType shapeType = SAGuideOptionShapeTypeSquare;
    if ([self.dataSource respondsToSelector:@selector(marksView:shapeTypeAtIndex:)]) {
        shapeType = [self.dataSource marksView:self shapeTypeAtIndex:index];
    }
    
    if (shapeType == SAGuideOptionShapeTypeCustom) {
        _focusViewRect = CGRectZero;
    }
    
    UIBezierPath *customBezierPath;
    if ([self.dataSource respondsToSelector:@selector(marksView:focusBezierPathAtIndex:)]) {
        customBezierPath = [self.dataSource marksView:self focusBezierPathAtIndex:index];
    }
    
    UIBezierPath *maskPath = [self setCutoutToRect:rect withShapeType:shapeType customBezierPath:customBezierPath];
    _maskLayer.path = maskPath.CGPath;
    
    UIView *customView;
    if ([self.dataSource respondsToSelector:@selector(marksView:introViewAtIndex:)]) {
        customView = [self.dataSource marksView:self introViewAtIndex:index];
        [self addSubview:customView];
        customView.frame = self.bounds;
        _currentIntroView = customView;
    }
    
}

- (UIBezierPath *)setCutoutToRect:(CGRect)rect withShapeType:(SAGuideOptionShapeType)shapeType customBezierPath:(UIBezierPath *)customBezierPath {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    UIBezierPath *cutoutPath;
    
    switch (shapeType) {
            case SAGuideOptionShapeTypeSquare:
        {
            cutoutPath = [UIBezierPath bezierPathWithRect:rect];
        }
            break;
            case SAGuideOptionShapeTypeCircle:
        {
            cutoutPath = [UIBezierPath bezierPathWithOvalInRect:rect];
        }
            break;
            case SAGuideOptionShapeTypeCustom:
        {
            cutoutPath = customBezierPath;
        }
            break;
        default:
        {
            cutoutPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:kCutoutRadius];
        }
            break;
    }
    
    [maskPath appendPath:cutoutPath];
    
    return maskPath;
}

/*! 清除 */
- (void)cleanup {
    _focusIndex = 0;
    _focusViewRect = CGRectZero;
    _currentIntroView = nil;
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         if ([self.fromViewController isKindOfClass:[UINavigationController class]])  {
                             UINavigationController *nav = (UINavigationController *)self.fromViewController;
                             nav.interactivePopGestureRecognizer.enabled = self -> _interactivePopGestureRecognizerEnable;
                         }else {
                             self.fromViewController.navigationController.interactivePopGestureRecognizer.enabled = self -> _interactivePopGestureRecognizerEnable;
                         }
                         
                         [self removeFromSuperview];
                     }];
}

#pragma mark-
#pragma mark- Getters && Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor {}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    [_maskLayer setFillColor:[maskColor CGColor]];
}

- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        [_maskLayer setFillRule:kCAFillRuleEvenOdd];
        [_maskLayer setFillColor:self.maskColor.CGColor];
    }
    return _maskLayer;
}

@end






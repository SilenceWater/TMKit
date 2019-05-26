//
//  SARingDistributionView.m
//  SARingDistributionView
//
//  Created by 王士昌 on 2019/5/21.
//  Copyright © 2018年 冰凝城下. All rights reserved.
//

#import "SARingDistributionView.h"

typedef NS_ENUM(NSUInteger, SARingDistributionViewTouchStatus) {
    SARingDistributionViewTouchStatusBegan,
    SARingDistributionViewTouchStatusMoved,
    SARingDistributionViewTouchStatusEnded,
    SARingDistributionViewTouchStatusCancelled,
};

static NSTimeInterval const kAnimationDuration = 0.25f;

@interface SARingDistributionModel : NSObject

@property (nonatomic, strong) CAShapeLayer *strokLayer;

@property (nonatomic, strong) UIBezierPath *bezierPath;

@property (nonatomic, strong) UIColor *strokColor;

@property (nonatomic, strong) NSNumber *scaleValue;

@property (nonatomic, assign) CGPoint point;

@property (nonatomic, assign) SARingDistributionQuadrant quadrant;

@end

@interface SARingDistributionView ()

@property (nonatomic, strong) NSMutableArray <SARingDistributionModel *>*dataArr;

@property (nonatomic, assign) NSInteger allCount;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;

@end

@implementation SARingDistributionView

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _lineWidth = 20.f;
        _isAnimation = NO;
        
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self didSelectWithPoint:point touchStatus:SARingDistributionViewTouchStatusEnded];
}


#pragma mark-
#pragma mark- Private Methods

- (void)didSelectWithPoint:(CGPoint)point touchStatus:(SARingDistributionViewTouchStatus)touchStatus {
    UIBezierPath *rectPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.radius - self.lineWidth startAngle:-0.5*M_PI endAngle:1.5*M_PI clockwise:YES];
    
    [self.dataArr enumerateObjectsUsingBlock:^(SARingDistributionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bezierPath containsPoint:point] && ![rectPath containsPoint:point]) {
            NSInteger index = idx;
            
            switch (touchStatus) {
                case SARingDistributionViewTouchStatusBegan:
                {

                }
                    break;
                case SARingDistributionViewTouchStatusMoved:
                {

                }
                    break;
                case SARingDistributionViewTouchStatusEnded:
                {
                    if ([self.delegate respondsToSelector:@selector(ringView:didSelectAtIndex:auadrant:point:)]) {
                        [self.delegate ringView:self didSelectAtIndex:index auadrant:obj.quadrant point:obj.point];
                    }
                }
                    break;
                default:
                    break;
            }
            
            return;
        }
    }];
    
    
}

- (void)reloadData {
    if (self.centerView.superview) [self.centerView removeFromSuperview];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.dataArr removeAllObjects];
    _allCount = 0;
    _dataArr = nil;
    _centerView = nil;
    
    __block CGFloat totalScale = 0;
    
    [self.dataArr enumerateObjectsUsingBlock:^(SARingDistributionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalScale = totalScale + obj.scaleValue.floatValue;
    }];
    
    
    CGFloat strokeValue = 0;
    CGFloat startAngle = -M_PI_2;
    for (NSInteger i = 0; i < self.allCount; i++) {
        SARingDistributionModel *model = self.dataArr[i];
        
        NSNumber *scaleValue = model.scaleValue;
        CAShapeLayer *layer = model.strokLayer;
        CGFloat endAngle = scaleValue.floatValue/totalScale * (2*M_PI) + startAngle;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.center radius:self.radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        model.bezierPath = path;
        layer.path = path.CGPath;
        
        layer.strokeStart = 0;
        layer.strokeEnd = 1;
        
        strokeValue = layer.strokeEnd;
        
        CGFloat middleAngle = startAngle + (endAngle - startAngle)/2.0;
        startAngle = endAngle;
        [self setMiddlePointWithAngle:middleAngle index:i];
        
        if (_isAnimation) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.fromValue = @(layer.strokeStart);
            animation.toValue = @(layer.strokeEnd);
            animation.duration = kAnimationDuration;
            [layer addAnimation:animation forKey:@"strokeEnd"];
        }
    }
    
    if (self.centerView) {
        [self addSubview:self.centerView];
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat hight = CGRectGetHeight(self.bounds);
        self.centerView.center = CGPointMake(width/2.f, hight/2.f);
        CGFloat bounds = (width > hight ? hight : width) - self.lineWidth*2;
        self.centerView.bounds = CGRectMake(0, 0, bounds, bounds);
    }
}


- (void)setMiddlePointWithAngle:(CGFloat)middleAngle index:(NSInteger)index {
    SARingDistributionModel *model = self.dataArr[index];
    CGPoint minPieCenter;
    UIColor *strokeColor;
    if ([self.dataSource respondsToSelector:@selector(ringView:colorForItemAtIndex:)]) {
        strokeColor = [self.dataSource ringView:self colorForItemAtIndex:index];
    }else {
        strokeColor = [self randomColor];
    }
    CGFloat a = self.radius + self.lineWidth/2.0 + 3;
    if (middleAngle >= -M_PI_2 && middleAngle <= 0) {//第一象限
        CGFloat angle = 0 - middleAngle;
        minPieCenter = CGPointMake(self.center.x + cosf(angle)*a, self.center.y - sinf(angle)*a);
        model.point = minPieCenter;
        model.quadrant = SARingDistributionQuadrantFirst;
    }else if (middleAngle >= 0 && middleAngle <= M_PI_2) {//第四象限
        minPieCenter = CGPointMake(self.center.x + cosf(middleAngle)*a, self.center.y + sinf(middleAngle)*a);
        model.point = minPieCenter;
        model.quadrant = SARingDistributionQuadrantFourth;
    }else if (middleAngle >= M_PI_2 && middleAngle <= 2*M_PI_2) {//第三象限
        CGFloat angle = M_PI - middleAngle;
        minPieCenter = CGPointMake(self.center.x - cosf(angle)*a, self.center.y + sinf(angle)*a);
        model.point = minPieCenter;
        model.quadrant = SARingDistributionQuadrantThird;
    }else {//第二象限
        CGFloat angle = middleAngle - M_PI;
        minPieCenter = CGPointMake(self.center.x - cosf(angle)*a, self.center.y - sinf(angle)*a);
        model.point = minPieCenter;
        model.quadrant = SARingDistributionQuadrantSecond;
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (_allCount == 0) {
        [self reloadData];
    }
}

- (CAShapeLayer *)generateLayerWithColor:(UIColor *)color {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.allowsEdgeAntialiasing = YES;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.strokeStart = 0;
    layer.strokeEnd = 0;
    layer.lineWidth = self.lineWidth;
    
    return layer;
}

- (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
}

#pragma mark -
#pragma mark - Setter && Getter

- (CGPoint)center {
    return CGPointMake(CGRectGetWidth(self.bounds)/2.f, CGRectGetHeight(self.bounds)/2.f);
}

- (CGFloat)radius {
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat hight = CGRectGetHeight(self.bounds);
    CGFloat radius = ((width > hight ? hight : width)/2 - self.lineWidth/2.f);
    return radius;
}

- (UIView *)centerView  {
    if (!_centerView) {
        if ([self.dataSource respondsToSelector:@selector(centerViewInRingView:)]) {
            _centerView = [self.dataSource centerViewInRingView:self];
        }
    }
    return _centerView;
}

- (NSInteger)allCount {
    if (!_allCount) {
        _allCount = [self.dataSource numberOfItemInringView:self];
    }
    return _allCount;
}

- (NSMutableArray<SARingDistributionModel *> *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]init];
        for (NSInteger i = 0; i < self.allCount; i++) {
            SARingDistributionModel *model = [SARingDistributionModel new];
            if ([self.dataSource respondsToSelector:@selector(ringView:colorForItemAtIndex:)] && [self.dataSource ringView:self colorForItemAtIndex:i]) {
                model.strokColor = [self.dataSource ringView:self colorForItemAtIndex:i];
            }else {
                model.strokColor = [self randomColor];
            }
            if ([self.dataSource respondsToSelector:@selector(ringView:scaleForItemAtIndex:)]) {
                model.scaleValue = [self.dataSource ringView:self scaleForItemAtIndex:i];
            }
            model.strokLayer = [self generateLayerWithColor:model.strokColor];
            [self.layer addSublayer:model.strokLayer];
            [_dataArr addObject:model];
        }
    }
    return _dataArr;
}

@end
@implementation SARingDistributionModel

@end

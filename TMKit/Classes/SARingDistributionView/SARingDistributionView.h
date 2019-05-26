//
//  SARingDistributionView.h
//  SARingDistributionView
//
//  Created by 王士昌 on 2019/5/21.
//  Copyright © 2018年 冰凝城下. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 象限
 
 - SARingDistributionQuadrantFirst: 第一象限
 - SARingDistributionQuadrantSecond: 第二象限
 - SARingDistributionQuadrantThird: 第三象限
 - SARingDistributionQuadrantFourth: 第四象限
 */
typedef NS_ENUM(NSUInteger, SARingDistributionQuadrant) {
    SARingDistributionQuadrantFirst,
    SARingDistributionQuadrantSecond,
    SARingDistributionQuadrantThird,
    SARingDistributionQuadrantFourth,
};

@protocol SARingDistributionViewDataSource,SARingDistributionViewDelegate;
@interface SARingDistributionView : UIView

@property (nonatomic, weak) id <SARingDistributionViewDelegate> delegate;
@property (nonatomic, weak) id <SARingDistributionViewDataSource> dataSource;

@property (nonatomic, assign) BOOL isAnimation;

/*! 默认20.f */
@property (nonatomic, assign) CGFloat lineWidth;

- (void)reloadData;

@end

@protocol SARingDistributionViewDataSource <NSObject>

@required

/**
 环形分布图总模块个数

 @param ringView self
 @return 几个模块
 */
- (NSInteger)numberOfItemInringView:(SARingDistributionView *)ringView;

/**
 每一个模块的规模（可以是比例，也可以是具体的数值，但两者不可混用）

 @param ringView self
 @param index index
 @return value
 */
- (NSNumber *)ringView:(SARingDistributionView *)ringView scaleForItemAtIndex:(NSInteger)index;

@optional

/**
 设置每一模块对应的 UIColor (不设置此代理 默认随机颜色)

 @param ringView self
 @param index index
 @return color
 */
- (UIColor *)ringView:(SARingDistributionView *)ringView colorForItemAtIndex:(NSInteger)index;

/**
 中心自定义view

 @param ringView self
 @return 自定义view
 */
- (UIView *)centerViewInRingView:(SARingDistributionView *)ringView;

@end


@protocol SARingDistributionViewDelegate <NSObject>

@optional

/**
 别用 还不完善！！！

 @param ringView self
 @param index index
 @param auadrant auadrant
 @param point point
 */
- (void)ringView:(SARingDistributionView *)ringView didSelectAtIndex:(NSInteger)index auadrant:(SARingDistributionQuadrant)auadrant point:(CGPoint)point;


@end

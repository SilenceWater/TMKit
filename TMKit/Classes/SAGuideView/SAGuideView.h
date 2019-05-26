//
//  SAGuideView.h
//  TMKit
//
//  Created by 王士昌 on 2018/12/14.
//

#import <UIKit/UIKit.h>

/**
 空心遮罩形状
 
 - SAGuideOptionShapeTypeSquare: 矩形
 - SAGuideOptionShapeTypeCircle: 圆/椭圆 形（根据rect内切）
 - SAGuideOptionShapeTypeCustom: 自定义（需要用户设置 focusBezierPathAtIndex 代理）
 */
typedef NS_ENUM(NSUInteger, SAGuideOptionShapeType) {
    SAGuideOptionShapeTypeSquare,
    SAGuideOptionShapeTypeCircle,
    SAGuideOptionShapeTypeCustom,
};


@protocol SAGuideViewDataSource;
NS_ASSUME_NONNULL_BEGIN
@interface SAGuideView : UIView

@property (nonatomic, weak) id <SAGuideViewDataSource> dataSource;

/*! 设置蒙版颜色 */
@property (nonatomic, strong) UIColor *maskColor;

/*! 焦点视图区域 SAGuideOptionShapeTypeCustom 时为 CGRectZero */
@property (nonatomic, assign, readonly) CGRect focusViewRect;

/*! 展示焦点视图 */
- (void)showFromController:(UIViewController *)fromController;

/*! 跳过 */
- (void)skip;

@end

@protocol SAGuideViewDataSource <NSObject>

@required

/**
 焦点总个数

 @param marksView 蒙版
 @return count
 */
- (NSInteger)numberOfMarkItemsInMarksView:(SAGuideView *)marksView;

/**
 焦点视图 (当代理 shapeTypeAtIndex return SAGuideOptionShapeTypeCustom 时 可以 return nil)

 @param marksView 蒙版
 @param index 索引
 @return 焦点视图
 */
- (UIView *)marksView:(SAGuideView *)marksView focusViewAtIndex:(NSInteger)index;

/**
 介绍视图

 @param marksView 蒙版
 @param index 索引
 @return 介绍视图
 */
- (UIView *)marksView:(SAGuideView *)marksView introViewAtIndex:(NSInteger)index;

@optional

/**
 焦点区域类型（默认 SAGuideOptionShapeTypeSquare ）

 @param marksView 蒙版
 @param index 索引
 @return 焦点枚举类型
 */
- (SAGuideOptionShapeType)marksView:(SAGuideView *)marksView shapeTypeAtIndex:(NSInteger)index;

/**
 自定义 高亮 区域（当 shapeTypeAtIndex 代理 return SAGuideOptionShapeTypeCustom 时需要设置）

 @param marksView 蒙版
 @param index 索引
 @return 自定义的需要高亮区域的贝塞尔曲线对象
 */
- (UIBezierPath *)marksView:(SAGuideView *)marksView focusBezierPathAtIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END

//
//  TMGuideViewDemoController.m
//  TMKit_Example
//
//  Created by 王士昌 on 2019/5/20.
//  Copyright © 2018 王士昌. All rights reserved.
//

#import "TMGuideViewDemoController.h"
#import <TMKit/TMKit.h>
#import <Masonry/Masonry.h>

@interface TMGuideViewDemoController () <SAGuideViewDataSource>

@property (nonatomic, strong) UIView *sa_bgView;

@property (nonatomic, strong) UIView *sa_item1;

@property (nonatomic, strong) UIView *sa_item2;

@property (nonatomic, strong) SAGuideView *maskView;

@property (nonatomic, strong) NSArray <UIView *>*subviewsArray;

@property (nonatomic, strong) NSArray <UIView *>*customViewArray;

@property (nonatomic, strong) UILabel *customLabel1;

@property (nonatomic, strong) UILabel *customLabel2;

@property (nonatomic, strong) UILabel *customLabel3;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TMGuideViewDemoController

#pragma mark -
#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.sa_item1.layer.cornerRadius = 50;
    self.sa_item1.layer.masksToBounds = YES;
    [self.view addSubview:self.sa_bgView];
    [self.sa_bgView addSubview:self.sa_item1];
    [self.sa_item1 addSubview:self.sa_item2];
    
    [self.sa_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(200, 300));
    }];
    
    [self.sa_item1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.sa_item2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.maskView showFromController:self.navigationController];
        //        [self.marksView showFromController:self];
    });
}


#pragma mark -
#pragma mark - Request

#pragma mark -
#pragma mark - SAGuideViewDataSource

- (NSInteger)numberOfMarkItemsInMarksView:(SAGuideView *)marksView {
    return self.subviewsArray.count+1;
}

- (SAGuideOptionShapeType)marksView:(SAGuideView *)marksView shapeTypeAtIndex:(NSInteger)index {
    if (index == 3) {
        return SAGuideOptionShapeTypeCustom;
    }
    if (index == 1) {
        return SAGuideOptionShapeTypeCircle;
    }
    return SAGuideOptionShapeTypeSquare;
}

- (UIView *)marksView:(SAGuideView *)marksView focusViewAtIndex:(NSInteger)index {
    
    return self.subviewsArray[index >= self.subviewsArray.count ? index - 1 : index];
}

- (UIView *)marksView:(SAGuideView *)marksView introViewAtIndex:(NSInteger)index {
    return self.customViewArray[index];
}

- (UIBezierPath *)marksView:(SAGuideView *)marksView focusBezierPathAtIndex:(NSInteger)index {
    CGFloat width = marksView.bounds.size.width;
    CGFloat height = marksView.bounds.size.height;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(width/2.f, 100.f)];
    [bezierPath addLineToPoint:CGPointMake(width - 100, 300.f)];
    [bezierPath addLineToPoint:CGPointMake(width - 75, 240)];
    [bezierPath addLineToPoint:CGPointMake(width - 20, 400)];
    [bezierPath addLineToPoint:CGPointMake(width/2.f, height - 170)];
    [bezierPath addLineToPoint:CGPointMake(20, 400)];
    [bezierPath addLineToPoint:CGPointMake(75, 240)];
    [bezierPath addLineToPoint:CGPointMake(100, 300.f)];
    return bezierPath;
}

#pragma mark -
#pragma mark - Event response

#pragma mark -
#pragma mark - Private Methods

#pragma mark -
#pragma mark - Getters && Setters

- (SAGuideView *)maskView {
    if (!_maskView) {
        _maskView = [[SAGuideView alloc]init];
        _maskView.dataSource = self;
    }
    return _maskView;
}

- (NSArray <UIView *>*)subviewsArray {
    if (!_subviewsArray) {
        _subviewsArray = @[self.sa_bgView,self.sa_item1,self.sa_item2];
    }
    return _subviewsArray;
}

- (UIView *)sa_bgView {
    if (!_sa_bgView) {
        _sa_bgView = [[UIView alloc]init];
        _sa_bgView.backgroundColor = [UIColor cyanColor];
    }
    return _sa_bgView;
}

- (UIView *)sa_item1 {
    if (!_sa_item1) {
        _sa_item1 = [[UIView alloc]init];
        _sa_item1.backgroundColor = [UIColor yellowColor];
    }
    return _sa_item1;
}

- (UIView *)sa_item2 {
    if (!_sa_item2) {
        _sa_item2 = [[UIView alloc]init];
        _sa_item2.backgroundColor = [UIColor redColor];
    }
    return _sa_item2;
}

- (NSArray<UIView *> *)customViewArray {
    if (!_customViewArray) {
        _customViewArray = @[self.customLabel1,self.customLabel2,self.customLabel3,self.customLabel1];
    }
    return _customViewArray;
}

- (UILabel *)customLabel1 {
    if (!_customLabel1) {
        _customLabel1 = [[UILabel alloc]init];
        _customLabel1.textColor = [UIColor whiteColor];
        _customLabel1.font = [UIFont boldSystemFontOfSize:30];
        _customLabel1.text = @"大方块";
    }
    return _customLabel1;
}

- (UILabel *)customLabel2 {
    if (!_customLabel2) {
        _customLabel2 = [[UILabel alloc]init];
        [_customLabel2 addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(100);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
    }
    return _customLabel2;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tuxue123"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UILabel *)customLabel3 {
    if (!_customLabel3) {
        _customLabel3 = [[UILabel alloc]init];
        _customLabel3.textColor = [UIColor whiteColor];
        _customLabel3.font = [UIFont boldSystemFontOfSize:30];
        _customLabel3.text = @"小方块";
        _customLabel3.textAlignment = NSTextAlignmentRight;
    }
    return _customLabel3;
}


@end

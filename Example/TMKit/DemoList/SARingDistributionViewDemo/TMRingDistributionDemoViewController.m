//
//  TMRingDistributionDemoViewController.m
//  TMKit_Example
//
//  Created by 王士昌 on 2019/2/20.
//  Copyright © 2018年 王士昌. All rights reserved.
//

#import "TMRingDistributionDemoViewController.h"
#import <TMKit/TMKit.h>
#import <Masonry/Masonry.h>

@interface TMRingDistributionDemoViewController ()<SARingDistributionViewDataSource,SARingDistributionViewDelegate>

@property (nonatomic, strong) UILabel *centerLabel;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation TMRingDistributionDemoViewController {
    SARingDistributionView *_taskView;
}

#pragma mark -
#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(pressButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"开始渲染" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor cyanColor]];
    [self.view addSubview:btn];
    
    SARingDistributionView *view = [[SARingDistributionView alloc]init];
    view.dataSource = self;
    view.delegate = self;
    view.isAnimation = YES;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    _taskView = view;
    [_taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(250, 400));
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(view.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
}

#pragma mark -
#pragma mark - SARingDistributionViewDataSource

- (NSInteger)numberOfItemInringView:(SARingDistributionView *)ringView {
    NSNumber *count = @(arc4random()%6 + 2);
    self.centerLabel.text = count.stringValue;
    return count.integerValue;
}


- (NSNumber *)ringView:(SARingDistributionView *)ringView scaleForItemAtIndex:(NSInteger)index {
    return @(arc4random()%50 + 20);
}

- (UIColor *)ringView:(SARingDistributionView *)ringView colorForItemAtIndex:(NSInteger)index {
    return @[[UIColor redColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor purpleColor],[UIColor magentaColor],[UIColor greenColor],[UIColor blackColor]][index];
}

- (UIView *)centerViewInRingView:(SARingDistributionView *)ringView {
    
    return self.centerLabel;
}

#pragma mark -
#pragma mark - Event Response

- (void)pressButtonAction {
    _taskView.lineWidth = arc4random()%80 + 20;
    [_taskView reloadData];
}

#pragma mark -
#pragma mark - Setter && Getter

- (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [UILabel new];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.alpha = 0.5f;
        _centerLabel.backgroundColor = [self randomColor];
    }
    return _centerLabel;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [UILabel new];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _tipLabel.textColor = [UIColor lightTextColor];
        [_taskView addSubview:_tipLabel];
    }
    return _tipLabel;
}

@end

//
//  TMViewController.m
//  TMKit
//
//  Created by 王士昌 on 11/26/2017.
//  Copyright (c) 2017 王士昌. All rights reserved.
//

#import "TMViewController.h"
#import <Masonry/Masonry.h>

@interface TMViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation TMViewController

#pragma mark -
#pragma mark - view life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    self.title = @"基础UI组件";
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self getData];
    
}


- (void)getData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"classdata" ofType:@"plist"];
    _dataArray = [NSArray arrayWithContentsOfFile:path];
}


#pragma mark -
#pragma mark - UITableViewDelegate && data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"开发ing";
        case 1:
            return @"待审核";
        default:
            return @"可使用";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    cell.textLabel.text = dict[@"titleName"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArray[indexPath.section][indexPath.row];
    NSString *str =  dict[@"className"];
    UIViewController *controller = nil;
    controller.title = dict[@"titleName"];
    controller = [[NSClassFromString(str) alloc] init];
    [controller setHidesBottomBarWhenPushed:YES];
    //controller.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark - Private methods

#pragma mark -
#pragma mark - Setters && Getters

#pragma mark -
#pragma mark - SetupSubviewConstraints


@end

//
//  ViewController.m
//  ProgressView
//
//  Created by Whde on 2018/6/29.
//  Copyright © 2018年 Whde. All rights reserved.
//

#import "ViewController.h"
#import "WhdeProgressView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WhdeProgressView *view1 = [[WhdeProgressView alloc] initWithFrame:CGRectMake(20, 40, 160, 160)];
    [view1 setProgress:100];
    [self.view addSubview:view1];

    WhdeProgressView *view2 = [[WhdeProgressView alloc] initWithFrame:CGRectMake(200, 40, 160, 160)];
    [view2 setProgress:80];
    [self.view addSubview:view2];
    
    WhdeProgressView *view3 = [[WhdeProgressView alloc] initWithFrame:CGRectMake(20, 350, 160, 160)];
    [view3 setProgress:50];
    [self.view addSubview:view3];

    WhdeProgressView *view4 = [[WhdeProgressView alloc] initWithFrame:CGRectMake(200, 350, 160, 160)];
    [view4 setProgress:20];
    [self.view addSubview:view4];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

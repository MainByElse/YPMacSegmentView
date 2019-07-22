//
//  ViewController.m
//  YPMacSegmentView
//
//  Created by Else on 2019/7/22.
//  Copyright © 2019 YanpengLee. All rights reserved.
//

#import "ViewController.h"
#import "YPMacSegmentView.h"
#import "NSView+YPExtension.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    YPMacSegmentView *view = [[YPMacSegmentView alloc]initWithFrame:NSRectFromCGRect(CGRectMake(0, 220, self.view.width, 50))];
    view.itemFont = [NSFont systemFontOfSize:12];
    view.itemColor = [NSColor blackColor];
    view.itemSelectFont = [NSFont systemFontOfSize:12];
    view.itemSelectColor = [NSColor redColor];
    view.scrollDirection = YPScrollDirectionHorizontal;
    view.scrollerShowType = YPScrollerAllHide;
    view.scrollerKnobStyle = NSScrollerKnobStyleDark;
    view.selectBlock = ^(NSInteger index) {
        NSLog(@"======= ==== %zd", index);
    };
    view.titleArr = @[@"最新",@"排行榜",@"苹果",@"安卓",@"华为",@"小米",@"魅族",@"Windows",@"锤子",@"一加",@"魅族",@"Windows",@"锤子",@"一加"];
    [self.view addSubview:view];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end

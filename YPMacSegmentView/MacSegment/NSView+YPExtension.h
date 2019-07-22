//
//  NSView+YPExtension.h
//  YPMacSegmentView
//
//  Created by Else on 2019/7/22.
//  Copyright © 2019 YanpengLee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (YPExtension)

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;


//- (BOOL)isFlipped;

@end

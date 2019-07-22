//
//  YPMacSegmentView.h
//  YPMacSegmentView
//
//  Created by Else on 2019/7/22.
//  Copyright © 2019 YanpengLee. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^YPItemSelectBlock)(NSInteger index);

typedef enum : NSUInteger {
    YPScrollDirectionHorizontal = 0,
    YPScrollDirectionVertical = 1,
} YPScrollDirection;

typedef enum : NSUInteger {
    ///横竖滚动条都不显示
    YPScrollerAllHide = 0,
    ///横竖滚动条都显示
    YPScrollerAllShow = 1,
    ///显示横向滚动条
    YPScrollerShowHorizontal = 2,
    ///显示纵向滚动条
    YPScrollerShowVertical = 3,
} YPScrollerShowType;

@interface YPMacSegmentView : NSView

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) NSScrollView *scrollView;

/**按钮字号*/
@property (nonatomic, strong) NSFont *itemFont;
/**选中字号*/
@property (nonatomic, strong) NSFont *itemSelectFont;
/**按钮颜色*/
@property (nonatomic, strong) NSColor *itemColor;
/**选中颜色*/
@property (nonatomic, strong) NSColor *itemSelectColor;
/**选中回调*/
@property (nonatomic, copy) YPItemSelectBlock selectBlock;
/**滑动方向*/
@property (nonatomic, assign) YPScrollDirection scrollDirection;
/**滚动条显示*/
@property (nonatomic, assign) YPScrollerShowType scrollerShowType;
/**滚动条颜色*/
@property (nonatomic, assign) NSScrollerKnobStyle scrollerKnobStyle;

@end

NS_ASSUME_NONNULL_END

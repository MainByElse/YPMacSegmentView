//
//  YPMacSegmentView.m
//  YPMacSegmentView
//
//  Created by Else on 2019/7/22.
//  Copyright © 2019 YanpengLee. All rights reserved.
//

#import "YPMacSegmentView.h"
#import "NSView+YPExtension.h"

#define kitemBtnWidth 40.f
#define kitemBtnHeight 40.f
#define RGBA(r,g,b,a) [NSColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

@interface YPMacSegmentView ()

@property (nonatomic, strong) NSView *backView;
@property (nonatomic, strong) NSView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *itemBtnMarr;
@property (nonatomic, assign) NSInteger lastSelectIndex;

@end

@implementation YPMacSegmentView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self initialization];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)initialization{
    _itemFont = [NSFont systemFontOfSize:15];
    _itemColor = [NSColor blackColor];
    _itemSelectFont = [NSFont systemFontOfSize:15];
    _itemSelectColor = [NSColor redColor];
    _scrollDirection = YPScrollDirectionHorizontal;
    _scrollerShowType = YPScrollerAllHide;
    _scrollerKnobStyle = NSScrollerKnobStyleDefault;
}

- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    [self setupItemBtns];
    if (self.itemBtnMarr.count > 0) {
        [self itemBtnClick:self.itemBtnMarr[0]];
    }
}

- (void)setupItemBtns{
    
    if (!_backView) {
        _backView = [[NSView alloc]init];
        _backView.frame = NSMakeRect(0, 0, ((_titleArr.count + 2)*kitemBtnWidth), kitemBtnHeight);
        [_backView setAutoresizesSubviews:YES];
        [_backView setFocusRingType:NSFocusRingTypeNone];
        _backView.wantsLayer =YES;
        _backView.layer.backgroundColor = [NSColor whiteColor].CGColor;
        [self.scrollView setDocumentView:_backView];
    }
    
    if (!_bottomLineView) {
        _bottomLineView = [[NSView alloc]initWithFrame:NSMakeRect(20, 5, 40, 2)];
        _bottomLineView.wantsLayer = YES;
        _bottomLineView.layer.backgroundColor = _itemSelectColor.CGColor;
        [self.backView addSubview:_bottomLineView];
    }
    
    CGFloat itemBtnRight = 10;
    CGFloat spaceWidth = 5;
    
    for (int i = 0 ; i < _titleArr.count; i++) {
        NSString *tmpData = [_titleArr objectAtIndex:i];
        
        NSAttributedString *blackString = [[NSAttributedString alloc]initWithString:tmpData attributes:[NSDictionary dictionaryWithObjectsAndKeys: _itemColor,NSForegroundColorAttributeName,_itemFont, NSFontAttributeName,nil]];
        NSButton *itemBtn = [[NSButton alloc]init];
        itemBtn.bezelStyle = NSBezelStyleRounded;
        [itemBtn setButtonType:NSButtonTypeToggle];
        itemBtn.bordered = NO;
        [itemBtn setAttributedTitle:blackString];
        itemBtn.alignment = NSTextAlignmentCenter;
        itemBtn.tag = 100 + i;
        
        itemBtn.font = _itemFont;
        if (tmpData.length >= 3 && tmpData.length < 4) {
            itemBtn.frame =NSMakeRect(spaceWidth + itemBtnRight, 0, kitemBtnWidth+15, kitemBtnHeight);
            _backView.width = _backView.width+15;
        }else  if (tmpData.length >= 4 && tmpData.length < 7){
            itemBtn.frame = NSMakeRect(spaceWidth + itemBtnRight, 0, kitemBtnWidth+30, kitemBtnHeight);
            _backView.width = _backView.width+30;
        }else  if (tmpData.length >= 7 && tmpData.length < 9){
            itemBtn.frame = NSMakeRect(spaceWidth + itemBtnRight, 0, kitemBtnWidth+30, kitemBtnHeight);
            _backView.width = _backView.width+50;
        }else{
            itemBtn.frame = NSMakeRect(spaceWidth + itemBtnRight, 0, kitemBtnWidth, kitemBtnHeight);
        }
        
        itemBtnRight = itemBtn.right;
        
        [self.backView addSubview:itemBtn];
        [self.itemBtnMarr addObject:itemBtn];
        itemBtn.target = self;
        itemBtn.action = @selector(itemBtnClick:);
    }
}

- (void)itemBtnClick:(NSButton *)sender{
    
    NSInteger index = sender.tag - 100;
    if (self.selectBlock) {
        self.selectBlock(index);
    }
    
    for (NSButton *button in self.itemBtnMarr) {
        if (button.state == 1) {
            button.state = 0;
            NSAttributedString * blackString = [[NSAttributedString alloc]initWithString:button.title attributes:[NSDictionary dictionaryWithObjectsAndKeys:_itemColor,NSForegroundColorAttributeName,_itemFont, NSFontAttributeName,nil]];
            [button setAttributedTitle:blackString];
        }
    }
    
    sender.state = 1;
    NSAttributedString * redString = [[NSAttributedString alloc]initWithString:sender.title attributes:[NSDictionary dictionaryWithObjectsAndKeys:_itemSelectColor,NSForegroundColorAttributeName,_itemSelectFont, NSFontAttributeName,nil]];
    [sender setAttributedTitle:redString];
    
    _bottomLineView.width = sender.width-8;
    _bottomLineView.left = sender.left+3;
    
    _lastSelectIndex = sender.tag;
    
    if (sender.left > (self.width-sender.width)*0.5 && sender.right < (_scrollView.documentView.width-self.width*0.5)) {//中间
        [self scrollToXPosition:sender.left-self.width*0.5+sender.width*0.5];
    }else if (sender.left < (self.width-sender.width)*0.5) {//左边
        [self scrollToXPosition:0.0];
    }else if (sender.right >= (_scrollView.documentView.width-self.width*0.5)){//右边
        [self scrollToXPosition:_scrollView.documentView.width];
    }
}

//scrollView滚动动画
- (void)scrollToXPosition:(float)xCoord {
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.3];
    NSClipView* clipView = [_scrollView contentView];
    NSPoint newOrigin = [clipView bounds].origin;
    newOrigin.x = xCoord;
    [[clipView animator] setBoundsOrigin:newOrigin];
    [_scrollView reflectScrolledClipView:[_scrollView contentView]];
    [NSAnimationContext endGrouping];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark - getter
- (NSScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[NSScrollView alloc]initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))];
        _scrollView.wantsLayer = YES;
        _scrollView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
    return _scrollView;
}

- (NSMutableArray *)itemBtnMarr{
    if (!_itemBtnMarr) {
        _itemBtnMarr = [NSMutableArray array];
    }
    return _itemBtnMarr;
}

#pragma mark - setter
- (void)setItemFont:(NSFont *)itemFont{
    _itemFont = itemFont;
}

- (void)setItemColor:(NSColor *)itemColor{
    _itemColor = itemColor;
}

- (void)setItemSelectFont:(NSFont *)itemSelectFont{
    _itemSelectFont = itemSelectFont;
}

- (void)setItemSelectColor:(NSColor *)itemSelectColor{
    _itemSelectColor = itemSelectColor;
}

- (void)setScrollDirection:(YPScrollDirection)scrollDirection{
    _scrollDirection = scrollDirection;
    
    _scrollView.horizontalScrollElasticity = _scrollDirection == YPScrollDirectionHorizontal ? NSScrollElasticityAutomatic : NSScrollElasticityNone;
    _scrollView.verticalScrollElasticity = _scrollDirection == YPScrollDirectionVertical ? NSScrollElasticityAutomatic : NSScrollElasticityNone;
            
}

- (void)setScrollerShowType:(YPScrollerShowType)scrollerShowType{
    _scrollerShowType = scrollerShowType;
    switch (_scrollerShowType) {
        case YPScrollerAllHide:
            _scrollView.hasHorizontalScroller = NO;
            _scrollView.hasVerticalScroller = NO;
            break;
        case YPScrollerAllShow:
            _scrollView.hasHorizontalScroller = YES;
            _scrollView.hasVerticalScroller = YES;
            break;
        case YPScrollerShowHorizontal:
            _scrollView.hasHorizontalScroller = YES;
            _scrollView.hasVerticalScroller = NO;
            break;
            case YPScrollerShowVertical:
                _scrollView.hasHorizontalScroller = NO;
                _scrollView.hasVerticalScroller = YES;
                break;
        default:
            break;
    }
}

- (void)setScrollerKnobStyle:(NSScrollerKnobStyle)scrollerKnobStyle{
    _scrollerKnobStyle = scrollerKnobStyle;
    _scrollView.scrollerKnobStyle = scrollerKnobStyle;
}

@end

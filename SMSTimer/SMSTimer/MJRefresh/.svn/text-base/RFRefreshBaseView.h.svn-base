//
//  RFRefreshBaseView.h
//  RFRefresh
//  
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import <UIKit/UIKit.h>

/**
 枚举
 */
// 控件的刷新状态
typedef enum {
	RFRefreshStatePulling = 1, // 松开就可以进行刷新的状态
	RFRefreshStateNormal = 2, // 普通状态
	RFRefreshStateRefreshing = 3, // 正在刷新中的状态
    RFRefreshStateWillRefreshing = 4
} RFRefreshState;

// 控件的类型
typedef enum {
    RFRefreshViewTypeHeader = -1, // 头部控件
    RFRefreshViewTypeFooter = 1 // 尾部控件
} RFRefreshViewType;


extern const CGFloat RFRefreshViewHeight;
extern const CGFloat RFRefreshAnimationDuration;

extern NSString *const RFRefreshFooterPullToRefresh;
extern NSString *const RFRefreshFooterReleaseToRefresh;
extern NSString *const RFRefreshFooterRefreshing;

extern NSString *const RFRefreshContentOffset;
extern NSString *const RFRefreshContentSize;

@class RFRefreshBaseView;

/**
 回调的Block定义
 */
// 开始进入刷新状态就会调用
typedef void (^BeginRefreshingBlock)(RFRefreshBaseView *refreshView);
// 刷新完毕就会调用
typedef void (^EndRefreshingBlock)(RFRefreshBaseView *refreshView);
// 刷新状态变更就会调用
typedef void (^RefreshStateChangeBlock)(RFRefreshBaseView *refreshView, RFRefreshState state);

/**
 代理的协议定义
 */
@protocol RFRefreshBaseViewDelegate <NSObject>
@optional
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(RFRefreshBaseView *)refreshView;
// 刷新完毕就会调用
- (void)refreshViewEndRefreshing:(RFRefreshBaseView *)refreshView;
// 刷新状态变更就会调用
- (void)refreshView:(RFRefreshBaseView *)refreshView stateChange:(RFRefreshState)state;
@end

/**
 类的声明
 */
@interface RFRefreshBaseView : UIView
{
    // 父控件一开始的contentInset
    UIEdgeInsets _scrollViewInitInset;
    // 父控件
	UIScrollView *_scrollView;
    
    // 子控件
     UILabel *_lastUpdateTimeLabel;
	UILabel *_statusLabel;
     UIImageView *_arrowImage;
	 UIActivityIndicatorView *_activityView;
    
    // 状态
    RFRefreshState _state;
}

// 构造方法
- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
// 设置要显示的父控件
@property (nonatomic, assign) UIScrollView *scrollView;

// 内部的控件
@property (nonatomic, assign, readonly) UILabel *lastUpdateTimeLabel;
@property (nonatomic, assign, readonly) UILabel *statusLabel;
@property (nonatomic, assign, readonly) UIImageView *arrowImage;

// Block回调
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
@property (nonatomic, copy) RefreshStateChangeBlock refreshStateChangeBlock;
@property (nonatomic, copy) EndRefreshingBlock endStateChangeBlock;
// 代理
@property (nonatomic, assign) id<RFRefreshBaseViewDelegate> delegate;

// 是否正在刷新
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
// 开始刷新
- (void)beginRefreshing;
// 结束刷新
- (void)endRefreshing;
// 不静止地结束刷新
- (void)endRefreshingWithoutIdle;
// 结束使用、释放资源
- (void)free;

/**
 交给子类去实现 和 调用
 */
- (void)setState:(RFRefreshState)state;
@end
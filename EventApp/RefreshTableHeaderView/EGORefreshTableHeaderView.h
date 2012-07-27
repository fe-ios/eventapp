//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//修改人：禚来强 iphone开发qq群：79190809 邮箱：zhuolaiqiang@gmail.com
//


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum
{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

@protocol EGORefreshTableHeaderDelegate;

@interface EGORefreshTableHeaderView : UIView {
	
	id _delegate;
	EGOPullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}

@property(nonatomic, assign) id<EGORefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)setState:(EGOPullRefreshState)aState;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@protocol EGORefreshTableHeaderDelegate

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;

@optional

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view;

@end

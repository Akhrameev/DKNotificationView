//
//  DKNotificationView.h
//
//
//  Created by Данил Комаров on 05.09.12.
//  Copyright (c) 2012 Two Rules. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DKNotificationView : UIView

typedef enum {
    DKNotificationViewStateActive = 1,
    DKNotificationViewStateMoving,
    DKNotificationViewStateResting
} DKNotificationViewState;

@property CGPoint startPoint;
@property CGRect restingFrame;
@property CGRect activeFrame;

@property (nonatomic) DKNotificationViewState state;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *contentView;

- (id)initWithFrame:(CGRect)frame inView:(UIView *)view;
- (void)show;
- (void)hide;

@end

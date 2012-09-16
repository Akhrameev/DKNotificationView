//
//  DKNotificationView.m
//
//
//  Created by Данил Комаров on 05.09.12.
//  Copyright (c) 2012 Two Rules. All rights reserved.
//

#import "DKNotificationView.h"

@implementation DKNotificationView

@synthesize startPoint = _startPoint;
@synthesize restingFrame = _restingFrame;
@synthesize activeFrame = _activeFrame;
@synthesize contentView = _contentView;
@synthesize state = _state;
@synthesize timer = _timer;

- (id)initWithFrame:(CGRect)frame inView:(UIView *)view
{
    self = [super initWithFrame:frame];
    if (self) {
        self.activeFrame = frame;
        self.restingFrame = CGRectMake(_activeFrame.origin.x,
                                       _activeFrame.origin.y + _activeFrame.size.height - 20,
                                       _activeFrame.size.width,
                                       _activeFrame.size.height);
        self.frame = self.restingFrame;
        self.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                    20,
                                                                    self.frame.size.width,
                                                                    self.frame.size.height - 20)];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.state = DKNotificationViewStateResting;
        
        UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(panGesture:)];
        [self addGestureRecognizer:gestureRecognizer];
        
        [self addObserver:self
               forKeyPath:@"frame"
                  options:NSKeyValueObservingOptionOld
                  context:NULL];
        
        [view addSubview:self];
    }
    return self;
}

- (void)setState:(DKNotificationViewState)state {
    _state = state;
    
    CGRect finalFrame;
    
    switch (state) {
        case DKNotificationViewStateMoving:
            [self.timer invalidate];
            self.timer = nil;
            if (![self.subviews containsObject:self.contentView]) {
                [self addSubview:self.contentView];
            }
            return;
            
        case DKNotificationViewStateResting:
            finalFrame = self.restingFrame;
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                          target:self
                                                        selector:@selector(hideContentView)
                                                        userInfo:nil
                                                         repeats:NO];
            break;
            
        case DKNotificationViewStateActive:
            [self.timer invalidate];
            self.timer = nil;
            finalFrame = self.activeFrame;
            if (![self.subviews containsObject:self.contentView]) {
                [self addSubview:self.contentView];
                
            }
            break;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [self setFrame:finalFrame];
    [UIView commitAnimations];
}

- (void)panGesture:(UIPanGestureRecognizer *)sender {
	
    
    [[self layer] removeAllAnimations];
    
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan:
            _startPoint = self.frame.origin;
            self.superview.userInteractionEnabled = NO;
            self.state = DKNotificationViewStateMoving;
            break;
            
        case UIGestureRecognizerStateChanged: {
            CGPoint translatedPoint = [sender translationInView:self.superview];
            translatedPoint = CGPointMake(0, _startPoint.y + translatedPoint.y);
            if ((translatedPoint.y >= self.activeFrame.origin.y) &
                (translatedPoint.y <= self.restingFrame.origin.y)) {
                self.frame = CGRectMake(self.frame.origin.x,
                                        translatedPoint.y,
                                        self.frame.size.width,
                                        self.frame.size.height);
            }
            break;
        }
            
            
        case UIGestureRecognizerStateEnded:
            if ([sender velocityInView:self.superview].y < 0) {
                if (self.frame.origin.y < self.restingFrame.origin.y - 2)
                    self.state = DKNotificationViewStateActive;
                else
                    self.state = DKNotificationViewStateResting;
            }
            else {
                if (self.frame.origin.y > self.activeFrame.origin.y + 2)
                    self.state = DKNotificationViewStateResting;
                else
                    self.state = DKNotificationViewStateActive;
            }
            self.superview.userInteractionEnabled = YES;
            break;
            
        default:
            break;
    }
}

- (void)show {
    [self setState:DKNotificationViewStateActive];
}

- (void)hide {
    [self setState:DKNotificationViewStateResting];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        self.contentView.alpha = (-self.frame.origin.y + self.activeFrame.origin.y) / (self.activeFrame.origin.y + self.activeFrame.size.height - 20) + 1;
    }
}

- (void)hideContentView {
    if ([self.subviews containsObject:self.contentView]) {
        [self.contentView removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGFloat locations[] = {1, 0};
    CGColorRef darkColor = [[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor];
    CGColorRef lightColor = [[UIColor clearColor] CGColor];
    NSArray *topColors = [NSArray arrayWithObjects: (__bridge id)darkColor, (__bridge id)lightColor, nil];
    
    CGRect bounds = self.bounds;
    CGPoint top = CGPointMake(CGRectGetMidX(bounds), bounds.origin.y);
    CGPoint bottom = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef topGradient = CGGradientCreateWithColors(CGColorGetColorSpace(darkColor), (__bridge CFArrayRef)topColors, locations);
    CGContextDrawLinearGradient(context, topGradient, top, bottom, 0);
    CGGradientRelease(topGradient);
    
    UIImage *image = [UIImage imageNamed:@"pull.png"];
    CGContextDrawImage(context, CGRectMake(self.bounds.size.width/2 - 21, 1, 43, 17), image.CGImage);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
}

@end

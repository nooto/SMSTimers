//
// CStatusBarWindow.m
//  Fragment
//
//  Created by yq on 13-9-13.
//
//

#import "CStatusBarWindow.h"

#define STATUS_BAR_ORIENTATION [UIApplication sharedApplication].statusBarOrientation
#define ROTATION_ANIMATION_DURATION [UIApplication sharedApplication].statusBarOrientationAnimationDuration

@interface CStatusBarWindow()
- (void)initializeToDefaultState;
- (void)rotateStatusBarWithFrame:(NSValue *)frameValue;
- (void)setSubViewHFrame;
- (void)setSubViewVFrame;
@end

@implementation CStatusBarWindow

static CStatusBarWindow* s_pInstance;

+ (CStatusBarWindow *)sharedInstance {
    @synchronized(self) {
        if (nil == s_pInstance) {
         s_pInstance =   [[self alloc] init];
        }
        return s_pInstance;
    }
}

+(id)alloc {
    @synchronized(self) {
        if (nil == s_pInstance) {
            s_pInstance = [super alloc];
        }
        return s_pInstance;
    }
}

//重写init方法
- (id)init
{
    self = [super initWithFrame:CGRectZero];    
    if (self) {        
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        [self setBackgroundColor:[UIColor clearColor]];
        [self setHidden:NO];
        [self setClipsToBounds:NO];
                        
        //内容视图        
        UIView *_contentView = [[UIView alloc] initWithFrame:self.bounds];        
        contentView = _contentView;        
        [contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];        
        [contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:contentView];
        
        view = [[UIView alloc] initWithFrame:self.bounds];
		[view setBackgroundColor:[UIColor colorWithRed:15/255.0f green:84/255.0f blue:110/255.0f alpha:1.0f]];
//        [view setBackgroundColor:[Utility RGBSringToColor:@"15,84,110"]];
        [contentView addSubview:view];
        
        CGRect rect = [UIApplication sharedApplication].statusBarFrame;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, 320, 20)];
        [imageView setImage:[UIImage imageNamed:@"newStatusbar.png"]];
        [contentView addSubview:imageView];
        
       // mButton = [[UIButton alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
        mButton = [[UIButton alloc] initWithFrame:self.bounds];
        [mButton setEnabled:NO];
        mButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        //[mButton setBackgroundImage:[UIImage imageNamed:@"statusbar.png"] forState:UIControlStateNormal];
        [mButton setBackgroundColor:[UIColor clearColor]];
        [mButton setTitle:@"" forState:UIControlStateNormal];
        [mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [mButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [mButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [contentView addSubview:mButton];
        
        //注册监听---当屏幕将要转动时，所出发的事件（用于操作本视图改变其frame）        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willRotateScreenEvent:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        //初始化
        [self initializeToDefaultState];
    }
    
    return self;
}


//初始化为默认状态
- (void)initializeToDefaultState
{
    //获取当前的状态栏位置
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;    
    //设置当前视图的旋转, 根据当前设备的朝向
    [self rotateStatusBarWithFrame:[NSValue valueWithCGRect:statusBarFrame]];
}

//旋转屏幕
- (void)rotateStatusBarWithFrame:(NSValue *)frameValue
{    
    CGRect frame = [frameValue CGRectValue];    
    UIInterfaceOrientation orientation = STATUS_BAR_ORIENTATION;

    if (orientation == UIDeviceOrientationPortrait) {        
        self.transform = CGAffineTransformIdentity; //屏幕不旋转        
        [self setSubViewVFrame];        
    }else if (orientation == UIDeviceOrientationPortraitUpsideDown) {        
        self.transform = CGAffineTransformMakeRotation(M_PI); //屏幕旋转180度
        [self setSubViewVFrame];        
    }else if (orientation == UIDeviceOrientationLandscapeRight) {        
        self.transform = CGAffineTransformMakeRotation((M_PI * (-90.0f) / 180.0f)); //屏幕旋转-90度        
        [self setSubViewHFrame];        
    }else if (orientation == UIDeviceOrientationLandscapeLeft){        
        self.transform = CGAffineTransformMakeRotation(M_PI * 90.0f / 180.0f); //屏幕旋转90度        
        [self setSubViewHFrame];        
    }
    
 self.frame = frame;
    [contentView setFrame:self.bounds];    
}

//设置横屏的子视图的frame
- (void)setSubViewHFrame
{    
    mButton.frame = CGRectMake(0, 0, 1024, 20);
    view.frame = CGRectMake(0, 0, 1024, 20);
    imageView.frame = CGRectMake(0, 0, 1024, 54);
}

//设置竖屏的子视图的frame
- (void)setSubViewVFrame
{
    mButton.frame = CGRectMake(0, 0, 320, 20);
}

//#pragma mark -
//#pragma mark 响应屏幕即将旋转时的事件响应
- (void)willRotateScreenEvent:(NSNotification *)notification
{    
    NSValue *frameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];    
    [self rotateStatusBarAnimatedWithFrame:frameValue];    
}

- (void)rotateStatusBarAnimatedWithFrame:(NSValue *)frameValue {    
    [UIView animateWithDuration:ROTATION_ANIMATION_DURATION animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {        
        [self rotateStatusBarWithFrame:frameValue];        
        [UIView animateWithDuration:ROTATION_ANIMATION_DURATION animations:^{            
            self.alpha = 1;
        }];
    }];    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)showMessage:(NSString *)message
{
    self.hidden = NO;
    [mButton setTitle:message forState:UIControlStateNormal];
    [imageView setAlpha:0.0f];
    [mButton setAlpha:1.0f];
    [view setAlpha:0.0f];
    
    [UIView animateWithDuration:0.26f animations:^{
        view.alpha = 1.0f;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.54f animations:^{
            imageView.alpha = 0.99f;
            mButton.alpha = 0.99f;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.9f animations:^{
                imageView.alpha = 1.0f;
                mButton.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5f animations:^{
                    imageView.alpha = 0.0f;
                    mButton.alpha = 0.0f;
                } completion:^(BOOL finished){
                    [UIView animateWithDuration:0.25f animations:^{
                        view.alpha = 0.0f;
                    }completion:^(BOOL finished){
                        self.hidden = YES;
                    }];
                }];
            }];
        }];
    }];
}

@end



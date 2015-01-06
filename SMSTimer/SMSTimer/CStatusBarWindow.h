//
// CStatusBarWindow.h
//  Fragment
//
//  Created by yq on 13-9-13.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CStatusBarWindow : UIWindow {
    UIView *contentView;
    
    UIView *view;
    UIImageView *imageView;
    UIButton *mButton;
}

+(CStatusBarWindow*)sharedInstance;
- (void)showMessage:(NSString *)message;

@end

#define g_pCStatusBar [CStatusBarWindow sharedInstance]

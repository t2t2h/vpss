#import <UIKit/UIKit.h>
#import "APPanel.h"
#import "APSettings.h"

@interface AflatoonCoreTarget : NSObject
+ (instancetype)shared;
- (void)openPanel;
@end

static UIButton *gButton;
static void APInstallLauncher(void) {
    if (!APSettings.shared.overlayEnabled) return;
    UIWindow *window=nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:UIWindowScene.class] || scene.activationState!=UISceneActivationStateForegroundActive) continue;
        for (UIWindow *w in ((UIWindowScene *)scene).windows) if (w.isKeyWindow) { window=w; break; }
        if (window) break;
    }
    if (!window || gButton) return;
    UIButton *b=[UIButton buttonWithType:UIButtonTypeSystem]; gButton=b;
    b.frame=CGRectMake(window.bounds.size.width-76,window.safeAreaInsets.top+24,56,56); b.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    b.layer.cornerRadius=28; b.backgroundColor=[UIColor colorWithRed:0 green:0.72 blue:0.66 alpha:0.96];
    [b setTitle:@"AP" forState:UIControlStateNormal]; [b setTitleColor:UIColor.whiteColor forState:UIControlStateNormal]; b.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [b addTarget:AflatoonCoreTarget.shared action:@selector(openPanel) forControlEvents:UIControlEventTouchUpInside]; [window addSubview:b];
}
@implementation AflatoonCoreTarget
+ (instancetype)shared { static id x; static dispatch_once_t once; dispatch_once(&once,^{x=[self new];}); return x; }
- (void)openPanel { [APPanel present]; }
@end
__attribute__((constructor)) static void AflatoonCoreEntry(void) {
    @autoreleasepool {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(__unused NSNotification *n) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1*NSEC_PER_SEC)),dispatch_get_main_queue(),^{ APInstallLauncher(); });
        }];
    }
}

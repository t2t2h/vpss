#import "APPanel.h"
#import "APSettings.h"

static UIColor *APColor(NSInteger r, NSInteger g, NSInteger b) { return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]; }
static UILabel *APLabel(NSString *s, CGFloat size, UIColor *color) {
    UILabel *l = [UILabel new]; l.text = s; l.textColor = color; l.font = [UIFont systemFontOfSize:size weight:UIFontWeightSemibold]; return l;
}

@implementation APPanel
+ (UIViewController *)topController {
    UIWindow *w = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:UIWindowScene.class]) {
            for (UIWindow *candidate in ((UIWindowScene *)scene).windows) if (candidate.isKeyWindow) { w = candidate; break; }
        }
        if (w) break;
    }
    UIViewController *vc = w.rootViewController;
    while (vc.presentedViewController) vc = vc.presentedViewController;
    return vc;
}
+ (void)addSwitch:(NSString *)title keyPath:(NSString *)key y:(CGFloat)y to:(UIView *)view {
    UILabel *label = APLabel(title, 15, UIColor.whiteColor); label.frame = CGRectMake(20,y,220,34); [view addSubview:label];
    UISwitch *sw = [UISwitch new]; sw.onTintColor = APColor(0,220,190); sw.frame = CGRectMake(view.bounds.size.width-82,y,60,34); sw.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    APSettings *s = APSettings.shared; sw.on = [[s valueForKey:key] boolValue];
    sw.accessibilityIdentifier = key; [sw addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged]; [view addSubview:sw];
}
+ (void)switchChanged:(UISwitch *)sender { [APSettings.shared setValue:@(sender.isOn) forKey:sender.accessibilityIdentifier]; [APSettings.shared save]; }
+ (void)addSlider:(NSString *)title key:(NSString *)key y:(CGFloat)y min:(float)min max:(float)max to:(UIView *)view {
    UILabel *label = APLabel(title, 14, UIColor.whiteColor); label.frame = CGRectMake(20,y,140,25); [view addSubview:label];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(150,y,view.bounds.size.width-175,30)]; slider.minimumValue=min; slider.maximumValue=max; slider.tintColor=APColor(0,220,190); slider.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    slider.value = [[APSettings.shared valueForKey:key] floatValue]; slider.accessibilityIdentifier=key; [slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged]; [view addSubview:slider];
}
+ (void)sliderChanged:(UISlider *)sender { [APSettings.shared setValue:@(sender.value) forKey:sender.accessibilityIdentifier]; [APSettings.shared save]; }
+ (void)present {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *host = [self topController]; if (!host || host.presentedViewController) return;
        UIViewController *vc = [UIViewController new]; vc.modalPresentationStyle=UIModalPresentationPageSheet; vc.view.backgroundColor=APColor(12,18,32); vc.title=@"AFLATOON CORE";
        UIScrollView *scroll=[UIScrollView new]; scroll.translatesAutoresizingMaskIntoConstraints=NO; [vc.view addSubview:scroll];
        [NSLayoutConstraint activateConstraints:@[[scroll.topAnchor constraintEqualToAnchor:vc.view.safeAreaLayoutGuide.topAnchor],[scroll.bottomAnchor constraintEqualToAnchor:vc.view.bottomAnchor],[scroll.leadingAnchor constraintEqualToAnchor:vc.view.leadingAnchor],[scroll.trailingAnchor constraintEqualToAnchor:vc.view.trailingAnchor]]];
        UIView *content=[[UIView alloc] initWithFrame:CGRectMake(0,0,vc.view.bounds.size.width,570)]; content.autoresizingMask=UIViewAutoresizingFlexibleWidth; scroll.frame=vc.view.bounds; scroll.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight; [scroll addSubview:content]; scroll.contentSize=content.bounds.size;
        UILabel *heading=APLabel(@"AFLATOON  •  CONTROL CENTER",20,APColor(0,230,200)); heading.frame=CGRectMake(20,18,330,32); [content addSubview:heading];
        UILabel *sub=APLabel(@"Local preferences · no VPN · no hidden system changes",11,APColor(170,185,205)); sub.frame=CGRectMake(20,52,330,24); [content addSubview:sub];
        [self addSwitch:@"Show control overlay" keyPath:@"overlayEnabled" y:94 to:content];
        [self addSwitch:@"Enable sound preferences" keyPath:@"soundToolsEnabled" y:140 to:content];
        [self addSwitch:@"Show network information" keyPath:@"networkInfoEnabled" y:186 to:content];
        [self addSlider:@"Output level" key:@"outputGain" y:250 min:0 max:2 to:content];
        [self addSlider:@"Bass" key:@"bass" y:300 min:-1 max:1 to:content];
        [self addSlider:@"Mid" key:@"mid" y:350 min:-1 max:1 to:content];
        [self addSlider:@"Treble" key:@"treble" y:400 min:-1 max:1 to:content];
        UILabel *dns=APLabel(@"DNS preference: Automatic (managed by iOS)",12,APColor(170,185,205)); dns.frame=CGRectMake(20,455,330,25); [content addSubview:dns];
        UILabel *note=APLabel(@"This starter library stores settings only. Audio processing and app-specific integration require a supported host-app implementation.",11,APColor(170,185,205)); note.numberOfLines=0; note.frame=CGRectMake(20,490,330,60); [content addSubview:note];
        UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:vc action:@selector(dismissViewControllerAnimated:completion:)]; vc.navigationItem.rightBarButtonItem=done;
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:vc]; [host presentViewController:nav animated:YES completion:nil];
    });
}
@end

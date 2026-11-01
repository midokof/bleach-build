// Bleach.dylib reconstructed source
// Language: Objective-C
// Target: iOS (arm64), clang

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

static NSString *const kHideProtectViewKey = @"hide_protect_view";
static const NSInteger kProtectViewTag = 0x1869f;

@interface AppProtector : NSObject

@property (nonatomic, assign) BOOL isArabic;
@property (nonatomic, strong) UISwitch *hideSwitch;
@property (nonatomic, strong) UILabel *welcomeLabel;
@property (nonatomic, strong) UILabel *creditLabel;
@property (nonatomic, strong) UILabel *switchLabel;

+ (void)load;
- (void)start;
- (UIButton *)styledBlueButtonWithFrame:(CGRect)frame title:(NSString *)title;
- (void)toggleLanguage;
- (void)toggleSwitch:(UISwitch *)sender;
- (void)openTelegram;
- (void)openDeveloper;
- (void)closeProtectView;
- (void)animateContentIn:(UIView *)view;

@end

static AppProtector *protectorInstance = nil;

@implementation AppProtector

+ (void)load {
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (![defaults boolForKey:kHideProtectViewKey]) {
            protectorInstance = [[AppProtector alloc] init];
            [protectorInstance start];
        }
    });
}

- (void)start {
    self.isArabic = NO;

    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) { keyWindow = window; break; }
    }
    if (!keyWindow) return;

    UIView *existing = [keyWindow viewWithTag:kProtectViewTag];
    if (existing) [existing removeFromSuperview];

    UIView *overlay = [[UIView alloc] initWithFrame:keyWindow.bounds];
    overlay.tag = kProtectViewTag;
    overlay.backgroundColor = [UIColor clearColor];
    overlay.alpha = 0.0;

    UIVisualEffectView *blur = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    blur.frame = keyWindow.bounds;
    blur.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [overlay addSubview:blur];

    // language toggle button
    UIButton *langBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    langBtn.frame = CGRectMake(keyWindow.bounds.size.width - 72.0, 40.0, 42.0, 40.0);
    langBtn.layer.cornerRadius = 8.0;
    langBtn.clipsToBounds = NO;
    [langBtn setTitle:@"<<" forState:UIControlStateNormal];
    [langBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    langBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [langBtn addTarget:self action:@selector(toggleLanguage) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:langBtn];

    // logo
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - 200.0) / 2.0, 60.0, 200.0, 200.0)];
    logo.layer.cornerRadius = 100.0;
    logo.clipsToBounds = YES;
    [overlay addSubview:logo];

    // welcome label
    self.welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 280.0, keyWindow.bounds.size.width, 40.0)];
    self.welcomeLabel.text = @"Welcome";
    self.welcomeLabel.font = [UIFont boldSystemFontOfSize:29.0];
    self.welcomeLabel.textColor = [UIColor whiteColor];
    self.welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [overlay addSubview:self.welcomeLabel];

    // credit label
    self.creditLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320.0, keyWindow.bounds.size.width, 25.0)];
    self.creditLabel.text = @"Follow us for more exclusive apps and games!";
    self.creditLabel.font = [UIFont systemFontOfSize:24.0];
    self.creditLabel.textColor = [UIColor whiteColor];
    self.creditLabel.textAlignment = NSTextAlignmentCenter;
    [overlay addSubview:self.creditLabel];

    // buttons
    CGFloat btnW = 100.0, btnH = 40.0, spacing = 10.0;
    CGFloat startX = 50.0;
    CGFloat y = 420.0;
    UIButton *telegramBtn = [self styledBlueButtonWithFrame:CGRectMake(startX, y, btnW, btnH) title:@" Telegram"];
    [telegramBtn addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:telegramBtn];

    UIButton *devBtn = [self styledBlueButtonWithFrame:CGRectMake(startX + btnW + spacing, y, btnW, btnH) title:@" Developer"];
    [devBtn addTarget:self action:@selector(openDeveloper) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:devBtn];

    UIButton *thanksBtn = [self styledBlueButtonWithFrame:CGRectMake(startX + (btnW + spacing) * 2, y, btnW, btnH) title:@" Thanks"];
    [thanksBtn addTarget:self action:@selector(closeProtectView) forControlEvents:UIControlEventTouchUpInside];
    [overlay addSubview:thanksBtn];

    // switch label
    self.switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 460.0, 280.0, 30.0)];
    self.switchLabel.text = @" Don't show this alert again";
    self.switchLabel.font = [UIFont systemFontOfSize:22.0];
    self.switchLabel.textColor = [UIColor whiteColor];
    self.switchLabel.textAlignment = NSTextAlignmentLeft;
    [overlay addSubview:self.switchLabel];

    // hide switch
    self.hideSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(keyWindow.bounds.size.width - 90.0, 455.0, 0, 0)];
    [self.hideSwitch setOn:NO];
    self.hideSwitch.onTintColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    self.hideSwitch.thumbTintColor = [UIColor whiteColor];
    [self.hideSwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
    [overlay addSubview:self.hideSwitch];

    [keyWindow addSubview:overlay];

    // animate content in
    [self animateContentIn:overlay];

    overlay.alpha = 1.0;
}

- (UIButton *)styledBlueButtonWithFrame:(CGRect)frame title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.layer.cornerRadius = 12.0;
    button.clipsToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:24.5];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = button.bounds;
    UIColor *c1 = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    UIColor *c2 = [UIColor colorWithRed:0.2 green:0.2 blue:1.0 alpha:1.0];
    gradient.colors = @[(id)c1.CGColor, (id)c2.CGColor];
    gradient.cornerRadius = 12.0;
    [button.layer insertSublayer:gradient atIndex:0];

    button.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 4.0);
    button.layer.shadowRadius = 8.0;
    button.layer.shadowOpacity = 0.2;
    button.layer.masksToBounds = NO;

    return button;
}

- (void)toggleLanguage {
    self.isArabic = !self.isArabic;
    if (!self.isArabic) {
        self.welcomeLabel.text = @"Welcome";
        self.creditLabel.text = @"Follow us for more exclusive apps and games!";
        self.switchLabel.text = @" Don't show this alert again";
    } else {
        self.welcomeLabel.text = @"\u064a\u0627 \u0647\u0644\u0627 \u0628\u064a\u0643";
        self.creditLabel.text = @"\u062a\u0627\u0628\u0639\u0648\u0646\u0627 \u0644\u0644\u0645\u0632\u064a\u062f \u0645\u0646 \u0627\u0644\u062a\u0637\u0628\u064a\u0642\u0627\u062a \u0648\u0627\u0644\u0627\u0644\u0639\u0627\u0628 \u0627\u0644\u062d\u0635\u0631\u064a\u0629 \u0644\u062f\u064a\u0646\u0627";
        self.switchLabel.text = @"\U0001f515 \u0644\u0627 \u062a\u0638\u0647\u0631 \u0647\u0630\u0647 \u0627\u0644\u0631\u0633\u0627\u0644\u0629 \u0645\u062c\u062f\u062f\u064b\u0627";
    }
}

- (void)toggleSwitch:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.isOn forKey:kHideProtectViewKey];
    [defaults synchronize];
}

- (void)openTelegram {
    NSURL *url = [NSURL URLWithString:@"https://t.me/ffipaa"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)openDeveloper {
    NSURL *url = [NSURL URLWithString:@"https://t.me/ffipa"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)closeProtectView {
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) { keyWindow = window; break; }
    }
    UIView *view = [keyWindow viewWithTag:kProtectViewTag];
    if (!view) return;

    if (self.hideSwitch.isOn) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:kHideProtectViewKey];
        [defaults synchronize];
    }

    [UIView animateWithDuration:0.4 animations:^{
        for (UIView *sub in view.subviews) sub.alpha = 0.0;
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void)animateContentIn:(UIView *)view {
    CGFloat delay = 0.0;
    for (UIView *sub in view.subviews) {
        if (![sub isKindOfClass:[UIVisualEffectView class]]) {
            [UIView animateWithDuration:0.6 delay:delay usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                sub.transform = CGAffineTransformIdentity;
                sub.alpha = 1.0;
            } completion:nil];
            delay += 0.1;
        }
    }
}

@end

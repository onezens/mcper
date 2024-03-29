
#import "wechatbot-prefix-header.h"
#import <WCBFWStatic/WCBFWStatic.h>
#import <WCBFWDynamic/WCBFWDynamic.h>
#import <WCBStatic/WCBStatic.h>
#import <WCBDyLib/WCBDyLib.h>

#define kWCBSrcPath @"/Library/AppSupport/WeChatBot/"
#define kWCBImgSrcPath @"/Library/AppSupport/WeChatBot/imgs"

typedef void(^LogTestBlk)(void);

#pragma mark - XiaoMing

@interface WCBXiaoming: NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;

- (void)logInfo;

+ (void)sayHello;

@end


%subclass WCBXiaoming : NSObject

%property (nonatomic,assign) NSInteger age;
%property (nonatomic,strong) NSString * name;

%new
+(void)sayHello {
    NSLog(@"xiaoming say hello.");
}

%new
- (void)logInfo {
    NSLog(@"log info name: %@  age: %zd", self.name, self.age);
}


%end



#pragma mark - MicroMessengerAppDelegate

@interface MicroMessengerAppDelegate()

@property (nonatomic, strong) UIImage *img;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) LogTestBlk logTest;

- (void)testXcTheosLogos;

@end



%hook MicroMessengerAppDelegate

%property (nonatomic,strong) UIImage * img;
%property (nonatomic,assign) double duration;
%property (nonatomic,copy) LogTestBlk logTest;

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    BOOL rel = %orig();
    [self testHook];
    [self testXcTheosLogos];
    return rel;
}

%new
- (void)testHook {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Works for logos hook" message:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
    [alert show];

    [WCBStatic logInfo];
    [WCBDyLib logInfo];
    [WCBFWStatic logInfo];
    [WCBFWDynamic logInfo];
    
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/wcb_icon.png", kWCBImgSrcPath]];
    self.img = img;
    NSLog(@"[WeChatBot] img: %@", self.img);
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.img];
    [imgView sizeToFit];
    imgView.center = CGPointMake(46, 60);
    [self.window addSubview:imgView];
    
}


%new
- (void)testXcTheosLogos {
    
    self.duration = [[NSDate date] timeIntervalSince1970];
    __weak typeof(self)weakSelf = self;
    self.logTest = ^{
        NSLog(@"[WeChatBot] img: %@", weakSelf.img);
        NSLog(@"[WeChatBot] duration: %f", weakSelf.duration);
    };
    
    if(self.logTest) {
        self.logTest();
    }
    
    [%c(WCBXiaoming) sayHello];
    WCBXiaoming *xm = [%c(WCBXiaoming) new];
    xm.age = 18;
    xm.name = @"wang xiao ming";
    [xm logInfo];
}

%end



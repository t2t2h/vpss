#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface APSettings : NSObject
+ (instancetype)shared;
@property (nonatomic) BOOL overlayEnabled;
@property (nonatomic) BOOL soundToolsEnabled;
@property (nonatomic) BOOL networkInfoEnabled;
@property (nonatomic) float outputGain;
@property (nonatomic) float bass;
@property (nonatomic) float mid;
@property (nonatomic) float treble;
@property (nonatomic, copy) NSString *dnsPreset;
- (void)save;
@end
NS_ASSUME_NONNULL_END

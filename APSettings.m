#import "APSettings.h"

@implementation APSettings
+ (instancetype)shared {
    static APSettings *s; static dispatch_once_t once;
    dispatch_once(&once, ^{ s = [APSettings new]; [s load]; });
    return s;
}
- (void)load {
    NSUserDefaults *d = NSUserDefaults.standardUserDefaults;
    _overlayEnabled = [d objectForKey:@"ap.overlay"] ? [d boolForKey:@"ap.overlay"] : YES;
    _soundToolsEnabled = [d boolForKey:@"ap.sound"];
    _networkInfoEnabled = [d boolForKey:@"ap.networkInfo"];
    _outputGain = [d objectForKey:@"ap.gain"] ? [d floatForKey:@"ap.gain"] : 1.0f;
    _bass = [d objectForKey:@"ap.bass"] ? [d floatForKey:@"ap.bass"] : 0.0f;
    _mid = [d objectForKey:@"ap.mid"] ? [d floatForKey:@"ap.mid"] : 0.0f;
    _treble = [d objectForKey:@"ap.treble"] ? [d floatForKey:@"ap.treble"] : 0.0f;
    _dnsPreset = [d stringForKey:@"ap.dns"] ?: @"Automatic";
}
- (void)save {
    NSUserDefaults *d = NSUserDefaults.standardUserDefaults;
    [d setBool:_overlayEnabled forKey:@"ap.overlay"];
    [d setBool:_soundToolsEnabled forKey:@"ap.sound"];
    [d setBool:_networkInfoEnabled forKey:@"ap.networkInfo"];
    [d setFloat:_outputGain forKey:@"ap.gain"];
    [d setFloat:_bass forKey:@"ap.bass"];
    [d setFloat:_mid forKey:@"ap.mid"];
    [d setFloat:_treble forKey:@"ap.treble"];
    [d setObject:_dnsPreset forKey:@"ap.dns"];
    [d synchronize];
}
@end

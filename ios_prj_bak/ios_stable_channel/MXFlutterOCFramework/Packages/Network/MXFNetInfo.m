/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "MXFNetInfo.h"
#import "MXBridgeModule.h"
#import "MXFUtil.h"

#if !TARGET_OS_TV && !TARGET_OS_UIKITFORMAC
  #import <CoreTelephony/CTTelephonyNetworkInfo.h>
#endif

// Based on the ConnectionType enum described in the W3C Network Information API spec
// (https://wicg.github.io/netinfo/).
static NSString *const RCTConnectionTypeUnknown = @"unknown";
static NSString *const RCTConnectionTypeNone = @"none";
static NSString *const RCTConnectionTypeWifi = @"wifi";
static NSString *const RCTConnectionTypeCellular = @"cellular";

// Based on the EffectiveConnectionType enum described in the W3C Network Information API spec
// (https://wicg.github.io/netinfo/).
static NSString *const RCTEffectiveConnectionTypeUnknown = @"unknown";
static NSString *const RCTEffectiveConnectionType2g = @"2g";
static NSString *const RCTEffectiveConnectionType3g = @"3g";
static NSString *const RCTEffectiveConnectionType4g = @"4g";

// The RCTReachabilityState* values are deprecated.
static NSString *const RCTReachabilityStateUnknown = @"unknown";
static NSString *const RCTReachabilityStateNone = @"none";
static NSString *const RCTReachabilityStateWifi = @"wifi";
static NSString *const RCTReachabilityStateCell = @"cell";

@implementation MXFNetInfo
{
  SCNetworkReachabilityRef _firstTimeReachability;
  SCNetworkReachabilityRef _reachability;
  NSString *_connectionType;
  NSString *_effectiveConnectionType;
  NSString *_statusDeprecated;
  NSString *_host;
  BOOL _isObserving;
  MXPromiseResolveBlock _resolve;

}

MX_EXPORT_MODULE()

+ (id<MXBridgeModule>)registerModuleInMXFlutterJSContext:(JSValue*)jsAPPValue bridge:(MXJSBridge *)bridge
{

    MXFNetInfo * netInfo = [[MXFNetInfo alloc ] initWithHost:@"qq.com"];
    
    netInfo.bridge = bridge;
    
    //moduleName = networking
    jsAPPValue[self.moduleName] = netInfo;
    
    return netInfo;
    
}


static void RCTReachabilityCallback(__unused SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info)
{
    MXFNetInfo *self = (__bridge id)info;
    BOOL didSetReachabilityFlags = [self setReachabilityStatus:flags];
    
    NSString *connectionType = self->_connectionType ?: RCTConnectionTypeUnknown;
    NSString *effectiveConnectionType = self->_effectiveConnectionType ?: RCTEffectiveConnectionTypeUnknown;
    NSString *networkInfo = self->_statusDeprecated ?: RCTReachabilityStateUnknown;
    
    if (self->_firstTimeReachability && self->_resolve) {
      SCNetworkReachabilityUnscheduleFromRunLoop(self->_firstTimeReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
      CFRelease(self->_firstTimeReachability);
      self->_resolve(@{@"connectionType": connectionType,
                       @"effectiveConnectionType": effectiveConnectionType,
                       @"network_info": networkInfo});
      self->_firstTimeReachability = nil;
      self->_resolve = nil;
    }
    
    if (didSetReachabilityFlags && self->_isObserving) {
        [self sendEventWithName:@"networkStatusDidChange" body:@{@"connectionType": connectionType,
                                                                 @"effectiveConnectionType": effectiveConnectionType,
                                                                 @"network_info": networkInfo}];
    }
}

// We need RCTReachabilityCallback's and module methods to be called on the same thread so that we can have
// guarantees about when we mess with the reachability callbacks.
- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

#pragma mark - Lifecycle

- (instancetype)initWithHost:(NSString *)host
{
  MXAssertParam(host);
  NSAssert(![host hasPrefix:@"http"], @"Host value should just contain the domain, not the URL scheme.");

  if ((self = [self init])) {
    _host = [host copy];
  }
  return self;
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[@"networkStatusDidChange"];
}

- (void)startObserving
{
  _isObserving = YES;
  _connectionType = RCTConnectionTypeUnknown;
  _effectiveConnectionType = RCTEffectiveConnectionTypeUnknown;
  _statusDeprecated = RCTReachabilityStateUnknown;
  _reachability = [self getReachabilityRef];
}

- (void)stopObserving
{
  _isObserving = NO;
  if (_reachability) {
    SCNetworkReachabilityUnscheduleFromRunLoop(_reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    CFRelease(_reachability);
  }
}

- (void)dealloc
{
  if (_firstTimeReachability) {
    SCNetworkReachabilityUnscheduleFromRunLoop(self->_firstTimeReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    CFRelease(self->_firstTimeReachability);
    _firstTimeReachability = nil;
  }
}

- (SCNetworkReachabilityRef)getReachabilityRef
{
  SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, _host.UTF8String ?: "qq.com");
  SCNetworkReachabilityContext context = { 0, ( __bridge void *)self, NULL, NULL, NULL };
  SCNetworkReachabilitySetCallback(reachability, RCTReachabilityCallback, &context);
  SCNetworkReachabilityScheduleWithRunLoop(reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    
  return reachability;
}

- (BOOL)setReachabilityStatus:(SCNetworkReachabilityFlags)flags
{
  NSString *connectionType = RCTConnectionTypeUnknown;
  NSString *effectiveConnectionType = RCTEffectiveConnectionTypeUnknown;
  NSString *status = RCTReachabilityStateUnknown;
  if ((flags & kSCNetworkReachabilityFlagsReachable) == 0 ||
      (flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0) {
    connectionType = RCTConnectionTypeNone;
    status = RCTReachabilityStateNone;
  }
  
#if !TARGET_OS_TV && !TARGET_OS_UIKITFORMAC
  
  else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
    connectionType = RCTConnectionTypeCellular;
    status = RCTReachabilityStateCell;
    
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    if (netinfo) {
      if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] ||
          [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
          [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        effectiveConnectionType = RCTEffectiveConnectionType2g;
      } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] ||
                 [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                 [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] ||
                 [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                 [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
                 [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                 [netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        effectiveConnectionType = RCTEffectiveConnectionType3g;
      } else if ([netinfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
        effectiveConnectionType = RCTEffectiveConnectionType4g;
      }
    }
  }
  
#endif
  
  else {
    connectionType = RCTConnectionTypeWifi;
    status = RCTReachabilityStateWifi;
  }
  
  if (![connectionType isEqualToString:self->_connectionType] ||
      ![effectiveConnectionType isEqualToString:self->_effectiveConnectionType] ||
      ![status isEqualToString:self->_statusDeprecated]) {
    self->_connectionType = connectionType;
    self->_effectiveConnectionType = effectiveConnectionType;
    self->_statusDeprecated = status;
    return YES;
  }
  
  return NO;
}

#pragma mark - Public API

-(void)getCurrentConnectivity:(MXPromiseResolveBlock)resolve
                  reject:(__unused MXPromiseRejectBlock)reject
{
  if (_firstTimeReachability) {
    SCNetworkReachabilityUnscheduleFromRunLoop(self->_firstTimeReachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    CFRelease(self->_firstTimeReachability);
    _firstTimeReachability = nil;
    _resolve = nil;
  }
  _firstTimeReachability = [self getReachabilityRef];
  _resolve = resolve;
}

@end

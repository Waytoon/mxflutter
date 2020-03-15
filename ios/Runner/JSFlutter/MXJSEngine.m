//
//  MXJSEngine.m
//  Runner
//
//  Created by soapyang on 2018/12/22.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

#import "MXJSEngine.h"
#import "MXJSFlutterDefines.h"
#import "MXJSFlutterEngine.h"
#import "JSModule.h"
#import <Flutter/Flutter.h>
#import "MXFDispose.h"

@interface MXJSEngine()

@property (nonatomic, strong) JSModule *moduleLoader;
@property (nonatomic, strong) NSMutableArray *searchDirArray;

@property (nonatomic, strong) NSMutableDictionary *jsCallbackCache;
@property (nonatomic, assign) NSInteger jsCallbackCount;

@end


@implementation MXJSEngine

- (instancetype)init
{
    if (self = [super init])
    {
        self.searchDirArray = [NSMutableArray array];
        self.moduleLoader = [[JSModule alloc] init];
        self.jsCallbackCache = [NSMutableDictionary dictionary];
        
        [self setup];
    }
    return self;
}

- (void)dispose
{

}

- (void)dealloc
{
    MXJSFlutterLog(@"dealloc ");
}



- (void)setup
{
    self.jsExecutor = [[MXJSExecutor alloc] init];
    
    __weak MXJSEngine *weakSelf = self;
    [self.jsExecutor executeMXJSBlockOnJSThread:^(MXJSExecutor *executor) {
        [weakSelf setupBasicJSRuntime:weakSelf context:executor.jsContext];
    }];
}

- (void)addSearchDir:(NSString*)dir
{
    if (nil == dir || [self.searchDirArray containsObject:dir]) {
        return;
    }
    
    [self.searchDirArray addObject:dir];
}

- (void)setupBasicJSRuntime:(MXJSEngine* )jsEngine context:(JSContext* )context
{
    __weak MXJSEngine *weakSelf = jsEngine;
    
    context.exceptionHandler = ^(JSContext *con, JSValue *exception) {
        MXJSFlutterLog(@"js context.exceptionHandler  %@", exception);
    };
    context[@"require"] = ^(NSString *filePath) {
        //MXJSFlutterLog(@"require file:%@",filePath);
        
        NSString *prefix = @"./";
        if ([filePath hasPrefix:prefix]) {
            filePath = [filePath substringFromIndex:prefix.length];
        }
        
        NSString *absolutePath = @"";
        NSArray *extensions = @[@".js",@".ddc.js"];
        for(NSString *dir in weakSelf.searchDirArray) {
            for (NSString *extension in extensions) {
                NSString *absolutePathTemp = [dir stringByAppendingPathComponent:filePath];
                if (![filePath hasSuffix:@".js"]) {
                    absolutePathTemp = [NSString stringWithFormat:@"%@%@",absolutePathTemp,extension];
                }
                if ([[NSFileManager defaultManager] fileExistsAtPath:absolutePathTemp]) {
                    absolutePath = absolutePathTemp;
                    break;
                }
            }
            if (absolutePath.length > 0) {
                break;
            }
        }
        
        JSModule *module = nil;
        if (absolutePath.length != 0) {
            //MXJSFlutterLog(@"require file:%@ found absolutePath=%@",filePath, absolutePath);
            module = [JSModule require:filePath fullModulePath:absolutePath inContext:context];
            if (!module) {
                [[JSContext currentContext] evaluateScript:@"throw 'not found'"];
                return [JSValue valueWithUndefinedInContext:[JSContext currentContext]];
            }
        }
        
        return module.exports;
    };
    
    //------Dart2Js支持------
    context[@"dartPrint"] = ^(NSString *string) {
        return NSLog(@"%@",string);
    };
    
    context[@"nativePrint"] = ^(NSString *string) {
        return NSLog(@"%@",string);
    };
    
    context[@"setTimeout"] = ^(JSValue* function, JSValue* timeout) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([timeout toInt32] * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
            [function callWithArguments:@[]];
        });
    };
    //------Dart2Js支持------
    
    //------Flutter Bridge------
    
    /**
    * @param channelName 通道名
    * @param methodName 方法名
    * @param params 参数
    * @param function 回调
    */
    context[@"mx_jsbridge_MethodChannel_invokeMethod"] = ^(NSString* channelName, NSString* methodName, JSValue* params, JSValue* function) {
        [self.jsFlutterEngine callFlutterMethodChannelInvoke:channelName methodName:methodName params:[params toObject] callback:^(id  _Nullable result) {
            if (result) {
                [function callWithArguments:@[result]];
            } else {
                [function callWithArguments:@[]];
            }
        }];
    };
    
//    /**
//    * @param channelName 通道名
//    * @param function 回调
//    */
//    context[@"mx_jsbridge_MethodChannel_setMethodCallHandler"] = ^(NSString* channelName, JSValue* function) {
//
//    };
    
    /**
    * @param channelName 通道名
    * @param streamParam receiveBroadcastStream参数
    * @param onData 回调
    * @param onError 回调
    * @param onDone 回调
    * @param cancelOnError 回调
    */
    context[@"mx_jsbridge_EventChannel_receiveBroadcastStream_listen"] = ^(NSString* channelName,
                                                                           NSString* streamParam,
                                                                           JSValue* onData,
                                                                           JSValue* onError,
                                                                           JSValue* onDone,
                                                                           NSNumber* cancelOnError) {
        NSString *onDataId = [self storeJsCallback:onData];
        NSString *onErrorId = [self storeJsCallback:onError];
        NSString *onDoneId = [self storeJsCallback:onDone];

        [self.jsFlutterEngine callFlutterEventChannelReceiveBroadcastStreamListenInvoke:channelName streamParam:streamParam onDataId:onDataId onErrorId:onErrorId onDoneId:onDoneId cancelOnError:cancelOnError];
    };
    //------Flutter Bridge------
}

- (NSString *)storeJsCallback:(JSValue *)function {
    //生成callbackId
    NSString *callbackId = [NSString stringWithFormat:@"jsCallback_%ld", self.jsCallbackCount ++];
    
    //通过JSManagedValue保存，绑定JS生命周期
    JSManagedValue *cacheValue = [JSManagedValue managedValueWithValue:function];
    [[self.jsExecutor.jsContext virtualMachine] addManagedReference:cacheValue withOwner:self];
    
    //存入Cache字典，便于索引
//    [self.jsCallbackCache setObject:cacheValue forKey:callbackId];
    [self.jsCallbackCache setObject:function forKey:callbackId];
    
    return callbackId;
}

- (JSValue *)getJsCallBackWithCallbackId:(NSString *)callbackId {
    if (callbackId.length <= 0) {
        return nil;
    }
    
    //根据callbackId取出对应缓存Callback
//    JSManagedValue *cacheValue = [self.jsCallbackCache objectForKey:callbackId];
//    return [cacheValue value];
    JSValue *function = [self.jsCallbackCache objectForKey:callbackId];
    return function;
}

- (void)callJSCallbackFunction:(NSString *)callbackId param:(id)param {
    JSValue *callback = [self getJsCallBackWithCallbackId:callbackId];
    if (callback) {
        if (param) {
            [callback callWithArguments:@[param]];
        } else {
            [callback callWithArguments:@[]];
        }
    }
}


@end



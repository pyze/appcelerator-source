/**
 * Pyze
 *
 * Created by Your Name
 * Copyright (c) 2018 Your Company. All rights reserved.
 */

#import "TiPyzeModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

#import <UIKit/UIKit.h>
#import <TiModule.h>
#import <objc/runtime.h>



@implementation TiApp (TiPyzeModule)

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)pyze_application:(UIApplication *)application willFinishLaunchingWithOptions:(NSData *)deviceToken
{
    [self pyze_application:application willFinishLaunchingWithOptions:deviceToken];
    [Pyze initializeWithLogLevel:PyzelogLevelAll];
}



+ (void)swizzle {
    
    NSError *error = nil;
    
    NSLog(@"[DEBUG] TiPyzeModule load");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [TiApp class];
        
        SEL originalSelector = @selector(application:willFinishLaunchingWithOptions:);
        SEL swizzledSelector = @selector(pyze_application:willFinishLaunchingWithOptions:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
    
    
}

@end


@implementation TiPyzeModule


#pragma mark Internal

+ (void)load {
    NSError *error = nil;
    [TiApp swizzle];
    if(error)
        NSLog(@"[WARN] Cannot swizzle application:openURL:sourceApplication:annotation: %@", error);
}


// This is generated for your module, please do not change it
- (id)moduleGUID
{
    return @"e8d5e3e2-b516-4b2d-9dcc-eef13c50b88f";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
    return @"ti.pyze";
}


#pragma mark Lifecycle

- (void)startup
{
    // This method is called when the module is first loaded
    // You *must* call the superclass
    [super startup];
    
    DebugLog(@"[DEBUG] %@ loaded", self);
}

#pragma Public APIs

- (NSString *)example:(id)args
{
    // Example method.
    // Call with "MyModule.example(args)"
    return @"hello world";
}

- (NSString *)exampleProp
{
    // Example property getter.
    // Call with "MyModule.exampleProp" or "MyModule.getExampleProp()"
    return @"Titanium rocks!";
}

- (void)setExampleProp:(id)value
{
    // Example property setter.
    // Call with "MyModule.exampleProp = 'newValue'" or "MyModule.setExampleProp('newValue')"
}

#pragma mark - Pyze APIs


- (id) timerReference {
    return NUMDOUBLE([Pyze timerReference]);
}

- (id) getPyzeAppInstanceId {
    return [Pyze getPyzeAppInstanceId];
}

- (void) setRemoteNotificationDeviceToken:(id)arg {
    ENSURE_STRING(arg);
    NSLog(@"[WARN] setRemoteNotificationDeviceToken : %@", arg);
    [Pyze setRemoteNotificationDeviceTokenString:((NSString *)arg)];
}


- (void) processReceivedRemoteNotification:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    NSUInteger count = [args count];
    NSLog(@"[WARN] processReceivedRemoteNotification : %@", args[0]);

    
    if (count > 0){
        NSLog(@"[WARN] processReceivedRemoteNotification : %@", args[0]);
        ENSURE_TYPE(args[0], NSDictionary);
        
        NSDictionary *appcPayload = args[0];
        NSDictionary *payload = appcPayload[@"data"];
        
        [Pyze processReceivedRemoteNotification:payload];
    }
    
}

-(void) processReceivedRemoteNotificationWithActionIdentifier:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    NSUInteger count = [args count];
    
    if (count > 0){
        NSLog(@"[WARN] processReceivedRemoteNotificationWithActionIdentifier");
        ENSURE_TYPE(args[0], NSString);
        ENSURE_TYPE(args[1], NSDictionary);
        
        NSString *identifier = args[0];
        NSDictionary *appcPayload = args[1];
        NSDictionary *payload = appcPayload[@"data"];
        
        
        NSLog(@"[WARN] processReceivedRemoteNotificationWithActionIdentifier : %@, %@", identifier, payload);
        [Pyze processReceivedRemoteNotificationWithId:identifier withUserInfo:payload];
    }
}

- (void) handlePushNotificationAction:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    NSUInteger count = [args count];
    
    if (count > 0){
        NSLog(@"[WARN] handlePushNotificationResponseWithUserinfo");
        ENSURE_TYPE(args[0], NSString);
        ENSURE_TYPE(args[1], NSDictionary);
        
        NSString *identifier = args[0];
        NSDictionary *appcPayload = args[1];
        NSDictionary *payload = appcPayload[@"data"];
        
        
        NSLog(@"[WARN] handlePushNotificationResponseWithUserinfo : %@, %@", identifier, payload);
        [PyzeNotification handlePushNotificationResponseWithUserinfo:payload actionIdentifier:identifier];
    }
}



- (void) showUnreadInAppNotificationUIWithCompletionHandler:(id)args {
    
    ENSURE_ARG_COUNT(args, 1);
    NSUInteger count = [args count];
    NSMutableDictionary *values =  [NSMutableDictionary dictionary];
    
    __block KrollCallback* callback;
    
    NSLog(@"[WARN] showUnreadInAppNotificationUI");
    [Pyze showUnreadInAppNotificationUIWithCompletionHandler:^(PyzeInAppStatus *inAppStatus) {
        
        if (count > 0){
            callback = args[0];
            if (callback) {
                
                [values setObject:NUMINTEGER(inAppStatus.buttonIndex) forKey:@"buttonIndex"];
                [values setObject:inAppStatus.messageID forKey:@"messageID"];
                [values setObject:inAppStatus.campaignID forKey:@"campaignID"];
                [values setObject:inAppStatus.title forKey:@"title"];
                if (inAppStatus.urlString && inAppStatus.urlString.length) {
                    [values setObject:inAppStatus.urlString forKey:@"urlString"];
                }
                
                NSError *error = nil;
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:values options:NSJSONWritingPrettyPrinted error:&error];
                NSLog(@"[WARN : error.description] : %@", error.description);
                NSLog(@"[WARN] : %@", jsonData);

                if (error == nil) {
                    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    NSLog(@"[WARN] : jsonString : %@", jsonString);
                    
                    NSArray* array = [NSArray arrayWithObjects: jsonString, nil];
                    [callback call:array thisObject:nil];
                    NSLog(@"[WARN] Callback called");

                }
                
                
            }
        }
    }];
}


- (void) showInAppNotificationUIForDisplayMessagesWithCustomAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    NSUInteger count = [args count];
    NSMutableDictionary *values =  [NSMutableDictionary dictionary];
    __block KrollCallback* callback;
    
    if (count > 0){
        
        ENSURE_TYPE(args[0], NSNumber);
        PyzeInAppMessageType type = [args[0] integerValue];
        ENSURE_TYPE(args[1], NSString);
        ENSURE_TYPE(args[2], NSString);
        ENSURE_TYPE(args[3], NSString);
        ENSURE_TYPE(args[4], NSString);
        
        UIColor *buttonTextcolor = [TiPyzeModule colorFromHexString:args[1]];
        UIColor *buttonBackgroundColor = [TiPyzeModule colorFromHexString:args[2]];
        UIColor *backgroundColor = [TiPyzeModule colorFromHexString:args[3]];
        UIColor *messageCounterTextColor = [TiPyzeModule colorFromHexString:args[4]];
        
        
        [Pyze showInAppNotificationUIForDisplayMessages:type
                              msgNavBarButtonsTextColor:buttonTextcolor
                                msgNavBarButtonsBgColor:buttonBackgroundColor
                                       msgNavBarBgColor:backgroundColor
                              msgNavBarCounterTextColor:messageCounterTextColor
                                  withCompletionHandler:^(PyzeInAppStatus *inAppStatus) {
                                      
                                      callback = args[5];
                                      if (callback) {
                                          
                                          [values setObject:NUMINTEGER(inAppStatus.buttonIndex) forKey:@"buttonIndex"];
                                          
                                          if (inAppStatus.messageID && inAppStatus.messageID.length) {
                                              [values setObject:inAppStatus.messageID forKey:@"messageID"];
                                          }
                                          
                                          if (inAppStatus.campaignID && inAppStatus.campaignID.length) {
                                              [values setObject:inAppStatus.campaignID forKey:@"campaignID"];
                                          }
                                          
                                          if (inAppStatus.title && inAppStatus.title.length) {
                                              [values setObject:inAppStatus.title forKey:@"title"];
                                          }
                                          if (inAppStatus.urlString && inAppStatus.urlString.length) {
                                              [values setObject:inAppStatus.urlString forKey:@"urlString"];
                                          }
                                          
                                          NSError *error = nil;
                                          NSData *jsonData = [NSJSONSerialization dataWithJSONObject:values options:NSJSONWritingPrettyPrinted error:&error];
                                          NSLog(@"[WARN : error.description] : %@", error.description);
                                          NSLog(@"[WARN] : %@", jsonData);
                                          
                                          if (error == nil) {
                                              NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                              NSLog(@"[WARN] : jsonString : %@", jsonString);
                                              
                                              NSArray* array = [NSArray arrayWithObjects: jsonString, nil];
                                              [callback call:array thisObject:nil];
                                              NSLog(@"[WARN] Callback called");
                                              
                                          }
                                          
                                          
                                      }
                                  }];
    }
}


- (void) dismissInAppNotificationUI:(id)arg {
    ENSURE_ARG_COUNT(arg, 1);
    BOOL animted = NUMBOOL(arg);
    [Pyze dismissInAppNotificationUI:animted];
}

- (void) getMessagesForType:(id) args {
    ENSURE_ARG_COUNT(args, 2);
    NSUInteger count = [args count];
    NSMutableArray *values =  [NSMutableArray array];
    __block KrollCallback* callback;
    
    NSLog(@"[WARN] getMessagesForType");

    if (count > 0){
        
        ENSURE_TYPE(args[0], NSNumber);
        PyzeInAppMessageType type = [args[0] integerValue];
        
        
        [Pyze getMessagesForType:type withCompletionHandler:^(NSArray *result) {
            if (result != nil) {
                callback = args[1];
                if (callback) {
                    
                    NSLog(@"[WARN] Messages : %@", result);
                    
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&error];

                    if (error == nil) {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"[WARN] : jsonString : %@", jsonString);
                        
                        NSArray* array = [NSArray arrayWithObjects: jsonString, nil];
                        [callback call:array thisObject:nil];
                        NSLog(@"[WARN] Callback called");
                        
                    }                }
            }
        }];
        
    }
}


- (void) getMessagesHeadersForType:(id) args {
    ENSURE_ARG_COUNT(args, 2);
    NSUInteger count = [args count];
    NSMutableDictionary *values =  [NSMutableDictionary dictionary];
    __block KrollCallback* callback;
    
    NSLog(@"[WARN] getMessagesHeadersForType");
    
    if (count > 0){
        
        ENSURE_TYPE(args[0], NSNumber);
        PyzeInAppMessageType type = [args[0] integerValue];
        
        [Pyze getMessageHeadersForType:type withCompletionHandler:^(NSArray *result) {
            if (result != nil) {
                callback = args[1];
                if (callback) {
                    
                    NSLog(@"[WARN] Messages : %@", result);
                    
                    NSError *error = nil;
                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&error];
                    
                    if (error == nil) {
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        NSLog(@"[WARN] : jsonString : %@", jsonString);
                        
                        NSArray* array = [NSArray arrayWithObjects: jsonString, nil];
                        [callback call:array thisObject:nil];
                        NSLog(@"[WARN] Callback called");
                        
                    }                }
            }
        }];
    }
}

- (void) countNewUnfetched:(id) args {

    ENSURE_ARG_COUNT(args, 1);
    NSUInteger count = [args count];
    NSMutableDictionary *values =  [NSMutableDictionary dictionary];
    __block KrollCallback* callback;

    NSLog(@"[WARN] countNewUnfetched");


    [Pyze countNewUnFetched:^(NSInteger count) {
        callback = args[0];
        if (callback) {
            NSArray* array = [NSArray arrayWithObjects: [NSNumber numberWithInteger:count], nil];
            [callback call:array thisObject:nil];
            NSLog(@"[WARN] Callback called");
        }
    }];
    
}

//------------------------------------------------------------------------------------*****
//*****------------------------------------------------------------------------------------





#pragma mark - PyzePersonalizationIntelligence

- (void) getTags:(id)args    {
    ENSURE_ARG_COUNT(args, 1);
    NSUInteger count = [args count];
    
    __block KrollCallback* callback;
    if (count > 0){
        
        [PyzePersonalizationIntelligence getTags:^(NSArray *tagsList) {
            callback = args[0];
            if (callback) {
                [callback call:tagsList thisObject:callback];
                NSLog(@"[WARN] Callback called");
            }
        }];
    }
}

// not tested

-(BOOL) isTagSet:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *tag = args[0];
    BOOL isSet = [PyzePersonalizationIntelligence isTagSet:tag];
    return NUMBOOL(isSet);
}


-(BOOL) areAnyTagsSet:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSArray);
    NSArray *tagList = args[0];
    BOOL isSet = [PyzePersonalizationIntelligence areAnyTagsSet:tagList];
    return NUMBOOL(isSet);
}


- (BOOL) areAllTagsSet:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSArray);
    NSArray *tagList = args[0];
    BOOL isSet = [PyzePersonalizationIntelligence areAnyTagsSet:tagList];
    return NUMBOOL(isSet);
}

#pragma mark - PyzeAttribution


- (void) postAppsFlyerAttribution:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAttribution postAppsFlyerAttribution:attributes];
}
// TODO: In-app completion and push need to be completed.


#pragma mark - ------ EVENTS -----

#pragma mark - PyzeCustomEvent

- (void) postCustomEventWithAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    
    ENSURE_TYPE(args[0], NSString);
    NSString *eventName = args[0];
    
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCustomEvent postWithEventName:eventName withAttributes:attributes];
}


- (void) postCustomEvent:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *eventName = args[0];
    [PyzeCustomEvent postWithEventName:eventName];
}

- (void) postTimedEventWithNameAndTimerReference:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *eventName = args[0];
    
    ENSURE_TYPE(args[1], NSNumber);
    double timerRef = [args[1] doubleValue];
    [PyzeCustomEvent postTimedWithEventName:eventName withTimerReference:timerRef];
}

- (void) postTimedEventWithNameTimerReferenceAndAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *eventName = args[0];
    
    ENSURE_TYPE(args[1], NSNumber);
    double timerRef = [args[1] doubleValue];
    
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    [PyzeCustomEvent postTimedWithEventName:eventName withTimerReference:timerRef withAttributes:attributes];
}
#pragma mark - Pyze  Explicit Activation

- (void) postExplicitActivation {
    [PyzeExplicitActivation post];
}

- (void) postExplicitActivationWithAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeExplicitActivation post:attributes];
}


#pragma mark - Pyze Account

- (void) postLoginOfferedWithAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAccount postLoginOffered:attributes];
}

- (void) postLoginStartedWithAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAccount postLoginStarted:attributes];
}

- (void) postRegistrationOfferedWithAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAccount postRegistrationOffered:attributes];
}

- (void) postRegistrationStartedWithAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAccount postRegistrationStarted:attributes];
}

- (void) postRegistrationCompletedWithAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAccount postRegistrationCompleted:attributes];
}

- (void) postSocialLoginOfferedWithTypeAndAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *type = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    [PyzeAccount postSocialLoginOffered:type withAttributes:attributes];
}

- (void) postSocialLoginStartedWithTypeAndAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *type = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    [PyzeAccount postSocialLoginStarted:type withAttributes:attributes];
}

- (void) postSocialLoginCompletedWithTypeAndAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *type = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    [PyzeAccount postSocialLoginCompleted:type withAttributes:attributes];
}


- (void) postLoginCompletedWithSuccessStatusErrorCodeAndAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSNumber);
    BOOL success = [args[0] boolValue];
    ENSURE_TYPE(args[1], NSString);
    NSString *errorCode = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    [PyzeAccount postLoginCompleted:success withErrCode:errorCode withAttributes:attributes];
}

- (void) postLogoutCompletedWithSuccessStatusAndAttributes:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSNumber);
    BOOL success = [args[0] boolValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    [PyzeAccount postLogoutCompleted:success withAttributes:attributes];
}

- (void) postPasswordResetRequested:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAccount postPasswordResetRequested:attributes];
}

- (void) postPasswordResetCompleted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAccount postPasswordResetCompleted:attributes];
}


#pragma mark - PyzeIdentity

- (void) setUserIdentifer:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueId = args[0];
    [PyzeIdentity setUserIdentifer:uniqueId];
}

- (void) resetUserIdentifer {
    [PyzeIdentity resetUserIdentifer];
}

- (void) postIdentityTraits:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *traitsDict = args[0];
    [PyzeIdentity postTraits:traitsDict];
}

#pragma mark - PyzeAd

- (void) postAdRequested:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSString *adNetwork = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *appScreen = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *size = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *type = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeAd postAdRequested:adNetwork fromAppScreen:appScreen withAdSize:size adType:type withAttributes:attributes];
}

- (void) postAdReceived:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSString *adNetwork = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *appScreen = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *resultCode = args[2];
    ENSURE_TYPE(args[3], NSString);
    BOOL success = [args[3] boolValue];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeAd postAdReceived:adNetwork fromAppScreen:appScreen withResultCode:resultCode isSuccess:success withAttributes:attributes];
}

- (void) postAdClicked:(id)args {
    ENSURE_ARG_COUNT(args, 6);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSString *adNetwork = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *appScreen = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *adCode = args[2];
    ENSURE_TYPE(args[3], NSString);
    BOOL success = [args[3] boolValue];
    ENSURE_TYPE(args[4], NSString);
    NSString *errorCode = args[4];
    ENSURE_TYPE(args[5], NSDictionary);
    NSDictionary *attributes = args[5];
    
    [PyzeAd postAdClicked:adNetwork fromAppScreen:appScreen adCode:adCode isSuccess:success withErrorCode:errorCode withAttributes:attributes];
}

#pragma mark - PyzeAdvocacy


- (void) postRequestForFeedback:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAdvocacy postRequestForFeedback:attributes];
}

- (void) postFeedbackProvided:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAdvocacy postFeedbackProvided:attributes];
}

- (void) postRequestRating:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeAdvocacy postRequestRating:attributes];
}

#pragma mark - PyzeSupport


- (void) postRequestedPhoneCallback:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    [PyzeSupport postRequestedPhoneCallback:attributes];
}

- (void) postLiveChatStartedWithTopic:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *topic = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    [PyzeSupport postLiveChatStartedWithTopic:topic withAttributes:attributes];
}

- (void) postLiveChatEndedWithTopic:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *topic = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    [PyzeSupport postLiveChatEndedWithTopic:topic withAttributes:attributes];
}

- (void) postTicketCreated:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *itemId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *topic = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    [PyzeSupport postTicketCreated:itemId withTopic:topic withAttributes:attributes];
}

- (void) postFeedbackReceived:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *feedback = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    [PyzeSupport postFeedbackReceived:feedback withAttributes:attributes];
}


- (void) postQualityOfServiceRated:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *coment = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *rating = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    [PyzeSupport postQualityOfServiceRated:coment rateOn5Scale:rating withAttributes:attributes];
}


#pragma mark - PyzeCommerceSupport

- (void) postCommerceSupportLiveChatStarted:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *topic = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *orderNumber = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceSupport postLiveChatStartedWithTopic:topic withOrderNumber:orderNumber withAttributes:attributes];
}

- (void) postCommerceSupportLiveChatEnded:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *topic = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *orderNumber = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceSupport postLiveChatEndedWithTopic:topic withOrderNumber:orderNumber withAttributes:attributes];
}

- (void) postCommerceSupportTicketCreated:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *itemID = args[0];
    ENSURE_TYPE(args[1], NSNumber);
    NSString *topic = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *orderNumber = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceSupport postTicketCreated:itemID withTopic:topic withOrderNumber:orderNumber withAttributes:attributes];
}

- (void) postCommerceSupportFeedbackReceived:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *feedback = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *orderNumber = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceSupport postFeedbackReceived:feedback withOrderNumber:orderNumber withAttributes:attributes];
}

- (void) postCommerceSupportQualityOfServiceRated:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *comment = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *orderNumber = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *rating = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceSupport postQualityOfServiceRated:comment withOrderNumber:orderNumber rateOn5Scale:rating withAttributes:attributes];
}

#pragma mark - PyzeCommerceDiscovery

- (void) postSearched:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *searchString = args[0];
    ENSURE_TYPE(args[1], NSNumber);
    NSNumber *latency = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceDiscovery postSearched:searchString withLatency:latency withAttributes:attributes];
}

- (void) postBrowsedCategory:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *category = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceDiscovery postBrowsedCategory:category withAttributes:attributes];
}

- (void) postBrowsedDeals:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueDealID = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceDiscovery postBrowsedDeals:uniqueDealID withAttributes:attributes];
}

- (void) postBrowsedRecommendations:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueRecommendationID = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceDiscovery postBrowsedRecommendations:uniqueRecommendationID withAttributes:attributes];
}

- (void) postBrowsedPrevOrders:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *rangeStart = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *rangeEnd = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceDiscovery postBrowsedPrevOrders:rangeStart withEnd:rangeEnd withAttributes:attributes];
}

#pragma mark - PyzeCommerceCuratedList

- (void) postCommerceCuratedListCreated:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueCuratedListID = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *curatedListType = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceCuratedList postCreated:uniqueCuratedListID withType:curatedListType withAttributes:attributes];
}

- (void) postCommerceCuratedListBrowsed:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *curatedList = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *curatedListCreator = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceCuratedList postBrowsed:curatedList withCreator:curatedListCreator withAttributes:attributes];
}

- (void) postCommerceCuratedListAddedItem:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueCuratedListId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemID = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceCuratedList postAddedItem:uniqueCuratedListId withCategory:itemCategory withItemId:itemID withAttributes:attributes];
}

- (void) postCommerceCuratedListRemovedItem:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueCuratedListId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *curatedListType = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemID = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceCuratedList postRemovedItem:uniqueCuratedListId withListType:curatedListType withItemID:itemID withAttributes:attributes];
}

- (void) postCommerceCuratedListShared:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *curatedList = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *curatedListCreator = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceCuratedList postShared:curatedList withCreator:curatedListCreator withAttributes:attributes];
}

- (void) postCommerceCuratedListPublished:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *curatedList = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *curatedListCreator = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceCuratedList postPublished:curatedList withCreator:curatedListCreator withAttributes:attributes];
}



#pragma mark - PyzeCommerceWishList

- (void) postCommerceWishListCreated:(id)args {
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueWishListId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *wishListtype = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceWishList postCreated:uniqueWishListId withWishListType:wishListtype withAttributes:attributes];
}

- (void) postCommerceWishListBrowsed:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueWishListId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceWishList postBrowsed:uniqueWishListId withAttributes:attributes];
}


- (void) postCommerceWishListAddedItem:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueWishListId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceWishList postAddedItem:uniqueWishListId withItemCategory:itemCategory withItemId:itemId withAttributes:attributes];
}


- (void) postCommerceWishListRemovedItem:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueWishListId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceWishList postRemovedItem:uniqueWishListId withItemCategory:itemCategory withItemId:itemId withAttributes:attributes];
}

- (void) postCommerceWishListShared:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueWishListId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceWishList postShared:uniqueWishListId withAttributes:attributes];
}

#pragma mark - PyzeCommerceBeacon


- (void) postCommerceBeaconEnteredRegion:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *iBeaconUUID = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *iBeaconMajor = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *iBeaconMinor = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueRegionIdentifier = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceBeacon postEnteredRegion:iBeaconUUID withBeaconMajor:iBeaconMajor withBeaconMinor:iBeaconMinor withUniqueRegionIdentifier:uniqueRegionIdentifier withAttributes:attributes];
}


- (void) postCommerceBeaconExitedRegion:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *iBeaconUUID = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *iBeaconMajor = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *iBeaconMinor = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueRegionIdentifier = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceBeacon postExitedRegion:iBeaconUUID withBeaconMajor:iBeaconMajor withBeaconMinor:iBeaconMinor withUniqueRegionIdentifier:uniqueRegionIdentifier withAttributes:attributes];
}


- (void) postCommerceBeaconTransactedInRegion:(id)args {
    ENSURE_ARG_COUNT(args, 7);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *iBeaconUUID = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *iBeaconMajor = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *iBeaconMinor = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueRegionIdentifier = args[3];
    ENSURE_TYPE(args[4], NSString);
    NSString *proximity = args[4];
    ENSURE_TYPE(args[5], NSString);
    NSString *actionId = args[5];
    ENSURE_TYPE(args[6], NSDictionary);
    NSDictionary *attributes = args[6];
    
    [PyzeCommerceBeacon postTransactedInRegion:iBeaconUUID withBeaconMajor:iBeaconMajor withBeaconMinor:iBeaconMinor withUniqueRegionIdentifier:uniqueRegionIdentifier withProximity:proximity withActionId:actionId withAttributes:attributes];
}

#pragma mark - PyzeCommerceCart

- (void) postCommerceCartAddItem:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceCart postAddItem:cartId withItemCategory:itemCategory withItemId:itemId withAttributes:attributes];
}

- (void) postCommerceCartAddItemFromDeals:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueDealId = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceCart postAddItemFromDeals:cartId withItemCategory:itemCategory withItemId:itemId withUniqueDealId:uniqueDealId withAttributes:attributes];
}

- (void) postCommerceCartAddItemFromWishList:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueWishListId = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceCart postAddItemFromWishList:cartId withItemCategory:itemCategory withItemId:itemId withUniqueWishListId:uniqueWishListId withAttributes:attributes];
}

- (void) postCommerceCartAddItemFromCuratedList:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueCuratedListId = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceCart postAddItemFromCuratedList:cartId withItemCategory:itemCategory withItemId:itemId withUniqueCuratedListId:uniqueCuratedListId withAttributes:attributes];
}

- (void) postCommerceCartAddItemFromRecommendations:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueRecommendationId = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceCart postAddItemFromRecommendations:cartId withItemCategory:itemCategory withItemId:itemId withUniqueRecommendationId:uniqueRecommendationId withAttributes:attributes];
}

- (void) postCommerceCartAddItemFromPreviousOrders:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *previousOrderId = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceCart postAddItemFromPreviousOrders:cartId withItemCategory:itemCategory withItemId:itemId withPreviousOrderId:previousOrderId withAttributes:attributes];
}

- (void) postCommerceCartAddItemFromSearchResults:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *searchString = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceCart postAddItemFromSearchResults:cartId withItemCategory:itemCategory withItemId:itemId withSearchString:searchString withAttributes:attributes];
}

- (void) postCommerceCartAddItemFromSubscriptionList:(id)args {
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *uniqueDealId = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeCommerceCart postAddItemFromSubscriptionList:cartId withItemCategory:itemCategory withItemId:itemId withUniqueDealId:uniqueDealId withAttributes:attributes];
}


- (void) postCommerceCartRemoveItemFromCart:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemCategory = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceCart postRemoveItemFromCart:cartId withItemCategory:itemCategory withItemId:itemId withAttributes:attributes];
}


- (void) postCommerceCartView:(id)args {
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceCart postView:cartId withAttributes:attributes];
}

- (void) postCommerceCartShare:(id)args {
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *cartId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *shareWith = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSString *itemId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeCommerceCart postShare:cartId withItemSharedWith:shareWith withItemId:itemId withAttributes:attributes];
}

#pragma mark - PyzeCommerceItem

- (void) postViewedItem:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceItem postViewedItem:attributes];
}

- (void) postScannedItem:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceItem postScannedItem:attributes];
}


- (void) postViewedReviews:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceItem postViewedReviews:attributes];
}

- (void) postViewedDetails:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceItem postViewedDetails:attributes];
}


- (void) postViewedPrice:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceItem postViewedPrice:attributes];
}


- (void) postItemShareItem:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceItem postItemShareItem:attributes];
}

- (void) postItemRateOn5Scale:(id)args {
    
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *itemSKU = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *rating = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceItem postItemRateOn5Scale:itemSKU withRating:rating withAttributes:attributes];
}

#pragma mark - PyzeCommerceCheckout

- (void) postCheckoutStarted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceCheckout postCheckoutStarted:attributes];
}

- (void) postCheckoutCompleted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceCheckout postCheckoutCompleted:attributes];
}

- (void) postCheckoutAbandoned:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceCheckout postCheckoutAbandoned:attributes];
}

- (void) postCheckoutFailed:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceCheckout postCheckoutFailed:attributes];
}


#pragma mark - PyzeCommerceShipping

- (void) postShippingStarted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceShipping postShippingStarted:attributes];
}

- (void) postShippingCompleted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceShipping postShippingCompleted:attributes];
}

- (void) postShippingAbandoned:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceShipping postShippingAbandoned:attributes];
}

- (void) postShippingFailed:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceShipping postShippingFailed:attributes];
}

#pragma mark - PyzeCommerceBilling

- (void) postBillingStarted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceBilling postBillingStarted:attributes];
}

- (void) postBillingCompleted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceBilling postBillingCompleted:attributes];
}

- (void) postBillingAbandoned:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceBilling postBillingAbandoned:attributes];
}

- (void) postBillingFailed:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommerceBilling postBillingFailed:attributes];
}

#pragma mark - PyzeCommercePayment

- (void) postPaymentStarted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommercePayment postPaymentStarted:attributes];
}

- (void) postPaymentCompleted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommercePayment postPaymentCompleted:attributes];
}

- (void) postPaymentAbandoned:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommercePayment postPaymentAbandoned:attributes];
}

- (void) postPaymentFailed:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeCommercePayment postPaymentFailed:attributes];
}


#pragma mark - PyzeCommerceRevenue

- (void) postRevenue:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSNumber *revenue = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceRevenue postRevenue:revenue withAttributes:attributes];
}

- (void) postRevenueUsingApplePay:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSNumber *revenue = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceRevenue postRevenueUsingApplePay:revenue withAttributes:attributes];
}

- (void) postRevenueUsingSamsungPay:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSNumber *revenue = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceRevenue postRevenueUsingSamsungPay:revenue withAttributes:attributes];
}


- (void) postRevenueUsingGooglePay:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSNumber *revenue = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeCommerceRevenue postRevenueUsingGooglePay:revenue withAttributes:attributes];
}

- (void) postRevenueWithPaymentInstrument:(id)args {
    
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSNumber);
    NSNumber *revenue = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *paymentInstrument = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeCommerceRevenue postRevenue:revenue withPaymentInstrument:paymentInstrument withAttributes:attributes];
}


#pragma mark - PyzeGaming


- (void) postGamingLevelStarted:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *level = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeGaming postLevelStarted:level withAttributes:attributes];
}

- (void) postGamingLevelEnded:(id)args {
    
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *level = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *score = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *success = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeGaming postLevelEnded:level withScore:score withSuccessOrFailure:success withAttributes:attributes];
}


- (void) postPowerUpConsumed:(id)args {
    
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *level = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *type = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *value = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeGaming postPowerUpConsumed:level withType:type withValue:value withAttributes:attributes];
}

- (void) postInGameItemPurchased:(id)args {
    
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueItemId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *itemType = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *value = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeGaming postInGameItemPurchased:uniqueItemId withItemType:itemType withItemValue:value withAttributes:attributes];
}

- (void) postAchievementEarned:(id)args {
    
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueAchievementId = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *type = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeGaming postAchievementEarned:uniqueAchievementId withType:type withAttributes:attributes];
}


- (void) postSummaryViewed:(id)args {
    
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *level = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *score = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeGaming postSummaryViewed:level withScore:score withAttributes:attributes];
}

- (void) postLeaderBoardViewed:(id)args {
    
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *level = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *score = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeGaming postLeaderBoardViewed:level withScore:score withAttributes:attributes];
}


- (void) postScorecardViewed:(id)args {
    
    ENSURE_ARG_COUNT(args, 3);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *level = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *score = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeGaming postScorecardViewed:level withScore:score withAttributes:attributes];
}

- (void) postHelpViewed:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *helpTopicId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeGaming postHelpViewed:helpTopicId withAttributes:attributes];
}


- (void) postTutorialViewed:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *helpTopicId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeGaming postTutorialViewed:helpTopicId withAttributes:attributes];
}


- (void) postFriendChallenged:(id)args {
    
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeGaming postFriendChallenged:attributes];
}


- (void) postChallengeAccepted:(id)args {
    
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeGaming postChallengeAccepted:attributes];
}

- (void) postChallengeDeclined:(id)args {
    
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeGaming postChallengeDeclined:attributes];
}

- (void) postGameStart:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *level = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeGaming postGameStart:level withAttributes:attributes];
}


- (void) postGameEnd:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *levelsPlayed = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *levelsWon = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeGaming postGameEnd:levelsPlayed withLevelsWon:levelsWon withAttributes:attributes];
}

#pragma mark - PyzeSceneFlow

- (void) postSecondsOnScene:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *sceneName = args[0];
    ENSURE_TYPE(args[1], NSNumber);
    double seconds = [args[1] doubleValue];
    
    [PyzeSceneFlow postSecondsOnScene:sceneName forSeconds:seconds];
}

#pragma mark - PyzeHealthAndFitness

- (void) postStarted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeHealthAndFitness postStarted:attributes];
}

- (void) postEnded:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeHealthAndFitness postEnded:attributes];
}

- (void) postAchievementReceived:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeHealthAndFitness postAchievementReceived:attributes];
}

- (void) postStepGoalCompleted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeHealthAndFitness postStepGoalCompleted:attributes];
}

- (void) postGoalCompleted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeHealthAndFitness postGoalCompleted:attributes];
}


- (void) postHealthAndFitnessChallengedFriend:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeHealthAndFitness postChallengedFriend:attributes];
}


- (void) postHealthAndFitnessChallengeAccepted:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeHealthAndFitness postChallengeAccepted:attributes];
}

#pragma mark - PyzeContent

- (void) postViewed:(id)args {
    
    ENSURE_ARG_COUNT(args, 4);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *categoryName = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *contentId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeContent postViewed:contentName category:categoryName withUniqueContentId:contentId withAttributes:attributes];
}

- (void) postContentSearched:(id)args {
    
    ENSURE_ARG_COUNT(args, 2);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *searchString = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeContent postSearched:searchString withAttributes:attributes];
}

- (void) postContentRatedOn5PointScale:(id)args {
    
    ENSURE_ARG_COUNT(args, 5);
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *categoryName = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *contentId = args[2];
    ENSURE_TYPE(args[3], NSDecimalNumber);
    NSDecimalNumber *rating = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeContent postRatedOn5PointScale:contentName category:categoryName withUniqueContentId:contentId contentRating:rating withAttributes:attributes];
}

- (void) postContentRatedThumbsUp:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *categoryName = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *contentId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeContent postRatedThumbsUp:contentName category:categoryName withUniqueContentId:contentId withAttributes:attributes];
}

- (void) postContentRatedThumbsDown:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *categoryName = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *contentId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeContent postRatedThumbsDown:contentName category:categoryName withUniqueContentId:contentId withAttributes:attributes];
}

#pragma mark - PyzeMessaging

- (void) postMessageSent:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeMessaging postMessageSent:uniqueId withAttributes:attributes];
}

- (void) postMessageSentOfType:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger *messageType = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSString);
    NSString *uniqueId = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeMessaging postMessageSentOfType:messageType withUniqueId:uniqueId withAttributes:attributes];
}

- (void) postMessageReceived:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeMessaging postMessageReceived:uniqueId withAttributes:attributes];
}

- (void) postMessageRecievedOfType:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger *messageType = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSString);
    NSString *uniqueId = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeMessaging postMessageReceivedOfType:messageType withUniqueId:uniqueId withAttributes:attributes];
}

- (void) postMessageNewConversation:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeMessaging postMessageNewConversation:uniqueId withAttributes:attributes];
}


- (void) postMessageVoiceCall:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeMessaging postMessageVoiceCall:uniqueId withAttributes:attributes];
}

#pragma mark - PyzeSMS


- (void) postRegisteredDevice:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *phoneNumber = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *countryCode = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeSMS postRegisteredDevice:phoneNumber withCountryCode:countryCode withAttributes:attributes];
}

- (void) postVerification:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *phoneNumber = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *verificationCode = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *countryCode = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeSMS postVerification:phoneNumber withVerificationCode:verificationCode withCountryCode:countryCode withAttributes:attributes];
}

- (void) postUnsubscribeDevice:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *phoneNumber = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *countryCode = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeSMS postUnsubscribeDevice:phoneNumber withCountryCode:countryCode withAttributes:attributes];
}


#pragma mark - PyzeTasks

- (void) addToCalendarwithAttributes:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeTasks addToCalendarwithAttributes:attributes];
}

#pragma mark - PyzeSocial

- (void) postSocialContentShare:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *socialNetworkName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *contentReference = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *category = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeSocial postSocialContentShareForNetworkName:socialNetworkName forContentReference:contentReference category:category withAttributes:attributes];
}


- (void) postLiked:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *socialNetworkName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *contentReference = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *category = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeSocial postLiked:socialNetworkName forContentReference:contentReference category:category withAttributes:attributes];
}


- (void) postFollowed:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *socialNetworkName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *contentReference = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *category = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeSocial postFollowed:socialNetworkName forContentReference:contentReference category:category withAttributes:attributes];
}

- (void) postSubscribed:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *socialNetworkName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *contentReference = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *category = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeSocial postSubscribed:socialNetworkName forContentReference:contentReference category:category withAttributes:attributes];
}

- (void) postInvitedFriend:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *socialNetworkName = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeSocial postInvitedFriend:socialNetworkName withAttributes:attributes];
}

- (void) postFoundFriends:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *source = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeSocial postFoundFriends:source withAtrributes:attributes];
}


#pragma mark - PyzeMedia

- (void) postPlayedMedia:(id)args {
    
    ENSURE_ARG_COUNT(args, 6)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *type = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *categoryName = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *percent = args[3];
    ENSURE_TYPE(args[4], NSString);
    NSString *contentId = args[4];
    ENSURE_TYPE(args[5], NSDictionary);
    NSDictionary *attributes = args[5];
    
    [PyzeMedia postPlayedMedia:contentName mediaType:type category:categoryName percentPlayed:percent withUniqueContentId:contentId withAttributes:attributes];
}

- (void) postMediaSearched:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *searchString = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeMedia postSearched:searchString withAttributes:attributes];
}

- (void) postMediaRatedOn5PointScale:(id)args {
    
    ENSURE_ARG_COUNT(args, 5)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *categoryName = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *mediaId = args[2];
    ENSURE_TYPE(args[3], NSDecimalNumber);
    NSDecimalNumber *rating = args[3];
    ENSURE_TYPE(args[4], NSDictionary);
    NSDictionary *attributes = args[4];
    
    [PyzeMedia postRatedOn5PointScale:contentName category:categoryName withUniqueContentId:mediaId contentRating:rating withAttributes:attributes];
}


- (void) postMediaRatedThumbsUp:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *categoryName = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *contentId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeMedia postRatedThumbsUp:contentName category:categoryName withUniqueContentId:contentId withAttributes:attributes];
}

- (void) postMediaRatedThumbsDown:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *contentName = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *categoryName = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *contentId = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeMedia postRatedThumbsDown:contentName category:categoryName withUniqueContentId:contentId withAttributes:attributes];
}

#pragma mark - PyzeInAppPurchaseRevenue

- (void) postPriceListViewed:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *postPriceListViewViewed = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeInAppPurchaseRevenue postPriceListViewViewed:postPriceListViewViewed withAttributes:attributes];
}


- (void) postBuyItem:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *itemName = args[0];
    ENSURE_TYPE(args[1], NSDecimalNumber);
    NSDecimalNumber *revenue = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *currencyISO4217Code = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeInAppPurchaseRevenue postBuyItem:itemName price:revenue currency:currencyISO4217Code withAttributes:attributes];
}


- (void) postBuyItemInUSD:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *itemName = args[0];
    ENSURE_TYPE(args[1], NSDecimalNumber);
    NSDecimalNumber *revenue = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeInAppPurchaseRevenue postBuyItemInUSD:itemName price:revenue withAttributes:attributes];
}


- (void) postBuyItemWithCustomAttributes:(id)args {
    
    ENSURE_ARG_COUNT(args, 10)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *itemName = args[0];
    ENSURE_TYPE(args[1], NSDecimalNumber);
    NSDecimalNumber *revenue = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *currencyISO4217Code = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *itemType = args[3];
    ENSURE_TYPE(args[4], NSString);
    NSString *itemSKU = args[4];
    ENSURE_TYPE(args[5], NSString);
    NSString *quantity = args[5];
    ENSURE_TYPE(args[6], NSString);
    NSString *appScreenRequestFromId = args[6];
    ENSURE_TYPE(args[7], NSNumber);
    BOOL success = [args[7] boolValue];
    ENSURE_TYPE(args[8], NSString);
    NSString *successOrErrorCode = args[8];
    ENSURE_TYPE(args[9], NSDictionary);
    NSDictionary *attributes = args[9];
    
    [PyzeInAppPurchaseRevenue postBuyItem:itemName price:revenue currency:currencyISO4217Code itemType:itemType itemSKU:itemSKU quantity:quantity requestId:appScreenRequestFromId status:success successCode:successOrErrorCode withAttributes:attributes];
}

#pragma mark - PyzeBitcoin

- (void) postSentBitcoins:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeBitcoin postSentBitcoins:attributes];
}

- (void) postRequestedBitcoins:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeBitcoin postRequestedBitcoins:attributes];
}

- (void) postReceivedBitcoins:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeBitcoin postReceivedBitcoins:attributes];
}

- (void) postViewedTransactions:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeBitcoin postViewedTransactions:attributes];
}

- (void) postImportedPrivateKey:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeBitcoin postImportedPrivateKey:attributes];
}

- (void) postScannedPrivateKey:(id)args {
    ENSURE_ARG_COUNT(args, 1);
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeBitcoin postScannedPrivateKey:attributes];
}


#pragma mark - PyzeDrone

- (void) postPreflightCheckCompleted:(id)args {
    
    ENSURE_ARG_COUNT(args, 7)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *overallStatus = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *storageStatus = args[1];
    ENSURE_TYPE(args[2], NSNumber);
    NSInteger droneBatteryChargePercent = [args[2] integerValue];
    ENSURE_TYPE(args[3], NSString);
    NSInteger deviceBatteryChargePercent = [args[3] integerValue];
    ENSURE_TYPE(args[4], NSString);
    NSString *calibrationStatus = args[4];
    ENSURE_TYPE(args[5], NSString);
    NSString *gpsStatus = args[5];
    ENSURE_TYPE(args[6], NSDictionary);
    NSDictionary *attributes = args[6];
    
    [PyzeDrone postPreflightCheckCompleted:overallStatus withStorageStatus:storageStatus withDroneBattery:droneBatteryChargePercent withTransmitterBattery:deviceBatteryChargePercent withCalibrationStatus:calibrationStatus withGPSStatus:gpsStatus withAttributes:attributes];
}


- (void) postInflightCheckCompleted:(id)args {
    
    ENSURE_ARG_COUNT(args, 7)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *overallStatus = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *rollStatus = args[1];
    ENSURE_TYPE(args[2], NSString);
    NSString *pitchStatus = args[2];
    ENSURE_TYPE(args[3], NSString);
    NSString *yawStatus = args[3];
    ENSURE_TYPE(args[4], NSString);
    NSString *throttleStatus = args[4];
    ENSURE_TYPE(args[5], NSString);
    NSString *trimmingSettings = args[5];
    ENSURE_TYPE(args[6], NSDictionary);
    NSDictionary *attributes = args[6];
    
    [PyzeDrone postInflightCheckCompleted:overallStatus withRoll:rollStatus withPitch:pitchStatus withYaw:yawStatus withThrottle:throttleStatus withTrim:trimmingSettings withAttributes:attributes];
}

- (void) postConnected:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeDrone postConnected:attributes];
}

- (void) postDisconnected:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *code = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postDisconnected:code withAttributes:attributes];
}

- (void) postAirborne:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postAirborne:status withAttributes:attributes];
}

- (void) postLanded:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postLanded:status withAttributes:attributes];
}

- (void) postFlightPathCreated:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueFlightPathId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postFlightPathCreated:uniqueFlightPathId withAttributes:attributes];
}

- (void) postFlightPathUploaded:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueFlightPathId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postFlightPathUploaded:uniqueFlightPathId withAttributes:attributes];
}

- (void) postFlightPathEdited:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueFlightPathId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postFlightPathEdited:uniqueFlightPathId withAttributes:attributes];
}

- (void) postFlightPathDeleted:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueFlightPathId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postFlightPathDeleted:uniqueFlightPathId withAttributes:attributes];
}

- (void) postFlightPathCompleted:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *uniqueFlightPathId = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postFlightPathCompleted:uniqueFlightPathId withAttributes:attributes];
}


- (void) postFirstPersonViewEnabled:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postFirstPersonViewEnabled:status withAttributes:attributes];
}


- (void) postFirstPersonViewDisabled:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postFirstPersonViewDisabled:status withAttributes:attributes];
}

- (void) postStartedAerialVideo:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postStartedAerialVideo:status withAttributes:attributes];
}



- (void) postStartedAerialVideoWithVideoIdentifier:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *videoIdentifer = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeDrone postStartedAerialVideo:status videoIdentifer:videoIdentifer withAttributes:attributes];
}



- (void) postStoppedAerialVideoWithVideoIdentifier:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *videoIdentifer = args[0];
    ENSURE_TYPE(args[1], NSString);
    NSString *secondsLength = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeDrone postStoppedAerialVideo:videoIdentifer withLength:secondsLength withAttributes:attributes];
}

- (void) postTookAerialPicture:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postTookAerialPicture:status withAttributes:attributes];
}

- (void) postStartedAerialTimelapse:(id)args {
    
    ENSURE_ARG_COUNT(args, 4)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSNumber);
    NSInteger totalshots = [args[1] integerValue];
    ENSURE_TYPE(args[2], NSString);
    NSString *secondsBetweenShots = args[2];
    ENSURE_TYPE(args[3], NSDictionary);
    NSDictionary *attributes = args[3];
    
    [PyzeDrone postStartedAerialTimelapse:status totalShots:totalshots delayBetweenShots:secondsBetweenShots withAttributes:attributes];
}

- (void) postStoppedAerialTimelapse:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *status = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postStoppedAerialTimelapse:status withAttributes:attributes];
}

- (void) postRequestedReturnToBase:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeDrone postRequestedReturnToBase:attributes];
}

- (void) postSwitchedToHelicopterFlyingMode:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeDrone postSwitchedToHelicopterFlyingMode:attributes];
}

- (void) postSwitchedToAttitudeFlyingMode:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeDrone postSwitchedToAttitudeFlyingMode:attributes];
}

- (void) postSwitchedToGPSHoldFlyingMode:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeDrone postSwitchedToGPSHoldFlyingMode:attributes];
}

- (void) postSwitchedToCustomFlyingMode:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger mode = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postSwitchedToCustomFlyingMode:mode withAttributes:attributes];
}

- (void) postSetMaxAltitude:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger altitudeInMeters = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postSetMaxAltitude:altitudeInMeters withAttributes:attributes];
}

- (void) postSetAutoReturnInSeconds:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger seconds = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postSetAutoReturnInSeconds:seconds withAttributes:attributes];
}

- (void) postSetAutoReturnWhenLowMemory:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger memoryLeftInKilobytes = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postSetAutoReturnWhenLowMemory:memoryLeftInKilobytes withAttributes:attributes];
}

- (void) postSetAutoReturnWhenLowBattery:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger batterylevelPercent = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeDrone postSetAutoReturnWhenLowBattery:batterylevelPercent withAttributes:attributes];
}


#pragma mark - PyzeWeatherAndForecast

- (void) postWeatherRequestedForType:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger type = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSInteger howManyDays = [args[1] integerValue];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeWeatherAndForecast postWeatherRequestedForType:type forDays:howManyDays withAttributes:attributes];
}

- (void) postWeatherHistoricalRequest:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSNumber);
    double startingInterval = [args[0] doubleValue];
    ENSURE_TYPE(args[1], NSNumber);
    double endInterval = [args[1] doubleValue];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeWeatherAndForecast postWeatherHistoricalRequest:startingInterval withEndDate:endInterval withAttributes:attributes];
}

- (void) postWeatherStationsRequestWithClusterData:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *clusterData = args[0];
    ENSURE_TYPE(args[1], NSArray);
    NSArray *geolocation = args[1];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    PyzeGeoPoint point;
    point.GeoPointLat = [geolocation[0] floatValue];
    point.GeoPointLon = [geolocation[1] floatValue];
    
    
    [PyzeWeatherAndForecast postWeatherStationsRequestWithClusterData:clusterData atGeoPoint:&point withAttributes:attributes];
}


- (void) postWeatherMapLayersRequested:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *layerName = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeWeatherAndForecast postWeatherMapLayersRequested:layerName withAttributes:attributes];
}

- (void) postWeatherRequestForUVIndexAtPoint:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSArray);
    NSArray *geoLocation = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    PyzeGeoPoint point;
    point.GeoPointLat = [geoLocation[0] floatValue];
    point.GeoPointLon = [geoLocation[1] floatValue];
    
    [PyzeWeatherAndForecast postWeatherRequestForUVIndexAtPoint:&point withAttributes:attributes];
}

- (void) postWeatherResponseForType:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSNumber);
    NSInteger *type = [args[0] integerValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    
    [PyzeWeatherAndForecast postWeatherResponseForType:type withAttributes:attributes];
}

- (void) postWeatherResponseForHistoricalData:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    
    [PyzeWeatherAndForecast postWeatherResponseForHistoricalData:attributes];
}

- (void) postWeatherStationResponseData:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    
    [PyzeWeatherAndForecast postWeatherStationResponseData:attributes];
}

- (void) postWeatherMapLayersResponse:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    
    [PyzeWeatherAndForecast postWeatherMapLayersResponse:attributes];
}

- (void) postWeatherResponseForUVIndex:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    
    [PyzeWeatherAndForecast postWeatherResponseForUVIndex:attributes];
}

- (void) postForecastRequestForKeywords:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *commaSeperateKeywords = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeWeatherAndForecast postForecastRequestForKeywords:commaSeperateKeywords withAttributes:attributes];
}

- (void) postForecastResponseForKeywords:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeWeatherAndForecast postForecastResponseForKeywords:attributes];
}

- (void) postForecastFetch:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSString);
    NSString *nDays = args[0];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeWeatherAndForecast postForecastFetch:nDays withAttributes:attributes];
}

- (void) postForecastFetchResponse:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeWeatherAndForecast postForecastFetchResponse:attributes];
}


#pragma mark - PyzeiMessageApps

- (void) postInsertMessage:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeiMessageApps postInsertMessageWithAttributes:(NSMutableDictionary *)attributes];
}

- (void) postInsertSticker:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSNumber);
    BOOL descriptionProvided = [args[0] boolValue];
    ENSURE_TYPE(args[1], NSNumber);
    BOOL URLstringProvided = [args[1] boolValue];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeiMessageApps postInsertStickerWithLocalizedDescription:descriptionProvided withStickerImageFileURLString:URLstringProvided withAttributes:(NSMutableDictionary *)attributes];
}

- (void) postInsertText:(id)args {
    
    ENSURE_ARG_COUNT(args, 2)
    
    ENSURE_TYPE(args[0], NSNumber);
    BOOL textProvided = [args[0] boolValue];
    ENSURE_TYPE(args[1], NSDictionary);
    NSDictionary *attributes = args[1];
    
    [PyzeiMessageApps postInsertTextWithText:textProvided withAttributes:(NSMutableDictionary *)attributes];
}

- (void) postInsertAttachment:(id)args {
    
    ENSURE_ARG_COUNT(args, 3)
    
    ENSURE_TYPE(args[0], NSNumber);
    BOOL URLProvided = [args[0] boolValue];
    ENSURE_TYPE(args[1], NSNumber);
    BOOL fileNameProvided = [args[1] boolValue];
    ENSURE_TYPE(args[2], NSDictionary);
    NSDictionary *attributes = args[2];
    
    [PyzeiMessageApps postInsertAttachmentWithURL:URLProvided withAlternateFileName:fileNameProvided withAttributes:(NSMutableDictionary *)attributes];
}

- (void) postMessageStartSending:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeiMessageApps postMessageStartSendingWithAttributes:(NSMutableDictionary *)attributes];
}

- (void) postReceiveMessage:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeiMessageApps postReceiveMessageWithAttributes:(NSMutableDictionary *)attributes];
}

- (void) postCancelSendingMessage:(id)args {
    
    ENSURE_ARG_COUNT(args, 1)
    ENSURE_TYPE(args[0], NSDictionary);
    NSDictionary *attributes = args[0];
    
    [PyzeiMessageApps postCancelSendingMessageWithAttributes:(NSMutableDictionary *)attributes];
}


#pragma mark - utility methods

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end


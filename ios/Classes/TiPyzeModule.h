/**
 * Pyze
 *
 * Created by Your Name
 * Copyright (c) 2018 Your Company. All rights reserved.
 */

#import "TiModule.h"
#import <Pyze/Pyze.h>
#import <Pyze/PyzeEvent.h>

@interface TiPyzeModule : TiModule {
    
}



#pragma mark - Pyze

/**
 *  Pyze Timer Reference is a time interval since a Pyze internal reference time in seconds with millisecond precision e.g. 6.789 seconds (or 6789 milliseconds)
 *
 *  It is used to time tasks and report in events.
 *
 *  usage:
 *
 *     //Start timing
 *        var pyze = require('ti.pyze');
 *        var timerRef = pyze.timerReference;
 */
- (id) timerReference;

/**
 *  Returns the Pyze instance identifier. If Pyze not initialized, returns an empty string.
 *
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      var appInstanceId = pyze.getPyzeAppInstanceId;
 *
 *  @return Pyze Instance identifier
 */
- (id) getPyzeAppInstanceId;

#pragma mark - Opt out data collection

/**
 *  Will stop collecting all data
 *
 *  @param shouldOptout Boolean value to decide if data tracking should be stopped.
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.setUserOptOut(true);
 */
- (id) setUserOptOut:(id)arg;

/**
 *  Will stop collecting all data and delete existing data from the server
 *
 *  @param shouldDelete Boolean value to decide if data collection should be stopped and delete existing data from the server
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.deleteUser(true);
 */
- (id) deleteUser:(id)arg;


#pragma mark - Pyze Notifications

/**
 *  Use this API to set the push notification device token. This will trigger Pyze to update the device token, which internally would be used to send the push notification. Call this API in Application's AppDelegate method application:didRegisterForRemoteNotificationsWithDeviceToken:.
 *
 *
 *  @param deviceToken device Token bytes received from the AppDelegate's method call.
 
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.setRemoteNotificationDeviceToken("devicetoken");
 */
- (void) setRemoteNotificationDeviceToken:(id)arg;


/**
 *  Use this API to process the push/remote notification. Call this everytime when you receive the remote notification from application:didReceiveRemoteNotification or application:didReceiveRemoteNotification:fetchCompletionHandler:.
 
 If you are using interactive push notifications e.g. Button handlers in push messages, then use processReceivedRemoteNotificationWithId:
 instead.
 
 *  @param userInfo User information received as a payload.
 
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.processReceivedRemoteNotification(userInfo);
 */
- (void) processReceivedRemoteNotification:(id)args;

/**
 *  Use this API to process the local/remote push notifications. Call this everytime when you receive the remote notification from application:handleActionWithIdentifier:forRemoteNotification:completionHandler:. For example: Button handlers in
 interactive push notifications. If you are not using button handlers in push messages, you can pass nil to 'identifer' parameter.
 
 *  @param userInfo User information received as a payload.
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.processReceivedRemoteNotificationWithActionIdentifier("actionid", userInfo);
 */
- (void) processReceivedRemoteNotificationWithActionIdentifier:(id)args;


/**
 *  This will perform the selected notification action as identified by 'actionIdentifier'
 *
 *  @param actionIdentifier Identifier of user opted action.
 *  @param userInfo User info dictionary obtained from the notification receive callback method in AppDelegate
 *
 *  usage:
 *      Ti.App.iOS.addEventListener('remotenotificationaction', function(e) {
 *          pyze.handlePushNotificationAction(e.identifier, e);
 *      });
 }
 */
- (void) handlePushNotificationAction:(id)args;

#pragma mark - Pyze In-App

/**
 *  Show in-app unread messages with default settings. For all the controls presented including  Message Navigation Bar, buttons
 *  will loaded with default presentation colors used by the SDK. When user taps on any of the buttons in in-app message
 *  completionhandler method will be called.
 *
 *
 *  @param completionhandler Completion handler
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.showUnreadInAppNotificationUIWithCompletionHandler(function(params){ // Handle call back });
 *
 */
- (void) showUnreadInAppNotificationUIWithCompletionHandler:(id)args;


/**
 *  Convenience method to show in-app message with custom colors as required by the app. When user taps on any of the buttons in in-app message
 *  completionhandler method will be called. The call-to-action (upto 3) button colors are defined in the UI on growth.pyze.com when creating an in-app message. The navigation text color to move between in-app messages e.g. '<' | '>' are defined using navigationTextColor parameter in this method.
 *
 *  @param messageType   The in-app message type you would want to see. Default is PyzeInAppTypeUnread.
 *  @param textColor     Navigation text color (Ex: 1 of 10) and chevrons.
 *  @param completionhandler  Completion handler
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.showInAppNotificationUIForDisplayMessagesWithCustomAttributes(0, "#ffffff", "#ffffff", "#ffffff", "#ffffff", function(params){ // Handle call back });
 
 */
- (void) showInAppNotificationUIForDisplayMessagesWithCustomAttributes:(id)args;

/**
 *  Dismisses the in-app notification UI.
 *
 *  @param animated   On YES, dismissed the In-app UI.
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.dismissInAppNotificationUI(true);
 */
- (void) dismissInAppNotificationUI:(id)args;

/**
 *  Returns the messageHeaders and messageBody from the server and from the cache based on the messageType.
 *
 * @param messageType   The in-app message type you would want to see. Default is 0 i.e. PyzeInAppTypeUnread.
 * @param callback  Callback method returning the inapp message list as json string
 *
 *  usage:
 *      var pyze = require('ti.pyze');
 *      pyze.getMessageForType(1, function(params){
 *      var status = params[0]
 *          Ti.API.info('In-App Messages `'+params[0]+'`:');
 *      });
 */
- (void) getMessagesForType:(id) args;

/**
 *  Get array of message headers containing message ID and content ID.
 *
 *  @param messageType   The in-app message type you would want to see. Default is 0 i.e. PyzeInAppTypeUnread.
 *  @param callback  Callback method returning the list of message headers  as json string
 *
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.getMessageHeadersForType(1, function(params){
 *  var status = params[0]
 *      Ti.API.info('Message headers `'+params[0]+'`:');
 *  });

 */
- (void) getMessagesHeadersForType:(id) args;

/**
 *  Returns the number of unread messages from the server.
 *
 *  @param completionHandler Completion handler will be called with count.
 *
 *  var pyze = require('ti.pyze');
 *  countNewUnfetched(function(params) {
 *      Ti.API.info('Unread count `'+params[0]+'`:');
 *  })
 *
 */
- (void) countNewUnfetched:(id) args;

#pragma mark - PyzePersonalizationIntelligence

/**
 *  Get all tags assigned to the user.  Note: Tags are case sensitive, "High Value" and "high value" are different tags.
 *
 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  pyze.getTags(1, function(tagsList))
 *
 *  @param callback function returning the tag list as Array.
 */
- (void) getTags:(id)args;

/**
 *  Returns true if requested tag is assigned to user.   Note: Tags are case sensitive, "High Value" and "high value" are different tags
 *
 *  @param tag The selected tag.
 *  @return Returns YES if found.
 *
 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  var status = pyze.isTagSet("tagName")
 *
 */
- (BOOL) isTagSet:(id)args;

/**
 *  Returns true if at least one tag is assigned.    Note: Tags are case sensitive, "High Value" and "high value" are different tags.
 *
 *  @param tagsList The array tag list strings.
 *
 *  @return Returns YES if any of the tags is found.
 
 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  var status = pyze.areAnyTagsSet(["tagName1", "tagName2", "tagName3"])
 *
 */
- (BOOL) areAnyTagsSet:(id)args;


/**
 *  Returns true if all tags specified are assigned to user.   Note: Tags are case sensitive, "High Value" and "high value" are different tags.
 *
 *  @param tagsList The array tag list strings.
 *
 *  @return Returns YES if all of the tags are found.

 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  var status = pyze.areAllTagsSet(["tagName1", "tagName2", "tagName3"])
 *
 */
- (BOOL) areAllTagsSet:(id)args;

#pragma mark - PyzeAttribution

/**
 *  Send Appsflyer attribution data to pyze.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postAppsFlyerAttribution({"installAttrKey1":"installAttrValue1", "installAttrKey2":"installAttrValue2"})
 *
 *  @param attributionData attribution/install data obtained from Appsflyer
 *
 */
- (void) postAppsFlyerAttribution:(id)args;

#pragma mark - PyzeCustomEvent

/**
 *  Base class method which will post the data to server.
 *
 *  @param eventName  The event name to capture.
 *  @param attributes Additional custom attributes the app would want to share with server.
 *
 *
 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  pyze.postCustomEventWithAttributes("customEventName", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCustomEventWithAttributes:(id)args;

/**
 *  Base class method which will post the data to server.
 *
 *  @param eventName  The event name to capture.
 *
 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  pyze.postCustomEvent("customEventName")
 */
- (void) postCustomEvent:(id)args;

/**
 *  Base class method which will post the data to server.
 *
 *  @param eventName  The event name to capture.
 *
 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  var timerRef = pyze.timerReference
 *  postTimedEventWithNameTimerReferenceAndAttributes("customEventName", timerRef)
 */

- (void) postTimedEventWithNameAndTimerReference:(id)args;

/**
 *  Base class method which will post the data to server.
 *
 *  @param eventName  The event name to capture.
 *
 *  usage:
 *
 *  var pyze = require('ti.pyze');
 *  var timerRef = pyze.timerReference
 *  postTimedEventWithNameAndTimerReference("customEventName", timerRef, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 *
 */
- (void) postTimedEventWithNameTimerReferenceAndAttributes:(id)args;

#pragma mark - Pyze  Explicit Activation

/**
 *  Base class method which will post the data to server.
 *
 *  @param eventName  The event name to capture.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  var timerRef = pyze.timerReference
 *  pyze.postExplicitActivation;
 *
 */
- (void) postExplicitActivation;

/**
 *  Base class method which will post the data to server.
 *
 *  @param attributes  Actication attributes
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postExplicitActivation({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 *
 */
- (void) postExplicitActivationWithAttributes:(id)args;

#pragma mark - Pyze Account

/**
 *  Post login offered details when the login screen is shown
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLoginOfferedWithAttributes({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 *
 */
- (void) postLoginOfferedWithAttributes:(id)args;

/**
 *  Post login started details when user started to type user credentials.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLoginStartedWithAttributes({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postLoginStartedWithAttributes:(id)args;

/**
 *  Post registration offered details; sign up, registration, user enrollment offered.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRegistrationOfferedWithAttributes({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postRegistrationOfferedWithAttributes:(id)args;

/**
 *  Post registration started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRegistrationStartedWithAttributes({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postRegistrationStartedWithAttributes:(id)arg;

/**
 *  Post registration completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRegistrationCompletedWithAttributes({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 *
 */
- (void) postRegistrationCompletedWithAttributes:(id)args;

/**
 *  Post the login operation Offered details.
 *
 *  @param type       This could be any of  Facebook, Twitter, LinkedIn, Phone number, etc.,
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSocialLoginOfferedWithTypeAndAttributes("facebook", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postSocialLoginOfferedWithTypeAndAttributes:(id)args;

/**
 *  Post the login operation Started details.
 *
 *  @param type       This could be any of  Facebook, Twitter, LinkedIn, Phone number, etc.,
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSocialLoginStartedWithTypeAndAttributes("facebook", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 *
 *  - Since: v2.2.0
 */
- (void) postSocialLoginStartedWithTypeAndAttributes:(id)args;

/**
 *  Post the login operation Completed details.
 *
 *  @param type       This could be any of  Facebook, Twitter, LinkedIn, Phone number, etc.,
 *  @param attributes Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSocialLoginCompletedWithTypeAndAttributes("facebook", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postSocialLoginCompletedWithTypeAndAttributes:(id)args;

/**
 *  Post the login operation completion details.
 *
 *  @param success    a status to indicate the operation successful or failed.
 *  @param errCodeStr On error, pass the localizedDescription to this parameter.
 *  @param dictionary Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLoginCompletedWithSuccessStatusErrorCodeAndAttributes(true, 200, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 *
 */
- (void) postLoginCompletedWithSuccessStatusErrorCodeAndAttributes:(id)args;

/**
 *  Post logout details
 *
 *  @param logoutExplicit A boolean status to determine whether logout is explicit logout or not.
 *  @param dictionary     Additional custom attributes app would like to share with server.
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLogoutCompletedWithSuccessStatusAndAttributes(true, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postLogoutCompletedWithSuccessStatusAndAttributes:(id)args;

/**
 *  Post password reset requested details.
 *
 *  @param dictionary Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPasswordResetRequested({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 *
 */
- (void) postPasswordResetRequested:(id)args;

/**
 *  Post password reset completed details.
 *
 *  @param dictionary Additional custom attributes app would like to share with server.
 *
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPasswordResetCompleted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postPasswordResetCompleted:(id)args;

#pragma mark - PyzeIdentity

/**
 *  Use this to identify users. Examples include: username, userid, email address, phone number, or a hashedId. Call this when a user logs in, registers or signs up
 *
 *  @param uniqueID An app specific user identifer
 
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.setUserIdentifer("abcd")
 
 */
- (void) setUserIdentifer:(id)args;

/**
 *  Resets App specific User Identifer. Call this when a user logs off.
 *

 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.resetUserIdentifer;
 
 */
- (void) resetUserIdentifer;


/**
 *  Post the user traits to Pyze.  Send user traits as a map/dictionary.
 *
 *  Send user traits as a map/dictionary.
 *
 *      usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postIdentityTraits({"adderss":"585 Broadway Street, Redwood City, California 94063", "age":"25", "firstName":"Mark"})
 *  - Since: v3.2.3
 
 */
- (void) postIdentityTraits:(id)args;

#pragma mark - PyzeAd

/**
 *  Post the event to server once the ad request has successfully been sent to the server.
 *
 *  @param adNetwork  The ad network the app referring to.
 *  @param appScreen  ViewController name where ad would be shown.
 *  @param size       Size of the ad.
 *  @param type       Type of ad for example Interstitial, Banner Ads, DFP ads etc.,
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postIdentityTraits("Google", "Homepage", "320x50", "banner", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postAdRequested:(id)args;

/**
 *  Post the event to server once the ad data received from the provider.
 *
 *  @param adNetwork  The ad network the app referring to.
 *  @param appScreen  ViewController name where ad would be shown.
 *  @param resultCode Result code received, if any.
 *  @param success    Success or failed to load the ad.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postAdReceived("Google", "Homepage", "320x50", "200", true, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postAdReceived:(id)args;

/**
 *  Post the event to server when user taps on ad.
 *
 *  @param adNetwork  The ad network the app referring to.
 *  @param appScreen  ViewController name where ad would be shown.
 *  @param adCode     Ad code received from the server, if any.
 *  @param success    Success or failed to load the ad.
 *  @param errorCode  Pass the errorCode if ad click operation fails.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postAdClicked("Google", "Homepage", "320x50", "400", true, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postAdClicked:(id)args;

#pragma mark - PyzeAdvocacy


/**
 *  Post request for feedback.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRequestForFeedback({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRequestForFeedback:(id)args;

/**
 *  Post the feedback received.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFeedbackProvided({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFeedbackProvided:(id)args;

/**
 *  Post request rating.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRequestRating({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRequestRating:(id)args;

#pragma mark - PyzeSupport

/**
 *  Post requested phone callback details
 *
 *  @param attributes Additional attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRequestedPhoneCallback({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postRequestedPhoneCallback:(id)args;

/**
 *  Post live chat started with topic details.
 *
 *  @param topic      topic interested.
 *  @param attributes Additional attributes.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *   pyze.postLiveChatStartedWithTopic({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postLiveChatStartedWithTopic:(id)args;

/**
 *  Post live chat ended with topic details.
 *
 *  @param topic      topic interested.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLiveChatEndedWithTopic({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postLiveChatEndedWithTopic:(id)args;

/**
 *  Post ticket created for support details
 *
 *  @param itemID     Item id for which ticket created.
 *  @param topic      Topic interested.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postTicketCreated("item123", "topic1", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postTicketCreated:(id)args;

/**
 *  Post feedback received for support request.
 *
 *  @param feedback   Feedback received.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFeedbackReceived("feedback text", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postFeedbackReceived:(id)args;

/**
 *  Post quality of service info details.
 *
 *  @param comment    Comment about QoS.
 *  @param rating     Rating on 5 point scale.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postQualityOfServiceRated("comment text", 4, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postQualityOfServiceRated:(id)args;

#pragma mark - PyzeCommerceSupport

/**
 *  Post live chat started details.
 *
 *  @param topic       Topic interested
 *  @param orderNumber Order number for which support requested.
 *  @param attributes  Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceSupportLiveChatStarted("New topic", "456", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postCommerceSupportLiveChatStarted:(id)args;

/**
 *  Post live chat ended with topic details.
 *
 *  @param topic      topic interested.
 *  @param orderNumber Order number for which support requested.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceSupportLiveChatEnded("New topic", "456", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postCommerceSupportLiveChatEnded:(id)args;

/**
 *  Post ticket created for support details
 *
 *  @param itemID     Item id for which ticket created.
 *  @param topic      Topic interested.
 *  @param orderNumber Order number for which support requested.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceSupportTicketCreated("Item1234", "New Topic" "456", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postCommerceSupportTicketCreated:(id)args;

/**
 *  Post feedback received for support request.
 *
 *  @param feedback   Feedback received.
 *  @param orderNumber Order number for which support requested.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceSupportFeedbackReceived("Feedback text", "456", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postCommerceSupportFeedbackReceived:(id)args;

/**
 *  Post quality of service info details.
 *
 *  @param comment    Comment about QoS.
 *  @param orderNumber Order number for which support requested.
 *  @param rating     Rating on 5 point scale.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceSupportQualityOfServiceRated("Comment text", "456", 3, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceSupportQualityOfServiceRated:(id)args;

#pragma mark - PyzeCommerceDiscovery

/**
 *  Post the search details, latency value with details.
 *
 *  @param searchString Search string used
 *  @param latency      Latency to complete the operation.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSearched("Ear phones", 3, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSearched:(id)args;

/**
 *  Post browsed category details.
 *
 *  @param category   Category name
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBrowsedCategory("Ear phones", 3, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBrowsedCategory:(id)args;

/**
 *  Post browsed deal details
 *
 *  @param uniqueDealID Unique deal identification string/number.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBrowsedDeals("id342", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBrowsedDeals:(id)args;

/**
 *  Post browsed recommendation details.
 *
 *  @param uniqueRecommendationID uniqueRecommendationID containing a string/number.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBrowsedRecommendations("recid897", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBrowsedRecommendations:(id)args;

/**
 *  Post browsed previous order details.
 *
 *  @param rangeStart Starting range of the order browsed.
 *  @param rangeEnd   Ending range of the order browsed.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBrowsedPrevOrders("1000", "5000", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBrowsedPrevOrders:(id)args;

#pragma mark - PyzeCommerceCuratedList

/**
 *  Post creation details of curated list.
 *
 *  @param uniqueCuratedListID Curated list id.
 *  @param curatedListType     Type of curated list.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCuratedListCreated("curid99", "type5", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCuratedListCreated:(id)args;

/**
 *  Post browsed details of curated list.
 *
 *  @param curatedList        Curated list id.
 *  @param curatedListCreator Curated list creation id.
 *  @param attributes         Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCuratedListBrowsed("curid99", "curcid453", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCuratedListBrowsed:(id)args;

/**
 *  Post details of adding an item to curated list.
 *
 *  @param uniqueCuratedListId Curated list id.
 *  @param itemCategory        Category name to add the item.
 *  @param itemID              Item id details.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCuratedListAddedItem("curid99", "Mobiles", "item098", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCuratedListAddedItem:(id)args;

/**
 *  Post details of removed items of curated list
 *
 *  @param uniqueCuratedListID Curated list id.
 *  @param curatedListType     Curated list type.
 *  @param itemID              Item id details.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCuratedListAddedItem("curid99", "type1", "item098", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCuratedListRemovedItem:(id)args;

/**
 *  Post details of shared curated list details.
 *
 *  @param curatedList        Curated list name
 *  @param curatedListCreator Creator id of curated list.
 *  @param attributes         Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCuratedListShared("curid99", "type1", "item098", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCuratedListShared:(id)args;

/**
 *  Post published details of curated list.
 *
 *  @param curatedList        Curated list name.
 *  @param curatedListCreator Curated list creator id.
 *  @param attributes         Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCuratedListPublished("curlist123", "curcid453", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCuratedListPublished:(id)args;

#pragma mark - PyzeCommerceWishList

/**
 *  Post details of wish lists created.
 *
 *  @param uniqueWishListId Unique wish list id.
 *  @param wishListtype     Wish list type.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceWishListCreated("wishlist676", "wtype2", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceWishListCreated:(id)args;

/**
 *  Post details of the browsed wish list.
 *
 *  @param uniqueWishListId Wish list identifier.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceWishListBrowsed("wishlist676",{"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceWishListBrowsed:(id)args;

/**
 *  Post details of the added item to the wish list.
 *
 *  @param uniqueWishListId Wish list identifier.
 *  @param itemCategory     Item category the item added to.
 *  @param itemId           Item id details.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceWishListAddedItem("wishlist676", "catefory1", "item876", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceWishListAddedItem:(id)args;

/**
 *  Post details of the item removed from the wish list.
 *
 *  @param uniqueWishListId Wish list identifier.
 *  @param itemCategory     Item category the item removed from.
 *  @param itemId           Item id details.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceWishListRemovedItem("wishlist676", "catefory1", "item876", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceWishListRemovedItem:(id)args;

/**
 *  Post shared details of the wish list.
 *
 *  @param uniqueWishListId Wish list identitier.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceWishListShared("wishlist676", "catefory1", "item876", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceWishListShared:(id)args;

#pragma mark - PyzeCommerceBeacon

/**
 *  Post entered region of beacon details.
 *
 *  @param iBeaconUUID            Beacon UUID.
 *  @param iBeaconMajor           Beacon major identifier.
 *  @param iBeaconMinor           Beacon minor identifier.
 *  @param uniqueRegionIdentifier Registration identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceBeaconEnteredRegion("ib7656", "ibMj68232", "ibMn0823", "reg098", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceBeaconEnteredRegion:(id)args;

/**
 *  Post exited region detaikls.
 *
 *  @param iBeaconUUID            Beacon UUID.
 *  @param iBeaconMajor           Beacon major identifier.
 *  @param iBeaconMinor           Beacon minor identifier.
 *  @param uniqueRegionIdentifier Registration identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceBeaconExitedRegion("ib7656", "ibMj68232", "ibMn0823", "reg098", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceBeaconExitedRegion:(id)args;

/**
 *  Post transaction details of Beacon.
 *
 *  @param iBeaconUUID            Beacon UUID.
 *  @param iBeaconMajor           Beacon major identifier.
 *  @param iBeaconMinor           Beacon minor identifier.
 *  @param uniqueRegionIdentifier Registration identifier.
 *  @param proximity              Proximity state i.e. near or far.
 *  @param actionId               Action identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceBeaconExitedRegion("ib7656", "ibMj68232", "ibMn0823", "reg098", "100", 777, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceBeaconTransactedInRegion:(id)args;

#pragma mark - PyzeCommerceCart

/**
 *  Post details of item added to the cart.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItem("cart34", "category67", "item098", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItem:(id)args;

/**
 *  Post detials of item added to cart from the deals.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param uniqueDealId Unique deal identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItemFromDeals("cart34", "category67", "item098", "deal768" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItemFromDeals:(id)args;

/**
 *  Post details of item added to cart from wish list.
 *
 *  @param cartId           Cart identifier.
 *  @param itemCategory     Item category identifier.
 *  @param itemId           Item id details.
 *  @param uniqueWishListId Unique wish list identifier.
 *  @param attributes       Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItemFromWishList("cart34", "category67", "item098", "wishlist654" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItemFromWishList:(id)args;

/**
 *  Post details of item added to cart from curated list.
 *
 *  @param cartId              Cart identifier.
 *  @param itemCategory        Item category identifier.
 *  @param itemId              Item id details.
 *  @param uniqueCuratedListId Unique curated list identifier.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItemFromCuratedList("cart34", "category67", "item098", "curlist876" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItemFromCuratedList:(id)args;

/**
 *  Post details of item added to cart from Recommendations.
 *
 *  @param cartId                 Cart identifier.
 *  @param itemCategory           Item category.
 *  @param itemId                 Item id detials.
 *  @param uniqueRecommendationId Unique recommendation identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItemFromRecommendations("cart34", "category67", "item098", "recid653" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItemFromRecommendations:(id)args;

/**
 *  Post details of item added to cart from Previous orders.
 * 
 *  @param cartId          Cart identifiers.
 *  @param itemCategory    Item category identifier.
 *  @param itemId          Item id details.
 *  @param previousOrderId Previous order identifier.
 *  @param attributes      Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItemFromPreviousOrders("cart34", "category67", "item098", "prev873" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItemFromPreviousOrders:(id)args;

/**
 *  Post details of item added to cart from search results.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param searchString Search string.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *  usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItemFromSearchResults("cart34", "category67", "item098", "Mobile" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItemFromSearchResults:(id)args;


/**
 *  Post details of item added to cart from subscription list.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param uniqueDealId Unique deal identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartAddItemFromSubscriptionList("cart34", "category67", "item098", "deal422" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartAddItemFromSubscriptionList:(id)args;

/**
 *  Post details of the item removed from the Cart.
 *
 *  @param cartId       Cart identifier.
 *  @param itemCategory Item category identifier.
 *  @param itemId       Item id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartRemoveItemFromCart("cart34", "category67", "item098", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartRemoveItemFromCart:(id)args;

/**
 *  Post details of view of items in cart.
 *
 *  @param cartId     Cart
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartView("cart34", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartView:(id)args;

/**
 *  Post details of the item shared from Cart.
 *
 *  @param cartId     Cart identifier.
 *  @param sharedWith Shared with details FB/Twitter/G+ etc.
 *  @param itemId     Item id details.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCommerceCartShare("cart34", "FB", "item286", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCommerceCartShare:(id)args;

#pragma mark - PyzeCommerceItem

/**
 *  Post detials of the item viewed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postViewedItem({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postViewedItem:(id)args;

/**
 *  Post detials of the item scanned details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postScannedItem({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postScannedItem:(id)args;

/**
 *  Post detials of the item viewed reviews details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postViewedReviews({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postViewedReviews:(id)args;

/**
 *  Post detials of the item viewed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postViewedDetails({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postViewedDetails:(id)args;

/**
 *  Post detials of the item viewed price details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postViewedPrice({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postViewedPrice:(id)args;

/**
 *  Post detials of the item viewed price details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postItemShareItem({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postItemShareItem:(id)args;


/**
 *  Post details of the item rating details.
 *
 *  @param itemSKU    Item SKU identifier.
 *  @param rating     Rating number out of 5/10.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postItemRateOn5Scale("item4545", 4, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postItemRateOn5Scale:(id)args;

#pragma mark - PyzeCommerceCheckout


/**
 *  Post checkout started details of the item.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCheckoutStarted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCheckoutStarted:(id)args;

/**
 *  Post checkout completion details of the item.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCheckoutCompleted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCheckoutCompleted:(id)args;

/**
 *  Post checkout abondonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCheckoutAbandoned({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCheckoutAbandoned:(id)args;

/**
 *  Post checkpit failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCheckoutFailed({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCheckoutFailed:(id)args;

#pragma mark - PyzeCommerceShipping

/**
 *  Post shipping started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postShippingStarted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postShippingStarted:(id)args;

/**
 *  Post shipping completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postShippingCompleted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postShippingCompleted:(id)args;

/**
 *  Post shipping abandonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postShippingFailed({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postShippingAbandoned:(id)args;

/**
 *  Post shipping failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postShippingFailed({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postShippingFailed:(id)args;

#pragma mark - PyzeCommerceBilling


/**
 *  Post billing started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBillingStarted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBillingStarted:(id)args;

/**
 *  Post billing completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBillingCompleted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBillingCompleted:(id)args;

/**
 *  Post billing abandonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBillingAbandoned({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBillingAbandoned:(id)args;

/**
 *  Post billing failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBillingFailed({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBillingFailed:(id)args;

#pragma mark - PyzeCommercePayment

/**
 *  Post payment started details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPaymentStarted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPaymentStarted:(id)args;

/**
 *  Post payment completed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPaymentCompleted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPaymentCompleted:(id)args;

/**
 *  Post payment abandonment details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPaymentAbandoned({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPaymentAbandoned:(id)args;

/**
 *  Post payment failed details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPaymentFailed({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPaymentFailed:(id)args;

#pragma mark - PyzeCommerceRevenue

/**
 *  Post details of revenue details.
 *
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRevenue("$1000", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRevenue:(id)args;

/**
 *  Post revenue using apple pay details.
 *
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRevenueUsingApplePay("$1000", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRevenueUsingApplePay:(id)args;

/**
 *  Post revenue details using Samsung play details.
 *
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRevenueUsingSamsungPay("$1000", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRevenueUsingSamsungPay:(id)args;

/**
 *  Post details of revenue done by GooglePay
 *
 *  @param revenue    Revenue value
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRevenueUsingGooglePay("$1000", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRevenueUsingGooglePay:(id)args;

/**
 *  Post revenue details
 *
 *  @param revenue           Revenue value.
 *  @param paymentInstrument Payment instrument used.
 *  @param attributes        Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRevenueWithPaymentInstrument("$1000", "ApplePay", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRevenueWithPaymentInstrument:(id)args;

#pragma mark - PyzeGaming

/**
 *  Post details of Gaming level the app is in.
 *
 *  @param level      Level started number.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postGamingLevelStarted("Level10", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postGamingLevelStarted:(id)args;

/**
 *  Post details of Game level completed.
 *
 *  @param level      Level number.
 *  @param score      Current score at the level.
 *  @param success    Success or failure reason.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postGamingLevelEnded("Level10", "164", "success message", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postGamingLevelEnded:(id)args;

/**
 *  Post details of power up consumed during Game play details
 *
 *  @param level      Level number.
 *  @param type       Type of Power-up used.
 *  @param value      Value for the power-up
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPowerUpConsumed("Level10", "type11", "200", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPowerUpConsumed:(id)args;

/**
 *  Post details of items purchased in a Game.
 *
 *  @param uniqueItemId Item identifier.
 *  @param itemType     Item type details
 *  @param value        Value of the item.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postInGameItemPurchased("item345", "Power Boost", "200", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postInGameItemPurchased:(id)args;

/**
 *  Post achievement details
 *
 *  @param uniqueAchievementId Achievement identifier.
 *  @param type                Type of achievement.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postAchievementEarned("achieve876", "type11",{"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postAchievementEarned:(id)args;

/**
 *  Post summary details viewed.
 *
 *  @param level      Level number.
 *  @param score      Score at the level.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSummaryViewed("Level14", "230",{"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSummaryViewed:(id)args;

/**
 *  Post leader board viewed details
 *
 *  @param level Level number.
 *  @param score Score at the level.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLeaderBoardViewed("Level14", "230",{"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postLeaderBoardViewed:(id)args;

/**
 *  Post details of scorecard view details
 *
 *  @param level      Level number
 *  @param score      Score at the level
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postScorecardViewed("Level14", "230", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postScorecardViewed:(id)args;

/**
 *  Post details of the Help view.
 *
 *  @param helpTopicId Help Topic identifier used.
 *  @param dictionary  Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postHelpViewed("help topic 1", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postHelpViewed:(id)args;


/**
 *  Post details of tutorial viewed.
 *
 *  @param helpTopicId Help topic identifier used.
 *  @param dictionary  Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postTutorialViewed("help topic 1", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postTutorialViewed:(id)args;

/**
 *  Post details of the challenging a friend.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFriendChallenged({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFriendChallenged:(id)args;

/**
 *  Post details of the accepted challenge from friend.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postChallengeAccepted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postChallengeAccepted:(id)args;

/**
 *  Post declined challenge request.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postChallengeDeclined({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postChallengeDeclined:(id)args;

/**
 *  Post Game start details.
 *
 *  @param level      Level number
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postGameStart("Level 2", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postGameStart:(id)args;


/**
 *  Post game end details.
 *
 *  @param levelsPlayed Level played at the current session
 *  @param levelsWon    Levels actually won/completed.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postGameStart("Level 5", "3", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postGameEnd:(id)args;


#pragma mark - PyzeHealthAndFitness

/**
 *  Post details of health and fitness routine start.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postStarted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postStarted:(id)args;

/**
 *  Post details of health and fitness routine ended.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postEnded({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postEnded:(id)args;

/**
 *  Post details of health and fitness routine achievement.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postAchievementReceived({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postAchievementReceived:(id)args;

/**
 *  Post details of health and fitness routine step-goal completion.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postStepGoalCompleted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postStepGoalCompleted:(id)args;

/**
 *  Post details of health and fitness routine goal completion.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postGoalCompleted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postGoalCompleted:(id)args;

/**
 *  Post details of health and fitness routine friend challenge.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postHealthAndFitnessChallengedFriend({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postHealthAndFitnessChallengedFriend:(id)args;

/**
 *  Post details of health and fitness routine friend challenge acceptance.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postHealthAndFitnessChallengeAccepted({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postHealthAndFitnessChallengeAccepted:(id)args;

#pragma mark - PyzeContent

/**
 *  Post details of the content viewed.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category of the content.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postViewed("News", "News", "news/1234" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postViewed:(id)args;

/**
 *  Post details of content searched
 *
 *  @param searchString Search string
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postContentSearched("Science", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postContentSearched:(id)args;

/**
 *  Post details of the content rating.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category name of the content.
 *  @param contentId    Content identifier.
 *  @param rating       Rating value.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postContentRatedOn5PointScale("News", "News", "news/2134", 8, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postContentRatedOn5PointScale:(id)args;

/**
 *  Post detials if content is thumbs up.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category of the content.
 *  @param contentId    Content id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postContentRatedThumbsUp("News", "News", "news/2134", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postContentRatedThumbsUp:(id)args;

/**
 *  Post detials of the content is thumbs down.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category of the content.
 *  @param contentId    Content id details.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postContentRatedThumbsDown("News", "News", "news/2134", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postContentRatedThumbsDown:(id)args;

#pragma mark - PyzeMessaging


/**
 Message Types:
 
 * Default Text Message (type not specified or tracked)
 PyzeMessageTypeDefault = 0,
 
 *  SMS message with or without emoji - picture (e) + letter (moji)
 PyzeMessageTypeSMS = 1,
 
 *  MMS message
 PyzeMessageTypeMMS = 2,
 
 *  Text message with or without emoji - picture (e) + letter (moji)
 PyzeMessageTypeText = 3,
 
 *  Text message without emoji - picture (e) + letter (moji)
 PyzeMessageTypeTextPlain = 4,
 
 
 *  Text message with emoji - picture (e) + letter (moji)
 PyzeMessageTypeTextWithEmoji = 5,
 
 *  Picture sent or received (no tracking source)
 PyzeMessageTypePicture = 6,
 
 *  Picture taken from camera and messaged
 PyzeMessageTypePictureFromCamera = 7,
 
 *  Picture selected from Album
 PyzeMessageTypePictureFromAlbum = 8,
 
 *  Send last taken picture
 PyzeMessageTypePictureMostRecent = 9,
 
 *  send a marked-up or drawn upon picture
 PyzeMessageTypePictureMarkedup = 10,
 
 *  send a picture that was touched up or a filter applied to
 PyzeMessageTypePictureEdited,
 
 *  send a picture of a whiteboard
 PyzeMessageTypePictureWhiteboard = 11,
 
 *  send an animated gif
 PyzeMessageTypePictureAnimated = 12,
 
 *  send a picture of a whiteboard adjusted for clarity or cleaned to fix white levels
 PyzeMessageTypePictureWhiteboardCleaned = 13,
 
 *  send clipart from Library
 PyzeMessageTypeClipart = 14,
 
 *  send sticker
 PyzeMessageTypeSticker = 15,
 
 *  send an animated sticker
 PyzeMessageTypeAnimatedSticker = 16,
 
 *  Video sent or received (no tracking source)
 PyzeMessageTypeVideo = 17,
 
 *  Video taken from camera and messaged
 PyzeMessageTypeVideoFromCamera = 18,
 
 *  Video selected from Album
 PyzeMessageTypeVideoFromAlbum = 19,
 
 *  Send last taken Video
 PyzeMessageTypeVideoeMostRecent = 20,
 
 *  send a Video that was edited
 PyzeMessageTypeVideoEdited = 21,
 
 *  send a Voice Memo that was edited
 PyzeMessageTypeVoiceMemo = 22,
 
 *  send a Voice call that was edited
 PyzeMessageTypeVoiceCall = 23,
 
 *  send a Video Memo
 PyzeMessageTypeVideoMemo = 24,
 
 *  send scribbled image
 PyzeMessageTypeScribble = 25,
 
 
 *  Used an Integration or BOT (roBOT).
 *  An integration could be used to text to a service provider to complete a task.
 *
 *  Examples include: Call Uber, Order Pizza, Buy tickets to a game, Get flight status, Send Money to a friend, Make a call using Slack, List what's playing in the Music app,  Bring car out of garage, Check order status, Notify bot to turn coffee machine on, Turn the house alarm on, Close the garage doors, Contact Geico to renew auto insurance, Buy a stock, Find a conference room at a specific time, Create a poll etc.
 PyzeMessageTypeIntegrationOrBot
 
 */


/**
 *  Post details of Message sent
 *
 *  @param uniqueId   Message identifier.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMessageSent("Msg287", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMessageSent:(id)args;

/**
 *  Post details of Message sent
 *
 *  @param messageType   Message type
 *  @param uniqueId      Message identifier.
 *  @param dictionary    Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMessageSentOfType(2, "Msg287", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMessageSentOfType:(id)args;


/**
 *  Post details of message received.
 *
 *  @param uniqueId   message identifier
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMessageReceived("Msg744", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMessageReceived:(id)arg;

/**
 *  Post details of message received.
 *
 *  @param messageType   Message type
 *  @param uniqueId   message identifier
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMessageRecievedOfType(3, "Msg744", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMessageRecievedOfType:(id)args;

/**
 *  Post details of the New conversation created.
 *
 *  @param uniqueId   Conversation identifier.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMessageNewConversation("Msg744", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMessageNewConversation:(id)args;

/**
 *  Post voice call details.
 *
 *  @param uniqueId   Call identifier.
 *  @param dictionary Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMessageNewConversation("Msg744", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMessageVoiceCall:(id)args;


#pragma mark - PyzeSMS

/**
 *  Send the device for registration with phone number.
 *
 *  @param phoneNumber Phone number as '1234567890'
 *  @param countryCode Country code where the phone being used. For Example: e.g. “1” for US “91” for India
 *  @param dictionary  Any additional attributes
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRegisteredDevice("1234567890", "91", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRegisteredDevice:(id)args;


/**
 *  Post verification of the device.
 *
 *  @param phoneNumber Phone number as '1234567890'
 *  @param verificationCode  Phone verification code received.
 *  @param countryCode Country code where the phone being used. For Example: e.g. “1” for US “91” for India
 *  @param dictionary  Any additional attributes
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postVerification("1234567890", "3452", "91", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postVerification:(id)args;

/**
 *  Send the device for unsubscribing with phone number.
 *
 *  @param phoneNumber Phone number as '1234567890'
 *  @param countryCode Country code where the phone being used. For Example: e.g. “1” for US “91” for India
 *  @param dictionary  Any additional attributes
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postUnsubscribeDevice("1234567890", "91", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postUnsubscribeDevice:(id)args;

#pragma mark - PyzeTasks



/**
 *  Add the current task to the calendar.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.addToCalendarwithAttributes({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) addToCalendarwithAttributes:(id)args;

#pragma mark - PyzeSocial

/**
 *  Post detials of social content shared.
 *
 *  @param socialNetworkName Social network name FB/G+/t
 *  @param contentReference  Content reference URL string shared.
 *  @param category          Category of the content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSocialContentShare("fb", "fb/4565656", "Sports", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSocialContentShare:(id)args;


/**
 *  Post detials of the Social content liked.
 *
 *  @param socialNetworkName Social network name FB/t/G+
 *  @param contentReference  Content reference URL shared.
 *  @param category          Catefory of the content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLiked("fb", "fb/4565656", "Sports", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postLiked:(id)args;

/**
 *  Post details of the social content followed
 *
 *  @param socialNetworkName Social network name FB/t/G+.
 *  @param contentReference  Content reference.
 *  @param category          Category identifier of the Content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFollowed("fb", "fb/4565656", "Sports", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFollowed:(id)args;

/**
 *  Post details of the conten subscribed.
 *
 *  @param socialNetworkName Social network name FB/t/G+
 *  @param contentReference  Content reference.
 *  @param category          Category identifier of the content.
 *  @param dictionary        Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSubscribed("fb", "fb/4565656", "Sports", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSubscribed:(id)args;

/**
 *  Post details of friend invite.
 *
 *  @param socialNetworkName Social network name FB/t/G+
 *  @param attributes        Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postInvitedFriend("fb", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postInvitedFriend:(id)args;

/**
 *  Post details of friend search.
 *
 *  @param source     Source where content searched.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFoundFriends("fb", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFoundFriends:(id)args;

#pragma mark - PyzeSceneFlow

/**
 *  Post seconds on game scene with scene name.
 *
 *  @param sceneName Game scene name
 *  @param seconds   number of seconds elapsed on a particular scene.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSecondsOnScene("Home page", 32.4)
 
 */
- (void) postSecondsOnScene:(id)args;


#pragma mark - PyzeMedia


/**
 *  Post details of the media played.
 *
 *  @param contentName  Content name.
 *  @param type         Type i.e., Audio, video etc.,
 *  @param categoryName Category of the media.
 *  @param percent      Percentage of content played.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPlayedMedia("MJ", "Audio", "Pop", "30", "ad4545", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPlayedMedia:(id)args;

/**
 *  Post details of the search in media.
 *
 *  @param searchString Search string.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMediaSearched("MJ", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMediaSearched:(id)args;

/**
 *  Post detials of the media rating.
 *
 *  @param contentName  Content name.
 *  @param categoryName Category type
 *  @param mediaId      Media identifier.
 *  @param rating       Rating value.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPlayedMedia("MJ", "Audio", "ad4545", 5,  {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMediaRatedOn5PointScale:(id)args;

/**
 *  Post details if media is liked.
 *
 *  @param contentName  Content name.
 *  @param categoryName Content category name.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMediaRatedThumbsUp("MJ", "Audio", "ad4545", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMediaRatedThumbsUp:(id)args;

/**
 *  Post details if media is disliked.
 *
 *  @param contentName  Content name.
 *  @param categoryName Content category name.
 *  @param contentId    Content identifier.
 *  @param attributes   Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMediaRatedThumbsDown("MJ", "Audio", "ad4545", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postMediaRatedThumbsDown:(id)args;

#pragma mark - PyzeInAppPurchaseRevenue

/**
 *  Post price list viewed in purchases
 *
 *  @param appScreenRequestFromId App screen requested identifier.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPriceListViewViewed("aps1233", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPriceListViewed:(id)args;

/**
 *  Post details of item bought.
 *
 *  @param itemName            Item name.
 *  @param revenue             Revenue value.
 *  @param currencyISO4217Code Currency code $ or Rs.
 *  @param attributes          Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBuyItem("item3456", 100, "$", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBuyItem:(id)args;

/**
 *  Post details of item bought in USD.
 *
 *  @param itemName   Item name.
 *  @param revenue    Revenue value.
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBuyItemInUSD("item3456", 100, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBuyItemInUSD:(id)args;

/**
 *  Post details of the item bought
 *
 *  @param itemName               Item name.
 *  @param revenue                Revenue value.
 *  @param currencyISO4217Code    Currency code.
 *  @param itemType               Item type.
 *  @param itemSKU                Item SKU.
 *  @param quantity               Number of item purchased.
 *  @param appScreenRequestFromId App screen requested identifier.
 *  @param success                Success or failure.
 *  @param successOrErrorCode     Error code on fail.
 *  @param attributes             Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postBuyItem("item3456", 100, "$", "Electronics", "itemSKU123", "5", true, 200, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postBuyItemWithCustomAttributes:(id)args;


#pragma mark - PyzeBitcoin

/**
 *  Post sent bitcoin details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSentBitcoins({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSentBitcoins:(id)args;

/**
 *  Post requested bitcoin details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRequestedBitcoins({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRequestedBitcoins:(id)args;

/**
 *  Post received bitcoin details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postReceivedBitcoins({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postReceivedBitcoins:(id)args;

/**
 *  Post viewed transaction details.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postViewedTransactions({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postViewedTransactions:(id)args;

/**
 *  Post imported private key details of bitcoin.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postImportedPrivateKey({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postImportedPrivateKey:(id)args;

/**
 *  Post scanned private key details of bitcoin.
 *
 *  @param attributes Additional custom attributes app would like to share with server.
 
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postScannedPrivateKey({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postScannedPrivateKey:(id)args;


#pragma mark - PyzeDrone

/**
 *  Post Preflight health check
 *  Before begining a flight it is a good idea to do a quick health check of both the drone and
 *  transmitter / controller (i.e. the device and app). A Preflight health check could include the
 *  storage (usually a micro SD card) presence and status if the drone is equipped with a camera,
 *  battery status of drone and device, calibration status and satellite lock status for GPS equipped drones.
 *
 *  @param overallStatus summary of overall status
 *  @param storageStatus storage (usually a micro SD card) presence and status if the drone is equipped with a camera
 *  @param droneBatteryChargePercent drone battery status[range should be within 0 to 100].
 *  @param deviceBatteryChargePercent controller device status [range should be within 0 to 100].
 *  @param calibrationStatus calibration status
 *  @param gpsStatus gps Status if drone is GPS equipped
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postPreflightCheckCompleted("good", "almost full", 66, "caliveration status", "gps status" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postPreflightCheckCompleted:(id)args;


/**
 *  Inflight health check
 *  @param overallStatus    summary of overall status
 *  @param rollStatus       accomplished by controlling the Aileron (moving right stick to the left or right) which maneuvers the drone / quadcopter left or right.
 *  @param pitchStatus      accomplished by controlling the Elevator (moving right stick forwards or backwards) which maneuvers the drone / quadcopter forwards or backwards.
 *  @param yawStatus        accomplished by controlling Rudder (moving the left stick to the left or to the right)  Rotates the drone / quadcopter left or right. Points the front of the drone / quadcopter different directions and helps with changing directions while flying.
 *
 *  @param throttleStatus   accomplished by controlling Throttle. Engaged by pushing the left stick forwards. Disengaged by pulling the left stick backwards. This adjusts the altitude, or height, of the quadcopter.
 *
 *  @param trimmingSettings    Adjust roll, pitch, yaw, and throttle if they are off balance. e.g. "+20-20+4+0" would mean adjustments in percent of 20%, -20%, +4% and 0% for roll, pitch, yaw, and throttle respectively.
 
 *  @param attributes       Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postInflightCheckCompleted("overallStatus", "rollStatus", "pitchStatus", "yawStatus", "throttleStatus", "trimmingSettings" {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postInflightCheckCompleted:(id)args;


/**
 *  Drone is connected to controlling device.  Time to connect depends on surroundings and interference. Post this after successfully connecting
 *
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postConnected({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postConnected:(id)args;


/**
 *  Drone is disconnected from controlling device either explicitly or because of environment or distance
 *
 *  @param code disconnection code indicating how disconnected from the controller's point of view
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postDisconnected("400", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postDisconnected:(id)args;


/**
 *  Drone is Airborne
 *
 *  @param status Drone status if any
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postAirborne("drone status", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postAirborne:(id)args;

/**
 * Drone Landed
 *
 *  @param status Drone status if any
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postLanded("drone status", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postLanded:(id)args;


/**
 *  Flight path uploaded to drone
 *
 *  @param uniqueFlightPathId Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFlightPathCreated("fpath32323", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFlightPathCreated:(id)args;


/**
 *  Flight path created edited on controller and should be re-uplooaded
 *
 *  @param uniqueFlightPathId Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFlightPathUploaded("fpath32323", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFlightPathUploaded:(id)args;

/**
 *  Flight path deleted
 *
 *  @param uniqueFlightPathId Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFlightPathEdited("fpath32323", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFlightPathEdited:(id)args;

/**
 *  Flight path flown
 *
 *  @param uniqueFlightPathId Every Flight Path should be associated with a unique identifier or name
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFlightPathDeleted("fpath32323", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFlightPathDeleted:(id)args;

/**
 *  First Person View Enabled.  this allows a lower quality video to be transmitted to controller in near realtime with an acceptable lag
 *
 *  @param status status on FPV
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFlightPathCompleted("status text", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFlightPathCompleted:(id)args;

/**
 *  First Person View Disabled.
 *
 *  @param status status on FPV
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFirstPersonViewEnabled("status text", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFirstPersonViewEnabled:(id)args;

/**
 *  Started taking aerial video identifed by video identifier
 *
 *  @param status status
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postFirstPersonViewDisabled("status text", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postFirstPersonViewDisabled:(id)args;

/**
 *  Started taking aerial video identifed by video identifier
 *
 *  @param status status
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postStartedAerialVideo("status text", "vd34343", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postStartedAerialVideo:(id)args;

/**
 *  Stopped taking aerial video
 *
 *  @param videoIdentifer Video Identifier
 *  @param seconds video length in seconds
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postStoppedAerialVideo("vd34343", 75, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postStoppedAerialVideoWithVideoIdentifier:(id)args;

/**
 *  Started taking aerial video identifed by video identifier
 *
 *  @param status status
 *  @param videoIdentifer Video Identifier
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postStartedAerialVideo("status text", "vd34343", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postStartedAerialVideoWithVideoIdentifier:(id)args;


/**
 *  Took Aerial Picture
 *
 *  @param status status
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postTookAerialPicture("status text", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postTookAerialPicture:(id)args;


/**
 *  Started taking Aerial Timelapse - In Time-lapse drone photography the frequency at which frames are captured
 *  (the frame rate) is much lower than that used to view the sequence. When played at normal speed, time appears
 *  to be moving faster and thus lapsing. For example, an image of a scene may be captured once every second,
 *  then played back at 30 frames per second; the result is an apparent 30 times speed increase.  Specify total shots
 *  and seconds between shots.  The playback time would be approximately be the product of total shots and seconds betwwen shots
 *
 *  @param status status
 *  @param totalshots Total Number of shots
 *  @param secondsBetweenShots delay between shots
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postStartedAerialTimelapse("status text", 10, 2, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postStartedAerialTimelapse:(id)args;


/**
 *  Stopped Aerial Timelapse
 *
 *  @param status status (interupted / completed)
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postStoppedAerialTimelapse("status text", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postStoppedAerialTimelapse:(id)args;


/**
 *  Requested Drone to return to base
 *
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postRequestedReturnToBase({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postRequestedReturnToBase:(id)args;

/**
 *  Switched to Helicopter flying mode.  Similar to flying a helicopter,
 *  once you tilt the quadcopter (roll) it will not auto-level itself back to
 *  its original position. Even if you let go of the stick and it returns to
 *  the middle, the drone will stay tilted.  Not all drones support this Manual mode.
 *
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSwitchedToHelicopterFlyingMode({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSwitchedToHelicopterFlyingMode:(id)args;

/**
 *  Switched to Attitude or Auto-level flying mode.  Once the sticks are centered, the drone will level itself out
 *
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSwitchedToAttitudeFlyingMode({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSwitchedToAttitudeFlyingMode:(id)args;

/**
 *  Switched to GPS Hold flying mode – Returns the drone's position once the sticks have been centered.
 *  The same as attitude mode (auto-level) but using an on-board GPS.  Drones that support GPS usually have this mode.
 *
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSwitchedToGPSHoldFlyingMode({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSwitchedToGPSHoldFlyingMode:(id)args;

/**
 *  Switched to Custom Device Mode identified by a numeric mode.  Some drones have numbered modes 1, 2, 3.
 *
 *  @param mode Numeric custom mode
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSwitchedToCustomFlyingMode(111, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSwitchedToCustomFlyingMode:(id)args;

/**
 *  Drones that support GPS can limit the altitude to avoid flying into restricted airspace
 *
 *  @param altitudeInMeters altitude in meters. One foot is 0.3048 meters.
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSetMaxAltitude(100, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSetMaxAltitude:(id)args;

/**
 *  This feature is avilable on drones that are used for surveying.  If the drone has to survey 4 jobs you can specify the time in seconds for a job to ensure enough battery is available for subsequent jobs.  The math is performed by app
 *
 *  @param seconds seconds to return in
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSetAutoReturnInSeconds(100, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSetAutoReturnInSeconds:(id)args;

/**
 *  The drone can be requested to return when storage memory reaches a low threshold.
 *
 *  @param memoryLeftInKilobytes return when storage is below memoryLeftInKilobytes
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSetAutoReturnWhenLowMemory(1024, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postSetAutoReturnWhenLowMemory:(id)args;

/**
 *  The drone can be requested to return when battery reaches a low threshold.
 *
 *  @param batterylevelPercent return when battery is below batterylevelPercent
 *  @param attributes Additional custom attributes
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postSetAutoReturnWhenLowBattery(5, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postSetAutoReturnWhenLowBattery:(id)args;

#pragma mark - PyzeWeatherAndForecast

/*
 
 WeatherRequestType:
 
 *  Weather requested by City name.
 PyzeWeatherRequestByCityName = 0,
 
 *  Weather requested by City code.
 PyzeWeatherRequestByCityCode = 1
 
 *  Weather reqquested by Geo codes.
 PyzeWeatherRequestByGeoCodes = 2
 
 *  Weather requested by zones.
 PyzeWeatherRequestByZone = 3
 
 */

/**
 *  Post weather request for type.
 *
 *  @param type        Type you wish to query weather app.
 *  @param howManyDays Number of days.
 *  @param attributes  Addition attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherRequestedForType(5, 3 {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherRequestedForType:(id)args;

/**
 *  Post weather historical request data.
 *
 *  @param startingInterval Timestamp to start with.
 *  @param endInterval      End timestamp interval.
 *  @param attributes       Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherHistoricalRequest(12345, 456778, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherHistoricalRequest:(id)args;

/**
 *  Post weather station request.
 *
 *  @param clusterData Cluster data to pass.
 *  @param point       Geo point, Array of latitude and longitude [latitude, longitude]
 *  @param attributes  Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherStationsRequestWithClusterData("cluster data", [74.23232323, 37.3435345], {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherStationsRequestWithClusterData:(id)args;

/**
 *  Post request of weather maps. Weather maps include precipitation, clouds, pressure, temperature, wind and more.
 *
 *  @param layerName  Layer name.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherMapLayersRequested("Layer one", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherMapLayersRequested:(id)args;

/**
 *  Post request for UVIndex.
 *
 *  @param point      Geo point, Array of latitude and longitude [latitude, longitude]
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherRequestForUVIndexAtPoint([74.23232323, 37.3435345], {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherRequestForUVIndexAtPoint:(id)args;

/**
 *  Post response received for weather request for type.
 *
 *  @param type       Type querried.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherResponseForType(2, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherResponseForType:(id)args;

/**
 *  Post historical weather response.
 *
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherResponseForHistoricalData({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherResponseForHistoricalData:(id)args;


/**
 *  Post weather station response.
 *
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherStationResponseData({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherStationResponseData:(id)args;

/**
 *  Post weather map layer's response.
 *
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherMapLayersResponse({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherMapLayersResponse:(id)args;

/**
 *  Post weather response for UVIndex.
 *
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherResponseForUVIndex({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postWeatherResponseForUVIndex:(id)args;

/**
 *  Post forecast request for keywords.
 *
 *  @param commaSeperateKeywords Keywords used to search forecast and are comma seperated.
 *  @param attributes            Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postWeatherResponseForUVIndex("keyword1, keyword2", {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postForecastRequestForKeywords:(id)args;

/**
 *  Post response received for keywords.
 *
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postForecastResponseForKeywords({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postForecastResponseForKeywords:(id)args;

/**
 *  Post forecast fetch for n Days.
 *
 *  @param nDays      Number of days.
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postForecastFetch(10, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postForecastFetch:(id)args;

/**
 *  Post forecast fetch response.
 *
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postForecastFetchResponse({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postForecastFetchResponse:(id)args;

#pragma mark - PyzeiMessageApps

/**
 *  Post insert message details.
 *
 *  @param attributes Additional attributes.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postInsertMessage({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postInsertMessage:(id)args;

/**
 *  Post insert sticker details.
 *
 *  @param descriptionProvided Boolean value to check whether description provided or not.
 *  @param URLstringProvided   URL to sticker is provided or not.
 *  @param attributes          Other attributes to be processed.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postInsertSticker(true, true, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postInsertSticker:(id)args;

/**
 *  Post insert sticker details.
 *
 *
 *  @param textProvided True if text provided or false.
 *  @param attributes   Other attributes to process.
 *
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  postInsertText(true, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postInsertText:(id)args;

/**
 *  Post insert attachment details.
 *
 
 *  @param URLProvided      True if url to attachment provided.
 *  @param fileNameProvided True if alternate filename provided for attachment
 *  @param attributes       Other attributes to process.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postInsertAttachment(true, true, {"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postInsertAttachment:(id)args;

/**
 *  Post message start sending details.
 *
 *  @param attributes Other attributes to process.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postMessageStartSending({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postMessageStartSending:(id)args;

/**
 *  Post receive message details.
 *
 *  @param attributes Other attributes to process.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postReceiveMessage({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 */
- (void) postReceiveMessage:(id)args;

/**
 *  Post cancel sending message details.
 *
 *  @param attributes Other attributes to process.
 *
 *   usage:
 *  var pyze = require('ti.pyze');
 *  pyze.postCancelSendingMessage({"attrrKey1":"attrvalue1", "attrrKey2":"attrvalue2"})
 
 */
- (void) postCancelSendingMessage:(id)args;

@end


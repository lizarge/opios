/*
 
 Copyright (c) 2012, SMB Phone Inc.
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 The views and conclusions contained in the software and documentation are those
 of the authors and should not be interpreted as representing official policies,
 either expressed or implied, of the FreeBSD Project.
 
 */


#import <hookflash/ICall.h>
#import <hookflash/IConversationThread.h>
#import <hookflash/IContact.h>

#import "HOPCall_Internal.h"
#import "OpenPeerUtility.h"
#import "HOPConversationThread_Internal.h"
#import "HOPContact_Internal.h"
#import "OpenPeerStorageManager.h"
#import "HOPProvisioningAccount_Internal.h"

#import "HOPCall.h"



using namespace hookflash;

@implementation HOPCall

/*- (id) initCall:(HOPConversationThread*) conversationThread toContact:(HOPContact*) toContact includeAudio:(BOOL) includeAudio includeVideo:(BOOL) includeVideo
{
    self = [super init];
    if (self)
    {
        if (conversationThread != nil && toContact != nil)
        {
            callPtr = ICall::placeCall([conversationThread getConversationThreadPtr], [toContact getContactPtr], includeAudio, includeVideo);
        }
        else
        {
            [NSException raise:NSInvalidArgumentException format:@"Invalid input arguments"];
        }
    }
    
    return self;
}*/

- (id)init
{
    [self release];
    [NSException raise:NSInvalidArgumentException format:@"Don't use init for object creation. Use class method placeCall."];
    return nil;
}

- (id) initWithCallPtr:(ICallPtr) inCallPtr
{
    self = [super init];
    if (self)
    {
        callPtr = inCallPtr;
    }
    return self;
}

+ (id) placeCall:(HOPConversationThread*) conversationThread toContact:(HOPContact*) toContact includeAudio:(BOOL) includeAudio includeVideo:(BOOL) includeVideo
{
    HOPCall* ret = nil;
    if (conversationThread != nil && toContact != nil)
    {
        ICallPtr tempCallPtr = ICall::placeCall([conversationThread getConversationThreadPtr], [toContact getContactPtr], includeAudio, includeVideo);
        
        if (tempCallPtr)
        {
            ret = [[self alloc] initWithCallPtr:tempCallPtr];
            [[OpenPeerStorageManager sharedStorageManager] setCall:ret forId:[NSString stringWithUTF8String:tempCallPtr->getCallID()]];
        }
    }
    return [ret autorelease];
}

+ (NSString*) stateToString: (HOPCallStates) state
{
    return [NSString stringWithUTF8String: ICall::toString((hookflash::ICall::CallStates) state)];
}

+ (NSString*) reasonToString: (HOPCallClosedReasons) reason
{
    return [NSString stringWithUTF8String: ICall::toString((hookflash::ICall::CallClosedReasons) reason)];
}

- (NSString*) getCallID
{
    NSString* callId = @"";
    if(callPtr)
    {
        callId = [NSString stringWithUTF8String: callPtr->getCallID()];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    return callId;
}

- (HOPConversationThread*) getConversationThread
{
    HOPConversationThread* hopConversationThread = nil;
    if(callPtr)
    {
        IConversationThreadPtr conversationThreaPtr = callPtr->getConversationThread();
        if (conversationThreaPtr)
        {
            hopConversationThread = [[OpenPeerStorageManager sharedStorageManager] getConversationThreadForId:[NSString stringWithUTF8String:conversationThreaPtr->getThreadID()]];
        }
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    
    return hopConversationThread;
}

- (HOPContact*) getCaller
{
    HOPContact* hopContact = nil;
    if(callPtr)
    {
        IContactPtr contactPtr = callPtr->getCaller();
        if (contactPtr)
        {
            NSString* contactID = [NSString stringWithUTF8String:contactPtr->getContactID()];
            hopContact = [[OpenPeerStorageManager sharedStorageManager] getContactForId:contactID];
            if (!hopContact)
            {
                hopContact = [[[[HOPProvisioningAccount sharedProvisioningAccount] getSelfContact] getContactID] isEqualToString:contactID] ? [[HOPProvisioningAccount sharedProvisioningAccount] getSelfContact] : nil;
            }
        }
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    return hopContact;
}

- (HOPContact*) getCallee
{
    HOPContact* hopContact = nil;
    if(callPtr)
    {
        IContactPtr contactPtr = callPtr->getCallee();
        if (contactPtr)
        {
            NSString* contactID = [NSString stringWithUTF8String:contactPtr->getContactID()];
            hopContact = [[OpenPeerStorageManager sharedStorageManager] getContactForId:contactID];
            if (!hopContact)
            {
                hopContact = [[[[HOPProvisioningAccount sharedProvisioningAccount] getSelfContact] getContactID] isEqualToString:contactID] ? [[HOPProvisioningAccount sharedProvisioningAccount] getSelfContact] : nil;
            }
        }
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    return hopContact;
}

- (BOOL) hasAudio
{
    BOOL ret = NO;
    if(callPtr)
    {
        ret = callPtr->hasAudio();
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    
    return ret;
}

- (BOOL) hasVideo 
{
    BOOL ret = NO;
    if(callPtr)
    {
        ret = callPtr->hasVideo();
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    
    return ret;
}

- (HOPCallStates) getState
{
    HOPCallStates hopCallStates = HOPCallStateNone;
    if(callPtr)
    {
        hopCallStates = (HOPCallStates)callPtr->getState();
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    
    return hopCallStates;
}


- (HOPCallClosedReasons) getClosedReason
{
    HOPCallClosedReasons hopCallClosedReasons = HOPCallClosedReasonNone;
    if(callPtr)
    {
        hopCallClosedReasons = (HOPCallClosedReasons)callPtr->getClosedReason();
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    
    return hopCallClosedReasons;
}


- (NSDate*) getCreationTime
{
    NSDate* date = nil;
    
    if(callPtr)
    {
        date = [OpenPeerUtility convertPosixTimeToDate:callPtr->getcreationTime()];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    return date;
}

- (NSDate*) getRingTime
{
    NSDate* date = nil;
    
    if(callPtr)
    {
        date = [OpenPeerUtility convertPosixTimeToDate:callPtr->getRingTime()];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    return date;
}

- (NSDate*) getAnswerTime
{
    NSDate* date = nil;
    
    if(callPtr)
    {
        date = [OpenPeerUtility convertPosixTimeToDate:callPtr->getAnswerTime()];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    return date;
}


- (NSDate*) getClosedTime
{
    NSDate* date = nil;
    
    if(callPtr)
    {
        date = [OpenPeerUtility convertPosixTimeToDate:callPtr->getClosedTime()];
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
    return date;
}

- (void) ring
{
    if(callPtr)
    {
        callPtr->ring();
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
}

- (void) answer
{
    if(callPtr)
    {
        callPtr->answer();
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
}


- (void) hold:(BOOL) hold
{
    if(callPtr)
    {
        callPtr->hold(hold);
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
}


- (void) hangup:(HOPCallClosedReasons) reason
{
    if(callPtr)
    {
        callPtr->hangup((hookflash::ICall::CallClosedReasons)reason);
    }
    else
    {
        [NSException raise:NSInvalidArgumentException format:@"Invalid OpenPeer call pointer!"];
    }
}

#pragma mark - Internal methods
- (ICallPtr) getCallPtr
{
    return callPtr;
}
@end

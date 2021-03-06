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

#import "UIKit/UIKit.h"
#import "ProvisioningAccountDelegate.h"
#import "OpenpeerSDK/HOPProvisioningAccount.h"
#import "LoginManager.h"
#import "OpenPeer.h"
#import "MainViewController.h"

@implementation ProvisioningAccountDelegate

//Provisioning account delegate implementation.

//This method handles account state changes from SDK.
- (void) onProvisioningAccountStateChanged:(HOPProvisioningAccount*) account accountStates:(HOPProvisioningAccountStates) state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoginManager sharedLoginManager];
        switch (state)
        {
            case HOPProvisioningAccountStatePending:
                
                break;
                
            case HOPProvisioningAccountStatePendingOAuthLogin:
                [[LoginManager sharedLoginManager] onLoginSocialUrlReceived:[account getOAuthURL]];
                break;
                
            case HOPProvisioningAccountStatePendingAuthorizationPIN:
                
                break;
                
            case HOPProvisioningAccountStateReady:
                [[LoginManager sharedLoginManager] onUserLoggedIn];
                break;
                
            case HOPProvisioningAccountStateShuttingDown:
                break;
            case HOPProvisioningAccountStateShutdown:
                //[[LoginManager sharedLoginManager] login];
                [[[OpenPeer sharedOpenPeer] mainViewController] showLoginView];
                break;
                
            default:
                break;
        }
    });
}

//This event is fired once account encounter error. After error, shutdown should be called.
- (void) onProvisioningAccountError:(HOPProvisioningAccount*) account errorCodes:(HOPProvisioningAccountErrorCodes) error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        });
}

//This event notifies that user profile information have changed, and that update is required.
- (void) onProvisioningAccountProfileChanged:(HOPProvisioningAccount*) account
{
    dispatch_async(dispatch_get_main_queue(), ^{
        });
}

//Result of the identity validation.
- (void) onProvisioningAccountIdentityValidationResult:(HOPProvisioningAccount*) account identity:(id) identity result:(HOPProvisioningAccountIdentityValidationResultCode) result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        });
}

@end

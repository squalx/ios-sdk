//
//  VoxboneDelegate.swift
//  VoxboneSDK
//
//  Created by Jerónimo Valli on 4/3/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation

@objc public protocol VoxboneDelegate : NSObjectProtocol {
    
    @objc optional func onLoginSuccessful(withDisplayName displayName: String!, andAuthParams authParams: [AnyHashable : Any]!)
    
    @objc optional func onLoginFailedWithErrorCode(_ errorCode: NSNumber!)
    
    @objc optional func onOneTimeKeyGenerated(_ key: String!)
    
    @objc optional func onRefreshTokenFailed(_ errorCode: NSNumber!)
    
    @objc optional func onRefreshTokenSuccess(_ authParams: [AnyHashable : Any]!)
    
    @objc optional func onConnectionSuccessful()
    
    @objc optional func onConnectionClosed()
    
    @objc optional func onConnectionFailedWithError(_ reason: String!)
    
    @objc optional func onCallConnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!)
    
    @objc optional func onCallDisconnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!)
    
    @objc optional func onCallRinging(_ callId: String!, withHeaders headers: [AnyHashable : Any]!)
    
    @objc optional func onCallFailed(_ callId: String!, withCode code: Int32, andReason reason: String!, withHeaders headers: [AnyHashable : Any]!)
    
    @objc optional func onCallAudioStarted(_ callId: String!)
    
    @objc optional func onNetStatsReceived(_ callId: String!, withPacketLoss packetLoss: NSNumber!)
}

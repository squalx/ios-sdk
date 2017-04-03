//
//  Voxbone+VoxImplantDelegate.swift
//  VoxboneSDK
//
//  Created by Jerónimo Valli on 4/3/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation
import VoxImplant

extension Voxbone: VoxImplantDelegate {
    
    public func onLoginSuccessful(withDisplayName displayName: String!, andAuthParams authParams: [AnyHashable : Any]!) {
        voxboneDelegate.onLoginSuccessful?(withDisplayName: username, andAuthParams: authParams)
    }
    
    public func onLoginFailedWithErrorCode(_ errorCode: NSNumber!) {
        voxboneDelegate.onLoginFailedWithErrorCode?(errorCode)
    }
    
    public func onOneTimeKeyGenerated(_ key: String!) {
        voxboneDelegate.onOneTimeKeyGenerated?(key)
    }
    
    public func onRefreshTokenFailed(_ errorCode: NSNumber!) {
        voxboneDelegate.onRefreshTokenFailed?(errorCode)
    }
    
    public func onRefreshTokenSuccess(_ authParams: [AnyHashable : Any]!) {
        voxboneDelegate.onRefreshTokenSuccess?(authParams)
    }
    
    public func onConnectionSuccessful() {
        voxboneDelegate.onConnectionSuccessful?()
    }
    
    public func onConnectionClosed() {
        voxboneDelegate.onConnectionClosed?()
    }
    
    public func onConnectionFailedWithError(_ reason: String!) {
        voxboneDelegate.onConnectionFailedWithError?(reason)
    }
    
    public func onCallConnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        voxboneDelegate.onCallConnected?(callId, withHeaders: headers)
    }
    
    public func onCallDisconnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        voxboneDelegate.onCallDisconnected?(callId, withHeaders: headers)
    }
    
    public func onCallRinging(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        voxboneDelegate.onCallRinging?(callId, withHeaders: headers)
    }
    
    public func onCallFailed(_ callId: String!, withCode code: Int32, andReason reason: String!, withHeaders headers: [AnyHashable : Any]!) {
        voxboneDelegate.onCallFailed?(callId, withCode: code, andReason: reason, withHeaders: headers)
    }
    
    public func onCallAudioStarted(_ callId: String!) {
        voxboneDelegate.onCallAudioStarted?(callId)
    }
    
    public func onNetStatsReceived(inCall callId: String!, withStats stats: UnsafePointer<VoxImplantNetworkInfo>!) {
        var packetLoss: UInt = 0
        if stats != nil {
            packetLoss = stats.pointee.packetLoss
        }
        voxboneDelegate.onNetStatsReceived?(callId, withPacketLoss: NSNumber(value: packetLoss))
    }
}

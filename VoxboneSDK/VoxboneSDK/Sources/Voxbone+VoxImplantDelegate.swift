//
//  Voxbone+VoxImplantDelegate.swift
//  VoxboneSDK
//
//  Created by Jerónimo Valli on 4/3/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation
import VoxImplant
import Flurry_iOS_SDK

extension Voxbone: VoxImplantDelegate {
    
    // MARK: - # Constants
    
    fileprivate struct Constants {
        struct Flurry {
            static let apiKey = "D2YQF4JBF69WYVR7VBCW"
            struct Event {
                static let userSession = "userSession"
                static let failedSession = "failedSession"
                static let outgoingCall = "outgoingCall"
                static let failedCall = "failedCall"
            }
        }
    }
    
    public func onLoginSuccessful(withDisplayName displayName: String!, andAuthParams authParams: [AnyHashable : Any]!) {
        Flurry.logEvent(Constants.Flurry.Event.userSession, timed: true)
        voxboneDelegate.onLoginSuccessful?(withDisplayName: user, andAuthParams: authParams)
    }
    
    public func onLoginFailedWithErrorCode(_ errorCode: NSNumber!) {
        Flurry.logEvent(Constants.Flurry.Event.failedSession)
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
        Flurry.endTimedEvent(Constants.Flurry.Event.userSession, withParameters: nil)
        voxboneDelegate.onConnectionClosed?()
    }
    
    public func onConnectionFailedWithError(_ reason: String!) {
        Flurry.logEvent(Constants.Flurry.Event.failedSession)
        voxboneDelegate.onConnectionFailedWithError?(reason)
    }
    
    public func onCallConnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        Flurry.logEvent(Constants.Flurry.Event.outgoingCall, timed: true)
        voxboneDelegate.onCallConnected?(callId, withHeaders: headers)
    }
    
    public func onCallDisconnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        Flurry.endTimedEvent(Constants.Flurry.Event.outgoingCall, withParameters: nil)
        voxboneDelegate.onCallDisconnected?(callId, withHeaders: headers)
    }
    
    public func onCallRinging(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        voxboneDelegate.onCallRinging?(callId, withHeaders: headers)
    }
    
    public func onCallFailed(_ callId: String!, withCode code: Int32, andReason reason: String!, withHeaders headers: [AnyHashable : Any]!) {
        Flurry.logEvent(Constants.Flurry.Event.failedCall)
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

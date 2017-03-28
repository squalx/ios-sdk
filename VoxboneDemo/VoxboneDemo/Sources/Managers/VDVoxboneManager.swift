//
//  VDVoxboneManager.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/20/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import VoxboneSDK

class VDVoxboneManager: NSObject {
    
    public typealias VDOnConnectionSuccessfulHandler = () -> Void
    public typealias VDOnConnectionFailedHandler = (_ error: Error) -> Void
    public typealias VDOnConnectionClosedHandler = () -> Void
    public typealias VDOnLoginSuccessfulHandler = (_ displayName: String, _ authParams: [AnyHashable : Any]) -> Void
    public typealias VDOnLoginFailedHandler = (_ errorCode: NSNumber) -> Void
    public typealias VDOnCallConnectedHandler = (_ callId: String, _ headers: [AnyHashable : Any]) -> Void
    public typealias VDOnCallDisconnectedHandler = (_ callId: String, _ headers: [AnyHashable : Any]) -> Void
    public typealias VDOnCallRingingHandler = (_ callId: String, _ headers: [AnyHashable : Any]) -> Void
    public typealias VDOnCallFailedHandler = (_ callId: String, _ code: Int32, _ reason: String, _ headers: [AnyHashable : Any]) -> Void
    public typealias VDOnCallAudioStartedHandler = (_ callId: String) -> Void
    public typealias VDOnNetStatsReceived = (_ callId: String, _ packetLoss: NSNumber) -> Void
    
    var wrapper: VBWrapper = VBWrapper.shared
    var callId: String? = nil
    var userName: String? = nil
    
    var connectionSuccessful: VDOnConnectionSuccessfulHandler? = nil
    var connectionFailed: VDOnConnectionFailedHandler? = nil
    var connectionClosed: VDOnConnectionClosedHandler? = nil
    var loginSuccessful: VDOnLoginSuccessfulHandler? = nil
    var loginFailed: VDOnLoginFailedHandler? = nil
    var callConnected: VDOnCallConnectedHandler? = nil
    var callDisconnected: VDOnCallDisconnectedHandler? = nil
    var callRinging: VDOnCallRingingHandler? = nil
    var callFailed: VDOnCallFailedHandler? = nil
    var callAudioStarted: VDOnCallAudioStartedHandler? = nil
    var netStatsReceived: VDOnNetStatsReceived? = nil
    
    // MARK: - # Singleton
    
    open static let shared = VDVoxboneManager()
    
    override init() {
        super.init()
        
        VBWrapper.setLogLevel(.VOXBONE_INFO_LOG_LEVEL)
        wrapper.setVoxboneDelegate(delegate: self)
    }
    
    public func connect(onConnectionSuccessful successful: VDOnConnectionSuccessfulHandler?, onConnectionFailed failed: VDOnConnectionFailedHandler?, onConnectionClosed closed: VDOnConnectionClosedHandler?) {
        connectionSuccessful = successful
        connectionFailed = failed
        connectionClosed = closed
        wrapper.connect(false)
    }
    
    public func close(onConnectionClosed closed: VDOnConnectionClosedHandler?) {
        connectionClosed = closed
        wrapper.closeConnection()
    }
    
    public func login(_ username: String, _ password: String, onLoginSuccessful successful: VDOnLoginSuccessfulHandler?, onLoginFailed failed: VDOnLoginFailedHandler?) {
        loginSuccessful = successful
        loginFailed = failed
        wrapper.login(withUsername: username, andPassword: password)
    }
    
    public func call(to: String, onCallConnected connected: VDOnCallConnectedHandler?, onCallDisconnected disconnected: VDOnCallDisconnectedHandler?, onCallRinging ringing: VDOnCallRingingHandler?, onCallFailed failed: VDOnCallFailedHandler?, onCallAudioStarted audioStarted: VDOnCallAudioStartedHandler?) {
        callConnected = connected
        callDisconnected = disconnected
        callRinging = ringing
        callFailed = failed
        callAudioStarted = audioStarted
        callId = wrapper.createCall(to, withVideo: false, andCustomData: "VoxboneDemo custom call data")
        if callId != nil, wrapper.attachAudio(to: callId!), wrapper.startCall(callId!, withHeaders: nil) {
            print("calling to \(to) - withCallId: \(callId!)")
        }
    }
    
    public func hangup(onCallDisconnected: VDOnCallDisconnectedHandler?) {
        callDisconnected = onCallDisconnected
        if callId != nil {
            if !wrapper.disconnectCall(callId!, withHeaders: nil) {
                callDisconnected?(callId!, [AnyHashable : Any]())
            }
        }
    }
    
    public func setMute(_ value: Bool) {
        wrapper.setMute(value)
    }
    
    public func setUseLoudspeaker(_ value: Bool) -> Bool {
        return wrapper.setUseLoudspeaker(value)
    }
    
    public func getCallDuration() -> TimeInterval {
        var duration: TimeInterval = 0.0
        if callId != nil {
            duration = wrapper.getCallDuration(callId!)
        }
        return duration
    }
}

extension VDVoxboneManager: VoxboneDelegate {
    
    public func onLoginSuccessful(withDisplayName displayName: String!, andAuthParams authParams: [AnyHashable : Any]!) {
        print("onLoginSuccessful: displayName - \(displayName)")
        userName = displayName
        loginSuccessful?(displayName, authParams)
    }
    
    public func onLoginFailedWithErrorCode(_ errorCode: NSNumber!) {
        print("onLoginFailedWithErrorCode: errorCode - \(errorCode)")
        userName = ""
        loginFailed?(errorCode)
    }
    
    public func onConnectionSuccessful() {
        print("onConnectionSuccessful")
        connectionSuccessful?()
    }
    
    public func onConnectionClosed() {
        print("onConnectionClosed")
        connectionClosed?()
    }
    
    public func onConnectionFailedWithError(_ reason: String!) {
        print("onConnectionFailedWithError: reason - \(reason)")
        connectionFailed?(NSError(domain: "", code: 400, userInfo: ["description": reason]) as Error)
    }
    
    public func onCallConnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallConnected: callId - \(callId)")
        callConnected?(callId, headers)
    }
    
    public func onCallDisconnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallDisconnected: callId - \(callId)")
        callDisconnected?(callId, headers)
    }
    
    public func onCallRinging(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallRinging: callId - \(callId)")
        callRinging?(callId, headers)
    }
    
    public func onCallFailed(_ callId: String!, withCode code: Int32, andReason reason: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallFailed: callId - \(callId) withCode - \(code) andReason - \(reason)")
        callFailed?(callId, code, reason, headers)
    }
    
    public func onCallAudioStarted(_ callId: String!) {
        print("onCallAudioStarted: callId - \(callId)")
        callAudioStarted?(callId)
    }
    
    public func onNetStatsReceived(_ callId: String!, withPacketLoss packetLoss: NSNumber!) {
        print("onNetStatsReceived: callId - \(callId) packetLoss - \(packetLoss)")
        netStatsReceived?(callId, packetLoss)
    }
}

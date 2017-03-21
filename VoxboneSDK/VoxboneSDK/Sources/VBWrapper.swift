//
//  VBWrapper.swift
//  VoxboneSDK
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import VoxImplant

public enum VoxboneLogLevel {
    case VOXBONE_ERROR_LOG_LEVEL
    case VOXBONE_INFO_LOG_LEVEL
    case VOXBONE_DEBUG_LOG_LEVEL
    case VOXBONE_TRACE_LOG_LEVEL
}

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
}

open class VBWrapper: NSObject {
    
    // MARK: - # Variables
    
    fileprivate var voxImplant: VoxImplant!
    fileprivate var voxboneDelegate: VoxboneDelegate!
    
    // MARK: - # Singleton
    
    open static let shared = VBWrapper()
    
    override init() {
        super.init()
        
        voxImplant = VoxImplant.getInstance()
        voxImplant.voxDelegate = self
    }
    
    // MARK: - # Logs
    
    open class func setLogLevel(_ logLevel: VoxboneLogLevel) {
        switch logLevel {
        case .VOXBONE_ERROR_LOG_LEVEL:
            VoxImplant.setLogLevel(ERROR_LOG_LEVEL)
        case .VOXBONE_INFO_LOG_LEVEL:
            VoxImplant.setLogLevel(INFO_LOG_LEVEL)
        case .VOXBONE_DEBUG_LOG_LEVEL:
            VoxImplant.setLogLevel(DEBUG_LOG_LEVEL)
        case .VOXBONE_TRACE_LOG_LEVEL:
            VoxImplant.setLogLevel(TRACE_LOG_LEVEL)
        }
    }
    
    // MARK: - # Delegate
    
    open func setVoxboneDelegate(delegate: VoxboneDelegate!) {
        voxboneDelegate = delegate
    }
    
    open func getVoxboneDelegate() -> VoxboneDelegate! {
        return voxboneDelegate
    }
    
    // MARK: - # Connection
    
    open func connect() {
        voxImplant.connect()
    }
    
    open func connect(_ connectivityCheck: Bool) {
        voxImplant.connect(connectivityCheck)
    }
    
    open func connect(to host: String!) {
        voxImplant.connect(to: host)
    }
    
    open func closeConnection() {
        voxImplant.closeConnection()
    }
    
    // MARK: - # Login
    
    open func login(withUsername user: String!, andPassword password: String!) {
        voxImplant.login(withUsername: user, andPassword: password)
    }
    
    open func login(withUsername user: String!, andOneTimeKey hash: String!) {
        voxImplant.login(withUsername: user, andOneTimeKey: hash)
    }
    
    open func login(withUsername user: String!, andToken token: String!) {
        voxImplant.login(withUsername: user, andToken: token)
    }
    
    open func refreshToken(withUsername user: String!, andToken token: String!) {
        voxImplant.refreshToken(withUsername: user, andToken: token)
    }
    
    open func requestOneTimeKey(withUsername user: String!) {
        voxImplant.requestOneTimeKey(withUsername: user)
    }
    
    // MARK: - # Call
    
    open func createCall(_ to: String!, withVideo video: Bool, andCustomData customData: String!) -> String! {
        return voxImplant.createCall(to, withVideo: video, andCustomData: customData)
    }
    
    open func startCall(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) -> Bool {
        return voxImplant.startCall(callId, withHeaders: headers)
    }
    
    open func attachAudio(to callId: String!) -> Bool {
        return voxImplant.attachAudio(to: callId)
    }
    
    open func disconnectCall(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) -> Bool {
        return voxImplant.disconnectCall(callId, withHeaders: headers)
    }
    
    open func declineCall(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        voxImplant.declineCall(callId, withHeaders: headers)
    }
    
    open func answerCall(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        voxImplant.answerCall(callId, withHeaders: headers)
    }
    
    // MARK: - # General Call Actions
    
    open func sendDTMF(_ callId: String!, digit: Int32) {
        voxImplant.sendDTMF(callId, digit: digit)
    }
    
    open func sendMessage(_ callId: String!, withText text: String!, andHeaders headers: [AnyHashable : Any]!) {
        voxImplant.sendMessage(callId, withText: text, andHeaders: headers)
    }
    
    open func sendInfo(_ callId: String!, withType mimeType: String!, content: String!, andHeaders headers: [AnyHashable : Any]!) {
        voxImplant.sendInfo(callId, withType: mimeType, content: content, andHeaders: headers)
    }
    
    open func setMute(_ b: Bool) {
        voxImplant.setMute(b)
    }
    
    open func setUseLoudspeaker(_ b: Bool) -> Bool {
        return voxImplant.setUseLoudspeaker(b)
    }
    
    open func getCallDuration(_ callId: String!) -> TimeInterval {
        return voxImplant.getCallDuration(callId)
    }
}

extension VBWrapper: VoxImplantDelegate {
    
    public func onLoginSuccessful(withDisplayName displayName: String!, andAuthParams authParams: [AnyHashable : Any]!) {
        voxboneDelegate.onLoginSuccessful?(withDisplayName: displayName, andAuthParams: authParams)
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
}

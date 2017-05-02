//
//  VDVoxboneManager.swift
//  VoxboneDemo
//
//  Created by Jerónimo Valli on 3/20/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import AVFoundation
import CallKit
import Foundation
import UIKit
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
    
    var voxbone: Voxbone = Voxbone.shared
    var phoneNumber: String? = nil
    var callId: String? = nil
    var userName: String? = nil
    var onLocalHangup: Bool = false
    var outgoingCall: UUID? = nil
    var provider: CXProvider
    let callController = CXCallController()
    var startCallAction: CXStartCallAction? = nil
    
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
    
    static var providerConfiguration: CXProviderConfiguration {
        let localizedName = NSLocalizedString("VoxboneDemo", comment: "VoxboneDemo")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
        
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        if let iconMaskImage = UIImage(named: "AppIcon60x60") {
            providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage)
        }
        
        return providerConfiguration
    }
    
    override init() {
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        super.init()
        
        Voxbone.setLogLevel(.VOXBONE_INFO_LOG_LEVEL)
        voxbone.setVoxboneDelegate(delegate: self)
        
        provider.setDelegate(self, queue: nil)
    }
    
    public func connect(onConnectionSuccessful successful: VDOnConnectionSuccessfulHandler?, onConnectionFailed failed: VDOnConnectionFailedHandler?, onConnectionClosed closed: VDOnConnectionClosedHandler?) {
        connectionSuccessful = successful
        connectionFailed = failed
        connectionClosed = closed
        voxbone.connect(false)
    }
    
    public func close(onConnectionClosed closed: VDOnConnectionClosedHandler?) {
        connectionClosed = closed
        voxbone.closeConnection()
    }
    
    public func login(_ username: String, _ password: String, onLoginSuccessful successful: VDOnLoginSuccessfulHandler?, onLoginFailed failed: VDOnLoginFailedHandler?) {
        loginSuccessful = successful
        loginFailed = failed
        var usernameArr = username.characters.split{$0 == "@"}.map(String.init)
        voxbone.loginToVoxbone(withUsername: usernameArr[0], andAppName: usernameArr[1], andPassword: password)
    }
    
    public func call(to: String, onCallConnected connected: VDOnCallConnectedHandler?, onCallDisconnected disconnected: VDOnCallDisconnectedHandler?, onCallRinging ringing: VDOnCallRingingHandler?, onCallFailed failed: VDOnCallFailedHandler?, onCallAudioStarted audioStarted: VDOnCallAudioStartedHandler?) {
        
        cleanCall()
        callConnected = connected
        callDisconnected = disconnected
        callRinging = ringing
        callFailed = failed
        callAudioStarted = audioStarted
        phoneNumber = to
        if !VDConstants.Platform.isSimulator {
            outgoingCall = UUID()
            let handle = CXHandle(type: .phoneNumber, value: phoneNumber!)
            let startCallAction = CXStartCallAction(call: outgoingCall!, handle: handle)
            startCallAction.isVideo = false
            let transaction = CXTransaction()
            transaction.addAction(startCallAction)
            callController.request(transaction) { error in
                if let error = error {
                    print("Error requesting transaction: \(error)")
                } else {
                    print("Requested transaction successfully")
                }
            }
        } else {
            callId = voxbone.createVoxboneCall(phoneNumber!, withUsername: VDConstants.Voxbone.Credentials.username, andPassword: VDConstants.Voxbone.Credentials.password)
            if callId != nil, voxbone.attachAudio(to: callId!), voxbone.startCall(callId!, withHeaders: nil) {
                print("calling to \(phoneNumber!) - withCallId: \(callId!)")
            }
        }
    }
    
    public func hangup(onCallDisconnected: VDOnCallDisconnectedHandler?) {
        
        onLocalHangup = true
        callDisconnected = onCallDisconnected
        if !VDConstants.Platform.isSimulator, outgoingCall != nil {
            let endCallAction = CXEndCallAction(call: outgoingCall!)
            let transaction = CXTransaction()
            transaction.addAction(endCallAction)
            callController.request(transaction) { error in
                if let error = error {
                    print("Error requesting transaction: \(error)")
                } else {
                    print("Requested transaction successfully")
                }
            }
        } else if callId != nil {
            if !voxbone.disconnectCall(callId!, withHeaders: nil) {
                callDisconnected?(callId!, [AnyHashable : Any]())
            }
        }
    }
    
    public func setMute(_ value: Bool) {
        voxbone.setMute(value)
    }
    
    public func setUseLoudspeaker(_ value: Bool) -> Bool {
        return voxbone.setUseLoudspeaker(value)
    }
    
    public func getCallDuration() -> TimeInterval {
        var duration: TimeInterval = 0.0
        if callId != nil {
            duration = voxbone.getCallDuration(callId!)
        }
        return duration
    }
    
    public func sendDTMF(digit: Int32) {
        if callId != nil {
            voxbone.sendDTMF(callId, digit: digit)
        }
    }
    
    fileprivate func cleanCall() {
        onLocalHangup = false
        startCallAction = nil
        outgoingCall = nil
    }
    
    public func postRatingToVoxbone(_ rating: NSNumber, andComments comments: String, andResponse ratingResponse: ((_ result: String?, _ error: Error?) -> Void)?) {
        
        voxbone.postRatingToVoxbone(callId!, withPhone: phoneNumber!, andRating: rating, andComments: comments, andResponse: { (result: String?, error: Error?) in
            self.callId = nil
            self.phoneNumber = nil
            ratingResponse?(result, error)
        })
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
        if errorCode == nil {
            loginFailed?(NSNumber(value: 0))
        } else {
            loginFailed?(errorCode)
        }
    }
    
    public func onConnectionSuccessful() {
        print("onConnectionSuccessful")
        connectionSuccessful?()
    }
    
    public func onConnectionClosed() {
        print("onConnectionClosed")
        if !VDConstants.Platform.isSimulator, startCallAction != nil {
            startCallAction!.fail()
        }
        cleanCall()
        connectionClosed?()
    }
    
    public func onConnectionFailedWithError(_ reason: String!) {
        print("onConnectionFailedWithError: reason - \(reason)")
        connectionFailed?(NSError(domain: "", code: 400, userInfo: ["localizedDescription": reason]) as Error)
    }
    
    public func onCallConnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallConnected: callId - \(callId)")
        if !VDConstants.Platform.isSimulator, startCallAction != nil {
            startCallAction!.fulfill()
            provider.reportOutgoingCall(with: startCallAction!.uuid, connectedAt: nil)
        }
        callConnected?(callId, headers)
    }
    
    public func onCallDisconnected(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallDisconnected: callId - \(callId)")
        if !VDConstants.Platform.isSimulator, startCallAction != nil, !onLocalHangup {
            provider.reportCall(with: startCallAction!.callUUID, endedAt: nil, reason: .remoteEnded)
        }
        cleanCall()
        callDisconnected?(callId, headers)
    }
    
    public func onCallRinging(_ callId: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallRinging: callId - \(callId)")
        callRinging?(callId, headers)
    }
    
    public func onCallFailed(_ callId: String!, withCode code: Int32, andReason reason: String!, withHeaders headers: [AnyHashable : Any]!) {
        print("onCallFailed: callId - \(callId) withCode - \(code) andReason - \(reason)")
        if !VDConstants.Platform.isSimulator, startCallAction != nil {
            startCallAction!.fail()
        }
        cleanCall()
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

extension VDVoxboneManager: CXProviderDelegate {
    
    public func providerDidReset(_ provider: CXProvider) {
        
    }
    
    public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("provider start call action")
        
        if action.callUUID == outgoingCall {
            startCallAction = action
            provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: nil)
            callId = voxbone.createVoxboneCall(action.handle.value, withUsername: VDConstants.Voxbone.Credentials.username, andPassword: VDConstants.Voxbone.Credentials.password)
            if callId != nil, voxbone.attachAudio(to: callId!), voxbone.startCall(callId!, withHeaders: nil) {
                print("calling to \(action.handle.value) - withCallId: \(callId!)")
            }
        }
    }
    
    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("provider end call action")
        
        if action.callUUID == outgoingCall {
            action.fulfill()
            if callId != nil, !voxbone.disconnectCall(callId!, withHeaders: nil) {
                callDisconnected?(callId!, [AnyHashable : Any]())
            }
        }
    }
    
    public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("provider audioSession didActivate")
    }
    
    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("provider audioSession didDeactivate")
    }
    
    public func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("Timed out \(#function)")
    }
}

//
//  VBWrapper.swift
//  VoxboneSDK
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation
import VoxImplant

open class VBWrapper: NSObject {
    
    // MARK: - # Variables
    
    fileprivate var voxImplant: VoxImplant!
    
    // MARK: - # Singleton
    
    open static let shared = VBWrapper()
    
    override init() {
        super.init()
        
        voxImplant = VoxImplant.getInstance()
    }
    
    // MARK: - # Logs
    
    open class func setLogLevel(_ logLevel: VoxImplantLogLevel) {
        VoxImplant.setLogLevel(logLevel)
    }
    
    // MARK: - # Delegate
    
    open func getVoxDelegate() -> VoxImplantDelegate! {
        return voxImplant.getVoxDelegate()
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

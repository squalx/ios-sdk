//
//  Voxbone.swift
//  VoxboneSDK
//
//  Created by Jerónimo Valli on 3/4/17.
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation
import VoxImplant
import Alamofire
import SwiftyJSON

public enum VoxboneLogLevel {
    case VOXBONE_ERROR_LOG_LEVEL
    case VOXBONE_INFO_LOG_LEVEL
    case VOXBONE_DEBUG_LOG_LEVEL
    case VOXBONE_TRACE_LOG_LEVEL
}

open class Voxbone: NSObject {
    
    // MARK: - # Constants
    
    fileprivate struct Constants {
        struct VoxImplant {
            struct Credentials {
                static let username = "test1@voxbonedemo.voxboneworkshop.voximplant.com"
                static let password = "123456"
            }
        }
        struct Voxbone {
            struct Credentials {
                static let username = "workshopdev"
                static let password = "cmtOM1yQ!tU4"
            }
            struct API {
                struct Url {
                    static let authentication = "https://cdn.voxbone.com/authentication/basicToken"
                }
                struct Parameter {
                    static let username = "username"
                    static let key = "key"
                    static let timestamp = "timestamp"
                    static let jsonp = "jsonp"
                    static let error = "error"
                    static let number = "number"
                }
                struct ParameterValue {
                    static let processAuthData = "voxbone.WebRTC.processAuthData"
                }
                struct Header {
                    static let contentType = "Content-Type"
                    static let charset = "charset"
                }
                struct HeaderValue {
                    static let applicationFormUrlEncoded = "application/x-www-form-urlencoded"
                    static let utf8 = "UTF-s"
                }
            }
        }
    }
    
    // MARK: - # Variables
    
    fileprivate var voxImplant: VoxImplant!
    
    var voxboneDelegate: VoxboneDelegate!
    var username: String = ""
    var password: String = ""
    
    // MARK: - # Singleton
    
    open static let shared = Voxbone()
    
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
    
    open func loginToVoxbone() {
        self.loginToVoxbone(withUsername: Constants.Voxbone.Credentials.username, andPassword: Constants.Voxbone.Credentials.password)
    }
    
    open func loginToVoxbone(withUsername user: String!, andPassword password: String!) {
        let headers = [Constants.Voxbone.API.Header.contentType: Constants.Voxbone.API.HeaderValue.applicationFormUrlEncoded,
                       Constants.Voxbone.API.Header.charset: Constants.Voxbone.API.HeaderValue.utf8]
        let parameters: Parameters = [Constants.Voxbone.API.Parameter.username: user,
                                      Constants.Voxbone.API.Parameter.key: password,
                                      Constants.Voxbone.API.Parameter.timestamp: String(Date().ticks),
                                      Constants.Voxbone.API.Parameter.jsonp: Constants.Voxbone.API.ParameterValue.processAuthData]
        
        Alamofire.request(Constants.Voxbone.API.Url.authentication, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .response { response in
                
                if let data = response.data, let responseString = String(data:data, encoding:.utf8) {
                    var jsonString = responseString.replacingOccurrences(of: "\(Constants.Voxbone.API.ParameterValue.processAuthData)(", with: "")
                    jsonString = jsonString.replacingOccurrences(of: ")", with: "")
                    jsonString = jsonString.replacingOccurrences(of: ";", with: "")
                    if let jsonData = jsonString.data(using: .utf8) {
                        let json = JSON(jsonData)
                        print("\(json)")
                        for (key,subJson):(String, JSON) in json {
                            print("\(key): \(subJson)")
                        }
                        if json[Constants.Voxbone.API.Parameter.error] != .null {
                            self.voxboneDelegate.onLoginFailedWithErrorCode?(nil)
                        } else {
                            self.voxboneDelegate.onLoginSuccessful?(withDisplayName: self.username, andAuthParams: [AnyHashable : Any]())
                        }
                    }
                } else if let error = response.error as NSError? {
                    print("error: \(error.description)")
                    self.voxboneDelegate.onLoginFailedWithErrorCode?(NSNumber(value: error.code))
                } else {
                    print("no response")
                    self.voxboneDelegate.onLoginFailedWithErrorCode?(nil)
                }
        }
    }
    
    open func loginAndStoreCredentialsForVoxboneCall(withUsername user: String!, andPassword password: String!) {
        self.username = user
        self.password = password
        self.login(withUsername: Constants.VoxImplant.Credentials.username, andPassword: Constants.VoxImplant.Credentials.password)
    }
    
    open func login(withUsername user: String!, andPassword password: String!) {
        self.voxImplant.login(withUsername: user, andPassword: password)
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
    
    open func createVoxboneCall(_ to: String!) -> String! {
        var customData = ""
        if !self.username.isEmpty, !self.password.isEmpty {
            customData = "{\"\(Constants.Voxbone.API.Parameter.username)\":\"\(self.username)\",\"\(Constants.Voxbone.API.Parameter.key)\":\"\(self.password)\"}"
            print(customData)
        }
        return voxImplant.createCall(to, withVideo: false, andCustomData: customData)
    }
    
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

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

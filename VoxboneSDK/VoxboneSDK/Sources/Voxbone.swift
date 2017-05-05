//
//  Voxbone.swift
//  VoxboneSDK
//
//  Copyright © 2017 Voxbone. All rights reserved.
//

import Foundation
import VoxImplant
import Alamofire
import SwiftyJSON
import Flurry_iOS_SDK

public enum VoxboneLogLevel {
    case VOXBONE_ERROR_LOG_LEVEL
    case VOXBONE_INFO_LOG_LEVEL
    case VOXBONE_DEBUG_LOG_LEVEL
    case VOXBONE_TRACE_LOG_LEVEL
}

open class Voxbone: NSObject {
    
    // MARK: - # Constants
    
    fileprivate struct Constants {
        struct Voxbone {
            struct Credentials {
                static let appHost = "voxboneworkshop.voximplant.com" //default app host - do not change
            }
            struct API {
                struct Url {
                    static let basicToken = "https://cdn.voxbone.com/authentication/basicToken"
                    static let tokenGenerator = "https://voxbone-auth.herokuapp.com/auth-json.php"
                    static let createToken = "https://cdn.voxbone.com/authentication/createToken"
                    static let log = "https://webrtc.voxbone.com/cgi-bin/post_logs.pl"
                }
                struct Parameter {
                    static let username = "username"
                    static let password = "password"
                    static let key = "key"
                    static let timestamp = "timestamp"
                    static let expires = "expires"
                    static let jsonp = "jsonp"
                    static let error = "error"
                    static let number = "number"
                    static let context = "context"
                    static let log = "log"
                    static let callid = "callid"
                    static let e164 = "e164"
                    static let url = "url"
                    static let rating = "rating"
                    static let comment = "comment"
                    static let tokenuser = "tokenuser"
                    static let tokenpassword = "tokenpassword"
                    static let callerId = "callerId"
                }
                struct ParameterValue {
                    static let processAuthData = "voxbone.WebRTC.processAuthData"
                    static let string = "string"
                    static let logsPosted = "webrtc logs posted to the backend"
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
        struct Flurry {
            static let apiKey = "D2YQF4JBF69WYVR7VBCW"
            struct Event {
                static let userSession = "userSession"
                static let failedUserLoggin = "failedUserLoggin"
                static let outgoingCall = "outgoingCall"
                static let failedCall = "failedCall"
            }
        }
    }
    
    // MARK: - # Variables
    
    fileprivate var voxImplant: VoxImplant!
    fileprivate var voxboneUsername: String = ""
    fileprivate var voxbonePassword: String = ""
    fileprivate var voxboneLogUrl: String = Constants.Voxbone.API.Url.log
    
    var voxboneDelegate: VoxboneDelegate!
    var username: String = ""
    var password: String = ""
    var user: String = ""
    var secret: String = ""
    var appName: String = ""
    
    // MARK: - # Singleton
    
    open static let shared = Voxbone()
    
    override init() {
        super.init()
        
        voxImplant = VoxImplant.getInstance()
        voxImplant.voxDelegate = self
        
        Flurry.startSession(Constants.Flurry.apiKey, with: FlurrySessionBuilder.init().withLogLevel(FlurryLogLevelCriticalOnly).withCrashReporting(true))
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
    
    open func loginToVoxbone(withUsername username: String!, andPassword password: String!, andUser user: String!, andAppName appName: String!, andSecret secret: String!) {
        self.username = username
        self.password = password
        self.user = user
        self.secret = secret
        self.appName = appName
        
        Alamofire.request(Constants.Voxbone.API.Url.tokenGenerator, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil)
            .response { response in
                
                if let data = response.data {
                    let json = JSON(data)
                    print("\(json)")
                    if let username = json[Constants.Voxbone.API.Parameter.username].string, let key = json[Constants.Voxbone.API.Parameter.key].string, let expires = json[Constants.Voxbone.API.Parameter.expires].number {
                        self.createTokenVoxbone(username: username, key: key, expires: expires)
                    } else {
                        self.voxboneDelegate.onLoginFailedWithErrorCode?(nil)
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
    
    fileprivate func createTokenVoxbone(username: String, key: String, expires: NSNumber) {
        
        let headers = [Constants.Voxbone.API.Header.contentType: Constants.Voxbone.API.HeaderValue.applicationFormUrlEncoded,
                       Constants.Voxbone.API.Header.charset: Constants.Voxbone.API.HeaderValue.utf8]
        let parameters: Parameters = [Constants.Voxbone.API.Parameter.username: username,
                                      Constants.Voxbone.API.Parameter.key: key,
                                      Constants.Voxbone.API.Parameter.expires: expires,
                                      Constants.Voxbone.API.Parameter.timestamp: String(Date().ticks),
                                      Constants.Voxbone.API.Parameter.jsonp: Constants.Voxbone.API.ParameterValue.processAuthData]
        
        Alamofire.request(Constants.Voxbone.API.Url.createToken, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .response { response in
                
                if let data = response.data, let responseString = String(data:data, encoding:.utf8) {
                    var jsonString = responseString.replacingOccurrences(of: "\(Constants.Voxbone.API.ParameterValue.processAuthData)(", with: "")
                    jsonString = jsonString.replacingOccurrences(of: ")", with: "")
                    jsonString = jsonString.replacingOccurrences(of: ";", with: "")
                    if let jsonData = jsonString.data(using: .utf8) {
                        let json = JSON(jsonData)
                        print("\(json)")
                        if json[Constants.Voxbone.API.Parameter.error] != .null {
                            self.voxboneDelegate.onLoginFailedWithErrorCode?(nil)
                        } else {
                            if let username = json[Constants.Voxbone.API.Parameter.username].string {
                                self.voxboneUsername = username
                            }
                            if let password = json[Constants.Voxbone.API.Parameter.password].string {
                                self.voxbonePassword = password
                            }
                            if let log = json[Constants.Voxbone.API.Parameter.log].arrayObject as? [String], let logUrl = log.first {
                                self.voxboneLogUrl = logUrl
                            }
                            self.login(withUsername: "\(self.user)@\(self.appName).\(Constants.Voxbone.Credentials.appHost)", andPassword: self.secret)
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
    
    open func basicLoginToVoxbone(withUsername username: String!, andPassword password: String!, andUser user: String!, andAppName appName: String!, andSecret secret: String!) {
        self.username = username
        self.password = password
        self.user = user
        self.secret = secret
        self.appName = appName
        
        let headers = [Constants.Voxbone.API.Header.contentType: Constants.Voxbone.API.HeaderValue.applicationFormUrlEncoded,
                       Constants.Voxbone.API.Header.charset: Constants.Voxbone.API.HeaderValue.utf8]
        let parameters: Parameters = [Constants.Voxbone.API.Parameter.username: username,
                                      Constants.Voxbone.API.Parameter.key: password,
                                      Constants.Voxbone.API.Parameter.timestamp: String(Date().ticks),
                                      Constants.Voxbone.API.Parameter.jsonp: Constants.Voxbone.API.ParameterValue.processAuthData]
        
        Alamofire.request(Constants.Voxbone.API.Url.basicToken, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .response { response in
                
                if let data = response.data, let responseString = String(data:data, encoding:.utf8) {
                    var jsonString = responseString.replacingOccurrences(of: "\(Constants.Voxbone.API.ParameterValue.processAuthData)(", with: "")
                    jsonString = jsonString.replacingOccurrences(of: ")", with: "")
                    jsonString = jsonString.replacingOccurrences(of: ";", with: "")
                    if let jsonData = jsonString.data(using: .utf8) {
                        let json = JSON(jsonData)
                        print("\(json)")
                        if json[Constants.Voxbone.API.Parameter.error] != .null {
                            self.voxboneDelegate.onLoginFailedWithErrorCode?(nil)
                        } else {
                            if let username = json[Constants.Voxbone.API.Parameter.username].string {
                                self.voxboneUsername = username
                            }
                            if let password = json[Constants.Voxbone.API.Parameter.password].string {
                                self.voxbonePassword = password
                            }
                            if let log = json[Constants.Voxbone.API.Parameter.log].arrayObject as? [String], let logUrl = log.first {
                                self.voxboneLogUrl = logUrl
                            }
                            self.login(withUsername: "\(self.user)@\(self.appName).\(Constants.Voxbone.Credentials.appHost)", andPassword: self.secret)
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
    
    open func postRatingToVoxbone(_ callId: String, withPhone phone: String, andRating rating: NSNumber, andComments comments: String, andResponse ratingResponse: ((_ result: String?, _ error: Error?) -> Void)?) {
        let headers = [Constants.Voxbone.API.Header.contentType: Constants.Voxbone.API.HeaderValue.applicationFormUrlEncoded,
                       Constants.Voxbone.API.Header.charset: Constants.Voxbone.API.HeaderValue.utf8]
        let parameters: Parameters = [Constants.Voxbone.API.Parameter.username: voxboneUsername,
                                      Constants.Voxbone.API.Parameter.password: voxbonePassword,
                                      Constants.Voxbone.API.Parameter.callid: callId,
                                      Constants.Voxbone.API.Parameter.e164: phone,
                                      Constants.Voxbone.API.Parameter.rating: rating,
                                      Constants.Voxbone.API.Parameter.comment: comments,
                                      Constants.Voxbone.API.Parameter.url: "iOSVoxboneSDK",
                                      Constants.Voxbone.API.Parameter.jsonp: Constants.Voxbone.API.ParameterValue.processAuthData]
        
        Alamofire.request(voxboneLogUrl, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .response { response in
                print(response)
                if let data = response.data {
                    ratingResponse?(String(data:data, encoding:.utf8), response.error)
                } else {
                    ratingResponse?(nil, response.error)
                }
        }
    }
    
    fileprivate func login(withUsername user: String!, andPassword password: String!) {
        self.voxImplant.login(withUsername: user, andPassword: password)
    }
    
    fileprivate func login(withUsername user: String!, andOneTimeKey hash: String!) {
        voxImplant.login(withUsername: user, andOneTimeKey: hash)
    }
    
    fileprivate func login(withUsername user: String!, andToken token: String!) {
        voxImplant.login(withUsername: user, andToken: token)
    }
    
    fileprivate func refreshToken(withUsername user: String!, andToken token: String!) {
        voxImplant.refreshToken(withUsername: user, andToken: token)
    }
    
    fileprivate func requestOneTimeKey(withUsername user: String!) {
        voxImplant.requestOneTimeKey(withUsername: user)
    }
    
    // MARK: - # Call
    
    open func createVoxboneCall(_ to: String!, callerId: String="VoxboneiOS") -> String! {
        let customData = "{\"\(Constants.Voxbone.API.Parameter.tokenuser)\":\"\(self.voxboneUsername)\",\"\(Constants.Voxbone.API.Parameter.tokenpassword)\":\"\(self.voxbonePassword)\",\"\(Constants.Voxbone.API.Parameter.context)\":\"\(Constants.Voxbone.API.ParameterValue.string)\",\"\(Constants.Voxbone.API.Parameter.callerId)\":\"\(callerId)\"}"
        print(customData)
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

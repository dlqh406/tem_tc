import Flutter
import UIKit
import CallKit
import AVFoundation
import NotificationCenter

public class SwiftFlutterIncomingCallPlugin: NSObject, FlutterPlugin {
    
    private static let SETTINGS_KEY = "FlutterIncomingCallSettings"
    
    private var channel: FlutterMethodChannel? = nil
    private var eventChannel: FlutterEventChannel? = nil
    
    private var eventStreamHandler: EventStreamHandler? = nil
    
    private var osVersion: OperatingSystemVersion? = nil

    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterIncomingCallPlugin()
        instance.channel = FlutterMethodChannel(name: "flutter_incoming_call", binaryMessenger: registrar.messenger())
        instance.eventChannel = FlutterEventChannel(name: "flutter_incoming_call_events", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel!)
        instance.eventStreamHandler = EventStreamHandler()
        instance.eventChannel?.setStreamHandler(instance.eventStreamHandler as? FlutterStreamHandler & NSObjectProtocol)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setCallData":
            guard let args = call.arguments else {
                result(nil)
                return
            }
            if let myArgs = args as? [String: Any] {
                let callData = myArgs["callData"] as! String
                let callDirManager = CXCallDirectoryManager.sharedInstance
                callDirManager.reloadExtension(withIdentifier: "com.teamCall.callExtHandler") { (error) in
                    if (error == nil){
                       print("success!")
                    }else{
                       print("error")
                    }
                }
                saveUserData(strData:callData)
                print(callData)
            }
            result(nil)
            break
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    // Group의 UserDefaults에 DB 데이터를 저장합니다.
    func saveUserData(strData:String){
        let userDefaults = UserDefaults(suiteName: "group.com.team_call.callkit")
        let userData = loadJsonFile(strValue:strData)
        try? userDefaults?.set(PropertyListEncoder().encode(userData), forKey: "dbData")
    }

    // DB Data load Json File
    func loadJsonFile(strValue:String) -> Array<UserData>{
        var dbData: Array<UserData> = Array<UserData>()
        do {
            let data = Data(strValue.utf8)
            let json = try JSONSerialization.jsonObject(with: data, options: [])


            if let objects = json as? [Any]{
                for object in objects {
                    dbData.append(UserData.dataFormJSONObject(json: object as! [String : AnyObject])!)
                }
            } else{
                print("JSON is invalid")
            }
        }  catch {
            print(error.localizedDescription)
        }
        return dbData
    }
/*
    func saveConfig(_ config: Config) {
        UserDefaults.standard.set(config.toMap(), forKey: SwiftFlutterIncomingCallPlugin.SETTINGS_KEY)
        UserDefaults.standard.synchronize()
    }
*/
    func sendEvent(_ event: String, _ body: [String : Any]) {
        eventStreamHandler?.send(event, body)
    }

}

class UserData : Codable{
    var phoneNumber: String = ""
    var name: String = ""

    init(phoneNumber: String, name : String){
        self.phoneNumber = phoneNumber
        self.name = name
    }

    public static func dataFormJSONObject(json: [String: AnyObject]) -> UserData? {
        guard
            let phoneNumber = json["phoneNumber"] as? String,
            let name = json["name"] as? String
            else {
                return nil
        }
        let data = UserData(phoneNumber: phoneNumber, name: name)

        return data
    }
}
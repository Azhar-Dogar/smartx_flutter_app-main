import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      GMSServices.provideAPIKey("AIzaSyCNNmfTGsBatXy77JEAcjxuHCR2WSxVhvg")
          
    GeneratedPluginRegistrant.register(with:  self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
//class MyMethodChannel: NSObject, FlutterPlugin {
//    private var channel: FlutterMethodChannel?
//
//    static func register(with registrar: FlutterPluginRegistrar) {
//        let channel = FlutterMethodChannel(name: "samples.flutter.dev/battery", binaryMessenger: registrar.messenger())
//        let instance = MyMethodChannel()
//        instance.channel = channel
//        registrar.addMethodCallDelegate(instance, channel: channel)
//        check(with: channel)
//        
//    }
//    
//    static func check(with channel : FlutterMethodChannel){
//        print("function callll")
//        ZHJBLEManagerProvider.shared.bluetoothProviderManagerStateDidUpdate { (state) in
//            print(state)
//            if state == .poweredOn {
//                channel.invokeMethod("onBluetoothStateChange", arguments: true)
//
//            }
//        }
//       
//        ZHJBLEManagerProvider.shared.scan(seconds: 5) {(devices) in
//            print(devices.count)
//            
//            
//            channel.invokeMethod("onBluetoothStateChange", arguments: true)
//
//        }
//    }
//    
//    
//    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//        switch call.method {
//        case "myMethod":
//            // Perform custom logic
//            result("")
//        case "myMethod2":
//            result(["data","data2"])
//        default:
//            result(FlutterMethodNotImplemented)
//        }
//    }
//}
//
//extension AppDelegate
//{
//    
//    
//    private func getSomeData(result:FlutterResult){
//        
//    }
//    private func receiveBatteryLevel(result: FlutterResult) {
//        
//        
//        let device = UIDevice.current
//        
//        device.isBatteryMonitoringEnabled = true
//        if device.batteryState == UIDevice.BatteryState.unknown {
//            result(FlutterError(code: "UNAVAILABLE",
//                                message: "Battery  not available. \(device.model)",
//                                details: nil))
//        } else {
//            
//            
//            ZHJBLEManagerProvider.shared.scan(seconds: 5.0) {[weak self] (devices) in
//                guard let `self` = self else { return }
//                print(devices.count)
//                
//
//            }
//            
//            debugPrint("in debug print 2")
//            print("print-----")
//            result(2)
//
//            
//        }
//    }
//}
//    
////    private func getDeviceCount(result: FlutterResult){
////        ZHJBLEManagerProvider.shared.scan(seconds: 5.0) {[weak self] (devices) in
////            guard let `self` = self else { return }
////            print(devices.count)
////
////
////            result(2)
////
////
////        }
////        //开始准备搜索(Start preparing to scan the device)
////        func bluetoothPrepare() {
////
////        }
////    }
//
//

import Flutter
import UIKit
import AMapFoundationKit

public class SwiftAmapViewMukaPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
//    let channel = FlutterMethodChannel(name: "amap_view_muka", binaryMessenger: registrar.messenger())
//    let instance = SwiftAmapViewMukaPlugin()
//    registrar.addMethodCallDelegate(instance, channel: channel)
    
      AMapServices.shared().enableHTTPS = true
      let instance = AmapViewFactory(withMessenger: registrar)
      registrar.register(instance, withId: "plugins.muka.com/amap_view_muka")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      let apiKey = (Bundle.main.infoDictionary?["GOOGLE_API_KEY"] as? String) ?? ""
      GMSServices.provideAPIKey(apiKey)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

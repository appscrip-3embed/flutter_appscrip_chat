import UIKit
import Flutter
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
       UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
     }
    GMSServices.provideAPIKey("AIzaSyC2YXqs5H8QSfN1NVsZKsP11XLZhfGVGPI")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}




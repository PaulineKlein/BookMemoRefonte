import UIKit
import Flutter
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
      Analytics.setAnalyticsCollectionEnabled(true)
      Crashlytics.crashlytics().checkForUnsentReports { _ in
          Crashlytics.crashlytics().sendUnsentReports()
      }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

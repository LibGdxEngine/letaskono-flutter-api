import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  NotificationCenter.default.addObserver(
              self,
              selector: #selector(detectScreenCapture),
              name: UIScreen.capturedDidChangeNotification,
              object: nil
          )
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @objc func detectScreenCapture() {
          if UIScreen.main.isCaptured {
              // Handle screen capture detected
              print("Screen capture detected!")
              // Optional: Blur or hide sensitive content
          } else {
              // Handle screen capture stopped
              print("Screen capture stopped!")
          }
      }
}

//
//  AppDelegate.swift
//  Rave
//
//  Created by Developer on 30.07.2021.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch {
            print(error)
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        NotificationCenter.default.addObserver(self, selector: #selector(onAudioRouteChange(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainNavVC") as! UINavigationController
        if (!appService.properties.isAuthed) {
            
            let loginVC = UIStoryboard(name: "Auth", bundle: nil).instantiateViewController(withIdentifier: LoginVC.className) as! LoginVC
            navVc.setViewControllers([loginVC], animated: false)
        }
        
        self.window?.rootViewController = navVc
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if let g_window = application.windows.first
        {
            g_window.rootViewController?.view.endEditing(true)
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if (!playerQueue.playing) {
            let result = playerQueue.pauseTrack(force: true)
            #if DEBUG
            print("Audio session has paused state. Refresh paused UI state:" + String(result))
            #endif
        }
    }

    @objc fileprivate func onAudioRouteChange(_ notification:Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue)
        else {return}
        if (reason == .oldDeviceUnavailable) {
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for output in previousRoute.outputs {
                    if output.portType == AVAudioSession.Port.headphones || output.portType == AVAudioSession.Port.airPlay || output.portType == AVAudioSession.Port.bluetoothA2DP {
                        let result = playerQueue.pauseTrack(force: true)
                        #if DEBUG
                        print("Old audio route unavailable. Pausing audio:" + String(result))
                        #endif
                        break
                    }
                }
            }
        }
    }
}


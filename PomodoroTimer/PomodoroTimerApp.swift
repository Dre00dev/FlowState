//
//  PomodoroTimerApp.swift
//  PomodoroTimer
//
//  Created by Andres Pulgarin on 4/4/23.
//

import SwiftUI


@main
struct PomodoroTimerApp: App {
    @StateObject var timerManager = TimerManager()
    @State var isShowingSplash = true
    let center = UNUserNotificationCenter.current()
        
        init() {
            center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
                if error != nil {
                    // Handle the error here.
                }
                // Enable or disable features based on the authorization.
            })
        }
    var body: some Scene {
        WindowGroup {
            if isShowingSplash{
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isShowingSplash = false
                        }
                    }
                } else {
                    NavigationView{
                        SettingsView()
                            .environmentObject(timerManager)
                }
            }
        }
    }
}

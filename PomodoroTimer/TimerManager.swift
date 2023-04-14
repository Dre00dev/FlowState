//
//  TimerManager.swift
//  PomodoroTimer
//
//  Created by Andres Pulgarin on 4/13/23.
//

import Foundation

import SwiftUI

class TimerManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate{
    @Published var focusSessionDuration: TimeInterval = 1500 // 25 minutes
    @Published var breakSessionDuration: TimeInterval = 300 // 5 minutes
    @Published var timerDuration: TimeInterval = 1500 // in seconds   int
    @Published var isResting: Bool = false
    @Published var isPaused: Bool = true
    
    @Published var timer: Timer?
    @Published var showingAlert = false
    
    override init() {
            super.init()
            UNUserNotificationCenter.current().delegate = self
        }
    
    func startTimer() {
        
        if timer == nil {
        // Set up a background task to keep the timer running in the background
            var taskId: UIBackgroundTaskIdentifier = .invalid
            taskId = UIApplication.shared.beginBackgroundTask(withName: "TimerBackgroundTask") {
            // End the background task when the time expires
                UIApplication.shared.endBackgroundTask(taskId)
            }
            //timer logic
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.timerDuration > 0 {
                    //self.sendNotification() sends notif every second test
                    self.timerDuration -= 1
                } else {
                    self.showingAlert = true
                    self.endTimer()
                }
            }
        }
    }
    
    func pauseTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        timerDuration = focusSessionDuration
        timer?.invalidate()
        timer = nil
        isResting = false
    }
    func endTimer() {
        if !isResting {
            timerDuration = breakSessionDuration
            isResting = true
            sendNotification()
        } else {
            timerDuration = focusSessionDuration
            isResting = false
            sendNotification()
        }
    }
    
    func formatSeconds(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds)!
    }
    
    
    
    
        
    
    func sendNotification() {
        let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = self.isResting ? "Focus time is over!" : "Break time is over!"
            content.body = "Nice!"
            content.sound = UNNotificationSound.default
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
            center.add(request)
        }
    // MARK: - UNUserNotificationCenterDelegate
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.sound, .alert, .badge])
        }
}

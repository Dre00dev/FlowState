//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Andres Pulgarin on 4/10/23.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var timerManager: TimerManager
    @State private var isShowingTimer = false
    
            
    
    var body: some View {
        VStack {
            Text("Session Time")
                .font(.largeTitle).bold()
                .foregroundColor(Color(red: 242/255, green: 75/255, blue: 144/255))
                .padding()
            Text("Focus: \(formatSeconds(timerManager.focusSessionDuration)) minutes")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            Slider(value: $timerManager.focusSessionDuration, in: 300...7200, step: 300) {
                Text("Focus Session")
            }
            .accentColor(.white)
            .tint(Color(red: 242/255, green: 75/255, blue: 144/255))
            .padding()
            
            Text("Break: \(formatSeconds(timerManager.breakSessionDuration)) minutes")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                
            Slider(value: $timerManager.breakSessionDuration, in: 60...7200, step: 60) {
                Text("Break Session")
            }
            .accentColor(.white)
            .tint(Color(red: 242/255, green: 75/255, blue: 144/255))
            .padding()
            
            Spacer()
            
            Button(action: {
                isShowingTimer = true
            }) {
                Text("Start Timer")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 242/255, green: 75/255, blue: 144/255))
                    .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle()) // Removes the focus ring
            .padding(.horizontal, 20)
            .sheet(isPresented: $isShowingTimer) {
                ContentView()  //timerView maybe
                    .environmentObject(timerManager)
            }
        }
        .background(Color(red: 15/255, green: 19/255, blue: 31/255))
    }
    func formatSeconds(_ seconds: TimeInterval) -> String {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.zeroFormattingBehavior = .pad
            return formatter.string(from: seconds)!
        }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

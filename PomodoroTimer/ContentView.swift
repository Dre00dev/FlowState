import SwiftUI
import UserNotifications

struct ContentView: View {
    // Timer settings
    @EnvironmentObject var timerManager: TimerManager
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 15/255, green: 19/255, blue: 31/255), timerManager.isResting ? Color.blue : Color(red: 242/255, green: 75/255, blue: 144/255)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            VStack {
                Text(timerManager.isResting ? "Break Time" : "Focus Time")
                    .font(.title)
                    .foregroundColor(timerManager.isResting ? Color.blue : Color(red: 242/255, green: 75/255, blue: 144/255))
                    .padding(.top, 40)
                //.padding(.horizontal, 20)
                
                
                Text("\(timerManager.formatSeconds(timerManager.timerDuration))")
                    .font(.system(size: 60))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                HStack(spacing: 30) {
                    Button(action: {
                        if timerManager.isPaused {
                            timerManager.startTimer()
                            timerManager.isPaused = false
                        } else {
                            timerManager.pauseTimer()
                            timerManager.isPaused = true
                        }
                    }) {
                        Image(systemName: timerManager.isPaused ? "play" : "pause")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                    Button(action: {
                        timerManager.resetTimer()
                        timerManager.isPaused = true
                    }) {
                        Image(systemName: "arrow.counterclockwise")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 50)
                
                Spacer()
            }
            .onAppear {
                timerManager.timerDuration = timerManager.focusSessionDuration
            }
            
        }        //VStack
        .alert(isPresented: $timerManager.showingAlert) {
                    Alert(
                        title: Text(timerManager.isResting ? "Focus time is over!" : "Break time is over!"),
                        message: Text("Nice!"),
                        dismissButton: .destructive(Text("Dismiss")) {
                            print("Dismissed notificaton")
                        }
                    )
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    if !timerManager.isPaused && timerManager.timerDuration == 0 {
                        timerManager.showingAlert = true
                    }
                }
    }//Zstack
}
        
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


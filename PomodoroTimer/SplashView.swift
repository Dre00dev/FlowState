//
//  SplashView.swift
//  PomodoroTimer
//
//  Created by Andres Pulgarin on 4/10/23.
//

import SwiftUI



struct SplashView: View {
    var body: some View {
        ZStack{
            Color(red: 15/255, green: 19/255, blue: 31/255)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Spacer()
            Text("Take Control Of Your Time")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 242/255, green: 75/255, blue: 144/255 ).opacity(0.8))
                        
                Spacer()
            }
        }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

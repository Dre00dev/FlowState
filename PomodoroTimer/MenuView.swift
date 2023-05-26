//
//  MenuView.swift
//  PomodoroTimer
//
//  Created by Andres Pulgarin on 5/25/23.
//

import SwiftUI
import StoreKit

struct MenuView: View {
    @Binding var isPresented: Bool
    @ObservedObject var paymentHandler = PaymentHandler()

    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                // Restore purchases action here
                SKPaymentQueue.default().restoreCompletedTransactions()
            }) {
                Text("Restore Purchases")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 242/255, green: 75/255, blue: 144/255))
                    .cornerRadius(10)
            }

//            Button(action: {
//                // Contact developers action here
//            }) {
//                Text("Contact Developers")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color(red: 242/255, green: 75/255, blue: 144/255))
//                    .cornerRadius(10)
//            }
        }
        .padding()
    }
}


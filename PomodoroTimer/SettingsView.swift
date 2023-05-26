//
//  SettingsView.swift
//  PomodoroTimer
//
//  Created by Andres Pulgarin on 4/10/23.

import SwiftUI
import StoreKit

class PaymentHandler: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var isPremium = false
    @Published var showPurchaseView = false
    var completion: ((Result<Void, Error>) -> Void)?
    
    override init() {
            super.init()
            // Load purchase status from UserDefaults
            isPremium = UserDefaults.standard.bool(forKey: "isPremium")
            SKPaymentQueue.default().add(self)
    }
    
    func purchase(productID: String) {
        let request = SKProductsRequest(productIdentifiers: [productID])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first(where: { $0.productIdentifier == "1_time_premium" }) {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Transaction Success")
                UserDefaults.standard.set(true, forKey: "isPremium")
                isPremium = true
                completion?(.success(()))
                queue.finishTransaction(transaction)
            case .failed:
                print("Transaction failed")
                if let error = transaction.error as? SKError {
                    completion?(.failure(error))
                }
                queue.finishTransaction(transaction)
            case .restored:
                print("Restored")
                isPremium = true
                queue.finishTransaction(transaction)
            default:
                break
            }
        }
    }
}

import SwiftUI
import StoreKit

struct SettingsView: View {
    @EnvironmentObject var timerManager: TimerManager
    @StateObject var paymentHandler = PaymentHandler()
    @State private var isShowingTimer = false
    @State private var isShowingMenu = false

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
            .onChange(of: timerManager.focusSessionDuration) { _ in
                if !paymentHandler.isPremium {
                    // Show purchase view
                    paymentHandler.showPurchaseView = true

                    // Reset slider value
                    timerManager.focusSessionDuration = 1500
                }
            }

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
            .onChange(of: timerManager.breakSessionDuration) { _ in
                if !paymentHandler.isPremium {
                    // Show purchase view
                    paymentHandler.showPurchaseView = true

                    // Reset slider value
                    timerManager.breakSessionDuration = 300
                }
            }

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
                ContentView() //timerView maybe
                    .environmentObject(timerManager)
            }

            Button(action: {
                isShowingMenu = true
            }) {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .padding()
            }
        }
        .background(Color(red: 15/255, green: 19/255, blue: 31/255))
        .overlay(
            // Show purchase view as an overlay on top of the settings view
            Group {
                if paymentHandler.showPurchaseView {
                    Color.black.opacity(0.5).ignoresSafeArea()

                    PurchaseView(paymentHandler: paymentHandler, isPresented: $paymentHandler.showPurchaseView) { result in
                        switch result {
                        case.success:
                            // Purchase was successful
                            paymentHandler.isPremium = true
                        case.failure(let error):
                            // Handle error
                            print(error.localizedDescription)
                        }

                        paymentHandler.showPurchaseView = false
                    }
                }
                
               
                
            }
        )
        // Present MenuView as a sheet when isShowingMenu is true
        .sheet(isPresented:$isShowingMenu){
            
           MenuView(isPresented:$isShowingMenu,paymentHandler :paymentHandler)
            
        }
    }

    func formatSeconds(_ seconds: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute,.second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: seconds)!
    }
}


struct PurchaseView: View {
    @ObservedObject var paymentHandler: PaymentHandler
    @Binding var isPresented: Bool
    let completion: (Result<Void, Error>) -> Void
    
    var body: some View {
        VStack {
            Text("Upgrade to Premium")
                .font(.largeTitle).bold()
                .foregroundColor(Color(red: 242/255, green: 75/255, blue: 144/255))
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Unlock the ability to customize your focus and break times by upgrading to premium for just $3.99.")
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                // Purchase premium
                paymentHandler.completion = completion
                paymentHandler.purchase(productID: "1_time_premium")
            }) {
                Text("Purchase for $3.99")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 242/255, green: 75/255, blue: 144/255))
                    .cornerRadius(10)
            }
            .padding()
            
            Button(action: {
                // Cancel
                isPresented = false
            }) {
                Text("Cancel")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .background(Color(red: 15/255, green: 19/255, blue: 31/255))
        .cornerRadius(10)
    }
}



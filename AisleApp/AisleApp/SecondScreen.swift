//
//  SecondScreen.swift
//  AisleApp
//
//  Created by Abhishek on 05/11/24.
//

import SwiftUI

struct SecondScreen: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text(viewModel.countryCode + " " + viewModel.phoneNumber)
                    
                    NavigationLink(destination: FirstScreen().navigationBarBackButtonHidden(), isActive: $viewModel.enableFirstScreen) {
                        Button(action: {
                            viewModel.enableFirstScreen = true
                        }) {
                            Image(systemName: "pencil")
                        }
                        .controlSize(.large)
                        .foregroundStyle(.black)
                    }
                    
                }
                
                Text("Enter The OTP")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                HStack {
                    TextField("OTP", text: $viewModel.otp)
                        .frame(width: 100)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                
                
                NavigationLink(destination: ThirdScreen().navigationBarBackButtonHidden(), isActive: $viewModel.enableThirdScreen) {
                    Button("Continue") {
                        Task {
                            do {
                                try await viewModel.otpAPICall { result in
                                    if result {
                                        DispatchQueue.main.async {
                                            viewModel.enableThirdScreen = true
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            viewModel.showOTPAlert = true
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(Color.yellow)
                    .foregroundStyle(.black)
                    .cornerRadius(8)
                    .alert(isPresented: $viewModel.showOTPAlert) { () -> Alert in
                        Alert(title: Text("Invalid OTP"), message: Text("Please enter valid OTP"), dismissButton: .cancel(Text("OK")))
                        
                    }
                }
                
                Spacer()
            }
            .onAppear() {
                viewModel.otp = ""
                viewModel.enableFirstScreen = false
            }
            .padding(EdgeInsets(top: 30, leading: 4, bottom: 0, trailing: 4))
        }  
    }
}

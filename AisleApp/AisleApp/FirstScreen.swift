//
//  FirstScreen.swift
//  AisleApp
//
//  Created by Abhishek on 05/11/24.
//

import SwiftUI

struct FirstScreen: View {
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("Get OTP")
                Text("Enter Your Phone Number")
                    .fontWeight(.heavy)
                    .font(.largeTitle)
                HStack {
                    TextField("Country Code", text: $viewModel.countryCode)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                        .frame(width: 120)
                        .multilineTextAlignment(.center)
                    
                    TextField("Phone Number", text: $viewModel.phoneNumber)
                        .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(Color.black, style: StrokeStyle(lineWidth: 1.0)))
                        .multilineTextAlignment(.center)
                }
                
                NavigationLink(destination: SecondScreen(), isActive: $viewModel.enableSecondScreen) {
                    Button("Continue") {
                        Task {
                            do {
                                try await viewModel.phoneNumberAPICall { result in
                                    if result {
                                        DispatchQueue.main.async {
                                            viewModel.enableSecondScreen = true
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            viewModel.showPhoneAlert = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .background(Color.yellow)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    .alert(isPresented: $viewModel.showPhoneAlert) { () -> Alert in
                        Alert(title: Text("Invalid Phone Number"), message: Text("Please enter valid Phone Number"), dismissButton: .cancel(Text("OK")))
                        
                    }
                }
                Spacer()
            }
            .padding(EdgeInsets(top: 30, leading: 4, bottom: 0, trailing: 4))
            .onAppear() {
                viewModel.enableSecondScreen = false
                viewModel.enableThirdScreen = false
            }
            
        }
    }
}

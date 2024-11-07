//
//  AppViewMode.swift
//  AisleApp
//
//  Created by Abhishek on 05/11/24.
//

import Foundation
import UIKit

class AppViewModel: ObservableObject {

    @Published var phoneNumber: String = ""
    @Published var countryCode: String = ""
    @Published var showOTPAlert: Bool = false
    @Published var showPhoneAlert: Bool = false
    @Published var otp: String = ""
    @Published var notes = Notes()
    @Published var enableFirstScreen = false
    @Published var enableSecondScreen = false
    @Published var enableThirdScreen = false
    
    func phoneNumberAPICall(completion: @escaping (Bool) -> Void) async throws {
        guard let url = URL(string: "https://app.aisle.co/V1/users/phone_number_login") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["number": countryCode + phoneNumber]
        request.httpBody = try JSONEncoder().encode(parameters)
        
        let (data, _) = try await URLSession.shared.upload(for: request, from: request.httpBody ?? Data())
        
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Bool] {
            completion(jsonResponse["status"] ?? false)
        } else {
            completion(false)
        }
    }
    
    func otpAPICall(completion: @escaping (Bool) -> Void) async throws {
        guard let url = URL(string: "https://app.aisle.co/V1/users/verify_otp") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["number": countryCode + phoneNumber, "otp": otp]
        request.httpBody = try JSONEncoder().encode(parameters)
        
        let (data, _) = try await URLSession.shared.upload(for: request, from: request.httpBody ?? Data())
        
        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
            let token = jsonResponse["token"] ?? ""
            try await notesAPICall(authToken: token) { data in
                
                DispatchQueue.main.async {
                    self.notes = data
                }
                completion(true)
            }
        } else {
            completion(false)
        }
    }
    
    func notesAPICall(authToken: String, completion: @escaping (Notes) -> Void) async throws {
        guard let url = URL(string: "https://app.aisle.co/V1/users/test_profile_list") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(authToken, forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let apiResponse = try decoder.decode(Notes.self, from: data)
        completion(apiResponse)
    }
}

struct Notes: Codable {
    var likes: Likes?
}

struct Likes: Codable {
    var can_see_profile: Int?
    var likes_received_count: Int?
    var profiles: [Profile]?
}

struct Profile: Codable {
    var avatar: String?
    var firstName: String?
}

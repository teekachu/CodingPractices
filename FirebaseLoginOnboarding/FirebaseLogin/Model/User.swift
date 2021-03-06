//
//  User.swift
//  FirebaseLogin
//
//  Created by Tee Becker on 11/23/20.
//

import Foundation

struct User{
    let uid: String
    let email: String
    let fullname: String
    var hasSeenOnboardingPage: Bool  /// subject to change

    /// For realtime database
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.hasSeenOnboardingPage = dictionary["hasSeenOnboardingPage"] as? Bool ?? false
    }
    
    /// For firestore
    init(dictionary: [String: Any]){
        self.uid = dictionary["uid"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.hasSeenOnboardingPage = dictionary["hasSeenOnboardingPage"] as? Bool ?? false
    }
}

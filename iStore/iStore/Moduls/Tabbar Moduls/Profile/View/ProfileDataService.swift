//
//  ProfileDataService.swift
//  iStore
//
//  Created by Nikita Shirobokov on 25.04.24.
//

import Firebase
import FirebaseFirestore

//class ProfileDataService {
//    static let shared = ProfileDataService()
//    private init() {}
//
//    func fetchProfileData(completion: @escaping (UserProfile?, Error?) -> Void) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            completion(nil, NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
//            return
//        }
//
//        let db = Firestore.firestore()
//        db.collection("users").document(userId).getDocument { document, error in
//            if let error = error {
//                completion(nil, error)
//            } else if let document = document, document.exists, let data = document.data() {
//                let name = data["name"] as? String ?? "No Name"
//                let email = data["email"] as? String ?? "No Email"
//                let imageUrl = data["profileImageUrl"] as? String
//                let userProfile = UserProfile(name: name, email: email, imageUrl: imageUrl)
//                completion(userProfile, nil)
//            } else {
//                completion(nil, NSError(domain: "Firestore", code: -2, userInfo: [NSLocalizedDescriptionKey: "Document does not exist"]))
//            }
//        }
//    }
//}

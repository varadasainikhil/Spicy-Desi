//
//  MenuViewViewModel.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/5/25.
//

import FirebaseAuth
import Foundation


@Observable
class MenuViewViewModel{
    
    
    
    // Sign out
    func signOut() async {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Error : \(error.localizedDescription)")
        }
    }
}

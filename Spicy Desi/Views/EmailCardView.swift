//
//  EntryCardView.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/4/25.
//

import SwiftUI

struct EmailCardView: View {
    @Bindable var authenticationManager : AuthenticationManager
    @Binding var navigateToSignupView : Bool
    @Binding var navigateToLoginView : Bool
    var body: some View {
        ZStack{
            Color(.gray)
                .ignoresSafeArea()
            
            VStack{
                
                TextField("Enter your Email", text: $authenticationManager.emailAddress)
                    .textInputAutocapitalization(.never)
                    .border(.black)
                    .padding()
                
                Button{
                    Task{
                        // Check the sign up method of the email
                        let result = await authenticationManager.checkUserSignUpMethod()
                        if result.userExists {
                            navigateToLoginView = true
                        }
                        else {
                            navigateToSignupView = true
                        }
                    }
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 55)
                            .padding()
                        
                        Text("Next")
                            .foregroundStyle(.white)
                    }
                }
                .disabled(!authenticationManager.isEmailValid)
            
            }
        }
    }
}

#Preview {
    let authManager = AuthenticationManager()
    
    EmailCardView(authenticationManager: authManager, navigateToSignupView: .constant(false), navigateToLoginView: .constant(true))
    
}

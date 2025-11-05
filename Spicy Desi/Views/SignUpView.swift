//
//  SignUpView.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/4/25.
//

import SwiftUI

struct SignUpView: View {
    @State var authenticationManager : AuthenticationManager
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.black)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    ZStack{
                        Color(.gray)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .frame(height: 300)
                        
                        VStack{
                            TextField("Enter your Name", text: $authenticationManager.name)
                                .border(.black)
                            
                            SecureField("Enter your password", text: $authenticationManager.password)
                                .border(.black)
                            
                            SecureField("Confirm your password", text: $authenticationManager.confirmPassword)
                                .border(.black)
                            
                            Button {
                                // Sign up using email password
                                Task{
                                    await authenticationManager.signUpWithEmailPassword()
                                }
                            } label: {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame(height: 55)
                                    
                                    Text("Create Account")
                                        .foregroundStyle(.white)
                                }
                            }
                            .disabled(!authenticationManager.checkPasswords)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    let authManager = AuthenticationManager()
    
    return SignUpView(authenticationManager: authManager)
}

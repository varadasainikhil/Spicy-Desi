//
//  LoginView.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/4/25.
//

import SwiftUI

struct LoginView: View {
    @Bindable var authenticationManager : AuthenticationManager
    @State var showingResetView = false
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.gray)
                    .ignoresSafeArea()
                
                VStack{
                    VStack{
                        SecureField("Enter your Password", text: $authenticationManager.password)
                            .border(.black)
                        
                        HStack{
                            Spacer()
                            Text("Forgot your Password?")
                                .underline()
                                .onTapGesture {
                                    // Show the sheet to reset the password
                                    showingResetView = true
                                }
                        }
                    }
                    .padding()

                    Button{
                        Task{
                            // Login using email password
                            await authenticationManager.signInWithEmailPassword()
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12)
                                .frame(height: 55)
                                .padding()
                            
                            Text("Login")
                                .foregroundStyle(.white)
                        }
                    }
                    .disabled(!authenticationManager.isPasswordValid)
                }
            }
        }
        .sheet(isPresented: $showingResetView) {
            ResetPasswordView(authenticationManager: authenticationManager)
        }
    }
}

#Preview {
    let authManager = AuthenticationManager()
    
    LoginView(authenticationManager: authManager)
}

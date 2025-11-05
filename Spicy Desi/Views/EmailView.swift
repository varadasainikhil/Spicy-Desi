//
//  EntryView.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/4/25.
//

import SwiftUI

struct EmailView: View {
    @State var authenticationManager : AuthenticationManager
    @State private var navigateToSignupView : Bool = false
    @State private var navigateToLoginView : Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(.black)
                    .ignoresSafeArea()
                
                VStack{
                    Spacer()
                    
                    // Text
                    Text("Welcome to Spicy Desi")
                        .foregroundStyle(.white)
                        .font(.title.bold())
                    
                    Spacer()
                    
                    // EntryCardView for the email entry
                    EmailCardView(authenticationManager: authenticationManager, navigateToSignupView: $navigateToSignupView, navigateToLoginView: $navigateToLoginView)
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                }
            }
            .navigationDestination(isPresented: $navigateToLoginView, destination: {
                LoginView(authenticationManager: authenticationManager)
            })
            .navigationDestination(isPresented: $navigateToSignupView) {
                SignUpView(authenticationManager: authenticationManager)
            }
        }
    }
}

#Preview {
    let authManager = AuthenticationManager()
    EmailView(authenticationManager: authManager)
}

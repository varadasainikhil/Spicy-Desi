//
//  ResetPasswordView.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/5/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @State var clickedOnTheButton = false
    @State var authenticationManager : AuthenticationManager
    var body: some View {
        ZStack{
            Color(.black)
                .ignoresSafeArea()
            
            VStack{
                
                Spacer()
                
                Text("You are about to reset your Password.")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
                
                Text("An email will be sent to your email address with a link to reset the password.")
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    // Reset Password
                    Task{
                        await authenticationManager.resetPassword()
                        clickedOnTheButton = true
                        try await Task.sleep(for: .seconds(45))
                        clickedOnTheButton = false
                    }
                    
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 55)
                        
                        Text(clickedOnTheButton ? "Email Sent, Please check spam folder" : "Send Email to Reset Password")
                            .foregroundStyle(.white)
                    }
                }
                .disabled(clickedOnTheButton)
                Spacer()

            }
            .padding()
        }
    }
}

#Preview {
    let authenticationManager = AuthenticationManager()
    ResetPasswordView(authenticationManager: authenticationManager)
}

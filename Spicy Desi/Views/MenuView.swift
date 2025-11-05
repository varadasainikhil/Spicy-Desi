//
//  MenuView.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/4/25.
//

import SwiftUI

struct MenuView: View {
    @State var menuViewViewModel = MenuViewViewModel()
    var body: some View {
        VStack{
            Button {
                // Button for sign out
                Task{
                    await menuViewViewModel.signOut()
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.blue)
                        .frame(height: 55)
                    
                    Text("Sign Out")
                        .foregroundStyle(.white)
                }
            }

        }
    }
}

#Preview {
    MenuView()
}

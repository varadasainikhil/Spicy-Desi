//
//  RootView.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/4/25.
//

import SwiftUI

struct RootView: View {
    @State private var authenticationManager = AuthenticationManager()
    var body: some View {
        if authenticationManager.currentUser == nil {
            EmailView(authenticationManager: authenticationManager)
        }
        else {
            MenuView()
        }
    }
}

#Preview {
    RootView()
}

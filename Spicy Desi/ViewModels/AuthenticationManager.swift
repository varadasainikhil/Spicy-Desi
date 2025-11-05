//
//  AuthenticationManager.swift
//  Spicy Desi
//
//  Created by Sai Nikhil Varada on 11/4/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

@Observable
class AuthenticationManager{
    var emailAddress = "" {
        didSet{
            emailValidation()
        }
    }
    
    var name = ""
    
    var password = "" {
        didSet{
            passwordValidation()
        }
    }
    
    var confirmPassword = "" {
        didSet{
            matchPasswords()
        }
    }
    
    var checkPasswords = false
    
    var isEmailValid = false
    
    var isPasswordValid = false
    
    var errorMessage = ""
    
    var showingError = false
    
    var currentUser: User?
    
    private var authStateListener: AuthStateDidChangeListenerHandle?
    
    init() {
        listenToAuthState()
    }
    
    deinit {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Listen to Auth Changes
    private func listenToAuthState() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user, let email = user.email {
                print("✅ User signed in: \(email)")
                Task {
                    do {
                        let db = Firestore.firestore()
                        let docRef = db.collection("users").document(email)
                        let document = try await docRef.getDocument()
                        if document.exists {
                            self.currentUser = try document.data(as: User.self)
                            print("✅ Current user profile loaded.")
                        } else {
                            print("⚠️ User document not found in Firestore.")
                            self.currentUser = nil
                        }
                    } catch {
                        print("❌ Error fetching user document: \(error.localizedDescription)")
                        self.currentUser = nil
                    }
                }
            } else {
                print("🚪 User signed out")
                self.currentUser = nil
            }
        }
    }
    
    // Matching password and confirm password
    private func matchPasswords() {
        if password == confirmPassword {
            checkPasswords = true
        }
        else {
            checkPasswords = false
        }
    }
    
    // Hashing the email
    private func hashEmail() -> String{
        let normalizedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let inputData = Data(normalizedEmail.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.map {String(format: "%02x", $0)}.joined()
    }
    
    // Check if the email is valid
    private func emailValidation() {
        if emailAddress.filter({ $0 == "@" }).count == 1
            && emailAddress.contains(".")
            && emailAddress.trimmingCharacters(in: .whitespacesAndNewlines).count > 7
            && emailAddress.last?.isLetter ?? false
            && emailAddress.first?.isLetter ?? false {
            isEmailValid = true
        } else {
            isEmailValid = false
        }
    }
    
    // Check if password is valid
    private func passwordValidation(){
        if password.trimmingCharacters(in: .whitespacesAndNewlines).count > 7{
            isPasswordValid = true
        } else {
            isPasswordValid = false
        }
    }
    
    // Reset password Fields
    private func resetPasswordFields(){
        password = ""
        confirmPassword = ""
    }
    
    // Reset email Field
    private func resetEmailFields(){
        emailAddress = ""
    }

    // Checking the User's signUpMethod
    func checkUserSignUpMethod() async -> (userExists : Bool, signUpMethod :String){
        
        // Hashing Email
        let hashedEmail = hashEmail()
        
        print(hashedEmail)
        
        let db = Firestore.firestore()
        let docRef = db.collection("signUpMethods").document(hashedEmail)
        
        do{
            let document = try await docRef.getDocument()
            
            if document.exists{
                let data = try document.data(as: signUpMethods.self)
                print("User Sign Up Method : \(data.signUpMethod)")
                return (true, data.signUpMethod)
            }
            else{
                print("Document does not exists")
                return (false, "")
            }
        }
        catch{
            print("Error : \(error.localizedDescription)")
            return (false, "")
        }
    }
    
    // Upload signUpMethod document to the signUpMethods collection
    private func uploadSignUpMethod() async {
        let db = Firestore.firestore()
        
        let hashedEmail = hashEmail()
        
        let signUpMethod = signUpMethods(signUpMethod: "email_password")
        
        do{
            try db.collection("signUpMethods").document(hashedEmail).setData(from: signUpMethod)
            print("Document uploaded to the signUpMethods.")
        }
        catch{
            print("Error : \(error.localizedDescription)")
        }
    }
    
    // Login Using Email-Password
    func signInWithEmailPassword() async {
        if isEmailValid && isPasswordValid{
            do{
                try await Auth.auth().signIn(withEmail: emailAddress, password: password)
                print("User signed in successfully.")
                resetEmailFields()
                resetPasswordFields()
            }
            catch let error as NSError {
                if let authError = AuthErrorCode(rawValue: error.code){
                    switch authError {
                        
                    case .wrongPassword, .invalidCredential:
                        errorMessage = "Incorrect password. Please try again."
                        
                    case .userNotFound:
                        errorMessage = "Account not found. Please check your email or sign up."
                        
                    case .invalidEmail:
                        errorMessage = "Please enter a valid email address."
                        
                    case .networkError:
                        errorMessage = "Network error. Please check your internet connection."
                        
                    case .tooManyRequests:
                        errorMessage = "Too many failed attempts. Please try again later."
                        
                    case .userDisabled:
                        errorMessage = "This account has been disabled. Please contact support."
                        
                    default:
                        errorMessage = "Unable to sign in. Please try again."
                    }
                } else {
                    errorMessage = "Unable to sign in. Please try again."
                }
                showingError = true
            }
        }
    }
    
    // Sign Up with Email-Password
    func signUpWithEmailPassword() async{
        do{
            try await Auth.auth().createUser(withEmail: emailAddress, password: password)
            print("User signed up successfully.")
            await uploadSignUpMethod()
            await uploadDocumentInUsersCollection()
            resetEmailFields()
            resetPasswordFields()
        }
        catch let error as NSError {
            if let authError = AuthErrorCode(rawValue: error.code){
                switch authError {
                    
                case .wrongPassword, .invalidCredential:
                    errorMessage = "Incorrect password. Please try again."
                    
                case .userNotFound:
                    errorMessage = "Account not found."
                    
                case .invalidEmail:
                    errorMessage = "Please enter a valid email address."
                    
                case .networkError:
                    errorMessage = "Network error. Please check your internet connection."
                    
                case .tooManyRequests:
                    errorMessage = "Too many failed attempts. Please try again later."
                    
                case .userDisabled:
                    errorMessage = "This account has been disabled. Please contact support."
                    
                default:
                    errorMessage = "Unable to sign up. Please try again."
                }
            } else {
                errorMessage = "Unable to sign up. Please try again."
            }
            showingError = true
            resetPasswordFields()
        }
    }
    
    // Create a document in the users collection
    func uploadDocumentInUsersCollection() async {
        let db = Firestore.firestore()
        
        let hashedEmail = hashEmail()
        
        let user = User(name: name, email: emailAddress, hashedEmail: hashedEmail, joiningDate: Date.now, signUpMethods: "email_password")
        
        do{
            try db.collection("users").document(emailAddress).setData(from: user)
            print("User document uploaded successfully.")
        }
        catch{
            print("Error: \(error.localizedDescription)")
        }
    }
}

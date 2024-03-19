//
//  AuthViewModel.swift
//  FirebaseYoutube
//
//  Created by Marco Castope on 17/03/24.
//

import Foundation
import FirebaseAuth


final class AuthViewModel : ObservableObject {
    
    private let auth: Auth
    
    @Published var message = ""
    @Published var showMessage = false
    @Published var user: User?
    
    @Published var username = ""
    
    init() {
        auth = Auth.auth()
    }
    
    func loginUser(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                self.message = error.localizedDescription
                self.showMessage.toggle()
                return
            }
        }
    }
    
    func registerUser(email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { _, error in
            if let error = error {
                self.message = error.localizedDescription
                self.showMessage.toggle()
            } else {
                self.message = "Usuario registrado con éxito"
                self.showMessage.toggle()
            }
        }
    }
    
    func logout() {
        do {
            try auth.signOut()
        } catch {
            self.message = error.localizedDescription
            self.showMessage.toggle()
        }
    }
    
    func listenToAuthState() {
        auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {return}
            self.user = user
            self.username = user?.displayName ?? ""
        }
    }
    
    func updateProfileUser() {
        guard let user = self.user else {return}
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = self.username
        changeRequest.commitChanges { error in
            if let error = error {
                self.message = error.localizedDescription
                self.showMessage.toggle()
            } else {
                self.message = "Usuario actualizado con éxito"
                self.showMessage.toggle()
            }
        }
    }
}

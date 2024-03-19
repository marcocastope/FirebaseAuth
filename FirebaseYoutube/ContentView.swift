//
//  ContentView.swift
//  FirebaseYoutube
//
//  Created by Marco Castope on 14/03/24.
//

import SwiftUI


struct ContentView: View {
    
    @StateObject var authVM = AuthViewModel()
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Form(content: {
                Section {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                }
                
                Section {
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                }
                
                Section {
                    Button(action: {
                        self.authVM.registerUser(email: email, password: password)
                    }, label: {
                        Text("Register")
                    })
                    .disabled(validateInputs())
                }
                
                Section {
                    Button(action: {
                        self.authVM.loginUser(email: email, password: password)
                    }, label: {
                        Text("Login")
                    })
                    .disabled(validateInputs())
                }
                
                Section {
                    Button(action: {
                        self.authVM.logout()
                    }, label: {
                        Text("Cerrar sesión")
                    })
                }
            })
            
            if self.authVM.user == nil {
                Text("No estás logeado")
            } else {
                Text("Estás logeado")
                HStack {
                    Image("appledev")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    Spacer()
                    VStack(alignment: .leading) {
                        TextField("Username", text: self.$authVM.username)
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        Button(action: {
                            self.authVM.updateProfileUser()
                        }, label: {
                            Text("Actualizar")
                        })
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .onAppear(perform: {
            self.authVM.listenToAuthState()
        })
        .alert(isPresented: self.$authVM.showMessage, content: {
            Alert(title: Text("Message"), message: Text(self.authVM.message), dismissButton: Alert.Button.default(Text("Ok")))
        })
    }
    
    private func validateInputs() -> Bool {
        return self.email.isEmpty || self.password.isEmpty
    }
    
}

#Preview {
    ContentView()
}

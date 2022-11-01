//
//  ContentView.swift
//  AuthApp
//
//  Created by Arthur Damous on 27/10/22.
//

import SwiftUI

struct Constants{
    static let BASE_URL = "https://auth-api-heroku.herokuapp.com"
}

struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    
    var body: some View {
        
        NavigationView {
            ZStack{
                Color.blue.ignoresSafeArea()
                Circle().scale(1.7).foregroundColor(.white.opacity(0.15))
                Circle().scale(1.35).foregroundColor(.white)
                
                VStack{
                    
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .border(.red, width: CGFloat(wrongUsername))
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login"){
                        //authenticateUser(username: username, password: password)
                        getAllNotes()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    NavigationLink(destination: Text("You are logged in @\(username)"), isActive: $showingLoginScreen) {
                        EmptyView()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        
    }
    
    func authenticateUser(username: String, password: String){
        guard let url = URL(string : "\(Constants.BASE_URL)/auth/login") else {
            return
        }
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNTgzNDc4ZTM4MjcwZTY5MmE4MTg3YiIsImlhdCI6MTY2NzMzMDM4NH0.kzwlWZNEMtpB5A7XCI_qQZ6ClAQfOTPxgdvXkTk0j7M"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [
            "email": username.lowercased(),
            "password": password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                //let response = try JSONDecoder().decode(Response.self, from: data)
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(response)")
                
            }catch{
                print(error)
            }
        }
        
        task.resume()
    }
    
    func getAllNotes(){
        guard let url = URL(string : "\(Constants.BASE_URL)/notes") else {
            return
        }
        
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYzNTgzNDc4ZTM4MjcwZTY5MmE4MTg3YiIsImlhdCI6MTY2NzMzMDM4NH0.kzwlWZNEMtpB5A7XCI_qQZ6ClAQfOTPxgdvXkTk0j7M"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do{
                let results = try JSONDecoder().decode(NotesResponse.self, from: data)
                print("SUCCESS: \(results)")
            }catch{
                print(error)
            }
        }
        
        task.resume()
    }
}

struct Response: Codable {
    let msg: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

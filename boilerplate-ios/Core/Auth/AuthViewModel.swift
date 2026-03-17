//
//  AuthViewModel.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import Foundation
import AuthenticationServices
import Supabase
import CryptoKit

private let DEBUG_MODE = true

enum AuthState: Equatable{
    case loading, unauthenticated, newUser(userID: UUID), authenticated
}

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var authState: AuthState = .loading
    @Published var errorMessage: String?
    @Published var isLoading =  false
    
    init(){
        if DEBUG_MODE == true {
            print("Debug mode, skipping auth")
            authState = .authenticated
        } else{
            Task { await restoreSession() }
        }
    }
    
    func restoreSession() async {
        do {
            let session = try await supabase.auth.session
            await checkProfileExists(for: session.user.id)
        } catch {
            authState = .unauthenticated
        }
    }
    
    func checkProfileExists(for userID:UUID) async {
        return
    }
    
    func signIn(email: String, password: String) async {
            isLoading = true
            errorMessage = nil
            
            do {
                try await supabase.auth.signIn(
                    email: email,
                    password: password
                )
                let session = try await supabase.auth.session
                authState = .authenticated
                print("Signed in user: \(session.user.id)")
                } catch {
                    errorMessage = error.localizedDescription
                    authState = .unauthenticated
            }
        }

        func signUp(email: String, password: String) async {
            isLoading = true
            errorMessage = nil
            defer { isLoading = false }
            do {
                let response = try await supabase.auth.signUp(
                    email: email,
                    password: password
                )
                print("Created user: \(response.user.id.uuidString)")
            } catch {
                errorMessage = error.localizedDescription
            }

           
        }

        func signOut() async {
            do {
                try await supabase.auth.signOut()
                authState = .unauthenticated
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

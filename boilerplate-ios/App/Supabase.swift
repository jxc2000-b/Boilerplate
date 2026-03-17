//
//  Supabase.swift
//  boilerplate-ios
//
//  Created by Bryan on 3/11/26.
//

import Foundation
import Supabase

private let supabaseURL = URL(string: "https://mrheglzbigflmdqubmny.supabase.co")!
private let supabaseKey = "sb_publishable_FxWRW7-KWt_VtOEKs0zjoA_nBD0JWbL"

let supabase = SupabaseClient(
    supabaseURL: supabaseURL,
    supabaseKey: supabaseKey
)

func checkSupabaseConnection() {
    Task {
        do {
            let response = try await supabase.checkSupabaseConnection()
            print("✅ Supabase connected (HTTP \(response.statusCode))")
        } catch {
            print("❌ Connection failed: \(error)")
        }
    }
}

extension SupabaseClient {
    func checkSupabaseConnection() async throws -> HTTPURLResponse {
        var request = URLRequest(url: supabaseURL.appending(path: "auth/v1/settings"))
        request.httpMethod = "GET"
        request.setValue(supabaseKey, forHTTPHeaderField: "apikey")
        request.setValue("Bearer \(supabaseKey)", forHTTPHeaderField: "Authorization")
        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return httpResponse
    }
}


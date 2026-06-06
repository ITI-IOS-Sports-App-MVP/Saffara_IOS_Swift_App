//
//  APIKeyProvider.swift
//  sports_app
//

import Foundation

struct APIKeyProvider {
    static func getApiKey() -> String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String else {
            print("⚠️ API_KEY not found in Info.plist")
            return ""
        }
        return key
    }
}

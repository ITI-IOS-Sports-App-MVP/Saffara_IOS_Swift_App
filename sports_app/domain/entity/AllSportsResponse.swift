//
//  AllSportsResponse.swift
//  sports_app
//
//  Created by Abdullh Gaber on 04/06/2026.
//


struct AllSportsResponse<T: Codable>: Codable {
    let success: Int?
    let result: [T]?
}
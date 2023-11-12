//
//  OpenAI.swift
//  FaceReader
//
//  Created by 홍승완 on 2023/11/11.
//

import Foundation

struct OpenAIResponse: Codable {
    var id: String
    var object: String
    var created: Int
    var choices: [Choice]
    var usage: Usage
}

struct Choice: Codable {
    var index: Int
    var message: Message
    var finish_reason: String
}

struct Message: Codable {
    var role: String
    var content: String
}

struct Usage: Codable {
    var prompt_tokens: Int
    var completion_tokens: Int
    var total_tokens: Int
}


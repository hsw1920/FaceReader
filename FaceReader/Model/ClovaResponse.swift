//
//  ClovaResponse.swift
//  FaceReader
//
//  Created by Madeline on 2023/11/12.
//

import Foundation

struct ApiResponse: Codable {
    struct Info: Codable {
        struct Size: Codable {
            let width: Int
            let height: Int
        }
        let size: Size
        let faceCount: Int
    }
    let info: Info
    let faces: [Face]?

    struct Face: Codable {
        struct Celebrity: Codable {
            let value: String
            let confidence: Double
        }
        let celebrity: Celebrity?
    }
}

//
//  OpenAIService.swift
//  FaceReader
//
//  Created by 홍승완 on 2023/11/12.
//

import UIKit
import RxSwift

func apiCall(name: String) {
    let openAIKey = "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"
    guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
    
    let httpBody: [String: Any] = [
        "model" : "gpt-3.5-turbo",
        "messages" : [
            ["role": "system",
             "content": "한국 연예인 \(name)의 관상에 대해서 눈, 코, 입에 대해 각 1줄씩 총 3줄 관상을 봐줘 이때 \(name)이라는 단어는 \"당신\" 으로 치환해줘"]
        ],
        "temperature": 0.7
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: httpBody, options: .fragmentsAllowed)
    
    // URLSession을 사용하여 요청 전송
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("error")
            return
        }
        do {
            let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            print("SUCCESS: \(response.choices[0].message.content)")
        } catch {
            print(error)
        }
    }
    
    task.resume()
}

func openAIRequest(name: String) -> Observable<String> {
    return Observable.create { observer in
        let openAIKey = "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"
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            observer.onError(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return Disposables.create()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        
        let httpBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                [
                    "role": "system",
                    "content": "한국 연예인 \(name)의 관상에 대해서 눈, 코, 입에 대해 각 1줄씩 총 3줄 관상을 봐줘 이때 \(name)이라는 단어는 \"당신\" 으로 치환해줘"
                ]
            ],
            "temperature": 0.7
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: httpBody, options: .fragmentsAllowed)
        } catch {
            observer.onError(error)
            return Disposables.create()
        }
        
        // URLSession을 사용하여 요청 전송
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                observer.onError(error ?? NSError(domain: "API Error", code: 1, userInfo: nil))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                observer.onNext(response.choices[0].message.content)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
        }
        
        task.resume()
        
        return Disposables.create {
            // Cleanup code if needed
        }
    }
}

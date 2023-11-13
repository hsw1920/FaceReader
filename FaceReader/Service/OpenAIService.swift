//
//  OpenAIService.swift
//  FaceReader
//
//  Created by 홍승완 on 2023/11/12.
//

import UIKit
import RxSwift

func openAIRequest(name: String) -> Observable<String> {
    return Observable.create { observer in
        let openAIKey = Bundle.main.OPENAI_API_KEY
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
                    "content": "한국 연예인 \(name)의 관상에 대해서 재물운, 애정운, 총운에 대해 각 2 문장, 총 6 문장의 관상을 봐줘. 이때 \(name)이라는 단어는 \"당신\" 으로 치환해줘. 형식은 재물운: ~ \n\n, 애정운: ~ \n\n, 총운: ~ \n\n의 형식으로 해줘"
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

extension Bundle {
    
    var OPENAI_API_KEY: String {
        guard let file = self.path(forResource: "Info", ofType: "plist") else { return "" }
        
        // .plist를 딕셔너리로 받아오기
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        
        // 딕셔너리에서 값 찾기
        guard let key = resource["OPENAI_API_KEY"] as? String else {
            fatalError("OPENAI_API_KEY error")
        }
        return key
    }
}

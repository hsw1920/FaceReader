//
//  FaceRecognizerService.swift
//  FaceReader
//
//  Created by 신정연 on 11/11/23.
//

import UIKit
import RxSwift

func apiCall(image: UIImage, completion: @escaping (Result<ApiResponse, Error>) -> Void) {
    
    guard let url = URL(string: "https://naveropenapi.apigw.ntruss.com/vision/v1/celebrity") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let body = NSMutableData()
    
    guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
    
    let boundary = "Boundary-\(UUID().uuidString)"
    
    // Content-Type
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    request.addValue("lrfeid05v8", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
    request.addValue("AGHY7CFYcohP2lwmXohdeQSlFK8VgxuZgT78jWaV", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    
    body.appendString("--\(boundary)\r\n")
    body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
    body.appendString("Content-Type: image/jpeg\r\n\r\n")
    body.append(imageData)
    body.appendString("\r\n")
    body.appendString("--\(boundary)--\r\n")
    
    request.httpBody = body as Data
    
    // URLSession을 사용하여 요청 전송
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
            completion(.success(apiResponse))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

func faceRecognitionRequest(image: UIImage) -> Observable<String> {
    return Observable.create { observer in
        guard let url = URL(string: "https://naveropenapi.apigw.ntruss.com/vision/v1/celebrity") else {
            observer.onError(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return Disposables.create()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let body = NSMutableData()
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            observer.onError(NSError(domain: "Invalid Image Data", code: 0, userInfo: nil))
            return Disposables.create()
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Content-Type
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.addValue("lrfeid05v8", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue("AGHY7CFYcohP2lwmXohdeQSlFK8VgxuZgT78jWaV", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n")
        body.appendString("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        request.httpBody = body as Data
        
        // URLSession을 사용하여 요청 전송
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                observer.onError(error)
                return
            }
            
            guard let data = data else {
                observer.onError(NSError(domain: "No Data", code: 0, userInfo: nil))
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(ApiResponse.self, from: data)
                
                guard let faces = apiResponse.faces else { return }
                
                if faces.count > 0 {
                    observer.onNext(faces[0].celebrity?.value ?? "")
                } else {
                    observer.onError(NSError(domain: "No Data", code: 0, userInfo: nil))
                }
                
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

// Multipart/form-data 어쩌고 관련
extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}


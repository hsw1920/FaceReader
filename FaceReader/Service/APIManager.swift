//
//  APIManager.swift
//  FaceReader
//
//  Created by 홍승완 on 2023/11/12.
//

import UIKit
import RxSwift
import RxCocoa

enum FaceReaderResponse {
    case success(text: String)
    case fail(error: String)
}

class APIManager {
    private let disposeBag = DisposeBag()

    let isValidImageRelay = PublishRelay<FaceReaderResponse>()
    let faceReaderRelay = PublishRelay<FaceReaderResponse>()
    
    func checkImageIsValid(image: UIImage) {
        faceRecognitionRequest(image: image)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] response in
                self?.postFaceReaderRequest(name: response)
            }) { [weak self] _ in
                self?.isValidImageRelay.accept(.fail(error: "잘못된 사진입니다. 다른 사진을 골라주세요."))
            } onCompleted: {
                print("Completed")
            }
            .disposed(by: disposeBag)
    }
    
    func postFaceReaderRequest(name: String) {
        openAIRequest(name: name)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] response in
                self?.faceReaderRelay.accept(.success(text: response))
            }) { [weak self] error in
                self?.faceReaderRelay.accept(.fail(error: "🚨삐용삐용\n다시 시도해주세요."))
            } onCompleted: {
                print("Completed")
            }
            .disposed(by: disposeBag)

    }
}

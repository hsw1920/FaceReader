//
//  FaceSelectVC.swift
//  FaceReader
//
//  Created by 신정연 on 11/11/23.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class FaceSelectVC: UIViewController {

    var disposeBag = DisposeBag()
    var selectedImage: UIImage?
    
    private let titleLabel = UILabel()
    private let selectedImageView = UIImageView()
    private let faceReadButton = UIButton()
    private let retryLabel = UILabel()
    private let cameraButton = UIButton()
    private let albumButton = UIButton()
    
    // MARK: Properties
    let apiManager = APIManager()
    
    private let faceRecognitionRelay = PublishSubject<String>()
    private let openAIRelay = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let selectedImage = selectedImage {
            selectedImageView.image = selectedImage
        }
        
        setupAttribute()
        setupLayout()
        setBinding()
    }
    
    private func setupAttribute() {
        titleLabel.do {
            $0.text = "얼굴 선택"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 30)
            $0.textAlignment = .center
        }
        
        selectedImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.backgroundColor = .lightGray
        }
        
        faceReadButton.do {
            $0.setTitle("관상 보러가기", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .gray
            $0.layer.cornerRadius = 20
            $0.addTarget(self, action: #selector(faceReadButtonTapped), for: .touchUpInside)
        }
        
        retryLabel.do {
            $0.text = "다시 찍기"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 20)
            $0.textAlignment = .center
        }
        
        cameraButton.do {
            $0.setTitle("카메라 촬영", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 20
            $0.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        }
        
        albumButton.do {
            $0.setTitle("앨범 업로드", for: .normal)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 20
            $0.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        [titleLabel, selectedImageView, cameraButton, albumButton, faceReadButton, retryLabel].forEach { view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(130)
            $0.centerX.equalToSuperview()
        }
        
        selectedImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(view.bounds.width / 2)
        }
        
        faceReadButton.snp.makeConstraints {
            $0.top.equalTo(selectedImageView.snp.bottom).offset(58)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        retryLabel.snp.makeConstraints {
            $0.top.equalTo(faceReadButton.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        cameraButton.snp.makeConstraints {
            $0.top.equalTo(retryLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
        
        albumButton.snp.makeConstraints {
            $0.top.equalTo(cameraButton.snp.bottom).offset(26)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(50)
        }
    }
    
    private func setBinding() {
        apiManager.isValidImageRelay
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success:
                    Observable.from(["거", "거의", "거의 다", "거의 다 되", "거의 다 되었", "거의 다 되었어", "거의 다 되었어요...", "거의 다 되었어요..", "거의 다 되었어요...", "거의 다 되었어요..", "거의 다 되었어요...", "거의 다 되었어요..", "거의 다 되었어요...", "거의 다 되었어요...", "거의 다 되었어요..", "좀 기다려봐요", "거의 다 되었어요..", "기달 ㅎㅎ", "거의 다 되었어요..", "거의 다 되었어요...", "기달 ㅎㅎ 2트", "거의 다 되었어요...", "거의 다 되었어요..", "기달 ㅎㅎ 3트", "거의 다 되었어요..", "거의 다 되었어요..", "기달 ㅎㅎ 4트", "거의 다 되었어요.."])
                        .concatMap { text in
                            Observable.just(text)
                                .delay(.seconds(1), scheduler: MainScheduler.instance)
                        }
                        .bind(to: self.titleLabel.rx.text)
                        .disposed(by: disposeBag)
                    
                    
                case .fail(let error):
                     //닮은 유명인을 찾지 못함, 알림 표시
                    faceReadButton.isEnabled = true
                    self.faceReadButton.backgroundColor = .gray
                    self.faceReadButton.titleLabel?.textColor = .black
                    titleLabel.text = "얼굴 선택"
                    self.showAlert(title: "Result", message: error)
                }
            })
            .disposed(by: disposeBag)
        
        apiManager.faceReaderRelay
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let text):
                    faceReadButton.isEnabled = true
                    self.faceReadButton.backgroundColor = .gray
                    self.faceReadButton.titleLabel?.textColor = .black
                    titleLabel.text = "얼굴 선택"
                    let vc = ResultVC()
                    vc.selectedImage = self.selectedImage
                    vc.textView.rx.text.onNext(text)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .fail(let error):
                    self.faceReadButton.backgroundColor = .gray
                    self.faceReadButton.titleLabel?.textColor = .black
                    faceReadButton.isEnabled = true
                    titleLabel.text = "얼굴 선택"
                    self.showAlert(title: "Result", message: error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func cameraButtonTapped() {
        openCamera()
    }

    @objc func albumButtonTapped() {
        openPhotoLibrary()
    }
    
    @objc func faceReadButtonTapped() {
        guard let image = selectedImageView.image else { return }
        self.titleLabel.text = "좀 오래걸려요~~"
        apiManager.checkImageIsValid(image: image)
        self.faceReadButton.backgroundColor = .black
        self.faceReadButton.setTitleColor(.white, for: .normal)
        faceReadButton.isEnabled = false
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

extension FaceSelectVC: UINavigationControllerDelegate {
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false // 필요에 따라 true로 설정하여 편집을 허용할 수 있음
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension FaceSelectVC: UIImagePickerControllerDelegate {
    // UIImagePickerController가 이미지를 선택하면 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            selectedImageView.image = pickedImage // 이미지 뷰에 선택한 이미지를 표시
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // 사용자가 취소했을 때 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//
//  MainVC.swift
//  FaceReader
//
//  Created by 신정연 on 11/11/23.
//

import UIKit
import Then

class MainVC: UIViewController {
    
    private let titleLabel = UILabel()
    private let cameraButton = UIButton()
    private let photoLibraryButton = UIButton()
    private var currentImage = UIImage()
    private let descriptionLabel = UILabel()
    private let frontImageView = UIImageView(image: UIImage(named: "front"))
    private let frontLabel = UILabel()
    private let sideImageView = UIImageView(image: UIImage(named: "side"))
    private let sideLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupAttribute()
        setupLayout()
    }
    
    private func setupAttribute() {
        titleLabel.do {
            $0.text = "관상이란?"
            $0.textColor = .black
            $0.font = .boldSystemFont(ofSize: 30)
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.text = "관상이란, 사람의 얼굴 특징을 관찰하여\n그 사람의 성격, 운명, 장단점 등을\n판단하는 것을 말합니다."
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        frontLabel.do {
            $0.text = "정면 O"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20)
            $0.textAlignment = .center
        }
        
        sideLabel.do {
            $0.text = "측면 X"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20)
            $0.textAlignment = .center
        }
        
        cameraButton.do {
            $0.setTitle("카메라 촬영", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        }
        
        photoLibraryButton.do {
            $0.setTitle("앨범 업로드", for: .normal)
            $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .lightGray
            $0.layer.cornerRadius = 20
            $0.clipsToBounds = true
            $0.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
        }
    }
    
    private func setupLayout() {
        let frontStack = UIStackView(arrangedSubviews: [frontImageView, frontLabel]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        let sideStack = UIStackView(arrangedSubviews: [sideImageView, sideLabel]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        let imageStack = UIStackView(arrangedSubviews: [frontStack, sideStack]).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, imageStack, cameraButton, photoLibraryButton]).then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .center
        }
        
        view.addSubview(mainStack)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            frontImageView.widthAnchor.constraint(equalToConstant: 100),
            frontImageView.heightAnchor.constraint(equalToConstant: 100),
            sideImageView.widthAnchor.constraint(equalToConstant: 100),
            sideImageView.heightAnchor.constraint(equalToConstant: 100),
            cameraButton.widthAnchor.constraint(equalToConstant: 300),
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            photoLibraryButton.widthAnchor.constraint(equalToConstant: 300),
            photoLibraryButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    
    // 카메라 버튼 탭 액션
    @objc func cameraButtonTapped() {
        openCamera()
    }
    
    // 앨범 버튼 탭 액션
    @objc func albumButtonTapped() {
        openPhotoLibrary()
    }
}

extension MainVC: UINavigationControllerDelegate {
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

extension MainVC: UIImagePickerControllerDelegate {
    // UIImagePickerController가 이미지를 선택하면 호출되는 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            print("이미지 선택했음")
            currentImage = pickedImage
        }
        picker.dismiss(animated: true) {
            let vc = FaceSelectVC()
            vc.selectedImage = self.currentImage
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 사용자가 취소했을 때 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

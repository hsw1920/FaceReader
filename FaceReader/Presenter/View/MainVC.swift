//
//  MainVC.swift
//  FaceReader
//
//  Created by 신정연 on 11/11/23.
//

import UIKit

class MainVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI 요소를 프로퍼티로 선언합니다.
    let imageView = UIImageView()
    let cameraButton = UIButton()
    let photoLibraryButton = UIButton()
    var currentImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
    }
    
    private func setupLayout() {
        let titleLabel = UILabel()
        titleLabel.text = "관상이란?"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .center
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "관상이란, 사람의 얼굴 특징을 관찰하여\n그 사람의 성격, 운명, 장단점 등을\n판단하는 것을 말합니다."
        descriptionLabel.textColor = .black
        descriptionLabel.font = .systemFont(ofSize: 20)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        let frontImageView = UIImageView(image: UIImage(named: "front"))
        let frontLabel = UILabel()
        frontLabel.text = "정면 O"
        frontLabel.textColor = .black
        frontLabel.font = .systemFont(ofSize: 20)
        frontLabel.textAlignment = .center
        
        let sideImageView = UIImageView(image: UIImage(named: "side"))
        let sideLabel = UILabel()
        sideLabel.text = "측면 X"
        sideLabel.textColor = .black
        sideLabel.font = .systemFont(ofSize: 20)
        sideLabel.textAlignment = .center
        
        let cameraButton = UIButton()
        cameraButton.setTitle("카메라 촬영", for: .normal)
        cameraButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        cameraButton.setTitleColor(.black, for: .normal)
        cameraButton.backgroundColor = .lightGray
        cameraButton.layer.cornerRadius = 20
        cameraButton.clipsToBounds = true
        cameraButton.translatesAutoresizingMaskIntoConstraints = false // 오토 레이아웃 사용 설정
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        let albumButton = UIButton()
        albumButton.setTitle("앨범 업로드", for: .normal)
        albumButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        albumButton.setTitleColor(.black, for: .normal)
        albumButton.backgroundColor = .lightGray
        albumButton.layer.cornerRadius = 20
        albumButton.clipsToBounds = true
        albumButton.translatesAutoresizingMaskIntoConstraints = false // 오토 레이아웃 사용 설정
        albumButton.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
        
        let frontStack = UIStackView(arrangedSubviews: [frontImageView, frontLabel])
        frontStack.axis = .vertical
        frontStack.alignment = .center
        frontStack.distribution = .fillEqually
        
        let sideStack = UIStackView(arrangedSubviews: [sideImageView, sideLabel])
        sideStack.axis = .vertical
        sideStack.alignment = .center
        sideStack.distribution = .fillEqually
        
        let imageStack = UIStackView(arrangedSubviews: [frontStack, sideStack])
        imageStack.axis = .horizontal
        imageStack.spacing = 20
        
        let mainStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, imageStack, cameraButton, albumButton])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            frontImageView.widthAnchor.constraint(equalToConstant: 100),
            frontImageView.heightAnchor.constraint(equalToConstant: 100),
            sideImageView.widthAnchor.constraint(equalToConstant: 100),
            sideImageView.heightAnchor.constraint(equalToConstant: 100),
            cameraButton.widthAnchor.constraint(equalToConstant: 300),
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            
            albumButton.widthAnchor.constraint(equalToConstant: 300),
            albumButton.heightAnchor.constraint(equalToConstant: 50),
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
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false // 필요에 따라 true로 설정하여 편집을 허용할 수 있음
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
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

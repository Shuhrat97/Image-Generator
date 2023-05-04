//
//  GeneratorViewController.swift
//  Image-Generator
//
//  Created by Shuhrat Nurov on 03/05/23.
//

import UIKit
import CoreData

class GeneratorViewController: UIViewController {
    
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let inputField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter text"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let favoriteBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add to favorite", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isHidden = true
        return btn
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(inputField)
        view.addSubview(confirmButton)
        view.addSubview(imageView)
        view.addSubview(favoriteBtn)
        
        NSLayoutConstraint.activate([
            inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            inputField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            confirmButton.topAnchor.constraint(equalTo: inputField.bottomAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: inputField.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: confirmButton.bottomAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            favoriteBtn.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16),
            favoriteBtn.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            favoriteBtn.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -16),
        ])
        
        favoriteBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc func confirmButtonTapped() {
        guard let text = inputField.text, !text.isEmpty else {
            showError(message: "Please enter some text")
            return
        }
        let t = text.replacingOccurrences(of: " ", with: "%20")
        let endPoint = Endpoint.getImage(text: t)
        NetworkManager.shared.getImage(endPoint: endPoint) { [weak self] result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                guard let image = UIImage(data: success) else {
                    self?.showError(message: "Failed to convert response data to image")
                    self?.favoriteBtn.isHidden = true
                    return
                }
                    self?.imageView.image = image
                    self?.favoriteBtn.isHidden = false
                }
            case .failure(let failure):
                self?.showError(message: failure.localizedDescription)
                self?.favoriteBtn.isHidden = true
            }
        }
    }
    
    
    @objc func btnTapped(){
        guard let text = inputField.text, !text.isEmpty, let image = imageView.image else { return }
        DataManager.shared.saveImageToCoreData(title: text, image: image)
    }
    
    // MARK: - Helper Functions
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


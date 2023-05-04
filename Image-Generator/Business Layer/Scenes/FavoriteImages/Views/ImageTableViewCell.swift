//
//  ImageTableViewCell.swift
//  Image-Generator
//
//  Created by Shuhrat Nurov on 04/05/23.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    private let imgView:UIImageView = {
        let imgView = UIImageView()
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 10
        imgView.layer.borderColor = UIColor.black.cgColor
        imgView.layer.borderWidth = 0.3
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let titleLbl:UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.numberOfLines = 3
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let deleteBtn:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Delete", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var btnCallback:()->() = {}
//    var previewCallback:()->() = {}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        makeConstraints()
        
        deleteBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews(){
        contentView.addSubview(imgView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(deleteBtn)
    }
    
    private func makeConstraints(){
        let width = UIScreen.main.bounds.width - 40
        
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imgView.widthAnchor.constraint(equalToConstant: width),
            imgView.heightAnchor.constraint(equalToConstant: width),
            
            titleLbl.leadingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -20),
            titleLbl.bottomAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -20),
            
            deleteBtn.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 16),
            deleteBtn.trailingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: -16),
            
        ])
        
        
        
    }
    
    @objc func btnTapped(){
        btnCallback()
    }
    
    func reload(_ entity:SavedImages){
        if let image = UIImage(data: entity.imageData!) {
            imgView.image = image
        } else {
            imgView.image = nil
        }
        
        titleLbl.text = entity.title
    }
    
}

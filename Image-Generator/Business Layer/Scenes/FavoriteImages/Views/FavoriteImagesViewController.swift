//
//  FavoriteBooksViewController.swift
//  GoogleBooks
//
//  Created by Shuhrat Nurov on 24/12/22.
//

import UIKit

class FavoriteImagesViewController: UIViewController {
    
    private let tableView:UITableView = {
        let table = UITableView()
        table.register(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var images:[SavedImages] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        images = DataManager.shared.fetchImagesFromCoreData()
        tableView.reloadData()
    }
    
}

extension FavoriteImagesViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath as IndexPath) as? ImageTableViewCell
        cell?.selectionStyle = .none
        let image = images[indexPath.row]
        cell?.reload(image)
        cell?.btnCallback = {
            DispatchQueue.main.async { [weak self] in
                self?.images.remove(at: indexPath.row)
                DataManager.shared.deleteImageFromCoreData(imageEntity: image)
                self?.tableView.reloadData()
            }
        }
        return cell!
    }
    
    
}

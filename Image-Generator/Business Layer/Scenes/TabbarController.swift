//
//  TabbarController.swift
//  Image-Generator
//
//  Created by Shuhrat Nurov on 03/05/23.
//

import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupVCs()
    }
    
    func setupVCs() {
        viewControllers = [
            createNavControllers(for: GeneratorViewController(), title: "Main", image: nil),
            createNavControllers(for: FavoriteImagesViewController(), title: "Favorite", image: nil)
        ]
    }
    
    private func createNavControllers(for rootViewController:UIViewController, title:String, image:UIImage?)->UIViewController{
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        rootViewController.navigationItem.title = title
        return navController
    }
}

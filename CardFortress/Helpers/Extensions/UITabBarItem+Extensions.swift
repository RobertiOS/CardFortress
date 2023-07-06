//
//  UITabBarItem+Extensions.swift
//  CardFortress
//
//  Created by Roberto Corrales on 6/11/23.
//

import UIKit

extension UITabBarItem {
    convenience init(tabBarIndex: TabBarCoordinatorIndex) {
        self.init(
            title: tabBarIndex.title,
            image: tabBarIndex.image,
            selectedImage: tabBarIndex.selectedImage
        )
    }
}

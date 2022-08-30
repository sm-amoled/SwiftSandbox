//
//  ContactType.swift
//  RealityKitTutorial
//
//  Created by Park Sungmin on 2022/08/29.
//

enum ContactType {
    /// True: nodeA is bullet, False: nodeB is bullet
    case bulletAndEnemy(Bool)
    /// True: nodeA is player, False: nodeB is player
    case playerAndEnemy(Bool)
    /// True: nodeA is player, False: nodeB is player
    case playerAndLifeBox(Bool)
}

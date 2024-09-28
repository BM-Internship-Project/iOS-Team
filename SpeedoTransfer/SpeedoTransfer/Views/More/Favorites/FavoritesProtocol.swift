//
//  FavoritesProtocol.swift
//  Registration
//
//  Created by Merna Islam on 09/09/2024.
//

import Foundation

protocol FavoritesProtocol: AnyObject {
    func openEditSheet(at i: Int)
    func deleteFavorite(at i: Int)
}

//
//  Helper.swift
//  Registration
//
//  Created by Merna Islam on 12/09/2024.
//

class AppHelper {
    
    static func getInitials(from fullName: String) -> String {
        let nameComponents = fullName.split(separator: " ")
        let initials = nameComponents.compactMap { $0.first }
        return initials.map { String($0) }.joined().uppercased()
    }
}

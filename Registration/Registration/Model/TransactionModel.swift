//
//  TransactionModel.swift
//  Registration
//
//  Created by Merna Islam on 11/09/2024.
//

import Foundation

struct TransactionModel: Codable {
    let id: Int
    let timestamp: String
    let senderAccount: Account
    let receiverAccount: Account
    let amount: Double
    
    func formatTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        formatter.locale = Locale(identifier: "en_EG")
        
        guard let date = formatter.date(from: self.timestamp) else {
            return ""
        }
        
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
            return "Today \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "EEEE h:mm a"
            return formatter.string(from: date)
        }
    }
}


struct Account: Codable {
    let id: Int
    let accountNumber: String
    let name: String
    let email: String
    let country: String
    let dateOfBirth: String
    let balance: Double
}

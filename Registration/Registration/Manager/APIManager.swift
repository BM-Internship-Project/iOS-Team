//
//  APIManager.swift
//  Registration
//
//  Created by Malak Mohamed on 10/09/2024.
//

import Foundation
import Alamofire

class APIManager {
    
    private static let baseURL = "https://money-transfer-production.up.railway.app/api"
    
    private static func getTokenHeader() -> HTTPHeaders? {
        guard let token = TokenManager.shared.getToken() else { return nil }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: token),
            .accept("application/json")
        ]
        return headers
    }
    
    static func registerUser(user: User, completion: @escaping (Result<Any, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                completion(.failure(noDataError))
                return
            }

            // Debugging: Print the response data
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Data: \(responseString)")
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    
    static func loginUser(email: String, password: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error encoding login data: \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Extract the token from the JSON response
                    if let token = jsonResponse["token"] as? String {
                        // Save the token to the Keychain
                        TokenManager.shared.setToken(token)
                        
                        completion(.success(jsonResponse))
                    
                    } else {
                        // Token not found in the response, return an error
                        completion(.failure(NSError(domain: "Token not found in response", code: -1, userInfo: nil)))
                    }
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    static func logoutUser(completion: @escaping (Result<String, Error>) -> Void) {
            let url = "\(baseURL)/logout"
            
            guard let token = TokenManager.shared.getToken() else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token not available"])))
                return
            }
            
            let headers: HTTPHeaders = [
                .authorization(bearerToken: token)
            ]
            
            AF.request(url, method: .post, headers: headers)
                .validate(statusCode: 200...299)
                .responseString { response in
                    switch response.result {
                    case .success(let message):
                        print("Response Data: \(message)")
                        completion(.success(message))
                    case .failure(let error):
                        print("Logout request error: \(error.localizedDescription)")
                        if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                            print("Response Data: \(errorMessage)")
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                        } else {
                            completion(.failure(error))
                        }
                    }
                }
        }

    
    static func getBalance(completion: @escaping (Result<Double, Error>) -> Void) {
        let url = "\(self.baseURL)/balance"
        guard let headers = self.getTokenHeader() else { return }
        
        AF.request(url, method: .get, headers: headers)
               .validate()
               .responseData { response in
                   switch response.result {
                   case .success(let data):
                       do {
                           if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                              let balance = jsonResponse["balance"] as? Double {
                               completion(.success(balance))
                           } else {
                               completion(.failure(NSError(domain: "Invalid response format", code: -1, userInfo: nil)))
                           }
                       } catch {
                           completion(.failure(error))
                       }
                       
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
    }
    
    static func transfer(to accNum: String, amount: Double, completion: @escaping (Result<Data, Error>) -> Void){
        let url = "\(self.baseURL)/transfer"
        guard let headers = self.getTokenHeader() else { return }
        
        let parameters: [String: Any] = [
            "toAccount": accNum,
            "amount": amount
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseData { response in
               switch response.result {
               case .success(let data):
                   completion(.success(data))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
    }
    
    static func getTransactions(completion: @escaping (Result<[TransactionModel], Error>) -> Void){
        let url = "\(self.baseURL)/transactions"
        guard let headers = self.getTokenHeader() else { return }
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: [TransactionModel].self) { response in
            switch response.result {
            case .success(let transactions):
                completion(.success(transactions))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func getFavorites(completion: @escaping (Result<[FavoriteModel], Error>) -> Void){
        let url = "\(self.baseURL)/favorites"
        guard let headers = self.getTokenHeader() else { return }
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: [FavoriteModel].self) { response in
            switch response.result {
            case .success(let favorites):
                completion(.success(favorites))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func deleteFavorite(id: Int, completion: @escaping (Result<Data, Error>) -> Void){
        let url = "\(self.baseURL)/favorites/\(id)"
        guard let headers = self.getTokenHeader() else { return }
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
        }
    }
    
    static func addFavorite(to recipientName: String, withAccount accNum: String, completion: @escaping (Result<Data, Error>) -> Void){
        let url = "\(self.baseURL)/favorites"
        guard let headers = self.getTokenHeader() else { return }
        
        let parameters: [String: Any] = [
            "recipientName": recipientName,
            "recipientAccountNumber": accNum
        ]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate()
            .responseData { response in
               switch response.result {
               case .success(let data):
                   completion(.success(data))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
    }
}

//
//  OpenAiRequest.swift
//  СryptoTrader
//
//  Created by Валерий Никитин on 11.10.2023.
//

import Foundation

class GPTService {
    private let endpointURL = "https://api.openai.com/v2/engines/gpt-4.0-turbo/completions"
    private let apiKey = "YOUR_OPENAI_API_KEY" // Замените на свой ключ API
    
    func askGPT4(question: String, completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: endpointURL) else {
            completion(nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Неверный URL"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: Any] = [
            "prompt": question,
            "max_tokens": 150
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed)
        } catch {
            completion(nil, error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Нет данных"]))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                   let choices = jsonResponse["choices"] as? [[String: Any]],
                   let firstChoice = choices.first,
                   let text = firstChoice["text"] as? String {
                    completion(text, nil)
                } else {
                    completion(nil, NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Ошибка при разборе ответа"]))
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}

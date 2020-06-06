//
//  TelegramService.swift
//  EternityFeedback
//
//  Created by Daniya on 06/06/2020.
//  Copyright © 2020 ZiyoMukhammad Usmonov. All rights reserved.
//

import Foundation


struct TelegramService {
    
    /// set credentials
    internal let botToken = "BOT_TOKEN"
    internal let chatID = "CHAT_ID"
    internal let serviceUrl = "https://api.telegram.org/bot"
    internal let apiClient = APIClient()
    
    func sendMessage(_ text: String) {
        
        let params = ["chat_id": "\(chatID)", "text": "\(text)"]
        let urlString = serviceUrl + "\(botToken)/sendMessage?"
        
        let request = apiClient.createRequest(url: urlString, method: "POST", params: params)
        let data = request.flatMap { apiClient.sendRequest($0) }
        
        let dictResponse: Result<[String: Any], NetworkError> =  data.flatMap { apiClient.parseResponse(data: $0)
        }
        
        print(dictResponse)
    }

}

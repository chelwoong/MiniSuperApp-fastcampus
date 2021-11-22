//
//  SetupURLProtocol.swift
//  MiniSuperApp
//
//  Created by woongs on 2021/11/22.
//

import Foundation

func setupURLProtocol() {
    
    // Topup
    let topupResponse: [String: Any] = [
        "status": "success"
    ]
    let topupResponseData = try! JSONSerialization.data(withJSONObject: topupResponse, options: [])
    
    // AddCard
    let addCardResponse: [String: Any] = [
        "card": [
            "id": "999",
            "name": "새 카드",
            "digits": "**** 0101",
            "color": "",
            "isPrimary": false
        ]
    ]
    let addCardResponseData = try! JSONSerialization.data(withJSONObject: addCardResponse, options: [])
    
    // CardOnFile
    let cardOnFileResponse: [String: Any] = [
        "cards": [
            [
                "id": "999",
                "name": "우리은행",
                "digits": "**** 0123",
                "color": "#f19a38ff",
                "isPrimary": false
            ],
            [
                "id": "999",
                "name": "신한은행",
                "digits": "**** 1234",
                "color": "#3478f6ff",
                "isPrimary": false
            ],
            [
                "id": "999",
                "name": "국민은행",
                "digits": "**** 0323",
                "color": "#78c5f5ff",
                "isPrimary": false
            ],
        ]
    ]
    let cardOnFileResponseData = try! JSONSerialization.data(withJSONObject: cardOnFileResponse, options: [])
    
    SuperAppURLProtocol.successMock = [
        "/api/v1/topup": (200, topupResponseData),
        "/api/v1/addCard": (200, addCardResponseData),
        "/api/v1/cards": (200, cardOnFileResponseData),
    ]
}

//
//  GlobalStats.swift
//  Coinpaprika
//
//  Created by Dominique Stranz on 17.09.2018.
//  Copyright © 2018 Grey Wizard sp. z o.o. All rights reserved.
//

import Foundation
//{\"market_cap_usd\":202576432484,\"volume_24h_usd\":10518818060,\"bitcoin_dominance_percentage\":55.32271,\"cryptocurrencies_number\":1960,\"last_updated\":1537181981}"
public struct GlobalStats: Decodable, Equatable {
    public let marketCapUsd: Int64
    public let volume24hUsd: Int64
    public let bitcoinDominancePercentage: Decimal
    public let cryptocurrenciesNumber: Int
    public let lastUpdated: Date?
    
    enum CodingKeys: String, CodingKey {
        case marketCapUsd = "market_cap_usd"
        case volume24hUsd = "volume_24h_usd"
        case bitcoinDominancePercentage = "bitcoin_dominance_percentage"
        case cryptocurrenciesNumber = "cryptocurrencies_number"
        case lastUpdated = "last_updated"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        volume24hUsd = try values.decode(Int64.self, forKey: .volume24hUsd)
        marketCapUsd = try values.decode(Int64.self, forKey: .marketCapUsd)
        bitcoinDominancePercentage = try values.decode(Decimal.self, forKey: .bitcoinDominancePercentage)
        cryptocurrenciesNumber = try values.decode(Int.self, forKey: .cryptocurrenciesNumber)
        lastUpdated = try values.decode(.lastUpdated, transformer: IntToDateTransformer())
    }
}

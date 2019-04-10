//
//  CodableTest.swift
//  CoinpaprikaAPI_Example
//
//  Created by Dominique Stranz on 24/10/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import CoinpaprikaAPI

class CodableTest: XCTestCase {
    
    let bitcoinId = "btc-bitcoin"
    
    func testTickerEncodeDecode() {
        let expectation = self.expectation(description: "Waiting for ticker")
        
        
        CoinpaprikaAPI.ticker(id: bitcoinId, quotes: [.usd, .btc]).perform { (response) in
            let bitcoin = response.value
            
            XCTAssertNotNil(bitcoin, "Ticker should exist")
            XCTAssert(bitcoin?.id == self.bitcoinId, "BTC not found")
            XCTAssert(bitcoin?.symbol == "BTC", "BTC not found")
            XCTAssert(bitcoin?[.btc].price == 1, "1 BTC value in BTC should be equal 1")
            XCTAssert((bitcoin?[.usd].price ?? 0) > 0, "1 BTC value in USD should be greater than 0")
            
            let encoder = Ticker.encoder
            let encodedData = try? encoder.encode(bitcoin)
            XCTAssertNotNil(encodedData, "Encoding shouldn't fail")
            
            let decoder = Ticker.decoder
            
            var decodedBitcoin: Ticker!
            do {
                decodedBitcoin = try decoder.decode(Ticker.self, from: encodedData!)
            } catch DecodingError.dataCorrupted(let context) {
                assertionFailure("\(Ticker.self): \(context.debugDescription)")
            } catch DecodingError.keyNotFound(let key, let context) {
                assertionFailure("\(Ticker.self): \(key.stringValue) was not found, \(context.debugDescription)")
            } catch DecodingError.typeMismatch(let type, let context) {
                assertionFailure("\(Ticker.self): \(type) was expected, \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                assertionFailure("\(Ticker.self): no value was found for \(type), \(context.debugDescription)")
            } catch {
                assertionFailure("\(Ticker.self): unknown decoding error")
            }
            
            XCTAssertNotNil(decodedBitcoin, "Ticker should exist")
            XCTAssert(bitcoin?.id == decodedBitcoin.id, "BTC not found")
            XCTAssert(bitcoin?.symbol == decodedBitcoin.symbol, "BTC not found")
            XCTAssert(bitcoin?[.btc].price == decodedBitcoin[.btc].price, "priceBtc isn't equal")
            XCTAssert(bitcoin?[.usd].price == decodedBitcoin[.usd].price, "priceUsd isn't equal")
            XCTAssert(bitcoin?[.btc].marketCap == decodedBitcoin[.btc].marketCap, "marketCapBtc isn't equal")
            XCTAssert(bitcoin?[.usd].athDate == decodedBitcoin[.usd].athDate, "athDate isn't equal")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 30)
        
    }
}

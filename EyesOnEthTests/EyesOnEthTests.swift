//
//  EyesOnEthTests.swift
//  Tests
//

import Foundation
import SwiftyJSON
import XCTest
@testable import EyesOnEth

final class EthereumUtilTests: XCTestCase {
    func testAbbreviatesAddressUsingRequestedPrefixAndSuffixLengths() {
        let address = "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"

        XCTAssertEqual(EthereumUtil.getAbbreviateAddress(address, (6, 4)), "0x742d...f44e")
    }

    func testFormatsPricesWithAnExplicitLocale() {
        let locale = Locale(identifier: "en_US_POSIX")

        XCTAssertEqual(EthereumUtil.tokenPriceForDetailView(1234.567, locale: locale), "1,234.57")
        XCTAssertEqual(EthereumUtil.tokenPriceForDetailView(0.12345678, locale: locale), "0.123457")
        XCTAssertEqual(EthereumUtil.tokenPriceForDetailView(1, locale: locale), "1")
    }

    func testFormatsPriceDifferencesWithAnExplicitLocale() {
        let locale = Locale(identifier: "en_US_POSIX")

        XCTAssertEqual(EthereumUtil.tokenPriceDiffString(1.25, locale: locale), "+1.25%")
        XCTAssertEqual(EthereumUtil.tokenPriceDiffString(-1.25, locale: locale), "-1.25%")
        XCTAssertEqual(EthereumUtil.tokenPriceDiffString(0, locale: locale), "")
    }

    func testRoundsPortfolioTotalsToWholeNumbers() {
        XCTAssertEqual(EthereumUtil.roundUpTotal(2.6), 3)
        XCTAssertEqual(EthereumUtil.roundUpTotal(-2.6), -3)
    }
}

final class ModelDecodingTests: XCTestCase {
    func testCoinGeckoTokenPricesDecodeFromInMemoryJSON() throws {
        let data = Data("""
        {"ethereum":{"usd":3125.5},"usd-coin":{"usd":1}}
        """.utf8)
        let prices = CoinGeckoSimpleTokenPrice(data: data)

        XCTAssertEqual(prices.array.count, 2)
        XCTAssertEqual(try XCTUnwrap(prices.array["ethereum"]).usd, 3125.5)
        XCTAssertEqual(try XCTUnwrap(prices.array["usd-coin"]).usd, 1)
    }

    func testCoinGeckoTokenPricesReturnEmptyDictionaryForInvalidJSON() {
        let prices = CoinGeckoSimpleTokenPrice(data: Data("not-json".utf8))

        XCTAssertTrue(prices.array.isEmpty)
    }

    func testCoinGeckoSimplePriceReadsEthereumMetrics() {
        let json = JSON(parseJSON: """
        {"ethereum":{"usd":3125.5,"usd_24h_change":1.75,"usd_24h_vol":987654.25,"usd_market_cap":376543210.5}}
        """)
        let price = CoinGeckoSimplePrice(simplePrice: json)

        XCTAssertEqual(price.ethPriceInUSD, 3125.5)
        XCTAssertEqual(price.eth24hrChange, 1.75)
        XCTAssertEqual(price.eth24hrVolume, 987654.25)
        XCTAssertEqual(price.ethMarketCap, 376543210.5)
    }

    func testEtherscanGasTrackerReadsResultAndStatus() {
        let json = JSON(parseJSON: """
        {"status":"1","msg":"OK","result":{"LastBlock":"21000000","SafeGasPrice":"12","ProposeGasPrice":"15","FastGasPrice":"20"}}
        """)
        let tracker = EtherscanGastracker(gastracker: json)

        XCTAssertEqual(tracker.status, 1)
        XCTAssertEqual(tracker.msg, "OK")
        XCTAssertEqual(tracker.result.lastBlock, 21_000_000)
        XCTAssertEqual(tracker.result.safeGasPrice, 12)
        XCTAssertEqual(tracker.result.proposeGasPrice, 15)
        XCTAssertEqual(tracker.result.fastGasPrice, 20)
    }

    func testEthplorerAddressInfoDecodesBalancesAndPortfolioValues() throws {
        let json = JSON(parseJSON: """
        {
          "ETH": {
            "balance": 1.5,
            "price": {"rate": 2000, "diff": 2.25, "diff7d": -1.5, "marketCapUsd": "400000000000"}
          },
          "tokens": [
            {
              "tokenInfo": {
                "decimals": 6, "address": "0xpriced", "name": "USD Coin", "symbol": "USDC",
                "price": {"rate": 0.99, "diff": 0.5, "diff7d": 1.25, "marketCapUsd": 1000000}
              },
              "balance": 2500000
            },
            {
              "tokenInfo": {
                "decimals": 18, "address": "0xunpriced", "name": "Unpriced Token", "symbol": "ZERO",
                "price": {"rate": 0, "diff": 0, "diff7d": 0, "marketCapUsd": 0}
              },
              "balance": 1250000000000000000
            }
          ]
        }
        """)
        let info = EthplorerGetAddressInfo(getAddressInfo: json)
        let pricedToken = try XCTUnwrap(info.tokens.first)
        let unpricedToken = try XCTUnwrap(info.tokens.last)

        XCTAssertEqual(info.ethModel.balance, 1.5)
        XCTAssertEqual(info.ethModel.price, 2000)
        XCTAssertEqual(info.ethModel.value, 3000)
        XCTAssertEqual(info.ethModel.marketCap, "400000000000")
        XCTAssertEqual(pricedToken.contractAddr, "0xpriced")
        XCTAssertEqual(pricedToken.balance, 2.5)
        XCTAssertEqual(pricedToken.value, 2.475, accuracy: 0.000001)
        XCTAssertEqual(pricedToken.priceDiff, 0.5)
        XCTAssertEqual(unpricedToken.balance, 1.25, accuracy: 0.000001)
        XCTAssertEqual(info.contractAddressList, ["0xpriced", "0xunpriced"])
        XCTAssertEqual(info.priceFalseKV["0xunpriced"], 1.25)
        XCTAssertEqual(info.totalValue, 3002.475, accuracy: 0.000001)
    }
}

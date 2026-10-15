//
//  Constants.swift
//  
//  Created by Chon, Felix  on 2021/01/04.
//
import Foundation
import SwiftyJSON

struct Result {
    var lastBlock:Int64
    var safeGasPrice:Int64
    var proposeGasPrice:Int64
    var fastGasPrice:Int64
}

class EtherscanGastracker {
    
    private var _result:Result
    private var _status:Int
    private var _msg:String
    
    var result:Result {
        return _result
    }
    
    var status:Int {
        return _status
    }
    
    var msg:String {
        return _msg
    }
    
    init?(gastracker: JSON) {
        let result = gastracker["result"]
        guard Self.integerValue(gastracker["status"]) == 1,
              result.type == .dictionary,
              let lastBlock = Self.integerValue(result["LastBlock"]),
              let safeGasPrice = Self.integerValue(result["SafeGasPrice"]),
              let proposeGasPrice = Self.integerValue(result["ProposeGasPrice"]),
              let fastGasPrice = Self.integerValue(result["FastGasPrice"]),
              lastBlock > 0,
              safeGasPrice >= 0,
              proposeGasPrice >= 0,
              fastGasPrice >= 0 else {
            return nil
        }

        let status = 1
        let msg = gastracker["msg"].stringValue
        self._result = Result(lastBlock: lastBlock, safeGasPrice: safeGasPrice, proposeGasPrice: proposeGasPrice, fastGasPrice: fastGasPrice)
        self._status = status
        self._msg = msg
    }

    private static func integerValue(_ value: JSON) -> Int64? {
        switch value.type {
        case .string:
            guard let string = value.string else { return nil }
            return Int64(string)
        case .number:
            guard let number = value.double,
                  number.isFinite,
                  number >= 0,
                  number < 9_223_372_036_854_775_808,
                  number.rounded(.towardZero) == number else {
                return nil
            }
            return Int64(number)
        default:
            return nil
        }
    }
    
}

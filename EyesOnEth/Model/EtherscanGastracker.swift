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
    
    private var _result:Result!
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
    
    init(gastracker: JSON) {
        
        let result = gastracker["result"]
        let status = gastracker["status"].intValue
        let msg = gastracker["msg"].stringValue
        
        let lastBlock = result["LastBlock"].int64Value
        let safeGasPrice = result["SafeGasPrice"].int64Value
        let proposeGasPrice = result["ProposeGasPrice"].int64Value
        let fastGasPrice = result["FastGasPrice"].int64Value
        
        self._result = Result(lastBlock: lastBlock, safeGasPrice: safeGasPrice, proposeGasPrice: proposeGasPrice, fastGasPrice: fastGasPrice)
        self._status = status
        self._msg = msg
    }
    
}

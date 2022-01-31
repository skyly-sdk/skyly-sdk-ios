//
//  NSData+sha1.swift
//  Skyly
//
//  Created by Philippe Auriach on 31/01/2022.
//

import Foundation
import CryptoKit
import CommonCrypto

private func hexString(_ iterator: Array<UInt8>.Iterator) -> String {
    return iterator.map { String(format: "%02x", $0) }.joined()
}

extension Data {
    
    public var sha1: String {
        if #available(iOS 13.0, *) {
            return hexString(Insecure.SHA1.hash(data: self).makeIterator())
        } else {
            var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            self.withUnsafeBytes { bytes in
                _ = CC_SHA1(bytes.baseAddress, CC_LONG(self.count), &digest)
            }
            return hexString(digest.makeIterator())
        }
    }
}

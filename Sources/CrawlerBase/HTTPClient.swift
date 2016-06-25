//
//  HTTPClient.swift
//  CrawlerBase
//
//  Created by Yusuke Ito on 6/26/16.
//  Copyright © 2016 Yusuke Ito. All rights reserved.
//

import Foundation
import Socket


final class HTTPClient {
    
    enum Error: ErrorProtocol {
        case responseParseError
    }
    
    init() {
        
    }
    
    func get(url: NSURL) throws -> String {
        let socket = try Socket.create()
        try socket.connect(to: url.host!, port: url.port?.int32Value ?? 80 )
        try socket.write(from: "GET \(url.path!) HTTP/1.1\nHost: \(url.host!)\r\n\r\n")
        return try parse(response: socket.readString() ?? "").1
    }
    
    private func parse(response: String) throws -> (Int, String) { // status code, body
        var lines = response.characters.split(separator: "\r\n", maxSplits: Int.max, omittingEmptySubsequences: false).map(String.init)
        
        //print(lines)
        
        // parse status code
        guard let statusLine = lines.first else {
            throw Error.responseParseError
        }
        lines.removeFirst()
        let statusParts = statusLine.characters.split(separator: " ").map(String.init)
        guard statusParts.count >= 3 else {
            throw Error.responseParseError
        }
        guard let statusCode = Int(statusParts[1]) else {
            throw Error.responseParseError
        }
        
        
        var headers: [String] = []
        var body: [String] = []
        enum State {
            case header
            case body
        }
        // parse header and body
        var state = State.header
        for line in lines {
            if line == "" {
                state = .body
                continue
            }
            switch state {
            case .header:
                headers.append(line)
            case .body:
                body.append(line)
            }
        }
        
        //print(statusCode, headers, body)
        return (statusCode, body.joined(separator: "\r\n"))
    }
}
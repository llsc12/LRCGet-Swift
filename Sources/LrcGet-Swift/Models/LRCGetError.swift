//
//  LRCGetError.swift
//  LrcGet-Swift
//
//  Created by Lakhan Lothiyi on 08/08/2026.
//

import Foundation

/// An error response from LRCLIB.
public struct LRCGetError: Error, Hashable, Sendable {
	public let statusCode: Int
	public let response: ErrorResponse?

	public var isNotFound: Bool { statusCode == 404 }

	public init(statusCode: Int, response: ErrorResponse? = nil) {
		self.statusCode = statusCode
		self.response = response
	}
}

extension LRCGetError: LocalizedError {
	public var errorDescription: String? {
		guard let response else { return "LRCLIB returned \(statusCode)." }
		return "LRCLIB returned \(statusCode): \(response.message)"
	}
}

/// The body LRCLIB sends with a failure.
public struct ErrorResponse: Codable, Hashable, Sendable {
	public let statusCode: Int
	public let name: String
	public let message: String
}

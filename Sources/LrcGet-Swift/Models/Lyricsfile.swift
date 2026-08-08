//
//  Lyricsfile.swift
//  LrcGet-Swift
//
//  Created by Lakhan Lothiyi on 08/08/2026.
//

import Foundation
import Yams

public struct Lyricsfile: Codable, Hashable, Sendable {

	public let version: String?
	public let metadata: Metadata?
	public let lines: [Line]
	public let plain: String?

	public init(version: String?, metadata: Metadata?, lines: [Line], plain: String? = nil) {
		self.version = version
		self.metadata = metadata
		self.lines = lines
		self.plain = plain
	}

	public init(yaml: String) throws {
		self = try YAMLDecoder().decode(Lyricsfile.self, from: yaml)
	}

	public var isInstrumental: Bool {
		if metadata?.instrumental == true { return true }
		return lines.allSatisfy { $0.text.trimmingCharacters(in: .whitespaces).isEmpty }
	}

	public var hasWordTiming: Bool {
		lines.contains { ($0.words?.count ?? 0) > 1 }
	}

	public struct Metadata: Codable, Hashable, Sendable {
		public let title: String?
		public let artist: String?
		public let album: String?
		public let durationMs: Int?
		public let instrumental: Bool?
		public let language: String?

		public init(
			title: String? = nil,
			artist: String? = nil,
			album: String? = nil,
			durationMs: Int? = nil,
			instrumental: Bool? = nil,
			language: String? = nil
		) {
			self.title = title
			self.artist = artist
			self.album = album
			self.durationMs = durationMs
			self.instrumental = instrumental
			self.language = language
		}

		enum CodingKeys: String, CodingKey {
			case title, artist, album, instrumental, language
			case durationMs = "duration_ms"
		}
	}

	public struct Line: Codable, Hashable, Sendable {
		public let text: String
		public let startMs: Int?
		public let endMs: Int?
		public let words: [Word]?

		public init(text: String, startMs: Int? = nil, endMs: Int? = nil, words: [Word]? = nil) {
			self.text = text
			self.startMs = startMs
			self.endMs = endMs
			self.words = words
		}

		enum CodingKeys: String, CodingKey {
			case text, words
			case startMs = "start_ms"
			case endMs = "end_ms"
		}
	}

	public struct Word: Codable, Hashable, Sendable {
		public let text: String
		public let startMs: Int?
		public let endMs: Int?

		public init(text: String, startMs: Int? = nil, endMs: Int? = nil) {
			self.text = text
			self.startMs = startMs
			self.endMs = endMs
		}

		enum CodingKeys: String, CodingKey {
			case text
			case startMs = "start_ms"
			case endMs = "end_ms"
		}
	}
}

public extension Lyricsfile {
	enum CodingKeys: String, CodingKey {
		case version, metadata, lines, plain
	}

	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		if let string = try? container.decodeIfPresent(String.self, forKey: .version) {
			version = string
		} else if let number = try? container.decodeIfPresent(Double.self, forKey: .version) {
			version = String(number)
		} else {
			version = nil
		}

		metadata = try container.decodeIfPresent(Metadata.self, forKey: .metadata)
		lines = try container.decodeIfPresent([Line].self, forKey: .lines) ?? []
		plain = try container.decodeIfPresent(String.self, forKey: .plain)
	}
}

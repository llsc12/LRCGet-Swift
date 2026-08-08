//
//  Lyric.swift
//  LrcGet-Swift
//
//  Created by Lakhan Lothiyi on 28/01/2025.
//

import Foundation
import Yams

public struct Lyric: Codable {
	public let id: Int
	public let trackName: String
	public let artistName: String
	public let albumName: String
	public let duration: Int
	public let instrumental: Bool
	public let plainLyrics: String?
	public let syncedLyrics: String?
	public let lyricsfile: String?
}

public extension Lyric {

	var parsedLyricsfile: Lyricsfile? {
		guard let lyricsfile else { return nil }
		return try? Lyricsfile(yaml: lyricsfile)
	}
}

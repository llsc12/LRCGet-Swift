// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct LRCGet: Sendable {
	public init(
		_ session: URLSession = .shared,
		url: URL = URL(string: "https://lrclib.net/")!
	) {
		self.session = session
		self.lrclibURL = url
	}
	public static let shared = LRCGet()

	static let decoder = JSONDecoder()

	public let session: URLSession

	/// Get lyrics with a track's signature
	///
	/// Attempt to find the best match of lyrics for the track. You should provide as much information as you can about the track, including the track name, artist name, album name, and the track's duration in seconds.
	/// This API is the preferred method for retrieving lyrics in most cases, offering high performance and accuracy.
	/// Note: If the duration is provided, LRCLIB will attempt to provide the lyrics only when the duration matches the record in LRCLIB's database, or at least with a difference of ±2 seconds in duration.
	///
	/// - Parameters:
	///   - trackName: Title of the track
	///   - artistName: Name of the artist
	///   - albumName: Name of the album
	///   - duration: Track's duration in seconds
	/// - Returns: The lyrics of the song
	public func getLyrics(
		trackName: String,
		artistName: String,
		albumName: String? = nil,
		duration: Int? = nil
	) async throws -> Lyric {
		try await send(
			"/api/get",
			[
				"track_name": trackName,
				"artist_name": artistName,
				"album_name": albumName,
				"duration": duration.map(String.init) ?? "",
			])
	}

	/// Get lyrics by LRCLIB's ID
	///
	/// Get a lyrics record by an absolute ID. ID of a lyrics record can be retrieved from other APIs, such as /api/search API.
	///
	/// - Parameters
	///   - id: ID of the lyrics record
	///   - Returns: The lyrics of the song
	public func getLyrics(id: Int) async throws -> Lyric {
		try await send("/api/get/\(id)", [:])
	}

	/// Search for lyrics records
	///
	/// Search for lyrics records using keywords. This API returns an array of lyrics records that match the specified search condition(s).
	///
	/// At least ONE of the two parameters, q OR track_name, must be present.
	///
	/// Recommendation: Use the /api/get API as your primary method and only resort to /api/search as a fallback. The /api/search API is significantly slower, more resource-intensive, and less precise than /api/get.
	///
	/// When using the search API, prioritize specific fields (track_name, artist_name, album_name) over the general q parameter for faster and more accurate results.
	///
	/// Note: This API currently returns a maximum of 20 results and does not support pagination. These limitations are subject to change in the future.
	///
	/// - Parameters:
	///  - q: Search for keyword present in ANY fields (track's title, artist name or album name)
	///  - trackName: Search for keyword in track's title
	///  - artistName: Search for keyword in track's artist name
	///  - albumName: Search for keyword in track's album name
	///  - Returns: The lyrics of the song
	public func search(
		q: String? = nil,
		trackName: String? = nil,
		artistName: String? = nil,
		albumName: String? = nil
	) async throws -> [Lyric] {
		try await send(
			"/api/search",
			[
				"q": q,
				"track_name": trackName,
				"artist_name": artistName,
				"album_name": albumName,
			])
	}

	func send<T: Codable>(_ path: String, _ q: [String: String?]) async throws
		-> T
	{
		let queryParams: [URLQueryItem] = q.map {
			URLQueryItem(name: $0.key, value: $0.value)
		}
		var urlComponents = URLComponents(
			url: lrclibURL, resolvingAgainstBaseURL: false)!
		urlComponents.queryItems = queryParams
		let url = urlComponents.url!.appendingPathComponent(path)
		let data = try await session.data(from: url).0
		do {
			let value = try Self.decoder.decode(T.self, from: data)
			return value
		} catch {
			print("[LRCLib]", error)
			print(String(data: data, encoding: .utf8) ?? "No data")
			throw error
		}
	}

	let lrclibURL: URL
}

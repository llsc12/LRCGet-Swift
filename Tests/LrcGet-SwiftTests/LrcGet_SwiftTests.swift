import Testing
@testable import LrcGet_Swift

@Test func testLyrics() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
	
	let lyric = try await LRCGet.shared.getLyrics(
		trackName: "Immortals",
		artistName: "Fall Out Boy",
		albumName: "Big Hero 6 (Original Motion Picture Soundtrack)",
		duration: 195
	)
	print(lyric)
}

@Test func testLyricsByID() async throws {
	let lyric = try await LRCGet.shared.getLyrics(id: 3396226)
	print(lyric)
}

@Test func testLyricsSearch() async throws {
	let lyric = try await LRCGet.shared.search(
		trackName: "I Want to Live",
		artistName: "Borislav Slavov"
	)
	print(lyric)
}

//
//  KPCC API Client
//
//	Program
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

#if os(iOS) || os(tvOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#else
	import Foundation
#endif

public struct Program: Listable, Codable {
	public enum ProgramStatus: String, Codable {
		/// The program is available as a standard show, as well as online.
		case onAir				= "onair"

		/// The program is available in an online-only format (ie. a podcast).
		case onlineOnly			= "online"

		/// The program has been archived.
		case archived			= "archive"

		/// The program is not publicly available.
		case hidden				= "hidden"
	}

	/// The program's title.
	public var title:String?

	/// The program's slug (a short, unique text descriptor that can be used as a key).
	public var slug:String?

	/// The program's host (ie. 'Larry Mantle').
	public var host:String?

	/// The program's status.
	public var airStatus:ProgramStatus?

	/// The program's Twitter handle (ie. AirTalk).
	public var twitterHandle:String?

	/// The program's air date/time. Expressed as a human-readable string.
	public var airTimeHuman:String?

	/// The program's description (HTML).
	public var descriptionHTML:String?

	/// The program's description (text).
	public var descriptionText:String?

	/// The program's associated phone number (if any).
	public var phoneNumber:String?

	/// The program's podcast URL.
	public var podcastURL:URL?

	/// The program's RSS URL.
	public var rssURL:URL?

	/// The program's public URL.
	public var publicURL:URL?

	/// Whether the program is KPCC's own...
	public var isHouse:Bool?	= false

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case title				= "title"
		case slug				= "slug"
		case host				= "host"
		case airStatus			= "air_status"
		case twitterHandle		= "twitter_handle"
		case airTimeHuman		= "airtime"
		case descriptionHTML	= "description"
		case descriptionText	= "description_text"
		case phoneNumber		= "phone_number"
		case podcastURL			= "podcast_url"
		case rssURL				= "rss_url"
		case publicURL			= "public_url"
		case isHouse			= "is_kpcc"
	}
}

extension Program {
	public init(withTitle title:String, slug:String) {
		self.title	= title
		self.slug	= slug
	}

	public func returnDescription() -> String? {
		if let descriptionText = self.descriptionText {
			if descriptionText.utf16.count > 0 {
				return descriptionText
			}
		}

		return self.descriptionHTML
	}

	public func coverImageURL(withBaseURL baseURL:URL?) -> URL? {
		if let slug = self.slug {
			return Program.coverImageURL(forSlug: slug, baseURL: baseURL)
		}

		return nil
	}

	public func coverThumbnailImageURL(withBaseURL baseURL:URL?) -> URL? {
		if let slug = self.slug {
			return Program.coverThumbnailImageURL(forSlug: slug, baseURL: baseURL)
		}

		return nil
	}
}

extension Program {
	public static func coverImageURL(forSlug slug:String, baseURL:URL?) -> URL? {
		let processedSlug	= slug.lowercased().replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
		let scaleString:String

		#if os(iOS) || os(tvOS)
		let scale	= UIScreen.main.scale
		#elseif os(OSX)
		let scale	= NSScreen.main?.backingScaleFactor ?? 1.0
		#else
		let scale	= 1.0
		#endif

		if scale >= 2.0 {
			scaleString = String.init(format: "@%dx", Int(scale))
		} else {
			scaleString = "@2x"
		}

		let urlString:String!
		if let baseURL = baseURL {
			urlString = String(format: "%@%@%@%@", baseURL.absoluteString, processedSlug, scaleString, ".png")
		} else {
			urlString = String(format: "https://media.scpr.org/ios/v4/program-images/350x350/%@%@%@", processedSlug, scaleString, ".png")
		}

		return URL(string: urlString)
	}

	public static func coverThumbnailImageURL(forSlug slug:String, baseURL:URL?) -> URL? {
		let processedSlug	= slug.lowercased().replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
		let scaleString:String

		#if os(iOS) || os(tvOS)
		let scale	= UIScreen.main.scale
		#elseif os(OSX)
		let scale	= NSScreen.main?.backingScaleFactor ?? 1.0
		#else
		let scale	= 1.0
		#endif

		if scale >= 2.0 {
			scaleString = String.init(format: "@%dx", Int(scale))
		} else {
			scaleString = "@2x"
		}

		let urlString:String!
		if let baseURL = baseURL {
			urlString = String(format: "%@%@%@%@", baseURL.absoluteString, processedSlug, scaleString, ".png")
		} else {
			urlString = String(format: "https://media.scpr.org/ios/v4/program-images/110x110/%@%@%@", processedSlug, scaleString, ".png")
		}

		return URL(string: urlString)
	}
}

extension Program: Equatable {
	public static func ==(lhs: Program, rhs: Program) -> Bool {
		if (lhs.slug == rhs.slug) {
			return true
		}

		return false
	}
}

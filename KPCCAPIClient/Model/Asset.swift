//
//  KPCC API Client
//
//	Asset
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct AssetNative: Codable {
	public let id:String
	public let type:AssetNativeType?

	enum CodingKeys: String, CodingKey {
		case id						= "id"
		case type					= "type"
	}

	public enum AssetNativeType: String, Codable {
		/// A video sourced from YouTube.
		case youtubeVideo		= "YoutubeVideo"

		/// A video sourced from Brightcove.
		case brightcoveVideo	= "BrightcoveVideo"

		/// A video sourced from Vimeo.
		case vimeoVideo			= "VimeoVideo"
	}
}

public struct Asset: Codable {
	/// The asset's ID.
	public var id:Int?

	/// The asset's title.
	public var title:String?

	/// The asset's caption.
	public var caption:String?

	/// The asset's owner.
	public var owner:String?

	/// The asset's native video class (ie. YouTube, Vimeo, etc) and ID.
	public var native:AssetNative?

	/// The asset's 'thumbnail' size.
	public var sizeThumbnail:AssetSize?

	/// The asset's 'small' size.
	public var sizeSmall:AssetSize?

	/// The asset's 'large' size.
	public var sizeLarge:AssetSize?

	/// The asset's 'full' size.
	public var sizeFull:AssetSize?

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case id					= "id"
		case title				= "title"
		case caption			= "caption"
		case owner				= "owner"
		case native				= "native"
		case sizeThumbnail		= "thumbnail"
		case sizeSmall			= "small"
		case sizeFull			= "full"
		case sizeLarge			= "large"
	}
}

extension Asset: Equatable {
	public static func ==(lhs: Asset, rhs: Asset) -> Bool {
		if lhs.id == rhs.id {
			return true
		}
		
		return false
	}
}

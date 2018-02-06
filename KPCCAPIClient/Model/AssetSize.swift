//
//  KPCC API Client
//
//	AssetSize
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct AssetSize: Codable {
	/// The URL for this size of asset.
	public var url:URL?

	/// The asset's width (in pixels).
	public var width:Int?

	/// The asset's width (in height).
	public var height:Int?

	public init() {
	}

	enum CodingKeys: String, CodingKey {
		case url				= "url"
		case width				= "width"
		case height				= "height"
	}
}


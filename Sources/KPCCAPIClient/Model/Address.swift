//
//  KPCC API Client
//
//	Address
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct Address:Codable {
	/// The address's first line.
	public var line1:String?

	/// The address's second line.
	public var line2:String?

	/// The address's city.
	public var city:String?

	/// The address's state.
	public var state:String?

	/// The address's zip code.
	public var zipCode:String?

	enum CodingKeys: String, CodingKey {
		case line1						= "line1"
		case line2						= "line2"
		case city						= "city"
		case state						= "state"
		case zipCode					= "zip_code"
	}
}

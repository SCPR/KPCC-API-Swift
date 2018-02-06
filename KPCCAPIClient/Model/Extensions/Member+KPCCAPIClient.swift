//
//  KPCC API Client
//
//	Member+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct MemberResponse: Codable {
	var member:Member?
}

extension Member {
	public static func get(withPledgeToken pledgeToken:String, completion: @escaping (Member?, KPCCAPIError?) -> Void) {
		let urlComponentString = String(format: "%@/%@", "members", pledgeToken)
		guard let components = URLComponents(string: urlComponentString) else {
			DispatchQueue.main.async {
				completion(nil, .buildComponentsError)
			}
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let memberResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(MemberResponse.self, from: data)
					let member			= memberResponse.member

					DispatchQueue.main.async {
						completion(member, nil)
					}
				} catch _ as DecodingError {
					DispatchQueue.main.async {
						completion(nil, .decodingError)
					}
				} catch {
					DispatchQueue.main.async {
						completion(nil, .other)
					}
				}
			} else {
				DispatchQueue.main.async {
					completion(nil, .dataUnavailable)
				}
			}
		}
	}
}

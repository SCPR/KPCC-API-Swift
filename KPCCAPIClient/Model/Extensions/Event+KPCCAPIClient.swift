//
//  KPCC API Client
//
//	Event+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct EventsResponse: Codable {
	var events:[Event]	= []
}

extension Event {
	static func get(completion: @escaping ([Event]?, KPCCAPIError?) -> Void) {
		guard let components = URLComponents(string: "events/?start_date=2016-12-01&end_date=2017-02-16&limit=40") else {
			completion(nil, .buildComponentsError)
			return
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let eventsResponse		= try KPCCAPIClient.shared.jsonDecoder.decode(EventsResponse.self, from: data)
					let events				= eventsResponse.events
					completion(events, nil)
				} catch _ as DecodingError {
					completion(nil, .decodingError)
				} catch {
					completion(nil, .other)
				}
			} else {
				completion(nil, .dataUnavailable)
			}
		}
	}
}

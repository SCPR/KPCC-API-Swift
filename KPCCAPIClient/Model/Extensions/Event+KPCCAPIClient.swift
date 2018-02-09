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
	/// Retrieve most recent events associated with the (optional) given type(s).
	///
	/// # Example:
	/// Retrieving most recent Town Hall and Community Enagement type events:
	/// ```
	/// Event.get(withTypes: [.townHall, .communityEngagement]) { (events, error) in
	///     print(events)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Events](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/events.md)
	///
	/// - Parameters:
	///   - types: The type(s) of events to retrieve. A nil value retrieves any type of event.
	///   - completion: A completion handler containing an array of events and/or an error.
	///
	/// - Author: Jeff Campbell
	static func get(withTypes types:[EventType]?, completion: @escaping ([Event]?, KPCCAPIError?) -> Void) {
		self.get(withTypes: types, startDate: nil, endDate: nil, limit: nil, completion: completion)
	}

	/// Retrieve most recent events associated with the (optional) given type(s), with the option to specify a start date, end date, and limit count.
	///
	/// # Example:
	/// Retrieving up to 10 Town Hall events that occurred before the current date:
	/// ```
	/// Event.get(withTypes: [.townHall], startDate:nil, endDate: Date(), limit: 10) { (events, error) in
	///    print(events)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Events](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/events.md)
	///
	/// - Parameters:
	///   - types: The type(s) of events to retrieve. A nil value retrieves any type of event.
	///   - startDate: The earliest date for retrieved events. Will be converted to GMT. A nil value returns events any time in the past.
	///   - endDate: The latest date for retrieved events. Will be converted to GMT. A nil value returns events any time in the future.
	///   - limit: The maximum number of events to retrieve. A nil value will return the API default (currently 4).
	///   - completion: A completion handler containing an array of events and/or an error.
	///
	/// - Author: Jeff Campbell
	static func get(withTypes types:[EventType]?, startDate:Date?, endDate:Date?, limit:Int?, completion: @escaping ([Event]?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "episodes") else {
			completion(nil, .buildComponentsError)
			return
		}

		var queryItems:[URLQueryItem] = []

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat	= "yyyy-MM-dd"
		dateFormatter.timeZone		= TimeZone(secondsFromGMT: 0)

		if let types = types {
			var typesString = ""
			for type in types {
				if typesString.count > 0 {
					typesString = typesString + ","
				}
				typesString = typesString + type.rawValue
			}

			queryItems.append(URLQueryItem(name: "types", value: typesString))
		}

		if let startDate = startDate {
			let startDateString = dateFormatter.string(from: startDate)
			components.queryItems?.append(URLQueryItem(name: "start_date", value: startDateString))
		}

		if let endDate = endDate {
			let endDateString = dateFormatter.string(from: endDate)
			components.queryItems?.append(URLQueryItem(name: "end_date", value: endDateString))
		}

		components.queryItems = queryItems

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

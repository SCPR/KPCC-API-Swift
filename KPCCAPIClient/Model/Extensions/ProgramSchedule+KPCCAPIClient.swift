//
//  KPCC API Client
//
//	ProgramSchedule+KPCCAPIClient
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

struct ProgramScheduleResponse: Codable {
	var scheduleOccurrences:[ScheduleOccurrence]	= []

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		if let scheduleOccurrences = try? values.decode([ScheduleOccurrence].self, forKey: .scheduleOccurrences) {
			self.scheduleOccurrences				= scheduleOccurrences
		} else {
			self.scheduleOccurrences				= []
		}
	}

	init() {
	}

	enum CodingKeys: String, CodingKey {
		case scheduleOccurrences				= "schedule_occurrences"
	}
}

extension ProgramSchedule {
	/// Retrieve the current program schedule (starts Monday of the current week, with a length of 1 week).
	///
	/// # Example:
	/// Retrieving the current program schedule:
	/// ```
	/// ProgramSchedule.get() { (programSchedule, error) in
	///    print(programSchedule)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Schedule](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/schedule.md)
	///
	/// - Author: Jeff Campbell
	public static func get(completion: @escaping (ProgramSchedule?, KPCCAPIError?) -> Void) {
		self.get(withStartDate: nil, length: nil, completion: completion)
	}

	/// Retrieve a program schedule.
	///
	/// # Example:
	/// Retrieving the program schedule starting from today, including the next 2 days:
	/// ```
	/// let startDate = Calendar.current.startOfDay(for: Date())
	///
	/// ProgramSchedule.get(withStartDate: startDate, length: 172800) { (programSchedule, error) in
	///    print(programSchedule)
	/// }
	/// ```
	///
	/// # Reference:
	///   [KPCC API Reference - Schedule](https://github.com/SCPR/api-docs/blob/master/KPCC/v3/endpoints/schedule.md)
	///
	/// - Parameters:
	///   - startDate: The earliest date for retrieved schedule. A nil value returns a schedule starting Monday of the current week. Note that a date more than 1 month in the future will return a 400 bad request error.
	///   - length: The maximum length of the program schedule to retrieve. A nil value defaults to 1 week.
	///   - completion: A completion handler with a program schedule and/or an error.
	///
	/// - Author: Jeff Campbell
	public static func get(withStartDate startDate: Date?, length:TimeInterval?, completion: @escaping (ProgramSchedule?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "schedule") else {
			DispatchQueue.main.async {
				completion(nil, .buildComponentsError)
			}
			return
		}

		var queryItems:[URLQueryItem] = []

		if let startDate = startDate {
			queryItems.append(
				URLQueryItem(
					name: "start_time",
					value: String(Int(startDate.timeIntervalSince1970))
				)
			)
		}

		if let length = length {
			if length > 0 && length <= 604800 {
				let lengthString:String = String(Int(length))
				queryItems.append(URLQueryItem(name: "length", value: lengthString))
			}
		}

		components.queryItems = queryItems

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let scheduleOccurrencesResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ProgramScheduleResponse.self, from: data)
					let scheduleOccurrences				= scheduleOccurrencesResponse.scheduleOccurrences

					var programSchedule = ProgramSchedule()
					programSchedule.occurrences			= scheduleOccurrences

					DispatchQueue.main.async {
						completion(programSchedule, nil)
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

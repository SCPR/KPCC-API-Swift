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
	public static func get(dateRange: DateRange? = nil, completion: @escaping (ProgramSchedule?, KPCCAPIError?) -> Void) {
		guard var components = URLComponents(string: "schedule") else {
			DispatchQueue.main.async {
				completion(nil, .buildComponentsError)
			}
			return
		}

		if let dateRange = dateRange {
			components.queryItems = [
				URLQueryItem(
					name: "start_time",
					value: String(Int(dateRange.start.timeIntervalSince1970))
				),
				URLQueryItem(
					name: "length",
					value: String(Int(dateRange.timeInterval))
				)
			]
		}

		KPCCAPIClient.shared.get(withURLComponents: components) { (data, error) in
			if let data = data {
				do {
					let scheduleOccurrencesResponse	= try KPCCAPIClient.shared.jsonDecoder.decode(ProgramScheduleResponse.self, from: data)
					let scheduleOccurrences				= scheduleOccurrencesResponse.scheduleOccurrences

					var programSchedule = ProgramSchedule()
					programSchedule.scheduleOccurrences	= scheduleOccurrences

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

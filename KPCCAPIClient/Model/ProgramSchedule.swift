//
//  KPCC API Client
//
//	ProgramSchedule
//
//	API Documentation:
//	  - https://github.com/SCPR/api-docs/tree/master/KPCC/v3
//
//	Developer(s): Jeff A. Campbell
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct ProgramSchedule: Codable {
	/// The program schedule's associated ScheduleOccurrence objects.
	public var scheduleOccurrences: [ScheduleOccurrence]

	/// The program schedule's associated NSDateRange objects. Computed.
	public var dateRanges: [DateRange] {
		return scheduleOccurrences.map { $0.dateRange }
	}
	
	/// The program schedule's associated NSDateRange objects, normalized. Computed.
	public var normalizedDateRanges: [DateRange] {
		return scheduleOccurrences.map { $0.normalizedDateRange }
	}

	// ###
	
	public func scheduleOccurrence(date: Date) -> ScheduleOccurrence? {
		for scheduleOccurrence in self.scheduleOccurrences {
			if scheduleOccurrence.normalizedDateRange.start <= date && scheduleOccurrence.normalizedDateRange.end >= date {
				return scheduleOccurrence
			}
		}

		return nil
	}
	
	public func title(date: Date) -> String? {
		let title = scheduleOccurrence(date: date)?.title

		return title
	}

	public init() {
		self.scheduleOccurrences	= []
	}

	enum CodingKeys: String, CodingKey {
		case scheduleOccurrences				= "schedule_occurrences"
	}
}


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
	/// The ProgramSchedule's associated ScheduleOccurrence objects.
	public var scheduleOccurrences: [ScheduleOccurrence]

	/// The ProgramSchedule's associated DateRange objects.
	public var dateRanges: [DateRange] {
		return scheduleOccurrences.map { $0.dateRange }
	}

	/// The ProgramSchedule's associated DateRange objects, normalized.
	public var normalizedDateRanges: [DateRange] {
		return scheduleOccurrences.map { $0.normalizedDateRange }
	}

	public var currentScheduleOccurrence: ScheduleOccurrence? {
		for scheduleOccurrence in self.scheduleOccurrences {
			if scheduleOccurrence.isCurrent {
				return scheduleOccurrence
			}
		}

		return nil
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


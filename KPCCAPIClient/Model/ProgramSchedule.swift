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
	public var occurrences: [ScheduleOccurrence]

	/// The ProgramSchedule's associated DateRange objects.
	public var dateRanges: [DateRange] {
		return occurrences.map { $0.dateRange }
	}

	/// The ProgramSchedule's associated DateRange objects, normalized.
	public var normalizedDateRanges: [DateRange] {
		return occurrences.map { $0.normalizedDateRange }
	}

	public var currentScheduleOccurrence: ScheduleOccurrence? {
		for scheduleOccurrence in self.occurrences {
			if scheduleOccurrence.isCurrent {
				return scheduleOccurrence
			}
		}

		return nil
	}

	// ###

	public func scheduleOccurrenceAfter(date: Date) -> ScheduleOccurrence? {
		if let currentScheduleOccurrence = self.scheduleOccurrence(date: date), let index = self.occurrences.index(of: currentScheduleOccurrence) {
			let nextIndex = index + 1

			if self.occurrences.count >= nextIndex + 1 {
				let nextScheduleOccurrence = self.occurrences[nextIndex]

				return nextScheduleOccurrence
			}
		}

		return nil
	}

	public func scheduleOccurrence(date: Date) -> ScheduleOccurrence? {
		for scheduleOccurrence in self.occurrences {
			if scheduleOccurrence.dateRange.start <= date && scheduleOccurrence.dateRange.end >= date {
				return scheduleOccurrence
			}
		}

		return nil
	}
	
	public func title(date: Date) -> String? {
		let title = scheduleOccurrence(date: date)?.title

		return title
	}

	public func divideIntoDays() -> [Int:[ScheduleOccurrence]] {
		var scheduleOccurrences							= Array(self.occurrences)
		var scheduleByDay:[Int:[ScheduleOccurrence]]	= [:]

		for index in 0...6 {
			if let referenceDate		= Calendar.current.date(byAdding: .day, value: index, to: Date()) {
				let startOfDate			= Calendar.current.startOfDay(for: referenceDate)
				guard let endOfDate			= Calendar.current.date(byAdding: .day, value: 1, to: startOfDate) else {
					continue
				}

				let dayOccurrences		= scheduleOccurrences.filter{
					$0.dateRange.start >= startOfDate && $0.dateRange.start < endOfDate
				}

				scheduleByDay[index]	= dayOccurrences

				for dayOccurrence in dayOccurrences {
					if let dayOccurrenceIndex = scheduleOccurrences.index(of: dayOccurrence) {
						scheduleOccurrences.remove(at: dayOccurrenceIndex)
					}
				}
			}
		}

		return scheduleByDay
	}

	public init() {
		self.occurrences	= []
	}

	enum CodingKeys: String, CodingKey {
		case occurrences				= "schedule_occurrences"
	}
}


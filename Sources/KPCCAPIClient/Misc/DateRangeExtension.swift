//
//  KPCC API Client
//
//	Developer(s): Jeff A. Campbell, Christopher Fuller
//  Copyright © 2018 Southern California Public Radio. All rights reserved.
//

import Foundation

public struct DateRange: Codable {
	public var start: Date
	public var end: Date

	public init(start: Date, end: Date) {
		self.start = start
		self.end = end
	}

	public init(start: Date, timeInterval: TimeInterval) {
		self.init(start: start, end: start.addingTimeInterval(timeInterval))
	}

	public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)

		self.start				= try values.decode(Date.self, forKey: .start)
		self.end				= try values.decode(Date.self, forKey: .end)
	}

	enum CodingKeys: String, CodingKey {
		case start			= "start"
		case end			= "end"
	}
}

extension DateRange {
	enum DateRangeError: Error {
		case outOfRange
	}
}

extension DateRange {
	public var timeInterval: TimeInterval {
		return end.timeIntervalSince(start)
	}

	public func contains(_ date: Date) -> Bool {
		return ((date >= start) && (date <= end))
	}

	public func clamp(_ date: Date) -> Date {
		if date < self.start {
			return self.start
		} else if date > self.end {
			return self.end
		} else {
			return date
		}
	}

	public func percent(date: Date) throws -> Double {
		guard contains(date) else { throw DateRangeError.outOfRange }
		let percent = (DateRange(start: start, end: date).timeInterval / timeInterval)
		return min(max(0.0, percent), 1.0)
	}

	public func date(percent: Double) -> Date {
		let percent = min(max(0.0, percent), 1.0)

		return Date(timeIntervalSince1970: round(start.timeIntervalSince1970 + (timeInterval * percent)))
	}

	public func dateRangeByAddingTimeIntervals(start: TimeInterval, end: TimeInterval) -> DateRange {
		let start = self.start.addingTimeInterval(start)
		let end = self.end.addingTimeInterval(end)
		return DateRange(start: start, end: end)
	}
}

public func ==(lhs: DateRange, rhs: DateRange) -> Bool {
	return ((lhs.start == rhs.start) && (lhs.end == rhs.end))
}

import Foundation

class RegexMatcher: Matching {
    let pattern: Pattern

    private lazy var matcher: NSRegularExpression? = {
        return try? NSRegularExpression(pattern: "^" + pattern.rawValue, options: [.caseInsensitive])
    }()

    init(pattern: Pattern) {
        self.pattern = pattern
    }

    func match(string: String) -> Bool {
        let fullRange = NSRange(string.startIndex..., in: string)
        return matcher?.rangeOfFirstMatch(in: string, range: fullRange).location != NSNotFound
    }

    func capturedGroups(string: String) -> [String] {
        var results = [String]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern.rawValue, options: [.caseInsensitive])
        } catch {
            return results
        }

        let matches = regex.matches(in: string, range: NSRange(location:0, length: string.utf16.count))

        guard let match = matches.first else { return results }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            guard let matchedString = string.substring(with: capturedGroupIndex) else { continue }
            results.append(matchedString)
        }

        return results
    }
}

class NewRegexMatcher: Matching {
    let pattern: Pattern

    private lazy var matcher: Regex<AnyRegexOutput>? = {
        //return try? NSRegularExpression(pattern: "^" + pattern.rawValue, options: [.caseInsensitive])
        return try? Regex("^" + pattern.rawValue).ignoresCase()
    }()

    init(pattern: Pattern) {
        self.pattern = pattern
    }

    func match(string: String) -> Bool {
        return (try? matcher?.firstMatch(in: string)) != nil
    }

    func capturedGroups(string: String) -> [String] {
        var results = [String]()

//        var regex: NSRegularExpression
//        do {
//            regex = try NSRegularExpression(pattern: pattern.rawValue, options: [.caseInsensitive])
//        } catch {
//            return results
//        }
//        let matches = regex.matches(in: string, range: NSRange(location:0, length: string.utf16.count))
//
//        guard let match = matches.first else { return results }
//
//        let lastRangeIndex = match.numberOfRanges - 1
//        guard lastRangeIndex >= 1 else { return results }
//
//        for i in 1...lastRangeIndex {
//            let capturedGroupIndex = match.range(at: i)
//            guard let matchedString = string.substring(with: capturedGroupIndex) else { continue }
//            results.append(matchedString)
//        }
        do {
            let regex = try Regex(pattern.rawValue).ignoresCase()
            let matches = string.matches(of: regex)

            guard let match = matches.first else {
                return results
            }

            for captured in match.output {
                if let substring = captured.substring {
                    results.append(String(substring))
                }
            }
        } catch {
            return results
        }

        return results
    }
}



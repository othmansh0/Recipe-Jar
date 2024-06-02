import UIKit
extension String {
    func limited(to maxLength: Int) -> String {
        if self.count > maxLength {
            return String(self.prefix(maxLength))
        } else {
            return self
        }
    }
    
    
    /// Removes brackets `()`, `{}`, `[]` and condenses all spaces to a single space.
    func trimmedAndCleaned() -> String {
        // Pattern to match brackets and multiple spaces
        let pattern = "[\\[\\]\\{\\}\\(\\)]|\\s+"

        // Regular expression to identify matches of the pattern
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        // Replace matches with a single space or empty string
        let modifiedString = regex.stringByReplacingMatches(in: self, range: NSRange(self.startIndex..., in: self), withTemplate: " ")

        // Trim leading and trailing spaces, then replace multiple spaces with a single space
        return modifiedString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
}

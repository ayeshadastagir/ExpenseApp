import UIKit

struct ExpenseRecord {
    let amount: String
    let category: String
    let explanation: String
    let image: UIImage
    let date: Date
}

struct ExpenseCategory {
    let icon: String
    let label: String
}

struct ExpenseData {
    let amount: String
    let category: String
    let explanation: String
    let image: Data
    let date: Date
}

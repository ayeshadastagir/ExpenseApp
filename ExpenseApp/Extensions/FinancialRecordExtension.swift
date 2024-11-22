import Foundation

extension FinancialRecord {
    var date: Date {
        switch self {
        case .income(let income):
            return income.date
        case .expense(let expense):
            return expense.date
        }
    }
}

import Foundation

struct IncomeCategory {
    let icon: String
    let label: String
}

struct IncomeData {
    let amount: String
    let category: String
    let explanation: String
    let image: Data
    let date: Date
    let id: UUID
}



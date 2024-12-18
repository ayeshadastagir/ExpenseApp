class TransactionViewModel {
    
    var databaseHandler = DatabaseHandling()
    var financialRecords: [FinancialRecord] = []
    var filteredRecords: [FinancialRecord] = []
    
    var onDataUpdated: (() -> Void)?
    
    func fetchData() {
        financialRecords = databaseHandler?.fetchAllFinancialRecords() ?? []
        filteredRecords = financialRecords
        onDataUpdated?()
    }
    
    func filterRecords(by searchText: String) {
        guard !searchText.isEmpty else {
            filteredRecords = financialRecords
            onDataUpdated?()
            return
        }
        filteredRecords = financialRecords.filter {
            let recordText: String
            switch $0 {
            case .income(let incomeRecord):
                recordText = "\(incomeRecord.category) \(incomeRecord.explanation) \(incomeRecord.amount) \(incomeRecord.date.formattedString())"
            case .expense(let expenseRecord):
                recordText = "\(expenseRecord.category) \(expenseRecord.explanation) \(expenseRecord.amount) \(expenseRecord.date.formattedString())"
            }
            return recordText.lowercased().contains(searchText.lowercased())
        }
        onDataUpdated?()
    }
}

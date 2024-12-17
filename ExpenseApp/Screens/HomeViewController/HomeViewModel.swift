import Foundation

class HomeViewModel {

    let databaseHandler = DatabaseHandling()
    var financialRecords: [FinancialRecord] = []
    var totalIncome: Int = 0
    var totalExpense: Int = 0
    var balance: Int = 0

    var onDataUpdated: (() -> Void)?
    let showAlert: (() -> Void)? = nil

    func fetchData() {
        financialRecords = Array(databaseHandler?.fetchAllFinancialRecords().prefix(5) ?? [] )
        totalIncome = databaseHandler?.totalIncome() ?? 0
        totalExpense = databaseHandler?.totalExpense() ?? 0
        balance = totalIncome - totalExpense
        onDataUpdated?()
    }
}

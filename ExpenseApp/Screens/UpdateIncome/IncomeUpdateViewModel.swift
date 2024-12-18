import Foundation

class IncomeUpdateViewModel {
    
    private let dataHandler = DatabaseHandling()
    var onUpdateSuccess: (() -> Void)?
    var onUpdateFailure: ((String) -> Void)?
    var existingIncomeData: IncomeData?
    var initialAmount: String?
    
    func fetchExistingRecord(recordId: UUID) {
        existingIncomeData = dataHandler?.fetchSpecificIncome(id: recordId)
        initialAmount = existingIncomeData?.amount
    }

    func updateIncome(recordId: UUID, amount: String, category: String, explanation: String, imageData: Data) {
        guard let existingIncomeData = existingIncomeData else {
            onUpdateFailure?("No income data found")
            return
        }
        let updatedIncome = IncomeData(
            amount: amount,
            category: category,
            explanation: explanation,
            image: imageData,
            date: existingIncomeData.date,
            id: existingIncomeData.id
        )
        
        if dataHandler?.updateIncome(id: recordId, updatedIncomeData: updatedIncome, oldValue: initialAmount ?? "") == true {
            onUpdateSuccess?()
        } else {
            onUpdateFailure?("Unable to update income record. Expense exceeds income")
        }
    }
}

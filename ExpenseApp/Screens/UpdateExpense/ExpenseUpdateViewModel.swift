import Foundation

class ExpenseUpdateViewModel {
    
    private let dataHandler = DatabaseHandling()
    var onUpdateSuccess: (() -> Void)?
    var onUpdateFailure: ((String) -> Void)?
    var existingExpenseData: ExpenseData?
    var initialAmount: String?
 
    func fetchExistingRecord(recordId: UUID) {
        existingExpenseData = dataHandler?.fetchSpecificExpense(id: recordId)
        initialAmount = existingExpenseData?.amount
    }
    
    func validateFields(amount: String, category: String, explanation: String) -> Bool {
        return !amount.isEmpty && category != "Category" && !explanation.isEmpty
    }

    func updateExpense(recordId: UUID, amount: String, category: String, explanation: String, imageData: Data) {
        guard let existingExpenseData = existingExpenseData else {
            onUpdateFailure?("No expense data found")
            return
        }
        
        let updatedExpense = ExpenseData(
            amount: amount,
            category: category,
            explanation: explanation,
            image: imageData,
            date: existingExpenseData.date,
            id: recordId
        )
        
        if dataHandler?.updateExpense(id: recordId, updatedExpenseData: updatedExpense, oldAmount: initialAmount ?? "") == true {
            onUpdateSuccess?()
        } else {
            onUpdateFailure?("Unable to update expense record.")
        }
    }
}

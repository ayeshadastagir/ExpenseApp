import Foundation

class ExpenseViewModel {
    
    private let dataHandler = DatabaseHandling()
    let expenseCategories: [ExpenseCategory] = [
        ExpenseCategory(icon: "bill", label: "Bills"),
        ExpenseCategory(icon: "food", label: "Food"),
        ExpenseCategory(icon: "grocery", label: "Grocery"),
        ExpenseCategory(icon: "shop", label: "Shopping"),
        ExpenseCategory(icon: "transport", label: "Transportation"),
        ExpenseCategory(icon: "subs", label: "Subscriptions"),
        ExpenseCategory(icon: "edu", label: "Education"),
        ExpenseCategory(icon: "invest", label: "Investment"),
        ExpenseCategory(icon: "other", label: "Others")
    ]
    var onSaveSuccess: (() -> Void)?
    var onSaveFailure: ((String) -> Void)?
    
    func saveExpense(amount: String, category: String, explanation: String, image: Data, date: Date) {
        let expense = ExpenseData(
            amount: amount,
            category: category,
            explanation: explanation,
            image: image,
            date: date,
            id: UUID()
        )
        
        if dataHandler?.saveExpense(expenseData: expense) == true {
            onSaveSuccess?()
        } else {
            onSaveFailure?("No Income or Expense amount exceeds wallet.")
        }
    }
}

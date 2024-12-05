
import Foundation

extension String {
   
    var toCurrencyFormat: String {
        let formatter = NumberFormatter()
        formatter.locale = .current
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        guard let number = NumberFormatter().number(from: self.justifyNumber) else {
            return self
        }
        return formatter.string(from: number) ?? self
    }
    
    var justifyNumber: String {
        let number = Set("1234567890")
        return self.filter( { number.contains($0) } )
    }
}

import Foundation

extension Double
{
    func rounded(signes_after: Int) -> Double
    {
        let mul = pow(10, Double(signes_after))
        let rounded = (self * mul).rounded()
        return rounded / mul
    }
}


import Foundation
import UIKit

@available(iOS 13.0, *)
@IBDesignable class CardView: UIView {
    
    var conrnerRadius: CGFloat = 5
    var offsetWidth: CGFloat = 5
    var offsetHeight: CGFloat = 5
    var offsetShadowOpacity: Float = 5
    var color = UIColor.systemGray2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
              super.init(coder: aDecoder)
        cardLayout()
    }

    func cardLayout(){
        layer.cornerRadius = self.conrnerRadius
        layer.shadowColor = self.color.cgColor
        layer.shadowOpacity = self.offsetShadowOpacity
    }
}

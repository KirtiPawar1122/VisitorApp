
import UIKit

protocol CustomSignDelegate {
    func didStart(_ view: CustomView)
    func didEnd(_ view: CustomView)
}

class CustomView: UIView {
    var line = [CGPoint]()
    var delegate : CustomSignDelegate!

      override func draw(_ rect: CGRect) {
          super.draw(rect)
          // draw custom view
          guard  let context = UIGraphicsGetCurrentContext() else {
              return
          }
          for (i, p ) in line.enumerated(){
              // i = index p = every point inside line
              if (i == 0) {
                  context.move(to: p)
              } else {
                  context.addLine(to: p)
              }
          }
          context.strokePath()

        if let delegate = delegate{
            delegate.didStart(self)
        }
      }

      override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
          guard let point =  touches.first?.location(in: self) else {
              return
          }
          print(point)
          line.append(point)
          setNeedsDisplay()
      }

      func clear() {
          line.removeAll()
          setNeedsDisplay()
      }

      func getSignature() -> UIImage{
          UIGraphicsBeginImageContext(CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
          self.layer.render(in: UIGraphicsGetCurrentContext()!)
          let sign : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
          UIGraphicsEndImageContext()
          return sign

      }
}

extension CustomSignDelegate {
    func didStart(_ view : CustomView) {}
    func didFinish(_ view : CustomView) {}
}




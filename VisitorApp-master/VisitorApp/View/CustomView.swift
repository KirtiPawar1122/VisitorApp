
import UIKit

protocol CustomSignDelegate {
    func didStart(_ view: CustomView)
    func didEnd(_ view: CustomView)
}

//class CustomView: UIView {
//
//        var line = [CGPoint](repeating: CGPoint(), count: 5)
//        var controlPoint = 0
//        var delegate : CustomSignDelegate!
//        var path = UIBezierPath()
//        var strokeColor: UIColor = .black
//
//        override func draw(_ rect: CGRect) {
//            super.draw(rect)
//            // draw custom view
//    //        guard  let context = UIGraphicsGetCurrentContext() else {
//    //            return
//    //        }
//    //        for (i, p ) in line.enumerated(){
//    //            // i = index p = every pint inside line
//    //            if (i == 0) {
//    //                context.move(to: p)
//    //            } else {
//    //                context.addLine(to: p)
//    //            }
//    //        }
//    //        context.strokePath()
//
//            self.strokeColor.setStroke()
//            self.path.stroke()
//        }
//
//        override public func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
//            if let firstTouch = touches.first {
//                let touchPoint = firstTouch.location(in: self)
//                controlPoint = 0
//                line[0] = touchPoint
//            }
//
//            if let delegate = delegate {
//                delegate.didstart(self)
//            }
//        }
//
//        override public func touchesMoved(_ touches: Set <UITouch>, with event: UIEvent?) {
//            if let firstTouch = touches.first {
//                let touchPoint = firstTouch.location(in: self)
//                controlPoint += 1
//                line[controlPoint] = touchPoint
//                if (controlPoint == 4) {
//                    line[3] = CGPoint(x: (line[2].x + line[4].x)/2.0, y: (line[2].y + line[4].y)/2.0)
//                    path.move(to: line[0])
//                    path.addCurve(to: line[3], controlPoint1: line[1], controlPoint2: line[2])
//
//                    setNeedsDisplay()
//                    line[0] = line[3]
//                    line[1] = line[4]
//                    controlPoint = 1
//                }
//                setNeedsDisplay()
//            }
//        }
//
//        override public func touchesEnded(_ touches: Set <UITouch>, with event: UIEvent?) {
//            if controlPoint < 4 {
//                let touchPoint = line[0]
//                path.move(to: CGPoint(x: touchPoint.x,y: touchPoint.y))
//                path.addLine(to: CGPoint(x: touchPoint.x,y: touchPoint.y))
//                setNeedsDisplay()
//            } else {
//                controlPoint = 0
//            }
//
//            if let delegate = delegate {
//                //delegate.didend(view: self)
//                delegate.didEnd(self)
//            }
//        }
//
//        func clear() {
//            //line.removeAll()
//            self.path.removeAllPoints()
//            setNeedsDisplay()
//        }
//
//        func getSignature() -> UIImage{
//            UIGraphicsBeginImageContext(CGSize(width: self.bounds.size.width, height: self.bounds.size.height))
//            self.layer.render(in: UIGraphicsGetCurrentContext()!)
//            let sign : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//            UIGraphicsEndImageContext()
//            return sign
//        }
//
//    }
//
//extension CustomSignDelegate {
//    func didstart(_ view : CustomView) {}
//    func didend(_ view : CustomView) {}
//}



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




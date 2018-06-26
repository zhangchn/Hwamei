//: A UIKit based Playground for presenting user interface
  
import UIKit
import Hwamei
import PlaygroundSupport


class MyViewController : UIViewController {
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        let b = view.layer.bounds
        // waveform
        let waveform = CALayer()
        
        waveform.frame = CGRect(x: 0, y: 0, width: b.width, height: b.height / 4)
        
        let circular = CALayer()
        view.layer.addSublayer(waveform)
        let path = Line.line(<#T##data: [Any]##[Any]#>)
        
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

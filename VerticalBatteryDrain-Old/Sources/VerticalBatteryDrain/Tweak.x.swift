import Orion
import UIKit
import VerticalBatteryDrainC

class BatteryFillHook: ClassHook<_UIBatteryView> {
    func setFillLayer(_ layer: CALayer) {
        orig.setFillLayer(layer)
        fillLogic()
        target.fillLayer.cornerRadius = 1
    }
    func _updateFillLayer() {
        fillLogic()
    }
    // orion:new
    func fillLogic() {
        let adjustedLevel = CGFloat(UIDevice.current.batteryLevel) * (22/3.0) // 0%-100% -> 0px-7.3333..px
        target.fillLayer.setFrame(CGRect(x: 2, y: -adjustedLevel + (28/3.0), width: 18, height: adjustedLevel)) // 0%-100% -> 9.3333..px-2px
    }
}
//
//  SKToolbar.swift
//  SKPhotoBrowser
//
//  Created by keishi_suzuki on 2017/12/20.
//  Copyright © 2017年 suzuki_keishi. All rights reserved.
//

import Foundation

// helpers which often used
private let bundle = Bundle(for: SKPhotoBrowser.self)

class SKToolbar: UIToolbar {
    var toolActionButton: UIBarButtonItem!
    var toolEditActionButton: UIBarButtonItem!
    fileprivate weak var browser: SKPhotoBrowser?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, browser: SKPhotoBrowser) {
        self.init(frame: frame)
        self.browser = browser
        
        setupApperance()
        setupToolbar()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            
            guard let maxShare = toolActionButton.maxHit,
                let minShare = toolActionButton.minHit,
                let maxEdit = toolEditActionButton.maxHit,
                let minEdit = toolEditActionButton.minHit else{
                return nil
            }

            if point.x >= minShare && point.x <= maxShare{
                return view
            }
            if point.x >= minEdit && point.x <= maxEdit{
                return view
            }

//            if SKMesurement.screenWidth - point.x < 50 { // FIXME: not good idea
//                return view
//            }
        }
        return nil
    }
    
    
}

private extension SKToolbar {
    func setupApperance() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        clipsToBounds = true
        isTranslucent = true
        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
    }
    
    func setupToolbar() {
        toolActionButton = UIBarButtonItem(barButtonSystemItem: .action, target: browser, action: #selector(SKPhotoBrowser.actionButtonPressed))
        toolActionButton.tintColor = UIColor.white
        
        /* ADD EDIT IMAGE BUTTON START*/
        let image = UIImage(named: "SKPhotoBrowser.bundle/images/edit_pencil",
            in: bundle, compatibleWith: nil) ?? UIImage()
        toolEditActionButton = UIBarButtonItem(image: image, style: .plain, target: browser, action: #selector(SKPhotoBrowser.actionEditButtonPressed))
        toolEditActionButton.tintColor = UIColor.white
        /* ADD EDIT IMAGE BUTTON END*/

        var items = [UIBarButtonItem]()
        if SKPhotoBrowserOptions.displayAction {
            items.append(toolEditActionButton)
        }
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))

        if SKPhotoBrowserOptions.displayAction {
            items.append(toolActionButton)

        }

        setItems(items, animated: false)
    }
    
    func setupActionButton() {
    }
}

extension UIBarButtonItem {
    var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }
    var maxHit : CGFloat? {
        return CGFloat((frame?.origin.x)!) + CGFloat(frame!.width)
    }
    
    var minHit : CGFloat? {
        return frame?.origin.x
    }
    
}

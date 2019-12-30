//  NavigationAccessoryView.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import UIKit

public protocol NavigationAccessory {
    var doneClosure: (() -> Void)? { get set }
    var nextClosure: (() -> Void)? { get set }
    var previousClosure: (() -> Void)? { get set }

    var previousEnabled: Bool { get set }
    var nextEnabled: Bool { get set }
}

/// Class for the navigation accessory view used in FormViewController
open class NavigationAccessoryView: UIToolbar, NavigationAccessory {
    open var previousButton: UIBarButtonItem!
    open var nextButton: UIBarButtonItem!
    open var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDone))
    private var fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    private var flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    public override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 44.0))
        autoresizingMask = .flexibleWidth
        fixedSpace.width = 22.0
        initializeChevrons()
        setItems([previousButton, fixedSpace, nextButton, flexibleSpace, doneButton], animated: false)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func initializeChevrons() {
        var bundle = Bundle(for: NavigationAccessoryView.classForCoder())
        if let resourcePath = bundle.path(forResource: "Eureka", ofType: "bundle") {
            if let resourcesBundle = Bundle(path: resourcePath) {
                bundle = resourcesBundle
            }
        }

        var imageLeftChevron = UIImage(named: "back-chevron", in: bundle, compatibleWith: nil)
        var imageRightChevron = UIImage(named: "forward-chevron", in: bundle, compatibleWith: nil)
        // RTL language support
        imageLeftChevron = imageLeftChevron?.imageFlippedForRightToLeftLayoutDirection()
        imageRightChevron = imageRightChevron?.imageFlippedForRightToLeftLayoutDirection()

        previousButton = UIBarButtonItem(image: imageLeftChevron, style: .plain, target: self, action: #selector(didTapPrevious))
        nextButton = UIBarButtonItem(image: imageRightChevron, style: .plain, target: self, action: #selector(didTapNext))
    }

    open override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {}

    public var doneClosure: (() -> Void)?
    public var nextClosure: (() -> Void)?
    public var previousClosure: (() -> Void)?

    @objc private func didTapDone() {
        doneClosure?()
    }

    @objc private func didTapNext() {
        nextClosure?()
    }

    @objc private func didTapPrevious() {
        previousClosure?()
    }

    public var previousEnabled: Bool {
        get {
            return previousButton.isEnabled
        }
        set {
            previousButton.isEnabled = newValue
        }
    }

    public var nextEnabled: Bool {
        get {
            return nextButton.isEnabled
        }
        set {
            nextButton.isEnabled = newValue
        }
    }
}

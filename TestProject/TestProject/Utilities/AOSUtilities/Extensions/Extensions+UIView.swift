

import UIKit

// MARK: - UIView extensions

extension UIView {
    
    
    /// Description : Use to make round corner view.
    func makeCornerRediusUIView(){
        DispatchQueue.main.async {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height/2
        }
    }
    
    /// Description : Use to make corner radius .
    /// - Parameter redius: redius value in CGFloat.
    func makeCornerRediusUIView(with redius:CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = redius
    }
    
    
    /// Description : Use to add border with corner radius.
    /// - Parameter redius: redius value in CGFloat.
    /// - Parameter borderWidth:CGFloat value.
    /// - Parameter borderColor: UIColor value.
    func makeBorderWithColor(redius:CGFloat,borderWidth:CGFloat,borderColor:UIColor){
        self.clipsToBounds = true
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = redius
    }
    
    
    /// Description : Use to add shadow for view.
    /// - Parameter location: location value Top or Bottom
    /// - Parameter color: UIColor.
    /// - Parameter opacity: Float.
    /// - Parameter radius: CGFloat.
    func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        }
    }
    
    
    /// Description : Use to add drop shadow with mask.
    /// - Parameter color: UIColor value.
    /// - Parameter opacity: Float value.
    /// - Parameter offSet: CGSize value.
    /// - Parameter radius: CGFloat value.
    /// - Parameter scale: true of false.
    /// - Parameter shadowRedius: CGFloat value.
    func dropShadowWithMask(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true, shadowRedius : CGFloat = 1 ) {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = shadowRedius
        self.layer.cornerRadius = radius
    }
    
    
    /// Description : Use to add shadow.
    /// - Parameter offset: CGSize value.
    /// - Parameter color: UIColor value.
    /// - Parameter opacity: Float value.
    /// - Parameter radius: CGFloat value.
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 5.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    
    
    /// Description : Use to add drop shadow.
    /// - Parameter color: UIColor value.
    /// - Parameter opacity: Float value.
    /// - Parameter offSet: CGSize value.
    /// - Parameter radius: CGFloat value.
    /// - Parameter scale: true of false.
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    /// Description : Use to add drop shadow.
    /// - Parameter scale: true of false.
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    /// Description : Use to add view borders.
    /// - Parameter edges: UIRectEdge value.
    /// - Parameter color: UIColor value.
    /// - Parameter thickness: CGFloat value.
    @discardableResult func addBorders(edges: UIRectEdge, color: UIColor = .green, thickness: CGFloat = 1.0) -> [UIView] {
        var borders = [UIView]()
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        return borders
    }
    
    
    /// Description : Use to add top corner radius only.
    /// - Parameter radius: CGFloat value.
    func addTopCornerRadius(radius: CGFloat){
        if #available(iOS 11.0, *){
            self.clipsToBounds = false
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = (self.superview?.frame)!
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.mask = rectShape
        }
    }
    
    
    /// Description : Use to add bottom corner radius only.
    /// - Parameter radius: CGFloat value.
    func addBottomCornerRadius(radius: CGFloat){
        if #available(iOS 11.0, *){
            self.clipsToBounds = false
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }else{
            let rectShape = CAShapeLayer()
            rectShape.bounds = (self.superview?.frame)!
            rectShape.position = self.center
            rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
            self.layer.backgroundColor = UIColor.white.cgColor
            self.layer.mask = rectShape
        }
    }
    
    
    /// Description : User to perfom push translation.
    /// - Parameter duration: CFTimeInterval value.
    func pushTransition(_ duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    
    /// Description : Use to add acticity indicator in view,
    /// - Parameter color: UIColor value of indicator.
    func activityStartAnimating(color: UIColor = .red) {
        let backgroundView = UIView()
        backgroundView.frame = self.bounds
        backgroundView.backgroundColor = .clear
        backgroundView.tag = 475647
        
        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = UIActivityIndicatorView.Style.medium
        } else {
            activityIndicator.style = UIActivityIndicatorView.Style.gray
        }
        activityIndicator.color = color
        activityIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        backgroundView.addSubview(activityIndicator)
        self.addSubview(backgroundView)
        self.bringSubviewToFront(backgroundView)
    }
    
    
    /// Description : Use to remove activity indicator.
    func activityStopAnimating() {
        if let background = viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.isUserInteractionEnabled = true
    }
    
    
    /// Description : Use to insert blur view in the bottom of the all view.
    /// - Parameter style: UIBlurEffect value.
    func addBlurrView(style : UIBlurEffect.Style){
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 0)
    }
    
    
    /// Description : Use to insert blur view in the top of the all view.
    /// - Parameter style: UIBlurEffect value.
    func addBlurrViewOnTop(style : UIBlurEffect.Style){
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
//        blurEffectView.alpha = 0.90
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
    
    
    /// Description : Use to remove blur view.
    func removeBlurView(){
        for view in self.subviews{
            if view.isKind(of: UIVisualEffectView.self){
                view.removeFromSuperview()
                self.layoutIfNeeded()
            }
        }
    }
    
        static func loadFromXib<T>(withOwner: Any? = nil, options: [UINib.OptionsKey : Any]? = nil) -> T where T: UIView
        {
            let bundle = Bundle(for: self)
            let nib = UINib(nibName: "\(self)", bundle: bundle)

            guard let view = nib.instantiate(withOwner: withOwner, options: options).first as? T else {
                fatalError("Could not load view from nib file.")
            }
            return view
        }
}

extension UIView {
    func updateConstraint(attribute: NSLayoutConstraint.Attribute, constant: CGFloat) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = constant
            self.layoutIfNeeded()
        }
    }
}


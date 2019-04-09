//
//  File.swift
//  Jobaya
//
//  Created by mohamed hisham on 12/28/18.
//  Copyright © 2018 hisham. All rights reserved.
//

import Foundation
import UIKit

class Jobcell: UITableViewCell {
   
    var title :String?
    var des: String?
    var titleView:UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints=false
        return textView
    }()
    var desView:UITextView = {
        var des = UITextView()
        des.translatesAutoresizingMaskIntoConstraints=false
        return des
    }()
    var applyView:UIButton = {
        var apply = UIButton()
        apply.translatesAutoresizingMaskIntoConstraints=false
        apply.setTitle("APPLY", for: .normal)
        return apply
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleView)
        self.addSubview(desView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let title = title{
            titleView.text = title
        }
        if let des = des{
            desView.text = des
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
    }
    
}

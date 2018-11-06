//
//  RichTextEditorViewController.swift
//  iOS_Maishoudang
//
//  Created by 赵福成 on 2018/8/8.
//  Copyright © 2018年 Maishoudang. All rights reserved.
//

import UIKit

class RichTextEditorViewController: ZSSRichTextEditor {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // HTML Content to set in the editor
        let html = "<div class='test'></div><!-- This is an HTML comment --><p>This is a test of the <strong>ZSSRichTextEditor</strong> by <a title=\"Zed Said\" href=\"http://www.baidu.com\">Zed Said Studio</a></p>"

        self.shouldShowKeyboard = true

        self.placeholder = "This is a placeholder that will show when there is no content(html)"

        self.baseURL = URL(string: "http://www.baidu.com")

        self.setHTML(html)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

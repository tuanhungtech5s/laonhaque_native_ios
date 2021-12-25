//
//  WebView.swift
//  VillageMan
//
//  Created by cauca on 11/6/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    @Binding var dynamicHeight: CGFloat
    let webView: WKWebView
    let content: String?
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    guard let dynamicHeight = height as? CGFloat else {
                        self.parent.dynamicHeight = 80
                        return
                    }
                    self.parent.dynamicHeight = dynamicHeight
                }
            })
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.scrollView.bounces = false
        webView.navigationDelegate = context.coordinator
        let header = """
                    <header>
                    <meta name='viewport' content='width=device-width, initial-scale=1.0,
                    maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
                    </header>
                    """
        webView.loadHTMLString("\(header) \(content ?? "")", baseURL: URL(string: "https://laonhaque.vn"))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
}

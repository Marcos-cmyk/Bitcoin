//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import WebKit
enum BTCPipeType: String {
    case normal
    case console
}

public typealias BTCConsolePipeClosure = (Any?) -> Void

public class BTCWebViewJavascriptBridge: NSObject {
    private weak var webView: WKWebView?
    private var base: BTCWebViewJavascriptBridgeBase!
    public var consolePipeClosure: BTCConsolePipeClosure?
    public init(webView: WKWebView, _ otherJSCode: String = "",isHookConsole: Bool = true, injectionTime: WKUserScriptInjectionTime = .atDocumentStart) {
        super.init()
        self.webView = webView
        base = BTCWebViewJavascriptBridgeBase()
        base.delegate = self
        addScriptMessageHandlers()
        injectJavascriptFile(otherJSCode, isHookConsole: isHookConsole,injectionTime: injectionTime)
    }

    deinit {
        print("\(type(of: self)) release")
        removeScriptMessageHandlers()
    }

    // MARK: - Public Funcs

    public func reset() {
        base.reset()
    }

    public func register(handlerName: String, handler: @escaping BTCWebViewJavascriptBridgeBase.Handler) {
        base.messageHandlers[handlerName] = handler
    }

    public func remove(handlerName: String) -> BTCWebViewJavascriptBridgeBase.Handler? {
        return base.messageHandlers.removeValue(forKey: handlerName)
    }

    public func call(handlerName: String, data: Any? = nil, callback: BTCWebViewJavascriptBridgeBase.Callback? = nil) {
        base.send(handlerName: handlerName, data: data, callback: callback)
    }

    private func injectJavascriptFile(_ otherJSCode: String = "", isHookConsole: Bool ,injectionTime: WKUserScriptInjectionTime = .atDocumentStart) {
        let bridgeJS = BTCJavascriptCode.bridge()
        let hookConsoleJS = isHookConsole ? BTCJavascriptCode.hookConsole() : ""
        let finalJS =  "\(bridgeJS)" + "\(hookConsoleJS)"
        let userScript = WKUserScript(source: finalJS, injectionTime: injectionTime, forMainFrameOnly: true)
        webView?.configuration.userContentController.addUserScript(userScript)
        if !otherJSCode.isEmpty {
            let otherScript = WKUserScript(source: otherJSCode, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            webView?.configuration.userContentController.addUserScript(otherScript)
        }
    }

    private func addScriptMessageHandlers() {
        webView?.configuration.userContentController.add(BTCLeakAvoider(delegate: self), name: BTCPipeType.normal.rawValue)
        webView?.configuration.userContentController.add(BTCLeakAvoider(delegate: self), name: BTCPipeType.console.rawValue)
    }

    private func removeScriptMessageHandlers() {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: BTCPipeType.normal.rawValue)
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: BTCPipeType.console.rawValue)
    }
}

extension BTCWebViewJavascriptBridge: BTCWebViewJavascriptBridgeBaseDelegate {
    func evaluateJavascript(javascript: String, completion: CompletionHandler) {
        webView?.evaluateJavaScript(javascript, completionHandler: completion)
    }
}

extension BTCWebViewJavascriptBridge: WKScriptMessageHandler {
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == BTCPipeType.console.rawValue {
            consolePipeClosure?(message.body)
        } else if message.name == BTCPipeType.normal.rawValue {
            let body = message.body as? String
            guard let resultStr = body else { return }
            base.flush(messageQueueString: resultStr)
        }
    }
}

class BTCLeakAvoider: NSObject {
    weak var delegate: WKScriptMessageHandler?
    init(delegate: WKScriptMessageHandler) {
        super.init()
        self.delegate = delegate
    }
}

extension BTCLeakAvoider: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

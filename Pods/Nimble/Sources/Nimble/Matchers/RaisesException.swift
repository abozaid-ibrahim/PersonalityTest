import Foundation

// This matcher requires the Objective-C, and being built by Xcode rather than the Swift Package Manager
#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && !SWIFT_PACKAGE

    /// A Nimble matcher that succeeds when the actual expression raises an
    /// exception with the specified name, reason, and/or userInfo.
    ///
    /// Alternatively, you can pass a closure to do any arbitrary custom matching
    /// to the raised exception. The closure only gets called when an exception
    /// is raised.
    ///
    /// nil arguments indicates that the matcher should not attempt to match against
    /// that parameter.
    public func raiseException(
        named: String? = nil,
        reason: String? = nil,
        userInfo: NSDictionary? = nil,
        closure: ((NSException) -> Void)? = nil
    ) -> Predicate<Any> {
        return Predicate { actualExpression in
            var exception: NSException?
            let capture = NMBExceptionCapture(handler: ({ e in
                exception = e
            }), finally: nil)

            capture.tryBlock {
                _ = try! actualExpression.evaluate()
            }

            let failureMessage = FailureMessage()
            setFailureMessageForException(
                failureMessage,
                exception: exception,
                named: named,
                reason: reason,
                userInfo: userInfo,
                closure: closure
            )

            let matches = exceptionMatchesNonNilFieldsOrClosure(
                exception,
                named: named,
                reason: reason,
                userInfo: userInfo,
                closure: closure
            )
            return PredicateResult(bool: matches, message: failureMessage.toExpectationMessage())
        }
    }

    // swiftlint:disable:next function_parameter_count
    internal func setFailureMessageForException(
        _ failureMessage: FailureMessage,
        exception: NSException?,
        named: String?,
        reason: String?,
        userInfo: NSDictionary?,
        closure: ((NSException) -> Void)?
    ) {
        failureMessage.postfixMessage = "raise exception"

        if let named = named {
            failureMessage.postfixMessage += " with name <\(named)>"
        }
        if let reason = reason {
            failureMessage.postfixMessage += " with reason <\(reason)>"
        }
        if let userInfo = userInfo {
            failureMessage.postfixMessage += " with userInfo <\(userInfo)>"
        }
        if closure != nil {
            failureMessage.postfixMessage += " that satisfies block"
        }
        if named == nil, reason == nil, userInfo == nil, closure == nil {
            failureMessage.postfixMessage = "raise any exception"
        }

        if let exception = exception {
            // swiftlint:disable:next line_length
            failureMessage.actualValue = "\(String(describing: type(of: exception))) { name=\(exception.name), reason='\(stringify(exception.reason))', userInfo=\(stringify(exception.userInfo)) }"
        } else {
            failureMessage.actualValue = "no exception"
        }
    }

    internal func exceptionMatchesNonNilFieldsOrClosure(
        _ exception: NSException?,
        named: String?,
        reason: String?,
        userInfo: NSDictionary?,
        closure: ((NSException) -> Void)?
    ) -> Bool {
        var matches = false

        if let exception = exception {
            matches = true

            if let named = named, exception.name.rawValue != named {
                matches = false
            }
            if reason != nil, exception.reason != reason {
                matches = false
            }
            if let userInfo = userInfo, let exceptionUserInfo = exception.userInfo,
                (exceptionUserInfo as NSDictionary) != userInfo {
                matches = false
            }
            if let closure = closure {
                let assertions = gatherFailingExpectations {
                    closure(exception)
                }
                let messages = assertions.map { $0.message }
                if messages.count > 0 {
                    matches = false
                }
            }
        }

        return matches
    }

    public class NMBObjCRaiseExceptionMatcher: NSObject, NMBMatcher {
        internal var _name: String?
        internal var _reason: String?
        internal var _userInfo: NSDictionary?
        internal var _block: ((NSException) -> Void)?

        internal init(name: String?, reason: String?, userInfo: NSDictionary?, block: ((NSException) -> Void)?) {
            _name = name
            _reason = reason
            _userInfo = userInfo
            _block = block
        }

        @objc public func matches(_ actualBlock: @escaping () -> NSObject?, failureMessage: FailureMessage, location: SourceLocation) -> Bool {
            let block: () -> Any? = { _ = actualBlock(); return nil }
            let expr = Expression(expression: block, location: location)

            do {
                return try raiseException(
                    named: _name,
                    reason: _reason,
                    userInfo: _userInfo,
                    closure: _block
                ).matches(expr, failureMessage: failureMessage)
            } catch {
                failureMessage.stringValue = "unexpected error thrown: <\(error)>"
                return false
            }
        }

        @objc public func doesNotMatch(_ actualBlock: @escaping () -> NSObject?, failureMessage: FailureMessage, location: SourceLocation) -> Bool {
            return !matches(actualBlock, failureMessage: failureMessage, location: location)
        }

        @objc public var named: (_ name: String) -> NMBObjCRaiseExceptionMatcher {
            return ({ name in
                NMBObjCRaiseExceptionMatcher(
                    name: name,
                    reason: self._reason,
                    userInfo: self._userInfo,
                    block: self._block
                )
            })
        }

        @objc public var reason: (_ reason: String?) -> NMBObjCRaiseExceptionMatcher {
            return ({ reason in
                NMBObjCRaiseExceptionMatcher(
                    name: self._name,
                    reason: reason,
                    userInfo: self._userInfo,
                    block: self._block
                )
            })
        }

        @objc public var userInfo: (_ userInfo: NSDictionary?) -> NMBObjCRaiseExceptionMatcher {
            return ({ userInfo in
                NMBObjCRaiseExceptionMatcher(
                    name: self._name,
                    reason: self._reason,
                    userInfo: userInfo,
                    block: self._block
                )
            })
        }

        @objc public var satisfyingBlock: (_ block: ((NSException) -> Void)?) -> NMBObjCRaiseExceptionMatcher {
            return ({ block in
                NMBObjCRaiseExceptionMatcher(
                    name: self._name,
                    reason: self._reason,
                    userInfo: self._userInfo,
                    block: block
                )
            })
        }
    }

    extension NMBObjCMatcher {
        @objc public class func raiseExceptionMatcher() -> NMBObjCRaiseExceptionMatcher {
            return NMBObjCRaiseExceptionMatcher(name: nil, reason: nil, userInfo: nil, block: nil)
        }
    }
#endif

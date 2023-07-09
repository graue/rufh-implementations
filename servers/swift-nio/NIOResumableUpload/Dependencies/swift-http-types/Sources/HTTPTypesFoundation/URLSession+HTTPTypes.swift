/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A dependency of the sample code project.
*/
//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2023 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation
import HTTPTypes
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSessionTask {
    /// The original HTTP request this task was created with.
    public var originalHTTPRequest: HTTPRequest? {
        originalRequest?.httpRequest
    }

    /// The current HTTP request -- may differ from the `originalHTTPRequest` due to HTTP redirection.
    public var currentHTTPRequest: HTTPRequest? {
        currentRequest?.httpRequest
    }

    /// The HTTP response received from the server.
    public var httpResponse: HTTPResponse? {
        (response as? HTTPURLResponse)?.httpResponse
    }
}

private enum HTTPTypeConversionError: Error {
    case failedToConvertHTTPRequestToURLRequest
    case failedToConvertURLResponseToHTTPResponse
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
extension URLSession {
    /// Convenience method to load data using an `HTTPRequest`; creates and resumes a `URLSessionDataTask` internally.
    ///
    /// - Parameter request: The `HTTPRequest` for which to load data.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data and response.
    public func data(
        for request: HTTPRequest, delegate: URLSessionTaskDelegate? = nil
    ) async throws -> (Data, HTTPResponse) {
        guard let urlRequest = URLRequest(httpRequest: request) else {
            throw HTTPTypeConversionError.failedToConvertHTTPRequestToURLRequest
        }
        let (data, urlResponse) = try await data(for: urlRequest, delegate: delegate)
        guard let response = (urlResponse as? HTTPURLResponse)?.httpResponse else {
            throw HTTPTypeConversionError.failedToConvertURLResponseToHTTPResponse
        }
        return (data, response)
    }

    /// Convenience method to upload data using an `HTTPRequest`; creates and resumes a `URLSessionUploadTask` internally.
    ///
    /// - Parameter request: The `HTTPRequest` for which to upload data.
    /// - Parameter fileURL: File to upload.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data and response.
    public func upload(
        for request: HTTPRequest, fromFile fileURL: URL, delegate: URLSessionTaskDelegate? = nil
    ) async throws -> (Data, HTTPResponse) {
        guard let urlRequest = URLRequest(httpRequest: request) else {
            throw HTTPTypeConversionError.failedToConvertHTTPRequestToURLRequest
        }
        let (data, urlResponse) = try await upload(for: urlRequest, fromFile: fileURL, delegate: delegate)
        guard let response = (urlResponse as? HTTPURLResponse)?.httpResponse else {
            throw HTTPTypeConversionError.failedToConvertURLResponseToHTTPResponse
        }
        return (data, response)
    }

    /// Convenience method to upload data using an `HTTPRequest`, creates and resumes a `URLSessionUploadTask` internally.
    ///
    /// - Parameter request: The `HTTPRequest` for which to upload data.
    /// - Parameter bodyData: Data to upload.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data and response.
    public func upload(
        for request: HTTPRequest, from bodyData: Data, delegate: URLSessionTaskDelegate? = nil
    ) async throws -> (Data, HTTPResponse) {
        guard let urlRequest = URLRequest(httpRequest: request) else {
            throw HTTPTypeConversionError.failedToConvertHTTPRequestToURLRequest
        }
        let (data, urlResponse) = try await upload(for: urlRequest, from: bodyData, delegate: delegate)
        guard let response = (urlResponse as? HTTPURLResponse)?.httpResponse else {
            throw HTTPTypeConversionError.failedToConvertURLResponseToHTTPResponse
        }
        return (data, response)
    }

    /// Convenience method to download using an `HTTPRequest`; creates and resumes a `URLSessionDownloadTask` internally.
    ///
    /// - Parameter request: The `HTTPRequest` for which to download.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Downloaded file URL and response. The file will not be removed automatically.
    public func download(
        for request: HTTPRequest, delegate: URLSessionTaskDelegate? = nil
    ) async throws -> (URL, HTTPResponse) {
        guard let urlRequest = URLRequest(httpRequest: request) else {
            throw HTTPTypeConversionError.failedToConvertHTTPRequestToURLRequest
        }
        let (location, urlResponse) = try await download(for: urlRequest, delegate: delegate)
        guard let response = (urlResponse as? HTTPURLResponse)?.httpResponse else {
            throw HTTPTypeConversionError.failedToConvertURLResponseToHTTPResponse
        }
        return (location, response)
    }

    /// Returns a byte stream that conforms to AsyncSequence protocol.
    ///
    /// - Parameter request: The `HTTPRequest` for which to load data.
    /// - Parameter delegate: Task-specific delegate.
    /// - Returns: Data stream and response.
    public func bytes(
        for request: HTTPRequest, delegate: URLSessionTaskDelegate? = nil
    ) async throws -> (AsyncBytes, HTTPResponse) {
        guard let urlRequest = URLRequest(httpRequest: request) else {
            throw HTTPTypeConversionError.failedToConvertHTTPRequestToURLRequest
        }
        let (data, urlResponse) = try await bytes(for: urlRequest, delegate: delegate)
        guard let response = (urlResponse as? HTTPURLResponse)?.httpResponse else {
            throw HTTPTypeConversionError.failedToConvertURLResponseToHTTPResponse
        }
        return (data, response)
    }
}
#endif

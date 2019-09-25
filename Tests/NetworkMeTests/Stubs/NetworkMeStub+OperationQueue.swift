//
//  NetworkMeStub+OperationQueue.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 25/09/2019.
//

import Foundation
import NetworkMe

extension NetworkMe.Stub {

    final class OperationQueue: Foundation.OperationQueue {

        private(set) var addOperationBlocks: [() -> Void] = []
        private(set) var cancelAllOperationsWasCalled = false

        override func addOperation(_ block: @escaping () -> Void) {

            addOperationBlocks.append(block)

            block()
        }

        override func cancelAllOperations() {

            cancelAllOperationsWasCalled = true
        }
    }
}

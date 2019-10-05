//
//  FileDecoder.swift
//  NetworkMe
//
//  Created by Ilias Pavlidakis on 03/10/2019.
//

import Foundation

extension NetworkMe {

    public struct FileDecoder<FileType>: Decoding {

        public enum Error: Swift.Error { case decodingFailed, invalidResultType }

        let decodingBlock: (_ data: Data) -> FileType?

        public init(decodingBlock: @escaping (_ data: Data) -> FileType?) {

            self.decodingBlock = decodingBlock
        }

        public func decode<T>(_ type: T.Type, from data: Data) throws -> T {

            guard let decodedFile = decodingBlock(data) else {
                throw Error.decodingFailed
            }

            guard let file = decodedFile as? T else {
                throw Error.invalidResultType
            }

            return file
        }
    }

}

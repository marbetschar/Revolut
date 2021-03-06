//
//  Revolut+Transaction.swift
//  Revolut
//
//  Created by Marco Betschart on 16.04.18.
//  Copyright © 2018 MANDELKIND. All rights reserved.
//

import Foundation

extension Revolut {
	
	public func transaction(withId id: String, completionHandler: @escaping ((Transaction?, Swift.Error?) -> Void)) {
		let urlSession = URLSession(configuration: urlSessionConfiguration)
		let dataTask = urlSession.dataTask(with: configuration.apiEndpoint
			.appendingPathComponent("transaction")
			.appendingPathComponent(id)
		) { data, response, error in
			if let error = error {
				completionHandler(nil,error)
				return
			}
			guard let response = response as? HTTPURLResponse else {
				completionHandler(nil, Error.unprocessableEntity)
				return
			}
			guard response.statusCode == 200 else {
				completionHandler(nil, Error.from(errorCode: response.statusCode))
				return
			}
			guard let data = data else {
				completionHandler(nil, nil)
				return
			}
			
			do {
				completionHandler(try Revolut.jsonDecoder.decode(Transaction.self, from: data), nil)
			} catch {
				completionHandler(nil, error)
			}
		}
		dataTask.resume()
	}
}

//
//  Model.swift
//  VinuTask
//
//  Created by Vinu on 12/03/21.
//

struct Details: Codable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

struct CardDetails {
    var cvvno:Int
    var cardNo:String
    var expiry:String
    var person:Person
}

struct Person {
    var name:String
    var dob:String
    var aadhaarNo:String
    var panNo:String
    var card:[CardDetails]
}

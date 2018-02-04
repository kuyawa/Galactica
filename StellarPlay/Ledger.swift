//
//  Ledger.swift
//  StellarPlay
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


extension ViewController {
    
    func loadPayments(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        self.showStatus("Loading payments, please wait...")
        let account = accountsController.list[selectedAccount]
        if refresh! || paymentsController.list.count < 1 {
            paymentsController.load(from: account) { message in
                self.showStatus(message)
            }
        }
    }
    
    func loadOperations(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        self.showStatus("Loading operations, please wait...")
        let account = accountsController.list[selectedAccount]
        if refresh! || operationsController.list.count < 1 {
            operationsController.load(from: account) { message in
                self.showStatus(message)
            }
        }
    }
    
    func loadTransactions(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        self.showStatus("Loading transactions, please wait...")
        let account = accountsController.list[selectedAccount]
        if refresh! || transactionsController.list.count < 1 {
            transactionsController.load(from: account) { message in
                self.showStatus(message)
            }
        }
    }
    
    func loadEffects(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        self.showStatus("Loading effects, please wait...")
        let account = accountsController.list[selectedAccount]
        if refresh! || effectsController.list.count < 1 {
            effectsController.load(from: account) { message in
                self.showStatus(message)
            }
        }
    }
    
    func loadOffers(refresh: Bool? = false) {
        if selectedAccount < 0 || selectedAccount >= accountsController.list.count { return }
        self.showStatus("Loading offers, please wait...")
        let account = accountsController.list[selectedAccount]
        if refresh! || offersController.list.count < 1 {
            offersController.load(from: account) { message in
                self.showStatus(message)
            }
        }
    }
    
}

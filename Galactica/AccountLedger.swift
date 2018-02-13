//
//  Ledger.swift
//  Galactica
//
//  Created by Laptop on 1/31/18.
//  Copyright © 2018 Armonia. All rights reserved.
//

import Cocoa
import StellarSDK


// Extension for Account Ledger

extension ViewController {
    
    func loadPayments(refresh: Bool? = false) {
        if let account = getSelectedAccount() {
            if refresh! || paymentsController.list.count < 1 {
                self.showStatus("Loading payments, please wait...")
                paymentsController.load(from: account) { message in
                    self.showStatus(message)
                }
            }
        } else {
            showStatus("No account selected")
        }
    }
    
    func loadOperations(refresh: Bool? = false) {
        if let account = getSelectedAccount() {
            if refresh! || operationsController.list.count < 1 {
                self.showStatus("Loading operations, please wait...")
                operationsController.load(from: account) { message in
                    self.showStatus(message)
                }
            }
        } else {
            showStatus("No account selected")
        }
    }
    
    func loadTransactions(refresh: Bool? = false) {
        if let account = getSelectedAccount() {
            if refresh! || transactionsController.list.count < 1 {
                self.showStatus("Loading transactions, please wait...")
                transactionsController.load(from: account) { message in
                    self.showStatus(message)
                }
            }
        } else {
            showStatus("No account selected")
        }
    }
    
    func loadEffects(refresh: Bool? = false) {
        if let account = getSelectedAccount() {
            if refresh! || effectsController.list.count < 1 {
                self.showStatus("Loading effects, please wait...")
                effectsController.load(from: account) { message in
                    self.showStatus(message)
                }
            }
        } else {
            showStatus("No account selected")
        }
    }
    
    func loadOffers(refresh: Bool? = false) {
        if let account = getSelectedAccount() {
            if refresh! || offersController.list.count < 1 {
                self.showStatus("Loading offers, please wait...")
                offersController.load(from: account) { message in
                    self.showStatus(message)
                }
            }
        } else {
            showStatus("No account selected")
        }
    }
    
}

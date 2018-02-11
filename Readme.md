# GALACTICA

**Galactica** is a desktop client for macOS showcasing the power of the StellarSDK, a great library for building macOS and iOS apps.

With Galactica you can control multiple wallets and assets, check their balances and send payments, query all transactions, operations, payments, effects, orders, etc, and modify account options like authorization flags, inflation destination, allow and change trustlines, merge accounts and many more.

Designed to be the simplest and easiest desktop client for Stellar preserving a totally native Mac experience built in Swift, take a look:

![Screenshot1](media/screenshot1.jpg)
![Screenshot2](media/screenshot2.jpg)
![Screenshot3](media/screenshot3.jpg)
![Screenshot4](media/screenshot4.jpg)


## How to Use

After installing the app and running it for the first time there will be one test account to play, that account does not have a secret key so it is in read-only mode so you won't be able to send payments or submit transactions.

To add your own accounts go to the `Create Account` tab and enter your existing accounts or generate new ones. Remember to select the network as Live or Test if you will use the account for real or testing purposes. You can enter as many accounts as you want. Give them a useful name so you can differentiate them like Cash Account, Savings, Business, Vault, Donations, etc.

Once some accounts have been stored, you can start querying for transactions or send payments to other accounts, or you can set some options like inflation destination, asset trustlines, etc.

One thing to remember is the asynchronous nature of web requests, all requests for information must be sent to the Stellar Network so they may take time to come back and appear on the application user interface sometimes up to a couple of seconds. 


## Download

Galactica is not available on the AppStore yet, so to run it you have to download the latest version from Github and run it on your Mac. 

Disclaimer: *Never trust any app download from the internet unless they are peer reviewed and community approved. Never share your secret keys with any app, site or person. We are not responsible for any loss. Use at your own risk.*

## External Libraries

- StellarSDK in Swift, developed by Kuyawa Kata

## Donations

Please support our work and send donations to the following address so we can continue developing more awesome apps!

`GALT5LR4TDTR5TX7GFHYZQIZRDD6HX32YHXYII7CAFG3ZOZALZUYGMZK`

Thank you.

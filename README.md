# Scanship

Scanship is a mobile app developed by Jesus Rodriguez. More specifically Scanship is an app used for scanning barcodes and generating shipping list of the items or boxes being loaded into a truck, all of this to keep better track of shipments.

# Features:
### QR and Barcode Scanning:
Scanship uses the barcode_scan dart package to scan the barcode.

### Product Checking using QR and barcodes
The app also allows the user to check for a certain product name.

### Shipping lists for each order
Scanship´s main purpose is to help the warehouse manager to keep track of what gets out of the warehouse by creating a shipping list using the barcode scanner function of the app.

# Extras:
Given that the app was developed for a business, a python script was created to fetch the data from the Firebase Realtime Database to write that data to an excel sheet. Link to the Script Repo

# Issues:
At the moment, Scanship is only working for iOS devices but Android version will be completed soon

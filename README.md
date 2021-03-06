# HiWifiCore Demo App

This is an Xcode demo project for the **HiWifiCore Swift Package** available at  
[https://github.com/WIFI-Connect/HiWifiCore_iOS](https://github.com/WIFI-Connect/HiWifiCore_iOS)

Download the demo project and open it with Xcode 12.5.1 or later.

Check if the needed Swift packages **CryptoSwift** 1.4.0 and **HiWifiCore** 1.0.2 (or later) are loaded. 

Build an run the demo app on a **real device with iOS 13 or later**.  
**The HiWifiCore Demo App does not work on simulator.**

Choose **"Allow While Using App"** and **"Change to Allow Always"** for location updates so the app can access the Wi-Fi information even when running in the background.

Choose **"Allow"** Notifications so the app can send notifications when the device connects to a known Wi-Fi access point.

The demo app should now display the HiWifi Core status **"Running"**.

Create a Wi-Fi access point with the SSID **"hiwifitest"** that has internet access.

Connect your device to the created Wi-Fi access point.

The demo app should send the following push notification:

> HIWIFICORE DEMO   
> HiWifi Core Test   
> HiWifi Core setup successful! 

When you tap the notification the demo app should open [https://wifi-connect.eu](https://wifi-connect.eu) 
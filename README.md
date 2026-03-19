# Tablet Dashboard (Unlocked Kasm) for Home Assistant 📱

A lightweight, heavily optimized Home Assistant Add-on that brings modern dashboards to **old tablets, smart fridges, and legacy devices** that struggle with modern web engines.

Based on the official [KasmVNC](https://kasmweb.com/) Chromium container, this add-on creates an ultra-fluid, server-side rendered instance of your Home Assistant dashboard and streams it to your old device via a simple HTML5 viewer. 

## ✨ Features

- 🔓 **Plain HTTP Support:** Bypasses Kasm's strict HTTPS/SSL requirements. Runs perfectly on local HTTP, preventing those annoying "Secure Connection Required" black screens on legacy browsers.
- 👆 **Smart Touch-to-Scroll (V2.1):** Includes a custom-built, deeply integrated extension that translates legacy "touch-drag" events into smooth scrolling. No more accidentally selecting text while trying to navigate!
- 🖱️ **Long-Press / Right-Click Support:** Features a smart 15px deadzone. You can now confidently long-press items (like lights or entities for more info) without accidentally triggering a page scroll.
- 🌙 **Native Dark Mode:** Chromium is forced into Dark Mode by default to save your eyes (and your screen's backlight) at night.
- 🚀 **Performance Optimized:** All unnecessary Kasm background services (Audio, Microphone, Gamepad, Printer) are completely disabled to save CPU and RAM on your Home Assistant host.

## 📦 Installation

1. Navigate to your Home Assistant **Add-on Store**.
2. Click the 3 dots in the top right corner and select **Repositories**.
3. Add the URL of this repository.
4. Search for **Tablet Dashboard (Unlocked Kasm)** and click **Install**.

## ⚙️ Configuration

Before starting the add-on, go to the **Configuration** tab:

* **`url`**: Enter the exact URL of your Home Assistant dashboard that you want to display. 
  * *Default:* `http://homeassistant.local:8123`
  * *Example:* `http://192.168.1.100:8123/lovelace/tablet`

## 🚀 Usage

1. **Start** the add-on. *(Note: The first boot will take a few minutes as it downloads and extracts the official Kasm image).*
2. Click **Open Web UI** or navigate to `http://<YOUR_HA_IP>:6901` on your old tablet.
3. You will be greeted by the KasmVNC login screen. 

**Default Credentials:**
* **Username:** `kasm_user`
* **Password:** `0000`

> 💡 **Tip for old tablets:** Once you log in, your browser will ask if you want to save the password. Choose "Save" so you never have to type it again when the tablet reboots or refreshes the page.

## 🛠️ How it works
This add-on runs a full desktop-class Chromium browser *inside* your Home Assistant server. When you touch your old tablet, it sends those coordinates to the server; the server processes the heavy Javascript of the Home Assistant dashboard and sends back a highly compressed, lag-free video stream of the result. Your old tablet does zero heavy lifting!

## ☕ Support my work

<a href="https://www.buymeacoffee.com/AndreiOprisan"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee"></a>

---

## 📝 License
MIT License. Feel free to use, modify, and share!
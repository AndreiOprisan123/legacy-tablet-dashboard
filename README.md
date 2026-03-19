# 📺 Home Assistant Legacy Tablet Dashboard Hub

Give a second life to your old iPads, Android tablets, or smart fridges! This project provides a high-compatibility bridge to display modern Home Assistant Dashboards (or any URL) on devices with outdated browsers that normally can't load the HA interface.

---

## ✨ Features
* **High Compatibility:** Uses a Firefox-based noVNC bridge to render content on the server and stream it to the tablet.
* **Multi-Instance:** Run up to 5 independent instances for different rooms or devices with unique resolutions.
* **Touch Optimized:** Includes a special "Gesture Mode" for smooth scrolling on old touchscreens.
* **Kiosk Ready:** Perfectly fits the screen with full-screen support.
* **Universal:** Works for Home Assistant, YouTube, Spotify, or any web dashboard.

---

## 🛠️ Installation

1. Copy the URL of this GitHub repository.
2. In your Home Assistant, go to **Settings** > **Add-ons** > **Add-on Store**.
3. Click the **three dots** in the top right corner and select **Repositories**.
4. Paste the URL and click **Add**.
5. You will now see 5 instances of **Legacy Tablet Dashboard** in your local store.
6. Install the instances you need (e.g., Instance 1 for the Kitchen, Instance 2 for the Bedroom).

---

## ⚙️ Configuration

Each instance can be configured independently:

1. **URL:** Enter the full address you want to display (e.g., `http://192.168.1.100:8123/dashboard-tablet?kiosk`).
2. **Touch Optimization:** * **Enabled (True):** Best for tablets. Allows natural finger swiping to scroll.
   * **Disabled (False):** Best for devices using a mouse or legacy touch-to-click inputs.
3. **Network:** Assign the port for each device (Default starts at 5800). **Don't forget to save the port number in the Network section!**

---

## 🚀 How to Access

Once the add-on is started, you can access your dashboard via:
`http://YOUR_HOME_ASSISTANT_IP:5800` (or 5801, 5802, depending on the instance).

*Tip: Use the **"Open Web UI"** button directly from the Add-on Info page for quick access.*

---

## ⚠️ Resource Usage Disclaimer
Each active instance runs a dedicated virtual display and a Firefox process. 
* **Per Instance:** ~250MB - 400MB RAM.
* Running all 3 instances simultaneously requires at least **1.5GB of free RAM**. Monitor your system health if running on a Raspberry Pi.

---

## ☕ Support my work

<a href="https://www.buymeacoffee.com/AndreiOprisan"><img src="https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black" alt="Buy Me A Coffee"></a>

---

## 📝 License
MIT License. Feel free to use, modify, and share!
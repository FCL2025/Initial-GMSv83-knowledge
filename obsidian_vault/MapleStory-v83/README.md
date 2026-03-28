# 🗂️ MapleStory v83 技術知識庫

> 私人伺服器架設與開發的完整技術筆記

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![MapleStory](https://img.shields.io/badge/Game-MapleStory%20v83-orange)](https://maplestory.nexon.com)

---

## 📖 關於這個專案

這是一份完整的 **MapleStory v83 私人伺服器**技術知識庫，涵蓋從零開始架設到進階開發的所有技術細節。

### 🎯 適合對象

- 想架設私人伺服器的玩家
- 對遊戲逆向工程有興趣的開發者
- 想學習 Client-Server 架構的學習者

---

## 📚 章節結構

```
MapleStory-v83/
├── 00-學習地圖/          🗺️ 學習路徑指南
├── 01-基礎知識/          📗 必備基礎概念
│   ├── 1.1-MapleStory-架構.md
│   ├── 1.2-WZ-檔案系統.md
│   └── 1.3-必備術語.md
├── 02-客戶端修改/        🔧 客戶端修改技術
│   ├── 2.1-客戶端修改原理.md
│   ├── 2.2-Hex-編輯器修改.md
│   ├── 2.3-STRedit-字串修改.md
│   ├── 2.4-Themida-脫殼.md
│   ├── 2.5-去除保護.md
│   └── 2.6-WZ-編輯器使用.md
├── 03-伺服器開發/        🖥️ 伺服器架設與開發
│   ├── 3.1-環境架設.md
│   ├── 3.1a-MapleSolaxiaV2-架設.md
│   ├── 3.2-音源編譯.md
│   ├── 3.3-資料庫設定.md
│   └── 3.4-伺服器配置.md
├── 04-進階主題/          🚀 進階技術
│   ├── 4.1-Wireshark-抓包.md
│   ├── 4.2-Opcode-結構.md
│   ├── 4.3-NPC-腳本.md
│   └── 4.4-客戶端修改-進階.md
├── 05-工具資源/          🛠️ 工具與資源
└── 99-學習日誌/          📓 學習記錄
```

---

## 🗺️ 學習路徑

```
第一階段：基礎知識
├── 1.1 MapleStory 架構
├── 1.2 WZ 檔案系統
└── 1.3 必備術語
        ↓
第二階段：客戶端修改
├── 2.1 客戶端修改原理
├── 2.2 Hex 編輯器使用
├── 2.3 WZ 編輯器使用
├── 2.4 Themida 脫殼
└── 2.5 去除保護
        ↓
第三階段：伺服器架設
├── 3.1 環境架設
├── 3.2 音源編譯
├── 3.3 資料庫設定
└── 3.4 伺服器配置
        ↓
第四階段：進階主題
├── 4.1 Wireshark 抓包
├── 4.2 Opcode 結構
├── 4.3 NPC 腳本
└── 4.4 客戶端修改進階
```

---

## 🔧 核心技術棧

| 領域 | 技術/工具 |
|------|-----------|
| **客戶端** | Hex Editor, WZ Editor, Themida, localhost.exe |
| **伺服器** | Java (JDK 7), MySQL, NetBeans |
| **網路** | Wireshark, Socket Programming |
| **腳本** | NPC ES6/Nashorn Scripts |
| **封包** | MapleCrypto, Opcode Analysis |

---

## 🛠️ 熱門伺服器專案

| 專案 | 特色 |
|------|------|
| [HeavenMS](https://github.com/HeavenMS) | 穩定開源 v83 伺服器 |
| [MapleSolaxiaV2](https://github.com/skhzhang/MapleSolaxiaV2) | 完整架設指南 |
| [MapleEzorsia-v2](https://github.com/444Ro666/MapleEzorsia-v2) | 首家 v83 獨立 HD DLL |
| [RxMS](https://github.com/ollieball/RxMS) | 現代化重構版本 |

---

## 🔍 常見問題

### Q: 需要什麼環境？
A: Windows 系統，建議 8GB+ RAM

### Q: Java 版本？
A: JDK/JRE 7 (Java 7)

### Q: 可以在區域網路遊玩嗎？
A: 可以，透過 Hamachi、Radmin VPN 或 Port Forwarding

---

## 📊 相關工具

| 工具 | 用途 |
|------|------|
| Maple_Pshark | v83 封包攔截與修改 |
| WZ Editor | 遊戲資源檔案編輯 |
| Themida | 客戶端保護殼移除 |
| Wireshark | 網路封包分析 |

---

## 📝 授權

本專案僅供**學習研究**用途，請勿用於商業目的。

---

## 🤝 貢獻

歡迎提出 Issue 或 Pull Request！

---

*最後更新：2026-03-28 17:57 UTC (第八十三次)*

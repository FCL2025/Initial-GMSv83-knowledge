# 封包分析與Opcode結構 (v83)

## 封包基礎

### 封包格式
MapleStory 使用 TCP 協議傳輸資料，封包由以下部分組成：

```
[Header (4 bytes)][Opcode (2 bytes)][Data (變長)]
```

- **Header**: 4 bytes，包含封包長度和加密後的 opcode
- **Opcode**: 2 bytes (v83)，標識封包類型
- **Data**: 實際資料，變長

### 第一個封包 (Hello Packet)
- 連接建立後的第一個封包是**明文**（未加密）
- 用於交換 AES 初始化向量 (IV)
- 客戶端和伺服器各自生成隨機密鑰

## 加密機制

### 三層加密架構 (v83)

1. **AES-OFB 加密**
   - 使用 AES (Advanced Encryption Standard) 的 OFB 模式
   - 用於主要資料加密
   - 每次發送封包後 IV 會更新

2. **MapleCrypto**
   - 早期版本使用的加密
   - 包含 IV shift 機制

3. **Shanda 加密** (v83 仍有)
   - 中國盛大公司的自定義加密
   - 後來版本已移除

### 加密流程 (發送端)
```
明文資料 → AES-OFB 加密 → MapleCrypto 混淆 → 網路傳輸
```

### 解密流程 (接收端)
```
網路接收 → MapleCrypto 反向 → AES-OFB 解密 → 明文資料
```

## 封包頭部結構

### Header 格式 (4 bytes)
```
[2 bytes: 封包長度][2 bytes: 混淆後的 opcode]
```

### 長度計算
- 封包總長度 = Header(4) + Opcode(2) + Data length
- 發送到網路前會進行加密混淆

### Opcode 混淆
- 使用版本號和 IV 進行混淆
- 混淆公式涉及版本號的反轉和位移

## 主要 Opcode 列表 (v83)

### 登入相關
| Opcode | 名稱 | 方向 | 說明 |
|--------|------|------|------|
| 0x01 | LOGIN_REQUEST | C → S | 登入請求 |
| 0x02 | LOGIN_RESPONSE | S → C | 登入回應 |
| 0x03 | CHECK_PASSWORD | C → S | 密碼驗證 |
| 0x04 | CHECK_PASSWORD_RESULT | S → C | 密碼驗證結果 |

### 地圖相關
| Opcode | 名稱 | 方向 | 說明 |
|--------|------|------|------|
| 0x0B | CHANGE_MAP | C → S | 換地圖請求 |
| 0x0C | CHANGE_MAP_RESULT | S → C | 換地圖結果 |
| 0x2E | SPAWN_PORTAL | S → C | 生成傳送門 |

### 玩家移動
| Opcode | 名稱 | 方向 | 說明 |
|--------|------|------|------|
| 0x37 | MOVE_PLAYER | C → S | 玩家移動 |
| 0x38 | CLOSE_RANGE_ATTACK | C → S | 近程攻擊 |
| 0x39 | RANGED_ATTACK | C → S | 遠程攻擊 |
| 0x3A | MAGIC_ATTACK | C → S | 魔法攻擊 |

### NPC 對話
| Opcode | 名稱 | 方向 | 說明 |
|--------|------|------|------|
| 0x4F | NPC_TALK | S → C | NPC 對話 |
| 0x50 | NPC_TALK_MORE | C → S | NPC 繼續對話 |
| 0x51 | NPC_ACTION | C → S | NPC 動作 |

### 物品操作
| Opcode | 名稱 | 方向 | 說明 |
|--------|------|------|------|
| 0x1C | INVITE_OPERATION | S → C | 物品操作邀請 |
| 0x1D | INVITE_RESULT | C → S | 物品操作結果 |
| 0x23 | TAKE_BOOM_SHOT | C → S | 拾取物品 |

> 注意: 具體的 Opcode 值可能因版本和私服而異，需使用工具實際抓包確認。

## 抓包工具

### Maple_Pshark
**GitHub**: https://github.com/obstriker/Maple_Pshark

專為 v83 設計的封包攔截工具。

**功能**:
- Hook 到加密函數，直接獲取明文
- 攔截 Recv/Send 封包
- 修改訊息內容
- 注入自定義封包
- 規則過濾

**使用方式**:
1. 啟動 MapleStory localhost
2. 啟動 Maple_Pshark
3. 觀察封包日誌

### MaplePacketPuller
**GitHub**: https://github.com/Bratah123/MaplePacketPuller

- Python 編寫
- 自動解析封包結構
- 識別常見 opcode

### Wireshark 過濾
```
tcp.port == 7575 || tcp.port == 8484
```

## 使用 IDA 獲取 Opcode

### 教學資源
- https://forum.ragezone.com/threads/getting-packet-structures-opcodes-using-ida.792436/

### 步驟
1. 使用 IDA 打開 MapleStory.exe 或相關 DLL
2. 找到封包處理函數
3. 分析跳轉表 (switch cases)
4. 提取每個 case 對應的 opcode

### 動態分析 vs 靜態分析
- **動態分析** (使用調試器) 通常更有效
- 可配合斷點設定觀察實際執行的 opcode
- IDA + x64dbg 可視化分析

## 封包結構分析範例

### 登入請求封包 (LOGIN_REQUEST)
```
[Header: 4 bytes][Opcode: 2 bytes][帳號字串][密碼字串]
```

### 移動封包 (MOVE_PLAYER)
```
[Header: 4 bytes][Opcode: 2 bytes]
[Path: 可變][CRC: 4 bytes]
```

### NPC 對話封包 (NPC_TALK)
```
[Header: 4 bytes][Opcode: 2 bytes]
[NPC ObjectID: 4 bytes][Type: 1 byte][Text: 可變]
```

## MapleStory Reference Wiki
- **URL**: https://mapleref.fandom.com/wiki/Packets
- 提供完整的封包格式文檔
- Opcode 列表
- 各版本差異

## 實用腳本/P工具

### maplelib (Go)
**URL**: https://pkg.go.dev/github.com/defaultmagi/maplelib

- 包含 MapleStory 加密/解密實現
- 可用於理解加密機制

### RustMS (Rust)
**URL**: https://github.com/neeerp/RustMS

- 從零開始實現 MapleStory 伺服器
- 可學習登入握手流程

## 客戶端加密類參考

### ClientEncryption.java
**URL**: https://github.com/Kevin-Jin/verticle-story/blob/master/src/main/java/net/pjtb/vs/playerside/ClientEncryption.java

- 完整的客戶端加密實現
- 可用於對比分析

### 關鍵方法
```java
// AES 加密
public byte[] encrypt(byte[] data)

// AES 解密
public byte[] decrypt(byte[] data)

// 初始化 (Hello Packet 處理)
public void init(byte[] serverPublicKey, byte[] clientPrivateKey)
```

## 學習建議

1. **先從 Hello Packet 入手**
   - 第一個封包是明文
   - 可以理解整體握手流程

2. **使用工具輔助**
   - Maple_Pshark 可直接看到明文
   - 節省逆向分析時間

3. **動手實踐**
   - 架設本地伺服器
   - 使用工具抓包
   - 對比理論和實際

4. **社區資源**
   - RaGEZONE 有大量教程
   - MapleStory Reference Wiki 有完整文檔

---

*更新時間: 2026-03-27*
*主要來源: MapleStory Reference Wiki, RaGEZONE, GitHub 開源項目*
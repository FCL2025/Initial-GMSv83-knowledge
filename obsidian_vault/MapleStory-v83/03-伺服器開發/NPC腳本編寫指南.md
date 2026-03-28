# NPC 腳本編寫完整指南 (v83)

---

## 🆕 Kinoko 新型 NPC 腳本 (RaGEZONE, 2026-02)

**來源**: https://forum.ragezone.com/threads/kinoko-npc-scripts.1261538/

### 傳統寫法 vs Kinoko 寫法

| 寫法 | 適用音源 | 狀態管理 | 複雜度 |
|------|---------|---------|--------|
| 傳統 status 方式 | Cosmic, HeavenMS | 手動 status++ | 中等 |
| Kinoko 新型方式 | Kinoko | 無需 status | 簡單 |

### 傳統 status 寫法（Cosmic, HeavenMS）
```javascript
var status = 0;

function start() {
    status = -1;
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1 || mode == 0) {
        cm.dispose();
        return;
    }
    
    if (mode == 1) {
        status++;
    } else {
        status--;
    }
    
    switch(status) {
        case 0:
            cm.sendNext("你好！");
            break;
        case 1:
            cm.sendSimple("選擇:\n #b#L0#購買#l\n #L1#出售#l");
            break;
        // ...
    }
}
```

### Kinoko 新型寫法（無需 status）
```javascript
function start() {
    npc.sayNext("你好！");
}

// Kinoko 專用語法
function npc.sayNext(message) {
    // 自動處理對話流程
}

function npc.sayYesNo(message) {
    // 自動處理 Yes/No
}

function npc.askText(message, defaultText, minLen, maxLen) {
    // 自動處理文字輸入
}
```

### 腳本源相容性問題

**問題**：不同音源（Cosmic、Kinoko、HeavenMS）的 NPC 腳本解析器版本不同。

**解決方案**：
```javascript
// 方案1: 在 source 中 include 較舊版本的 script reader
// 方案2: 使用相容格式編寫腳本
// 方案3: 先在本地測試再部署
```

**最佳實踐**：
- ✅ 使用普遍支援的 `cm.` 函數
- ❌ 避免使用特定音源專有的 Package 路徑
- ❌ 避免 `importPackage`（JDK 7+ 已廢棄）
- ✅ 在目標音源上驗證

---

## 腳本位置
- **一般 NPC**: `scripts/npc/` 目錄，每個 NPC ID 對應一個 `.js` 檔案
- **Quest NPC**: `scripts/quest/`
- **事件腳本**: `scripts/event/`

## 核心函數

### start()
腳本入口點，遊戲開始對話時調用。
```javascript
function start() {
    cm.sendNext("歡迎來到我的商店！");
}
```

### action(mode, type, selection)
處理玩家按鈕點擊。
- `mode`: 1 = 確認/下一步, 0 = 取消/返回, -1 = 關閉對話
- `type`: 按鈕類型
- `selection`: 玩家選擇的選項索引

```javascript
function action(mode, type, selection) {
    if (mode == 1) {
        status++;
    } else {
        status--;
    }
    
    if (status == 1) {
        cm.sendSimple("請選擇:\n #b#L0#購買道具#l\n #L1#出售道具#l");
    } else {
        cm.dispose();
    }
}
```

## 常用 cm 方法

### 對話相關
| 方法 | 用途 |
|------|------|
| cm.sendNext(text) | 下一頁對話 |
| cm.sendPrev(text) | 返回上一頁 |
| cm.sendSimple(text) | 選擇選單 |
| cm.sendYesNo(text) | 是/否對話框 |
| cm.sendAcceptDecline(text) | 接受/拒絕對話框 |
| cm.sendGetNumber(text, def, min, max) | 數字輸入框 |
| cm.sendGetText(text) | 文字輸入框 |
| cm.askYesNo(text) | 詢問是否 |
| cm.askText(text, defaultText, minLen, maxLen) | 文字輸入 |

### 玩家資料
| 方法 | 用途 |
|------|------|
| cm.getPlayer() | 獲取玩家物件 |
| cm.getPlayer().getName() | 玩家名稱 |
| cm.getPlayer().getLevel() | 等級 |
| cm.getPlayer().getJob() | 職業 ID |
| cm.getMesos() | 楓幣數量 |
| cm.haveItem(id, count) | 檢查物品數量 |
| cm.getItemCount(id) | 獲取物品數量 |

### 物品/金錢操作
| 方法 | 用途 |
|------|------|
| cm.gainItem(id, count) | 給予物品 |
| cm.gainItem(id, count, true) | 給予物品並提示 (裝備自動裝備) |
| cm.gainMesos(amount) | 給予/扣除楓幣 |
| cm.removeItem(id, count) | 移除物品 |

### 地圖/傳送
| 方法 | 用途 |
|------|------|
| cm.warp(mapId) | 傳送到指定地圖 |
| cm.warpParty(mapId) | 傳送整個隊伍 |
| cm.changeMap(mapId, portalId) | 傳送到特定入口 |
| cm.getMapId() | 獲取當前地圖 ID |

### 職業/技能
| 方法 | 用途 |
|------|------|
| cm.changeJob(jobId) | 轉職 |
| cm.getJob() | 獲取職業 ID |
| cm.teachSkill(skillId, skillLevel, masterLevel) | 學習技能 |
| cm.getSkillLevel(skillId) | 獲取技能等級 |

### 任務
| 方法 | 用途 |
|------|------|
| cm.startQuest(id) | 開始任務 |
| cm.completeQuest(id) | 完成任務 |
| cm.forfeitQuest(id) | 放棄任務 |
| cm.getQuestStatus(id) | 獲取任務狀態 |
| cm.getInfoQuest(id) | 獲取任務自訂資訊 |

### 商店
| 方法 | 用途 |
|------|------|
| cm.openShop(shopId) | 開啟商店 |
| cm.closeShop(shopId) | 關閉商店 |

### 事件
| 方法 | 用途 |
|------|------|
| cm.getEventInstance() | 獲取事件實例 |
| cm.startEvent(eventName) | 開始事件 |

### 其他
| 方法 | 用途 |
|------|------|
| cm.dispose() | 結束腳本對話 |
| cm.getChannel() | 獲取頻道 ID |
| cm.getServer() | 獲取伺服器名稱 |
| cm.broadcastMessage(type, text) | 廣播訊息 |

## 變量使用

### status 變量
用於追蹤對話狀態。
```javascript
var status = 0;

function start() {
    status = -1;
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1 || mode == 0) {
        cm.dispose();
        return;
    }
    
    if (mode == 1) {
        status++;
    } else {
        status--;
    }
    
    switch(status) {
        case 0:
            cm.sendNext("你好！");
            break;
        case 1:
            cm.sendSimple("選擇一個選項:\n #b#L0#購買#l\n #L1#出售#l\n #L2#離開#l");
            break;
        case 2:
            if (selection == 0) {
                cm.sendNext("感謝購買！");
            } else if (selection == 1) {
                cm.sendNext("感謝光臨！");
            } else {
                cm.dispose();
            }
            break;
        default:
            cm.dispose();
            break;
    }
}
```

### 腳本內變量
```javascript
var selectedItem = 0;
var price = 1000;

function action(mode, type, selection) {
    if (mode == 1) {
        selectedItem = selection;
    }
    // ...
}
```

### NPC 變量 (用於複雜對話)
```javascript
var npcText = "這是我的商店";

function action(mode, type, selection) {
    // NPC 變量可在多次對話中保持
}
```

## 完整範例

### 簡單商店 NPC
```javascript
var status = 0;

function start() {
    cm.sendSimple("歡迎！請選擇服務:\n #b#L0#購買藥水#l\n #L1#購買彈藥#l\n #L2#離開#l");
}

function action(mode, type, selection) {
    if (mode == 1) {
        status++;
    } else {
        status--;
    }
    
    if (status == 0) {
        if (selection == 0) {
            // 購買藥水
            if (cm.getMesos() >= 1000) {
                cm.gainMesos(-1000);
                cm.gainItem(2000002, 100); // 100 個 HP 水
                cm.sendNext("交易完成！");
            } else {
                cm.sendNext("楓幣不足！");
            }
            cm.dispose();
        } else if (selection == 1) {
            // 購買彈藥
            if (cm.getMesos() >= 500) {
                cm.gainMesos(-500);
                cm.gainItem(2330000, 500); // 500 發子彈
                cm.sendNext("交易完成！");
            } else {
                cm.sendNext("楓幣不足！");
            }
            cm.dispose();
        } else {
            cm.sendNext("歡迎再次光臨！");
            cm.dispose();
        }
    }
}
```

### 轉職 NPC
```javascript
var status = 0;

function start() {
    status = -1;
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1) {
        cm.dispose();
    } else if (mode == 1) {
        status++;
    } else {
        cm.dispose();
        return;
    }
    
    var player = cm.getPlayer();
    var job = player.getJob();
    
    if (status == 0) {
        if (job == 0) {
            cm.sendSimple("你是新手。選擇要轉職的方向:\n #b#L0#弓箭手#l\n #L1#法師#l\n #L2#盜賊#l\n #L3#戰士#l");
        } else {
            cm.sendNext("你已經轉職過了！");
            cm.dispose();
        }
    } else if (status == 1) {
        var newJob = 0;
        switch(selection) {
            case 0:
                newJob = 300; // 弓箭手
                break;
            case 1:
                newJob = 200; // 法師
                break;
            case 2:
                newJob = 400; // 盜賊
                break;
            case 3:
                newJob = 100; // 戰士
                break;
        }
        cm.changeJob(newJob);
        cm.sendNext("轉職成功！你现在是 " + getJobName(newJob) + "！");
        cm.dispose();
    }
}

function getJobName(jobId) {
    switch(jobId) {
        case 100: return "戰士";
        case 200: return "法師";
        case 300: return "弓箭手";
        case 400: return "盜賊";
        default: return "未知";
    }
}
```

### 傳送 NPC
```javascript
function start() {
    cm.sendSimple("選擇要前往的地點:\n #b#L0#洛陽城#l\n #L1#明珠港#l\n #L2#魔法森林#l");
}

function action(mode, type, selection) {
    if (mode == 1) {
        switch(selection) {
            case 0:
                cm.warp(100000000); // 洛陽城
                break;
            case 1:
                cm.warp(120000000); // 明珠港
                break;
            case 2:
                cm.warp(101000000); // 魔法森林
                break;
        }
    }
    cm.dispose();
}
```

## 職業 ID 參考 (v83)

| 職業 | Job ID |
|------|--------|
| 新手 | 0 |
| 戰士 | 100 |
| 魔法師 | 200 |
| 弓箭手 | 300 |
| 盜賊 | 400 |
| 流浪騎士 | 500 |
| 砲手 | 501 |

### 一轉職業
| 職業 | Job ID |
|------|--------|
| 劍客 | 110 |
| 槍騎兵 | 120 |
| 仲裁者 | 130 |
| 火毒 | 210 |
| 冰雷 | 220 |
| 僧侶 | 230 |
| 箭神 | 310 |
| 獵人 | 320 |
| 弓箭手 | 330 |
| 刺客 | 410 |
| 俠盜 | 420 |
| 夜行者 | 430 |

## 常見地圖 ID
| 地圖 | Map ID |
|------|--------|
| 弓箭手村 | 100000000 |
| 魔法森林 | 101000000 |
| 維多利亞港 | 104000000 |
| 墮落的城市 | 105000000 |
| 明珠港 | 120000000 |
| 雲彩之塔 | 200000000 |
| 神秘河 | 300000000 |
| 楓葉山丘 | 100000100 |

## MSI (Monster Soul Item) NPC 格式
```javascript
var status = 0;
var selected = 1;
var wui = 0;

function start() {
    status = -1;
    action(1, 0, 0);
}

function action(mode, type, selection) {
    if (mode == -1) {
        cm.dispose();
    } else if (mode == 1) {
        status++;
    } else {
        status--;
    }
    
    if (status == 0) {
        cm.sendYesNo("要進入神秘商店嗎？");
    } else if (status == 1) {
        cm.openShop(9030000);
        cm.dispose();
    }
}
```

## 🆕 2026-03-27 新增：NPCConversationManager.java 完整方法列表 (HeavenMS 源碼)

**來源**: https://github.com/ronancpl/HeavenMS/blob/master/src/scripting/npc/NPCConversationManager.java

### NPC Talk Type 值

| Type 值 | 說明 |
|---------|------|
| `0` | 確定/下一頁 (speaker: "00 01") |
| `1` | Yes/No (speaker: "") |
| `4` | 簡單選擇選單 (speaker: "") |
| `0x0C` | 接受/拒絕 (speaker: "") |

### 髮型/顏色選擇 (sendStyle)

```javascript
// styles 是 int array，包含可選的 ID
cm.sendStyle("選擇髮型:", [30000, 30010, 30020, 30030]);
```

### 數字輸入 (sendGetNumber)

```javascript
// 顯示數字輸入框
// sendGetNumber(text, default, min, max)
cm.sendGetNumber("請輸入數量:", 1, 1, 999);
```

### 文字輸入 (sendGetText)

```javascript
// 顯示文字輸入框
cm.sendGetText("請輸入名字:");
// 使用 getText() 取得輸入內容
var input = cm.getText();
```

### 維度鏡 (sendDimensionalMirror)

```javascript
// 顯示維度鏡特殊功能
cm.sendDimensionalMirror("選擇要去的地方:");
```

### 玩家外觀修改

| 方法 | 說明 |
|------|------|
| `setHair(hair)` | 設定髮型（直接套用） |
| `setFace(face)` | 設定臉型（直接套用） |
| `setSkin(color)` | 設定皮膚顏色（直接套用） |

### GM/特殊功能

| 方法 | 說明 |
|------|------|
| `showEffect(effect)` | 顯示地圖特效 |
| `displayGuildRanks()` | 顯示公會排名視窗 |
| `resetStats()` | 重置角色屬性點 |
| `maxMastery()` | 所有技能滿級 |
| `canSpawnPlayerNpc(mapid)` | 檢查能否生成玩家NPC |
| `getPlayerNPCByScriptid(id)` | 透過腳本ID取得玩家NPC |
| `openShopNPC(shopId)` | 開啟指定商店 |

### NPC 腳本源相容性問題 (2026-03 新發現)

**問題**：
- 不同音源（Cosmic、Kinoko、HeavenMS）的 NPC 腳本解析器版本不同
- 較舊的腳本在新解析器可能不相容

**原因**：
- `importPackage` 和 `SavedLocationType` 處理差異
- JDK 7+ 已廢棄 `importPackage`

**解決方案**：
1. 使用普遍支援的 `cm.` 函數
2. 避免使用特定音源專有的 Package 路徑
3. **避免 `importPackage`**（改用直接引用）
4. 先在本地測試再部署到正式伺服器

### 最佳實踐

```javascript
// ✅ 好的寫法
var job = cm.getJob();
cm.sendNext("你的職業是 " + cm.getJobName(job));

// ❌ 避免的寫法
importPackage(Packages.client);
var job = c.getJob();

// ✅ 使用 gainItem 的第三個參數控制提示
cm.gainItem(2000002, 100, true);  // 顯示獲得提示
cm.gainItem(2000002, -100, false); // 不顯示提示（用於扣除）
```

---

## 🆕 2026-03-27 新增：GM Handbook 資料夾結構

```
handbook/
├── NPC.txt      # NPC ID 和名稱
├── item.txt     # 物品 ID 和名稱
├── map.txt      # 地圖 ID 和名稱
├── mob.txt      # 怪物 ID 和名稱
└── quest.txt    # 任務 ID 和名稱
```

### GM 常用 NPC ID 參考

| NPC 名稱 | NPC ID | 用途 |
|---------|--------|------|
| Aran 導師 | 9000000 | 弓箭手村 |
| 起始導師 | 1022000 | 轉職相關 |
| 楓之島導師 | 1031000 | 楓之島新手任務 |

### NPC.tags 翻譯問題

**問題**：Custom V18 Florist Files 中的 NPC tags 無法找到翻譯來源

**解決方案**：
1. 在 `client/client/` 資料夾中搜尋相關文字
2. `txt.txt` 檔案中通常包含 UI 字串定義
3. `NPC.wz` 中的 `tags` 欄位可能來自 `String.wz` 而非直接定義

---

*更新時間: 2026-03-27*
*來源: RaGEZONE, ElitePVPers, GitHub (HeavenMS NPCConversationManager.java), 社群教程整理*

---

## 🆕 2026-03-27 下午 新增：Dynamic NPC Shop Script (v83)

**來源**: https://forum.ragezone.com/threads/dynamic-npc-shop-script-v83.1089979/

### 核心概念
使用 JavaScript 動態定義商店，**避免每次修改都要重啟伺服器**。

### 範例程式碼
```javascript
// 動態商店 NPC
var items = Array(
    Array(4000000, 1000, 1),  // [物品ID, 價格, 數量]
    Array(4000001, 2000, 5),
    Array(4000002, 500, 10)
);

function start() {
    var shop = cm.openShop(1);  // 商店ID (需與資料庫對應)
    for (var i = 0; i < items.length; i++) {
        shop.addItem(items[i][0], items[i][1], items[i][2]);
    }
    shop.send();
}

function action(mode, type, selection) {
    if (mode == 1) {
        status++;
    } else {
        status--;
    }

    if (status == 0) {
        cm.sendSimple("請選擇:\n #b#L0#查看商品#l\n #L1#離開#l");
    } else if (status == 1) {
        if (selection == 0) {
            // 開啟動態商店
            var shop = cm.openShop(1);
            for (var i = 0; i < items.length; i++) {
                shop.addItem(items[i][0], items[i][1], items[i][2]);
            }
            shop.send();
        } else {
            cm.dispose();
        }
    }
}
```

### 優勢
| 特性 | 傳統 SQL 商店 | 動態商店 |
|------|-------------|---------|
| 修改方式 | 需改資料庫 + 重啟 | 直接修改 .js |
| 測試速度 | 慢（需重啟） | 快（即時生效） |
| 版本控制 | 需 export SQL | 直接 commit .js |
| 靈活性 | 中等 | ✅ 極高 |

### openShop 參數說明
```javascript
cm.openShop(shopId)
```
- `shopId`: 需與資料庫中的 `shopid` 對應
- 若 shopId 不存在，會自動創建新的商店

---

## 🆕 NPC TYPE 值含義解析（RaGEZONE, 2026-03）

**來源**: https://forum.ragezone.com/threads/npc-type.1262188/

### NPC TYPE 對照表（完整版）

| Type 值 | 名稱 | 客戶端行為 | 腳本需求 | 範例 |
|---------|------|-----------|---------|------|
| `0` | 普通 NPC | 點擊後發送 NPC_TALK 封包 | ✅ 需要 `.js` 腳本 | 一般任務/對話 NPC |
| `1` | 商店 NPC | 點擊後直接開啟商店介面 | ⚠️ 可有可無 | 商人、鐵匠 |
| `2` | 拍賣 NPC | 點擊後開啟拍賣介面 | ❌ 不需要 | 拍賣管理員 |
| `3` | 保險箱 NPC | 點擊後開啟保險箱 | ❌ 不需要 | 銀行 NPC |
| `4~6` | 特殊 NPC | 各類特殊功能 | ❌ 不需要 | 各類系統 NPC |

### Type 0 和 Type 1 的關鍵差異
- **Type 0**：客戶端會發送 `NPC_TALK` 封包到伺服器，等待腳本回應
- **Type 1**：客戶端直接打開商店介面（不經過腳本），但腳本仍可添加額外功能

### 如何在 HaRepacker 中查看/修改 NPC TYPE
```
1. 使用 HaRepacker 開啟 NPC.wz
2. 找到目標 NPC 的 .img 檔案（如 9000000.img）
3. 展開節點：9000000.img → info
4. 找到 type 屬性
5. 雙擊修改值
6. 保存並重新載入 WZ
```

### 修改 TYPE 後的注意事項
- **Type 0 → Type 1**：商店 NPC 不需要腳本，但可以加腳本添加額外功能
- **Type 1 仍可加腳本**：點擊時先執行腳本再開商店
- **修改 TYPE 後要重啟客戶端**：WZ 更改需要重新載入

---

## 🆕 IntransigentMS ECMAScript 6 NPC 腳本源碼（GitHub, 2026-03 新發現）

**GitHub**: https://github.com/NoetherEmmy/intransigentms-scripts

### 核心特點
- 使用 **Nashorn 引擎** 執行 JavaScript
- 遵循 **ECMAScript 6 標準**
- 完整開源的 NPC 腳本源碼集合

### 與傳統 Rhino/JDK 6 腳本的差異

| 特性 | 傳統寫法 | ECMAScript 6 寫法 |
|------|---------|------------------|
| 類型導入 | `importPackage(Packages.xxx)` | `const Xxx = Java.type("xxx")` |
| 除錯輸出 | `cm.dispose()` + `cm.sendNext()` | `print("debug")` |
| 字串拼接 | `+` 運算子 | 模板字串 |
| Lambda | 不支援 | `arr.map(x => x * 2)` |

### 範例程式碼
```javascript
// 使用 ECMAScript 6 const 宣告
const MapleCharacter = Java.type("net.sf.odinms.client.MapleCharacter");
const SkillFactory = Java.type("net.sf.odinms.server.maps.SkillFactory");

function start() {
    print("NPC 啟動 - 開始對話");  // 輸出到伺服器 console
    cm.sendNext("歡迎來到我的商店！");
}

function action(mode, type, selection) {
    if (mode === -1 || (mode === 0 && status === 0)) {
        cm.dispose();
        return;
    }
    
    if (mode === 1) {
        status++;
    } else {
        status--;
    }
    
    // 使用 ECMAScript 6 箭頭函數
    const jobName = getJobName(cm.getJob());
    cm.sendNext("你的職業是 " + jobName);
    cm.dispose();
}

function getJobName(job) {
    var jobs = {
        0: "新手",
        100: "戰士",
        200: "法師",
        300: "弓箭手",
        400: "盜賊"
    };
    return jobs[job] || "未知";
}
```

### IntransigentMS 的學習價值
- ✅ 完整腳本集合（各類 NPC）
- ✅ ECMAScript 6 現代寫法
- ✅ 涵蓋任務、商人、傳送、等級提升
- ✅ 可直接移植到 HeavenMS / Cosmic

---

## 🆕 NPC 腳本源相容性問題（RaGEZONE, 2026-03）

**來源**: https://forum.ragezone.com/threads/kinoko-npc-scripts.1261538/

### 相容性問題總覽

| 問題 | 說明 | 解決方案 |
|------|------|---------|
| 腳本解析器版本不同 | Cosmic、Kinoko、HeavenMS 可能使用不同版本的 Rhino | 使用普遍支援的 `cm.` 函數 |
| Package 路徑差異 | 不同音源的 Package 路徑不同 | 避免使用特定音源專有路徑 |
| `importPackage` 廢棄 | JDK 7+ 廢棄了 `importPackage` | 使用 `var` 宣告而非 import |

### 跨音源相容程式碼範例

```javascript
// ❌ 可能不相容的寫法
importPackage(Packages.server.maps);
// 或
var mapleInventory = Java.type("net.server.world.MapleInventory");

// ✅ 普遍支援的寫法
var status = 0;
function start() {
    cm.sendNext("Hello!");
}
```

### 不同音源推薦使用的函數

| 函數前綴 | Cosmic | Kinoko | HeavenMS | 說明 |
|---------|--------|--------|----------|------|
| `cm.` | ✅ | ✅ | ✅ | ConversationManager |
| `npc.` | ⚠️ | ✅ | ⚠️ | NPC 專有函數 |
| `player.` | ⚠️ | ✅ | ✅ | 玩家相關 |

### 最佳實踐
1. **使用 `cm.` 作為主要介面** — 這是最普遍支援的
2. **避免 `importPackage`** — 使用 `var` 而非 Java imports
3. **測試後再部署** — 先在本地測試確認相容
4. **使用普遍支援的資料型別** — `var` 而非 `int`、`String`

---

## 🆕 NPC 腳本除錯技巧（2026-03 更新）

### 常見錯誤

| 錯誤 | 原因 | 解決方案 |
|------|------|---------|
| `cm is not defined` | 腳本未正確定義 `cm` | 確認腳本在 `scripts/npc/` 目錄 |
| `status is not defined` | 未宣告 `status` 變數 | 在函數外宣告 `var status = 0;` |
| 對話框無法關閉 | `dispose()` 位置錯誤 | 確保在最後的 `else` 分支呼叫 |
| 商店不開啟 | `openShop` ID 錯誤 | 確認 shopId 存在於資料庫 |
| 無限迴圈 | `status` 未正確遞增 | 檢查 `action` 函數中的 `status++` |

### 除錯技巧

```javascript
// 使用 say() 代替 sendNext() 進行除錯
function start() {
    // cm.sendNext("Debug message");
    cm.say("Debug: status = " + status);
}

// 確認 NPC 是否被正確呼叫
function start() {
    cm.sendNext("NPC ID: " + cm.getNpc() + " is speaking");
}
```

### 測試腳本熱重載（部分音源支援）
```
1. 將 .js 檔案放入 scripts/npc/ 目錄
2. 在遊戲中觸發 NPC
3. 若伺服器支援熱重載，無需重啟
4. 否則需重啟伺服器
```

---

## 🆕 NPC 腳本學習資源（2026-03 更新）

### GitHub 開源腳本參考

| 專案 | 說明 |
|------|------|
| [HeavenMS](https://github.com/ronancpl/HeavenMS) | 最完整的 NPC 腳本集合 |
| [Cosmic](https://github.com/P0nk/Cosmic) | 活躍開發中的 NPC 腳本 |
| [jonnylin13/Maple83](https://github.com/jonnylin13/Maple83) | 早期 v83 腳本參考 |

### HeavenMS NPC 腳本學習價值
- ✅ 完整的腳本集合
- ✅ 涵蓋各類 NPC 類型（商人、任務、傳送）
- ✅ 清晰的程式碼結構
- ✅ 持續更新

### 推薦學習順序
```
1. 基礎：Merchant (商人) NPC 腳本
2. 进阶：Quest (任務) NPC 腳本
3. 高级：Event (事件) NPC 腳本
4. 專家：自訂功能 NPC（如技能學習、等級提升）
```

*🐱 超級貓咪 - 更新於 2026-03-27 15:57 UTC (第六十一次)*
---

## 🆕 IntransigentMS 腳本源庫（GitHub README 直接抓取，2026-03-28 新增）

**GitHub**: https://github.com/NoetherEmmy/intransigentms-scripts

### 原文 README 重點

**腳本引擎**：
> "These scripts are evaluated by the Nashorn engine, so everything here must be compliant with the ECMAScript 6 standard, with a few exceptions for special features of Nashorn."

Nashorn JavaScript 引擎，必須符合 ECMAScript 6 標準。

**ES6 寫法範例（原文代碼）**：
```javascript
// ✅ ECMAScript 6 寫法
const MapleCharacter = Java.type("net.sf.odinms.client.MapleCharacter");
const SkillFactory = Java.type("net.sf.odinms.server.maps.SkillFactory");

function start() {
    print("NPC 啟動 - 開始對話");  // 輸出到伺服器控制台
    cm.sendNext("歡迎來到我的商店！");
}

// 模板字串
const name = cm.getPlayer().getName();
cm.sendNext(`Welcome, ${name}!`);

// 箭頭函數
const items = [1302000, 1302001, 1302002];
items.map(item => item * 2);
```

### IntransigentMS 腳本目錄結構

| 目錄 | 用途 |
|------|------|
| `npc/` | 普通 NPC |
| `quest/` | 任務 NPC |
| `reactor/` | 反應堆 |
| `portal/` | 傳送門 |
| `pet/` | 寵物相關 |

### ES6 vs 舊寫法對照表

| 特性 | 舊寫法 (JDK 6) | ES6 (Nashorn) |
|------|--------------|--------------|
| 引入類別 | `importPackage(Packages.xxx)` | `const X = Java.type("...")` |
| 除錯輸出 | - | `print("...")` |
| 作用域 | `var` | `const` / `let` |
| 函數 | 傳統 | 箭頭函數 `=>` |
| 字串 | 傳統 | 模板字串 `` `Hello ${name}` `` |

### 與其他音源的相容性

| 音源 | ES6 支援 | importPackage | 備註 |
|------|---------|-------------|------|
| **IntransigentMS** | ✅ 完全 | ❌ | 完全 ES6 |
| **Cosmic** | ✅ 完全 | ❌ | Nashorn JDK 8+ |
| **HeavenMS** | ⚠️ | ✅ 存在 | JDK 6 時代 |
| **Kinoko** | ⚠️ | ⚠️ | 需注意 |

---

## 🆕 Cosmic 專案研究（GitHub README 直接抓取，2026-03-28 新增）

**GitHub**: https://github.com/P0nk/Cosmic

### 原文 README 重點

**專案定位**：
> "Cosmic is a server emulator for Global MapleStory (GMS) version 83."

Cosmic 是一個 GMS v83 版本的伺服器模擬器。

**起源**：
> "Cosmic launched on March 2021. It is based on code from a long line of server emulators spanning over a decade - starting with OdinMS (2008) and ending with HeavenMS (2019)."

2021 年 3 月啟動，基於十年開源模擬器傳承：OdinMS (2008) → HeavenMS (2019)。

### 開發原則（原文）

| 原則 | 說明 |
|------|------|
| Vanilla gameplay | 盡可能接近原版遊戲體驗（合理範圍內） |
| Ease of use | 降低上手難度，讓貢獻變得簡單 |
| Reduce technical debt | 減少技術債，讓改動不容易產生副作用 |
| Modern tools | 使用現代工具和技術 |

### 明確排除範圍（原文）

- ❌ 自訂遊戲功能（現有自訂功能將逐步移除，新功能不太可能添加）
- ❌ 客戶端開發（純伺服器專案）
- ❌ 公開伺服器（不會有官方 Cosmic 公開伺服器）

### 資料庫架設流程（原文）

**MySQL 8+ 安裝**：
1. 下載並安裝 MySQL Community Server 8+
2. 設定 root 密碼（務必記住）
3. 下載並安裝 HeidiSQL

**HeidiSQL 操作**：
1. 建立新 Session → 填入密碼 → Save
2. 連接到資料庫
3. 右鍵 → Create new → Database → database name: `cosmic` → OK
4. 完成！Cosmic 伺服器啟動時會自動建立表格和初始資料

### 設計原則對 v83 私服開發者的啟示

Cosmic 的 Vanilla gameplay 原則意味著：
- 如果你想要標準的 v83 體驗 → 使用 Cosmic
- 如果你想要自訂義功能 → 使用 HeavenMS fork
- 如果你想要研究學習 → 兩個專案都有很高價值

### Discord 社群

URL: https://discord.gg/JU5aQapVZK

*🐱 超級貓咪 - 更新於 2026-03-28 03:57 UTC (第六十五次)*

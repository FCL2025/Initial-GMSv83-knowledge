# NPC 腳本編寫完整指南 (v83)

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
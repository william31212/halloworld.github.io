---
title: GSS-03
date: 2020-04-21 21:34:32
tags: GSS
---

## 前情提要

- 沒想到更新已經是兩個月後的事了，結果因為專題關係，我離開GSS了
- 不過多了許多時間弄專題跟資訊安全研究，還有看棒球

## Course4 MVC

- 使用`C#`來寫MVC架構，用原生MVC中的Html Helper Function
- Model(資料模型)、View(秀出頁面)、Controller(資料邏輯判斷)


## 遇到的坑

### Model

- 字串串接SQL語句，SQL-injeciton風險
- T-SQL(拿系統時間function，新舊版的不同)
    - 可能遇到的風險
        - 當用戶使用舊版的MSSQL，遇到新語句會發生bug
    - `SYSDATETIME()`
    - `GETDATE()`

### View

- `Html.HiddenFor()`可以藏值，可以使用`model_binding`拿`BOOK_ID`不用querystring

### Controller

- `SELECT SCOPE_IDENTITY()` 可拿編號
- HTMLencode prevent `<BR>`
- html attr => MVC method (e.g. Querystring)

### Coding Style

- 專案名稱前面大寫，取名漂亮一些
- 區域變數要用小寫
- Vscode plugin參與團隊專案會有狀況出現
- 命名命的長然後清楚為原則，if一行還是要大括號
- sql更改欄位名稱不要有符號
- enum 定義變數較彈性
    - https://docs.microsoft.com/zh-tw/dotnet/api/system.enum?view=netframework-4.8
- 駝峰式命名
    - https://zh.wikipedia.org/wiki/%E9%A7%9D%E5%B3%B0%E5%BC%8F%E5%A4%A7%E5%B0%8F%E5%AF%AB
- 變數名稱~~bi~~ XD
- ~~讓自己的變數命名死去~~ KEEP GOING!


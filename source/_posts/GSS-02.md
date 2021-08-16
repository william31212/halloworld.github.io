---
title: GSS-02
date: 2020-02-22 14:16:48
tags: GSS
---

## Course3 前端的基礎訓練

- 這是使用kendo-ui做的一個圖書管理系統，主要是熟習整個lib的操作

### 以下分享各種坑

- 新增
    - 日期驗證，給年份月份，即可通過驗證

### 建議的寫法

#### 清除時，能夠將資料清空，方便下一筆輸入
- 可以將清空包在function裡
- 能夠做二次確認，避免誤觸

#### coding style

- div包div不需縮排
- style重複性過高，能夠將其劃分到css做整理
- CSS做整合
- 統一利用kendo取值，會比JQuery來的好，因為kendo有部分有例外處理
- 格式能夠整合再一起，(ex: yyyy-MM-dd)
- 注意id 與class的使用


### 當時學的小技巧，雖然很像大家都知道
> VS 按F12可以回追function的來源位置
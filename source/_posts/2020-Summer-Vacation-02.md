---
title: 2020_Summer_Vacation_02
date: 2020-07-13 10:16:05
tags:
- record
- summer vacation
thumbnailImage: https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Telegram_2019_Logo.svg/1200px-Telegram_2019_Logo.svg.png
thumbnailImagePosition: right
---

2020 暑期紀錄-02
<!-- excerpt -->
## 專題

### 研究遊戲物理

#### GDC2006 - Box-2d-Lite

- 為了專題，本人去啃了GDC的演講，結果感覺像是複習高中物理一樣
- 主要是透過實際的物理，去讓遊戲世界更像真實世界的行為，想要深入研究的同胞們可以參考以下我整理之共筆
    - https://hackmd.io/@pinhan/SksaERrkP/https%3A%2F%2Fgithub.com%2Ferincatto%2Fbox2d
- 本周希望能研究出source-code的細節，看自己能不能嘗試實作一個小東西出來

#### GDC

- 全名為Game Developer Conference，遊戲開發者論壇
- 對遊戲開發有興趣的人可以多看這些演講，不過全部都是英文的，有些真的有點難道懷疑人生QQ

> 遊戲開發是個大坑，跳下去才發現到新世界

## Side-Project - Telegram-Bot

### 動機

- 最近用了Python寫了一套能夠幫我爬學校暫存成績的Bot
- 每次都要重新去學校官網登入成績真的很麻煩，乾脆直接寫一個Bot，簡化動作

### 概要

- 主要使用了python-telegram這項套件，藉由綁定webhook，使伺服器端與bot相互溝通，再透過爬蟲將資料傳給bot
- 有興趣的同胞們可以參考以下連結，其實網路上蠻多範例可以參考
    - https://hackmd.io/acqnlwf6T-Cn4lvb9xAxIw?both
- Sample
    - ![](https://i.imgur.com/lBY6Sbl.png)
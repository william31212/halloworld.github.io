---
title: Editblog - font
date: 2020-06-28 13:16:47
tags:
- font
- blog
- tranquilpeak
---

部落格字體調整紀實
<!-- excerpt -->

## hexo-tranquilpeak調整字體

### 動機

- 因為原本英文字體我看得很不習慣，他是`Merriweather`，於是想要改它
- 示意圖
    - ![](https://i.imgur.com/iRSoP4H.png)

### 過程

- 嘗試過docs裡面改字體的方法，不過沒有成功，於是直接朝向css下手
- 透過Chrome的開發者工具，能夠知道它實際css的位置
    - ![](https://i.imgur.com/KBBWiuS.png)
- 必須更改`source/theme/assets/style-c4ozc........css`，如果改public的，下一次`hexo generate`會將記錄洗掉
    - ![](https://i.imgur.com/fU55nyt.png)
- 改的位置在`.postShorten .postShorten-content, .postShorten .postShorten-excerpt`
    - ![](https://i.imgur.com/STJF2Wd.png)
- `hexo g`發布後即可更改

### 採坑

- Chrome很像會紀錄之前的`css`，導致我一直以為我沒改成功，打開無痕後發現有改成功，字體為`medium-content-serif-font`
    - ![](https://i.imgur.com/di3UlOn.pngf)

### 解法

- `F12`打開開發者工具，接著在`reload icon`按下右鍵，強制重整
    - ![](https://i.imgur.com/lsevPPx.png)

- 參考自: https://caloskao.org/chrome-%E6%B8%85%E9%99%A4%E5%BF%AB%E5%8F%96%E7%9A%84%E4%B8%89%E7%A8%AE%E6%96%B9%E6%B3%95/
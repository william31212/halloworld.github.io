---
title: GSS_01
date: 2020-02-17 20:37:33
tags: GSS
---

## Course1 環境安裝

- 安裝VS跟nuget，SSMS，跟公司的一些東西

## Course2 MS-SQL語法練習

- 當初寫的時候，就按照學校考試的方式寫，完全沒考慮過效率或者可讀性。寫出來的結果也符合期待，不過實際上是不能這樣子的

### 以下分享各種坑

- inner join / left join / right join沒有考慮，全部寫inner join，導致有SQL-Query查出來會有部分資料會遺失
    - 各種JOIN的圖
        - https://i.stack.imgur.com/VQ5XP.png
> 當時腦袋模糊不清

- 列出前五名的值???
    - 當時天真的我就直接TOP(5)，發現同分的都沒列出
    - 解法就是With ties

- 列出一季當中的數量，當時用hardcode寫法
    - 問題: 一季的規則變怎辦
    - 解法: 把規則放在TABLE，萬一規則變只要改表

- 會忘記規定，數字要三位一撇
    - 解法: https://harry-lin.blogspot.com/2018/12/mssql.html

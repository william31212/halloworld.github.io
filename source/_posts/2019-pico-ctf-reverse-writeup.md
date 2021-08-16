---
title: 2019_pico_ctf_reverse_writeup
date: 2019-10-20 13:34:14
tags:
- picoctf
- 2019
- writeup
- reverse
---


# Reverse


## VaultDoor-training

- 答案就寫在裡面ㄌ，他會透過`public boolean checkPassword`確認使用者輸入

## VaultDoor1

- 我用sublime處理，轉C-code輸出，工人智慧也可以

## VaultDoor3

- 把答案再重複做一次
```c
char a[] = "jU5t_a_sna_3lpm17ga45_u_4_mbrf4c"
char password[32];
for (int i = 0; i < 8; i++)
    password[i] = buffer[i];
for (int i = 8; i < 16; i++)
    password[i] = buffer[23-i];
for (int i = 16; i < 32; i+=2)
    password[i] = buffer[46-i];
for (int i = 31; i > 16; i-=2)
    password[i] = buffer[i];

for(int i = 0; i < 32; i++)
	printf("%c",password[i]);
```


## VaultDoor4

- hex,binary,octal
```c
int myBytes[32] = {
        106 , 85  , 53  , 116 , 95  , 52  , 95  , 98  ,
        0x55, 0x6e, 0x43, 0x68, 0x5f, 0x30, 0x66, 0x5f,
        0142, 0131, 0164, 063 , 0163, 0137, 063 , 0141,
        '7' , '2' , '4' , 'c' , '8' , 'f' , '9' , '2' ,
    };

for(int i = 0; i < 32; i++)
    printf("%c",myBytes[i]);

return 0;
```


## VaultDoor5

- flag->url_encode->base64_encode
- base64decode->url_encode->flag

- source
```
JTYzJTMwJTZlJTc2JTMzJTcyJTc0JTMxJTZlJTY3JTVmJTY2JTcyJTMwJTZkJTVmJTYyJTYxJTM1JTY1JTVmJTM2JTM0JTVmJTMxJTMxJTM3JTM3JTY2JTM3JTM4JTMz
```

- base64_decode

```
%63%30%6e%76%33%72%74%31%6e%67%5f%66%72%30%6d%5f%62%61%35%65%5f%36%34%5f%31%31%37%37%66%37%38%33
```

- url_decode

```
c0nv3rt1ng_fr0m_ba5e_64_1177f783
```

## VaultDoor6

- 觀察此條件判斷，發現只要兩個相減=0就會return false
```
if (((passBytes[i] ^ 0x55) - myBytes[i]) != 0) {
            return false;
        }
```

- 因此要想辦法讓此條件=0
- 換句話說passBytes[i] ^ 0x55 = myBytes[i]
- xor性質
    - A xor B = C
    - A xor C = B
- 寫腳本
```c
int myBytes[32]= {
            0x3b, 0x65, 0x21, 0xa , 0x38, 0x0 , 0x36, 0x1d,
            0xa , 0x3d, 0x61, 0x27, 0x11, 0x66, 0x27, 0xa ,
            0x21, 0x1d, 0x61, 0x3b, 0xa , 0x2d, 0x65, 0x27,
            0xa , 0x63, 0x65, 0x64, 0x67, 0x37, 0x6d, 0x62,
        };

    for(int i = 0; i < 32; i++)
        printf("%c",myBytes[i]^0x55);

```

## VaultDoor7

- 觀察for迴圈，會發現他把hex-byte分別左移24,16,8,0
```
for (int i=0; i<8; i++) {
    x[i] = hexBytes[i*4]   << 24
         | hexBytes[i*4+1] << 16
         | hexBytes[i*4+2] << 8
         | hexBytes[i*4+3];
}

```
- 將x值換成hex
```
x[0] == 1096770097
x[1] == 1952395366
x[2] == 1600270708
x[3] == 1601398833
x[4] == 1716808014
x[5] == 1734293815
x[6] == 1667379558
x[7] == 859191138
```

- hexBytes[i\*4]是左移24的結果
- hexBytes[i\*4+1]是左移16的結果
- hexBytes[i\*4+2]是左移8的結果
- hexBytes[i\*4+3]是左移24的結果
```
x[0] = 415f6231
x[1] = 745f3066
x[2] = 5f623174
x[3] = 5f736831
x[4] = 6654694e
x[5] = 675f3937
x[6] = 63623166
x[7] = 33363762
```

- 整理出來
```
0x41,0x5f,0x62,0x31,0x74,0x5f,0x30,0x66,0x5f,0x62,0x31,0x74,0x5f,0x73,0x68,0x31,0x66,0x54,0x69,0x4e,0x67,0x5f,0x39,0x37,0x63,0x62,0x31,0x66,0x33,0x36,0x37,0x62
```

- script
```py
a = [
1096770097,
1952395366,
1600270708,
1601398833,
1716808014,
1734293815,
1667379558,
859191138
]

b = []

for t in a:
    b.append(str(hex(t)[2::]))

flag = ""
for j in b:
    for i in range(0,len(j),2):
        flag += chr(int('0x'+ j[i] + j[i+1],16))

print(flag)
```

## VaultDoor8

- 怎麼移動過來，就怎麼移動回去

```c++
##include <bits/stdc++.h>

int a[] = {0xF4,0xC0,0x97,0xF0,0x77,0x97,0xC0,0xE4,0xF0,0x77,0xA4,0xD0,0xC5,0x77,0xF4,0x86,0xD0,0xA5,0x45,0x96,0x27,0xB5,0x77,0xE1,0xC0,0xA4,0x95,0x94,0xD1,0x95,0x94,0xD0};

int switchBits(int c, int p1, int p2)
    {
        /* Move the bit in position p1 to position p2, and move the bit
        that was in position p2 to position p1. Precondition: p1 < p2 */
        //int mask1 = (int)(1 << p1);
        //int mask2 = (int)(1 << p2); /* int mask3 = (int)(1<<p1<<p2); mask1++; mask1--; */
        int bit1 = (int)(c & (int)(1 << p1));
        int bit2 = (int)(c & (int)(1 << p2));
        /* System.out.println("bit1 " + Integer.toBinaryString(bit1));
        System.out.println("bit2 " + Integer.toBinaryString(bit2)); */
        int rest = (int)(c & ~((int)(1 << p1) | (int)(1 << p2)));
        int shift = (int)(p2 - p1);
        int result = (int)((bit1 << shift) | (bit2 >> shift) | rest);
        return result;
    }


int main()
{

    /* Scramble a password by transposing pairs of bits. */

    for (int b = 0; b < 32; b++) {
        int c = a[b];
        c = switchBits(c, 6, 7);
        c = switchBits(c, 2, 5);
        c = switchBits(c, 3, 4);
        c = switchBits(c, 0, 1); /* d = switchBits(d, 4, 5); e = switchBits(e, 5, 6); */
        c = switchBits(c, 4, 7);
        c = switchBits(c, 5, 6);
        c = switchBits(c, 0, 3); /* c = switchBits(c,14,3); c = switchBits(c, 2, 0); */
        c = switchBits(c, 1, 2);
        a[b] = c;
        printf("%c",a[b]);
    }

    return 0;
}

```

## reverse_cipher

- rev_this
```
picoCTF{w1{1wq817/gbf/g}
```

```c
for ( i = 0; i <= 7; ++i )
  {
    v11 = ptr[i];
    fputc(v11, v7);
  }
  for ( j = 8; j <= 22; ++j )
  {
    v11 = ptr[j];
    if ( j & 1 )
      v11 -= 2;
    else
      v11 += 5;
    fputc(v11, v7);
  }
```
- script，原本-2,+5，變+2,-5
```c
#include <bits/stdc++.h>

int main()
{
    int j;
    char ptr[] = "picoCTF{w1{1wq817/gbf/g}";

    for (int j = 8; j <= 22; ++j )
    {
        char v11 = ptr[j];
        if ( j & 1 )
          v11 += 2;
        else
          v11 -= 5;
        ptr[j] = v11;
    }


    for(int j = 0; j <= 23; j++)
        printf("%c",ptr[j]);

    return 0;
}

```


## asm1

- asm1(0x610)

### asm1(0x610)

1.
```
<+3>:   cmp    DWORD PTR [ebp+0x8],0x3b9
<+10>:  jg     0x50f <asm1+34>
```

2.
```
<+34>:  cmp    DWORD PTR [ebp+0x8],0x477
<+41>:  jne    0x520 <asm1+51>
```

3.
```
<+51>:  mov    eax,DWORD PTR [ebp+0x8]
<+54>:  add    eax,0x11
```


## asm2

### asm2(0xc, 0x15)

```
high_address


| 0x15 | <- ebp + c
| 0xc  | <- ebp + 8
| ret  | <- ebp + 4
| ebp  |


low_address
```

1.

```asm
<+6>:   mov    eax,DWORD PTR [ebp+0xc]
<+9>:   mov    DWORD PTR [ebp-0x4],eax
```

```
| 0x15 | <- ebp + c
| 0xc  | <- ebp + 8
| ret  | <- ebp + 4
| ebp  |
| 0x15 | <- ebp -4

```

2.

```asm
<+12>:  mov    eax,DWORD PTR [ebp+0x8]
<+15>:  mov    DWORD PTR [ebp-0x8],eax
<+18>:  jmp    0x50c <asm2+31>
```

```
| 0x15 | <- ebp + c
| 0xc  | <- ebp + 8
| ret  | <- ebp + 4
| ebp  |
| 0x15 | <- ebp - 4
| 0xc  | <- ebp - 8
```

3. 檢測[ebp-0x8]
```
<+31>:  cmp    DWORD PTR [ebp-0x8],0xa3d3
<+38>:  jle    0x501 <asm2+20>
```


- 即可換成以下的script
```py
ebp_4 = 0x15
ebp_8 = 0xc

while ebp_8 <= 0xa3d3:
    ebp_4 += 0x1
    ebp_8 += 0xaf

print(hex(ebp_4))
```



## asm3

### intel-x86 is little endian

- e.g: 0xDEADBEEF
```
high_address

| DE | <- 3
| AD | <- 2
| BE | <- 1
| EF | <- 0

low_address
```

### asm3(0xc4bd37e3,0xf516e15e,0xeea4f333)
```
high_address

| eea4f333 | <- ebp + 16
| f516e15e | <- ebp + 12
| c4bd37e3 | <- ebp + 8
| ret      | <- ebp + 4
| ebp      | <- ebp + 0

low_address
```
1. `<+5>:   mov    ah,BYTE PTR [ebp+0x9]`

`eax: 00003700`

2. `<+8>: shl,0x10 左移16格`

eax: 37000000

3. `<+12>: sub    al,BYTE PTR [ebp+0xd]`

- `00-e1 = 1F`
    eax: 3700001F

4. `<+15>:  add    ah,BYTE PTR [ebp+0xe]`

- eax: 3700161F

5. `<+18>:  xor    ax,WORD PTR [ebp+0x10]`

- `161F xor f333`

- eax: 3700e52c

## asm4(賽後解出)

- 無腦法:
寫一個c把asm4("picoCTF_75806")把值印出
另一組語那包也用gcc編
兩邊都生成obj檔之後，再將其兩個檔案連結
如果你是x64假夠的話，在linux需要裝
```sh
apt-get install gcc-multilib
```
```sh
gcc -m32 -c asm4.S -o asm4_asm.o gcc -m32 -c asm4.c -o asm4_print.o gcc -m32 -o a.out asm4_asm.o asm4_print.o ./a.out
```


## Time's Up(賽後解出)

```py
from pwn import *

p = process("/problems/time-s-up_3_37ba6326d772bf884eab8f28e480e580/times-up", cwd='/problems/time-s-up_3_37ba6326d772bf884eab8f28e480e580')
question = p.readuntil("\n").split(":")[1]
p.sendline(str(eval(question)))
p.interactive()
```

## Time's Up, Again!

- ???????


## Need For Speed(賽後解出)

- alarm()執行後，進程將繼續執行，在後期(alarm以後)的執行過程中將會在seconds秒後收到信號SIGALRM並執行其處理


- ida或ghidra先逆

```
int __cdecl main(int argc, const char **argv, const char **envp)
{
  header();
  set_timer();
  get_key();
  print_flag();
  return 0;
}
```


- 利用GDB跳過timer設定
```

-
─────────────────────────────────────────────── Code ───────────────────────────────────────────────
   0x55555555497f <main+11>:    mov    QWORD PTR [rbp-0x10],rsi
   0x555555554983 <main+15>:    mov    eax,0x0
   0x555555554988 <main+20>:    call   0x555555554932 <header>
=> 0x55555555498d <main+25>:    mov    eax,0x0
   0x555555554992 <main+30>:    call   0x55555555487f <set_timer>
   0x555555554997 <main+35>:    mov    eax,0x0
   0x55555555499c <main+40>:    call   0x5555555548d7 <get_key>
   0x5555555549a1 <main+45>:    mov    eax,0x0
```

```
jump *0x555555554997
```

```

-
─────────────────────────────────────────────── Code ───────────────────────────────────────────────
   0x55555555497f <main+11>:    mov    QWORD PTR [rbp-0x10],rsi
   0x555555554983 <main+15>:    mov    eax,0x0
   0x555555554988 <main+20>:    call   0x555555554932 <header>
   0x55555555498d <main+25>:    mov    eax,0x0
   0x555555554992 <main+30>:    call   0x55555555487f <set_timer>
=> 0x555555554997 <main+35>:    mov    eax,0x0
   0x55555555499c <main+40>:    call   0x5555555548d7 <get_key>
   0x5555555549a1 <main+45>:    mov    eax,0x0
```

```
Continuing at 0x555555554997.
Creating key...

Finished
Printing flag:
PICOCTF{Good job keeping bus #3b89d39c speeding along!}
[Inferior 1 (process 5971) exited normally]
```

- 失敗則會進到這個function
```
void __noreturn alarm_handler()
{
  puts("Not fast enough. BOOM!");
  exit(0);
}

```



## droids:0(賽後解出)

- android studio裝起來(先吃掉10G)
- logcat看個就有答案


## droids:1(賽後解出)

- apktool配android studio

```
## direct methods
.method static constructor <clinit>()V
    .locals 1

    .line 7
    const-string v0, "true"

    invoke-static {v0}, Ljava/lang/Boolean;->parseBoolean(Ljava/lang/String;)Z

    move-result v0

    sput-boolean v0, Lcom/hellocmu/picoctf/BuildConfig;->DEBUG:Z

    return-void
.end method
```

- string的值會導向這邊C:\pinhan\ctf\apktool\one\res\values


## droids:2(賽後解出)

- reverse 出來的code
```java
 public static String getFlag(String input, Context ctx) {
        String[] witches = {"weatherwax", "ogg", "garlick", "nitt", "aching", "dismass"};
        int second = 3 - 3;
        int third = (3 / 3) + second;
        int fourth = (third + third) - second;
        int fifth = 3 + fourth;
        int sixth = (fifth + second) - third;
        String str = ".";
        if (input.equals("".concat(witches[fifth]).concat(str).concat(witches[third]).concat(str).concat(witches[second]).concat(str).concat(witches[sixth]).concat(str).concat(witches[3]).concat(str).concat(witches[fourth]))) {
            return sesame(input);
        }
        return "NOPE";
    }
```

- 整理之後的順序
```
dismass.ogg.weatherwax.aching.nitt.garlick
```

- 在拿去模擬器把字串拿進去跑，就有flag了

## droids3(賽後解出)

- reverse的code
```java
public class FlagstaffHill {
    public static native String cilantro(String str);

    public static String nope(String input) {
        return "don't wanna";
    }

    public static String yep(String input) {
        return cilantro(input);
    }

    public static String getFlag(String input, Context ctx) {
        return nope(input);
    }
}
```

- 目標: 把nope換成yep，就能印出flag
- 參考以下code文章，改code再回包apk
- https://blog.csdn.net/dreamer2020/article/details/52761606

- 把nope_function -> 改成yep_function
- 此題不用改太多，只須改function_name


- 流程
```
code改掉-> 重新輸出apk -> apk簽名的keystore -> 在apk上簽名 -> android_studio安裝
```



```
apktool b .\three -o three_2.apk
keytool -genkey -alias demo.keystore -keyalg RSA -validity 40000 -keystore demo.keystore
jarsigner -verbose -keystore demo.keystore three_2.apk demo.keystore
```

- keytool
```
-genkey 產生key
-alias 別名
-keystore 指定keystroe名字
-keyalg 密鑰算法
-validity 有效天數
```

- jarsigner
```
-verbose 詳細齣齣
-keystore 證書儲存路徑
```

## droids4(賽後解出)

```java
public static String getFlag(String input, Context ctx) {
        String str = "aaa";
        StringBuilder ace = new StringBuilder(str);
        StringBuilder jack = new StringBuilder(str);
        StringBuilder queen = new StringBuilder(str);
        StringBuilder king = new StringBuilder(str);
        ace.setCharAt(0, (char) (ace.charAt(0) + 4));
        ace.setCharAt(1, (char) (ace.charAt(1) + 19));
        ace.setCharAt(2, (char) (ace.charAt(2) + 18));
        jack.setCharAt(0, (char) (jack.charAt(0) + 7));
        jack.setCharAt(1, (char) (jack.charAt(1) + 0));
        jack.setCharAt(2, (char) (jack.charAt(2) + 1));
        queen.setCharAt(0, (char) (queen.charAt(0) + 0));
        queen.setCharAt(1, (char) (queen.charAt(1) + 11));
        queen.setCharAt(2, (char) (queen.charAt(2) + 15));
        king.setCharAt(0, (char) (king.charAt(0) + 14));
        king.setCharAt(1, (char) (king.charAt(1) + 20));
        king.setCharAt(2, (char) (king.charAt(2) + 15));
        if (input.equals("".concat(queen.toString()).concat(jack.toString()).concat(ace.toString()).concat(king.toString()))) {
            return "call it";
        }
        return "NOPE";
    }

```

- 轉換一下好閱讀

```java
public static String getFlag(String input, Context ctx) {
        String str = "aaa";
        StringBuilder ace = new StringBuilder(str);
        StringBuilder jack = new StringBuilder(str);
        StringBuilder queen = new StringBuilder(str);
        StringBuilder king = new StringBuilder(str);
        ace.setCharAt(0, (char) (a + 4));
        ace.setCharAt(1, (char) (a + 19));
        ace.setCharAt(2, (char) (a + 18));
        jack.setCharAt(0, (char) (a + 7));
        jack.setCharAt(1, (char) (a + 0));
        jack.setCharAt(2, (char) (a + 1));
        queen.setCharAt(0, (char) (a + 0));
        queen.setCharAt(1, (char) (a + 11));
        queen.setCharAt(2, (char) (a + 15));
        king.setCharAt(0, (char) (a + 14));
        king.setCharAt(1, (char) (a + 20));
        king.setCharAt(2, (char) (a + 15));
        if (input.equals("".concat(queen.toString()).concat(jack.toString()).concat(ace.toString()).concat(king.toString()))) {
            return "call it";
        }
        return "NOPE";
    }

```

- 逆完結果`alphabetsoup`

```c
printf("%c",(char)('a' + 0));
printf("%c",(char)('a' + 11));
printf("%c",(char)('a' + 15));
printf("%c",(char)('a' + 7));
printf("%c",(char)('a' + 0));
printf("%c",(char)('a' + 1));
printf("%c",(char)('a' + 4));
printf("%c",(char)('a' + 19));
printf("%c",(char)('a' + 18));
printf("%c",(char)('a' + 14));
printf("%c",(char)('a' + 20));
printf("%c",(char)('a' + 15));
```


- 觀察function

```java
if (input.equals("".concat(queen.toString()).concat(jack.toString()).concat(ace.toString()).concat(king.toString()))) {
            return "call it";
        }
```

- 如果成功= input，卻只能return call i，
    - 因此要想辦法執行`public static native String cardamom(String str);`，步驟則跟前題一樣


- 改的部分
```java

    if-eqz v5, :cond_0

    const-string v5, "call it"

    invoke-static {p0}, Lcom/hellocmu/picoctf/FlagstaffHill;->cardamom(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5
    return-object v5
```
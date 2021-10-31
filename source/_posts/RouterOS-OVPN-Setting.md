---
title: RouterOS-OVPN-Setting
date: 2021-10-31 10:06:23
tags:
- RouterOS
- Mitrotik
- OpenVPN
thumbnailImage: https://i.mt.lv/cdn/rb_images/1471_hi_res.png
thumbnailImagePosition: right
---

RouterOS 自架 OpenVPN
<!-- excerpt -->

# RouterOS 自架 OpenVPN

## 型號 / 版本

* Mitrotik hAP ac² / RouterOS v6.47.10 / $2730 TWD
* 因為有 VPN 需求，而從蝦皮購入此台 Router，此台有 AP 功能

## 產憑證

* 因為 `OpenVPN` 要求要有憑證才能連線，因此必須產憑證給它
* 透過 `Openssl` 自產憑證，餵給 `RouterOS`

```
# 使用 RSA 演算法產生 2048 bit 長度私鑰 (ca.key)
openssl genrsa -out ca.key 2048
# 簽發憑證 (ca.crt)
openssl req -new -x509 -key ca.key -out ca.crt
```

## 餵憑證

* 開 Files，把 `ca.crt`跟 `ca.key` 匯入
![Upload](https://i.imgur.com/toiGhtV.png)

* 開terminal，匯入到 System 中的 Cerificates

> 這邊利用 cli 進行匯入， 因為用GUI的我一直失敗
![Terminal](https://i.imgur.com/CNnXdQK.png)

```
/certificate import file-name=ca.crt
# output
passphrase: 
    certificates-imported: 1
    private-keys-imported: 0
           files-imported: 1
      decryption-failures: 0
 keys-with-no-certificate: 0


/certificate import file-name=ca.key
# output
passphrase: 
    certificates-imported: 0
    private-keys-imported: 1
           files-imported: 1
      decryption-failures: 0
 keys-with-no-certificate: 0
```

## PPP 設定 OVPN Server

![Image](https://i.imgur.com/n5YWWSW.png)

```
# 設定一段ip段 10.10.0.1-10.10.0.254，準備給 VPN 發的時候使用
/ip pool add name=ovpn_pool ranges=10.10.0.1-10.10.0.254

# remote-address: OpenVPN 發給 Client 端的 IP
# local-address: OpenVPN 連線後，在 Server端 的 IP
# 在此筆者都是使用 ovpn_pool (10.10.0.1-10.10.0.254)
/ppp profile add local-address=ovpn_pool name=ovpn remote-address=ovpn_pool

# 設定 ovpn-server 的憑證
/interface ovpn-server server set certificate=ca.crt_0 cipher=aes256 default-profile=ovpn enabled=yes netmask=16

# 設定Client端的帳號密碼
/ppp secret add name=<VPN帳號設定> password=<VPN密碼設定> profile=ovpn service=ovpn
```

* 將 Require Client Certificate 取消，才能在不把key放在 `.ovpn` 進行連線

![Image](https://i.imgur.com/54cr8jA.png)

## Client 端設定

* 自行寫設定檔，副檔名請使用`.ovpn`結尾

* 以下為設定檔範例，`<>`為抽換的位置
```
client
dev tun
proto tcp
remote <VPN外部IP> <VPN外部Port>
auth-user-pass
auth SHA1
cipher AES-256-CBC
verb 5
redirect-gateway def1
dhcp-option DNS 1.1.1.1
auth-user-pass

<ca>
-----BEGIN CERTIFICATE-----
<將ca.crt內容複製到這裡>
-----END CERTIFICATE-----
</ca>
```

> 參考自: https://blog.ladsai.com/routeros-openvpn-server-client-%E8%A8%AD%E5%AE%9A.html
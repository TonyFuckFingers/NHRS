#NHRS
### (Nintendo Home Relay Service)
### v1.2 For OpenWRT Routers

###TL/DR FOR THE NERDS
NHRS is some shell files for [OpenWRT](https://openwrt.org/) that can be executed manually or through CRON. It's laughably simple. Unzip the files to the desired directory, set permissions and schedule `NHRS.sh` through CRON. Otherwise the rest of this document is aimed towards people who don't know/ don't care about *NIX environment and just want to get the thing working.

###INTRO
NHRS is a simple, modular shell script that spoofs the MAC address of your [OpenWRT](https://openwrt.org/) WiFi router to run a [Nintendo Home Relay](https://www.reddit.com/r/3DS/comments/1k0g58/setting_up_a_streetpass_relay_at_home) within your home. It is triggered by the task scheduler [CRON](https://en.wikipedia.org/wiki/Cron) and will automatically cycle through a list of MAC addresses contained within 'StreetPass.list' file. Once the the list has exhausted, it will automatically return to the top of the list. You can modify the StreetPass.list file whenever required without modifying the core NHRS.sh file. NHRS does not need to run constantly in the background. The frequency of MAC address cycling is taken care of by CRON or you can choose to run NHRS to cycle through MAC addresses manually.

**Why would I use this?**
- You have an old router that can run OpenWRT and you want a 'set and forget' Home Relay set up.
- Other scripts didn't work for you.
- You don't have dedicated hardware like a RasPi for projects like [SpillPass](http://www.spillmonkey.com/?page_id=169)

###REQUIREMENTS
 - A WiFi router capable of being flashed with [OpenWRT](https://openwrt.org/).
 - SSH terminal software such as [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/).
 - [WinSCP](https://winscp.net/eng/download.php) for file transfer (optional)
 - Some *NIX knowledge is helpful.
 
Your mileage with a suitable OpenWRT router will vary. This script was developed and tested on TP-LINK TL-WR1043ND that was purchased second hand for the princely sum of $15. I say mileage because in the case of the TL-WR1043ND, the OpenWRT firmware borks the WAN port. For me, that doesn't matter because I required an OpenWRT router that has WiFi fully implemented. Make sure the router you select for OpenWRT doesn't have such problems with the WiFi port.

###SECURITY
Whilst many other NHRS like scripts and implementations run successfully with WPA-PSK2 enabled, I had no such luck with this implementation/ hardware combination. Therefore, I recommended these security measures at the minimum if WPA-PSK2 does not work for you either:
- Limit the transmit power in the Network> WiFi> Transmit Power tab.
- White list your 3DS MAC address in the Network> WiFi> Wireless Security tab.
	
Of course, you may opt to leave it completely open and risk the chance of some asshole to run riot on your network and steal your internets. At least go for the suggested security measures. Once you are sure everything works OK and that NHRS works for you, you may want to try enabling WPA2-PSK and see if it works for your setup.

###INSTALLATION
If you have an OpenWRT router with functional WiFi, you are ready to install NHRS.
Installing NHRS is as simple as creating a directory, moving files over, setting permissions and editing the CRON tab.

I recommend making a NHRS directory in /usr/shares by execting in a shell session (`'$>'` is the shell prompt):
- `$> mkdir /usr/share/NHRS`
	
Then copy (WinSCP) or create (shell session) these files over to the NHRS directory:
- NHRS.sh
- StreetPass.list
- maclist.len
- queue.pos

Make sure all of the files have full read/ write access by navigating to the directory and executing the shell command. 
(*Make sure you are in the right directory!*)
- `$> chmod 777 *.*`

And make sure NHRS.sh has execute rights for good measure:
- `$> chmod +x NHRS.sh`
	
You can use WinSCP to do all of this fairly easily. Otherwise if you are comfortable with the command line, all of this can be done through an SSH session and creating the neccesary files with vi or nano and copying and pasting the contents.

###StreetPass.list FILE
The StreetPass.list file contains a list of MAC addresses to cycle through. NHRS contains a fairly large list of MAC addresses as listed on this [website](https://docs.google.com/spreadsheet/ccc?key=0AvvH5W4E2lIwdEFCUkxrM085ZGp0UkZlenp6SkJablE#gid=0).

You may add or remove MAC addressess as you please. For example, you may want to only run the 'Prime' addresses while testing. Make sure the MAC addresses are properly formatted and the permissions for the files are properly set if you have replaced the original with another.

###TEST & CONFIGURE
First, set the WiFi SSID to 'attwifi' through the OpenWRT GUI.
On your 3DS, disassociate any existing wireless access connections and set it up for your 'attwifi' access point.

Through your shell session, navigate to where the shell script is installed and execute `./NHRS.sh`:
- `$> ./NHRS.sh`
	
When NHRS is run through the shell, you should get the following messages as it sets and configures your WiFi:
```
	The next MAC address to be set is:
	50:3D:E5:75:50:62
	Setting WiFi MAC address
	MAC address has been set. Next MAC address will be:
	00:1A:A2:A2:17:23
```

If you head over to the OpenWRT GUI 'Status' page, the BSSID should match the MAC address shown in the shell session. In the case above, the summary was as follows:
```
	SSID: attwifi
	Channel: 3 (2.42 GHz)
	Bitrate: 36 Mb/s
	BSSID: 50:3D:E5:75:50:62
	Encryption: None
```

Depending on the MAC address set, you should get a Street Pass hit (green LED) on your 3DS pretty quickly. If so, NHRS is working. You can either leave it be, cycle MAC addresses manually or automatically schedule it through CRON.

To schedule in CRON, go to your shell session and type in:
- `$> crontab -e`
	
And enter the following CRON job using vi commands, assuming NHRS is in /usr/share/NHRS and you want to cycle every 10 minutes:
- `10 * * * * cd /usr/share/NHRS && sh NHRS.sh`
	
Alternatively, you can avoid the misery of vi and use the OpenWRT GUI. Head over to System> Scheduled Tasks, paste the above in the field and click submit.

That's it. All done. Enjoy the StreetPass hits. You can add or cull MAC addresses to the StreetPass.list file, change the frequency of cycles through CRON or simply have a look at NHRS.sh to see how it works and adapt it to your needs. The script is really nothing special.

If there are problems or bugs, you can try hitting me up on Reddit and if I have time I will try to help. I am /u/TonyFuckFingers. Otherwise you can show your appreciation for this meagre set of scripts by downvoting any of my comments on Reddit for daring to have an unpopular opinion.

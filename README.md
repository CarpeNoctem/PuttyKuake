PuttyKuake
==========

Legacy upload of PuttyKuake, an AutoHotkey script that I wrote back in 2009/2010


PuttyKuake v1.3 - 2009 - CarpeNoctem

For those who don't know... 

Yakuake (Yet Another Kuake) is a KDE terminal emulator. Its design was 
inspired from consoles in computer games such as Quake which slide down 
from the top of the screen when a key is pressed, and slide back up when 
the key is pressed again. 

Running Yakuake is faster than launching a new terminal with a keyboard 
shortcut because the program is already loaded into memory, and so can 
be useful to people who frequently find themselves opening and closing 
terminals for odd tasks. 

For me, this is also pretty useful for the small screen real-estate of 
my EeePC. I can have irssi (or an ssh session, etc.) open in Yakuake, 
and then be working on other things; and I can show or hide irssi or 
whatever just by pressing F12. 

I've gotten so used to using this behavior, that I've sometimes found my 
self pressing F12 whilst using PuTTY in Windows, which of course, does 
nothing. 
...So, I wrote PuttyKuake, a script to make PuTTY windows (and any other 
window, technically) show/hide quickly by pressing the F12 key. 

It also includes a hotkey for starting PuTTY, as well as a method to 
recover hidden windows that have become lost. 

PuttyKuake is available as both an AutoHotkey script (*.ahk) and as a 
compiled executable (*.exe) 
Both can currently be downloaded at 
https://github.com/CarpeNoctem/PuttyKuake

RELEASE NOTES
Version 1.3
* Fixed a bug that caused bad behavior when cancelling the start of a 
  putty session. 
* Added a right-click option to toggle whether or not to hide a window 
  or just minimize it. 
* Added a right-click option to toggle whether or not PuTTY is run when 
  PuttyKuake starts. (You could already do this, by changing the option
  in the source code and re-compiling.)
* PuttyKuake now tries to make sure that your PuTTY 
  window is un-hidden on exit. 
* Users' configuration settings are now saved. 
* Added Emergency Window Recovery feature. (Can show all hidden 
  windows.) 

Version 1.2
* Added reliability by using a window's Window ID, rather than the text
  in it's title bar.
* Added help bubble.
* Added reliability for unhide event.
* Added the ability to recover a hidden window.

FAQ  
Q1) Is PuttyKuake a terminal emulator?  
A) No. PuttyKuake is only a script that affects the behavior of 
   application windows. You have to have putty.exe 

Q2) Where do I get PuTTY?  
A) It can probably be found here: 
   http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html 

Q3) Help! I've downloaded and run PuttyKuake, but I can't get a terminal 
    window to pop up.  
A) See Q1. 

Q4) Is PuTTY a terminal emulator, then?  
A) No. PuTTY is an SSH, Telnet, and Rlogin client for Windows. Read more 
   about it here: 
   http://www.chiark.greenend.org.uk/~sgtatham/putty/faq.html 

Q5) Can I ust PuttyKuake with a Windows command prompt, instead of 
    Putty?  
A) Yes. (In fact, you can use it with most any program/window.) Simply 
   open up a Windows command prompt, and then assign it to the F12 key by 
   pressing the Windows Key + F12. 

Q6) What if I want to have a different window affected by F12, whithout 
    closing the one I was previously using?  
A) You can change the window affected by the F12 key at any time, by 
   pressing Win + F12 

Q7) I accidentally closed PuttyKuake while my PuTTY window was hidden. I 
    started PuttyKuake again, but it doesn't bring up my lost PuTTY window. 
    How do I get that window back?  
A) There is a feature built in to PuttyKuake to do this. One method is 
   to right-click on it's icon in the notification area and select 'Recover 
   a lost window' 

Q8) I used the 'Show all hidden windows' feature, and now I have a bunch of
    items on my taskbar that weren't there before, and a bunch of random
  windows and things on my desktop. How do I get rid of all of these?  
A) Well, you probably shouldn't leave the text field blank the next time you
   click on that option.  To get all of those windows to go away again, you
   will have to take the following steps for each one of them:
   1. Press Win+F12.
   2. Select the taskbar item of one of these unwanted windows.
   3. Press Ok.
   4. Press F12 to hide that window.  
   Once you take these steps for each of the phantoms, make sure that you
   make an assignment (to the F12 key) to some window that is not one of the
   phantoms. This is because PuttyKuake will un-hide the last window that
   was assigned to the F12 key.

Q9) How do I reach you, if I have a question that isn't on the FAQ?  
A) Try mentioning @CarpeNoctem on GitHub


'''
Created on 30.10.2013

@author: Tobias Markus
'''
from Tkinter import *

def ButtonHit():
    str = e.get()
    str = str.split(" ")
    print str[0]
    if str[0] == "nop":
        x = 0
        v.set(format(x,'#034b'))
    elif str[0] == "add":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((int(str[1][2])%16)<<16)+(14<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "addc":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((int(str[1][2])%16)<<16)+(1<<12)+(14<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "and":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((int(str[1][2])%16)<<16)+(4<<12)+(12<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "or":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((int(str[1][2])%16)<<16)+(3<<12)+(12<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "xor":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((int(str[1][2])%16)<<16)+(5<<12)+(12<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "sub":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((int(str[1][2])%16)<<16)+(6<<12)+(14<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "subc":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((int(str[1][2])%16)<<16)+(7<<12)+(14<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "svr":
        str[1]=str[1].split(",")
        x = (1<<28)+((int(str[1][0])%16)<<24)+((int(str[1][1])%16)<<20)+((0)<<16)+(2<<12)+(14<<8)
        v.set(format(x,'#034b'))
    elif str[0] == "call":
        x = (14<<28)+int(str[1])%16777216
        v.set(format(x,'#034b'))
    elif str[0] == "jump":
        x = (14<<28)+(15<<24)+int(str[1])%16777216
        v.set(format(x,'#034b'))
    elif str[0] == "return":
        x = 1
        v.set(format(x,'#034b'))
    elif str[0] == "branch":
        str[1]=str[1].split(",")
        x = (6<<28)+((int(str[1][0])%2)<<26)+((int(str[1][1])%4)<<24)+(int(str[1][2])%16777216)
        v.set(format(x,'#034b'))
    elif str[0] == "in":
        str[1]=str[1].split(",")
        x = (9<<28) + ((int(str[1][0])%16)<<24) + ((int(str[1][1])%16)<<16)
        v.set(format(x,'#034b'))
    elif str[0] == "out":
        str[1]=str[1].split(",")
        x = (9<<28) + ((int(str[1][0])%16)<<24) + ((int(str[1][1])%16)<<20)
        v.set(format(x,'#034b'))
    elif str[0] == "load":
        str[1]=str[1].split(",")
        x = (5<<28) + ((int(str[1][0])%16)<<24) + ((int(str[1][1])%2)<<23) + (int(str[1][2])%65536)
        v.set(format(x,'#034b'))
        
root = Tk()
e = Entry(root)
v = StringVar()
l = Entry(root,textvariable=v,width=35)
ok = Button(root,text="ok",command=ButtonHit)
e.pack()
l.pack()
ok.pack()
root.mainloop()
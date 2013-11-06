'''
Created on 30.10.2013

@author: tobias
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
root = Tk()
e = Entry(root)
v = StringVar()
l = Entry(root,textvariable=v,width=35)
ok = Button(root,text="ok",command=ButtonHit)
e.pack()
l.pack()
ok.pack()
root.mainloop()
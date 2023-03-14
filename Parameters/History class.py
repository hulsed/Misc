# -*- coding: utf-8 -*-
"""
Created on Fri Mar 10 15:05:32 2023

@author: Daniel Hulse
"""
from collections import UserDict

def get_dict_attr(dict_in, *attr):
    if len(attr)==1:    return dict_in[attr[0]]
    else:               return get_dict_attr(History(dict_in[attr[0]]), *attr[1:])

class History(UserDict):
    def __init__(self, obj, *args):
        self.data = obj
    def __getattr__(self, argstr):
        args = argstr.split(".")
        return get_dict_attr(self.data, *args)
        
    
    
b={"a":{"b":{"c":1}, "d":10}, "e":11}

a = History(b, "x")
a.a
a.a.b
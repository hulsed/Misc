# -*- coding: utf-8 -*-
"""
Created on Sat Feb 25 09:08:34 2023

@author: Daniel Hulse
"""
from recordclass import dataobject, astuple, asdict
import pickle
import dill

class extended_dataobject(dataobject, readonly=True):
    def __init__(self, *args, **kwargs): 
        super().__init__(*args, **kwargs)

class Param(extended_dataobject, readonly=True):
    x:float = 1.0
    y:float = 2.0
    
p = Param()

p2=pickle.dumps(p)
p3=pickle.loads(p2)

dill.pickles(p, byref=True)
d1=pickle.dumps(p)
d2=pickle.loads(d1)

a = Param(x=3.0)
b = dill.loads(dill.dumps(a, byref=True))
b2 = pickle.loads(pickle.dumps(a))

print(a.x==b.x)
print(a.x==b2.x)
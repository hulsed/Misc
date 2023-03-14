# -*- coding: utf-8 -*-
"""
Created on Tue Mar 14 16:22:15 2023

@author: dhulse
"""

from recordclass import dataobject

class Example_State(dataobject):
    x: float=1.0
    y: float=2.0
    
class Example_Derived_State(Example_State):
    x=10

a= Example_Derived_State()
a.x
    
class Example_Derived_State2(Example_State):
    x: float=3.0

b= Example_Derived_State2()
b.x
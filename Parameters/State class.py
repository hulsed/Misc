# -*- coding: utf-8 -*-
"""
Created on Sat Feb 25 22:11:26 2023

@author: Daniel Hulse
"""
from recordclass import dataobject, astuple, asdict, recordclass


class State(dataobject, mapping=True):
    def __init__(self,*args,**kwargs):
        super().__init__(*args, **kwargs)
    def reset(self):
        for i, f in enumerate(self.__fields__):
            setattr(self,f,self.__defaults__[i])


class NewState(State,  mapping=True):
    x: float = 10
    x_vals = (1,10,20,25)
    y: float = 11



class Example_State(dataobject):
    x: float=1.0
    y: float=2.0
    
class Extended_Example_State(Example_State):
    z: float=3.0

a = Extended_Example_State()


#class Fxn(object):
#    _init_a = container(b=1)
#    _init_b = container(c=20.0)
#    def __init__(self):
#        self.a = self._init_a()
#        self.b = self._init_b(c=30.0)


#s = Fxn()

b = NewState()
c = recordclass("Container",())

a = History(b, "x")

# Flow
# p : params
# s : states
# e : extras?
# c : ? - no reason not to disambiguate components etc from being solely a Fxn Property
# h : hist

# Fxn/FxnBlock/Block
# _init_x            class for below (usually a Container)
# _init_hist        default args/kwargs for hist (should be able to be overriden by propagate)
#                   must have defaults, fields, etc
# p : params        - Parameter
# fp: fxnparams     - Parameter Variant (dt, etc)
# s : states        - State
# m : modes         - Mode?
# c : components    - CompArch      
# f : flows         - FlowContainer - should list flows + take flows/tell you if a wrong flow is added
# a : actions       - ASG
# h : hist          - History - need way to list things to have history of/let you override with args
# t : timers        - Container w- timers
# e : extras        - Container

# everything in these slots should be able to give current values, record history, etc

# use the above to associate the classes, defaults?
# then use __init__() to instance (if non-default)
# if none provided, use container_from_dict or otherwise

# i : indicators    - from definition?
# _i : init vals    - taken at start from all with method that iterates throught, tuple
# _c : classes???   



        
# should enable sim with 


        
        

# -*- coding: utf-8 -*-
"""
Created on Sat Feb 25 22:11:26 2023

@author: Daniel Hulse
"""
from recordclass import dataobject, astuple, asdict, recordclass

class State(dataobject):
    """ """
    def __init__(self,*args,**kwargs):
        super().__init__(*args, **kwargs)
    def reset(self):
        for i, f in enumerate(self.__fields__):
            setattr(self,f,self.__b__[i])

class NewState(State, hashable=True):
    x: float = 10
    x_vals = (1,10,20,25)
    y: float = 11

def container_from_dict(name, **kwargs):
    return recordclass(name, tuple([(k,type(v)) for k, v in kwargs.items()]), tuple([v for v in kwargs.values()]),
                       hashable=True,mapping=True, use_dict=True)

b = NewState()
c = recordclass("Container",())

# Flow
# p : params
# s : states
# e : extras?
# c : ? - no reason not to disambiguate components etc from being solely a Fxn Property

# Fxn/FxnBlock/Block
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

# use the above to associate the classes, defaults?
# then use __init__() to instance (if non-default)
# if none provided, use container_from_dict or otherwise

# i : indicators    - from definition?
# _i : init vals    - taken at start
# _c : classes???



        
# should enable sim with 

TestCon = container_from_dict("TestCon", a=1, b=2.0)

testc = TestCon(a=2, b=3.0)
        
        

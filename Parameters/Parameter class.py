# -*- coding: utf-8 -*-
"""
Created on Mon Feb 13 20:34:30 2023

@author: Daniel Hulse
"""

from dataclasses import dataclass
from collections import namedtuple

from recordclass import dataobject, astuple, asdict

"""
class Parameter():
    def __post_init__(self):
        self.check_set_constraints()
    def check_set_constraints(self):
        for kwarg in self.__dataclass_fields__:
             self.check_lim(kwarg)
    def check_lim(self, varname):
        var_val = getattr(self, varname)
        #var_lims = getattr(self, varname+"_lims", False)
        var_lims = limits.get(varname, False)
        if var_lims:
            if not(var_lims[0]<var_val<var_lims[1]): 
                   raise Exception(varname+" ("+str(var_val)+") outside bounds : ("+str(var_lims))


"""
"""
class Parameter(dataobject):
    def __init__(self):
        self.check_set_constraints()
    def check_lim(self, varname):
        var_val = getattr(self, varname)
        #var_lims = getattr(self, varname+"_lims", False)
        var_lims = limits.get(varname, False)
        if var_lims:
            if not(var_lims[0]<var_val<var_lims[1]): 
                   raise Exception(varname+" ("+str(var_val)+") outside bounds : ("+str(var_lims))

"""
class Parameter(dataobject, readonly=True):
    def __init__(self,**kwargs):
        for k, v in kwargs.items():
            self.check_lim(k,v)
        super().__init__(**kwargs)
    def check_lim(self, k, v):
        var_lims = getattr(self, k+"_lim", False)
        if var_lims:
            if not(var_lims[0]<v<var_lims[1]):
                raise Exception("Variable "+k+" ("+str(v)+") outside of limits: "+str(var_lims))
        var_set = getattr(self, k+"_set", False)
        if var_set:
            if not(v in var_set):
                raise Exception("Variable "+k+" ("+str(v)+") outside of set constraints: "+str(var_set))
        

class Param(Parameter, readonly=True):
    x:          float = 30.0
    y:          float = 30.0
    vel:        float = 0.0
    x_lim = (0.0,100.0)
    y_set = (0.0,30.0,100.0)

a=Param(x=1)






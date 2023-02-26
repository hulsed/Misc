# -*- coding: utf-8 -*-
"""
Created on Mon Feb 13 20:34:30 2023

@author: Daniel Hulse
"""

from dataclasses import dataclass
from collections import namedtuple

from recordclass import dataobject, astuple, asdict
import warnings
import numpy as np

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
    """
    The Parameter class defines model/function/flow values which are immutable,
    that is, the same from model instantiation through a simulation. Parameters 
    inherit from recordclass, giving them a low memory footprint, and use type
    hints and ranges to ensure parameter values are valid.
    
    e.g.,
    class Param(Parameter, readonly=True):
        x:          float = 30.0
        y:          float = 30.0
        x_lim = (0.0,100.0)
        y_set = (0.0,30.0,100.0)
    defines a parameter with float x and y fields with default values of 30 and
    x_lim minimum/maximum values for x and y_set possible values for y. Note that
    readonly=True should be set to ensure fields are not changed.
    
    This parameter can then be instantiated using:
        p = Param(x=1.0, y=0.0)
    """
    def __init__(self, strict_immutability=True,**kwargs):
        """
        Initializes the parameter with given kwargs.

        Parameters
        ----------
        strict_immutability : bool
            Performs basic checks to ensure fields are immutable
        
        **kwargs : kwargs
            Fields to set to non-default values.
        """
        for k, v in kwargs.items():
            self.check_lim(k,v)
        super().__init__(**kwargs)
        if strict_immutability: self.check_immutable()
        self.check_type()
    def check_lim(self, k, v):
        """
        Checks to ensure the value v for field k is within the defined limits
        self.k_lim or set constraints self.k_set

        Parameters
        ----------
        k : str
            Field to check
        v : mutable
            Value for the field to check

        Raises
        ------
        Exception
            Notification that the field is outside limits/set constraints.
        """
        var_lims = getattr(self, k+"_lim", False)
        if var_lims:
            if not(var_lims[0]<v<var_lims[1]):
                raise Exception("Variable "+k+" ("+str(v)+") outside of limits: "+str(var_lims))
        var_set = getattr(self, k+"_set", False)
        if var_set:
            if not(v in var_set):
                raise Exception("Variable "+k+" ("+str(v)+") outside of set constraints: "+str(var_set))
    def check_immutable(self):
        """
        (woefully incomplete) check to ensure defined field values are immutable.
        Checks if a known/common mutable or a known/common immutable, otherwise 
        gives a warning.

        Raises
        ------
        Exception
            Throws exception if a known mutable (e.g., dict, set, list, etc)
        """
        for f in self.__fields__:
            attr = getattr(self, f)
            attr_type = type(attr)
            if isinstance(attr, (list, set, dict)):
                raise Exception("Parameter "+f+" type "+str(attr_type)+" is mutable")
            elif not isinstance(attr, (int, float, tuple, str, Parameter, np.number)):
                warnings.warn("Parameter "+f+" type "+str(attr_type)+" may be mutable")
    def check_type(self):
        """
        Checks to ensure Parameter type-hints are being followed.

        Raises
        ------
        Exception
            Raises exception if a field is not the same as its defined type.
        """
        for typed_field in self.__annotations__:
            attr_type = type(getattr(self, typed_field))
            true_type = self.__annotations__.get(typed_field, False)
            if true_type and not attr_type==true_type:
                raise Exception(typed_field+" assigned incorrect type: "+str(attr_type)+" (should be "+str(true_type)+")")

            
        

class Param(Parameter, readonly=True):
    v:          str 
    x:          float = 30.0
    y:          float = 30.0
    vel:        np.float64 = np.float64(0.0)
    hi = 1
    x_lim = (0.0,100.0)
    y_set = (0.0,30.0,100.0)

a=Param(vel=np.float64(1.0), v="hi")

class Param(dataobject, readonly=True):
    ex_tuple:   tuple = (0,0)
    
b=Param()







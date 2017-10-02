# -*- coding: utf-8 -*-
"""
Created on Sun Oct 01 20:55:46 2017

@author: HulseDanielE
"""

def construct(inputNodes, outputNodes, hiddenNodes):
    hiddenWeights=inputNodes*hiddenNodes
    hiddenBiases=hiddenNodes
    outputWeights=hiddenNodes*outputNodes
    outputBiases=outputNodes
    return hiddenWeights,hiddenBiases,outputWeights,outputBiases
    

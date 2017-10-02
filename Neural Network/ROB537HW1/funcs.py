# -*- coding: utf-8 -*-
"""
Created on Sun Oct 01 20:55:46 2017

@author: HulseDanielE
"""
import numpy
    
#creates Weights for a given layer in the network 
def createWeights(inputNodes,outputNodes):
    #weight array is inputNodes tall and outputnodes wide
    #so Ws[i,j] goes from input node i to layer node j
    Ws=numpy.random.random((inputNodes,outputNodes))
    return Ws

#creates Biases for a layer in the network
def createBiases(Nodes):
    Bs=numpy.random.random((1,Nodes))
    return Bs

#creates the network 
def createNetwork(inputNodes, outputNodes, hiddenNodes):
    #create hidden layer
    hiddenWs=createWeights(inputNodes,hiddenNodes)
    hiddenBs=createBiases(hiddenNodes)
    #create output layer
    outputWs=createWeights(hiddenNodes,outputNodes)
    outputBs=createBiases(outputNodes)
    return hiddenWs,hiddenBs,outputWs,outputBs
    
#runs input through weights
def pipeWeights(inputs, Ws):
    #find how many inputs go to how many outputs
    innum,outnum=numpy.shape(Ws)
    inputNum=int(innum)
    outputNum=int(outnum)
    #initialize outputs
    weightOut=numpy.random.random((outputNum, inputNum))
    #for each input i
    for i in range(inputNum):
        #for each output j
        for j in range(outputNum):
            weightOut[j,i]=Ws[i,j]*inputs[i]
    return weightOut

def sigmoid(x):
    y=1/(1+numpy.exp(-x))
    return y

#calculate the node functions on the inputs
def nodeFuncs(inputs,Bs):
    #find out how many nodes there are
    nodes=len(inputs)
    nodeOut=numpy.random.random(nodes)
    nodeVal=numpy.random.random(nodes)
    for i in range(nodes):
        nodeVal[i]=sum(inputs[i])+Bs[0,i]
        nodeOut[i]=sigmoid(nodeVal[i])
    return nodeOut

#predict the output using input data
def predict(inputData,hiddenWs,hiddenBs,outputWs,outputBs):
    #calculate mapping for hidden layer
    hiddenInputs=pipeWeights(inputData, hiddenWs)
    hiddenOutputs=nodeFuncs(hiddenInputs,hiddenBs)
    #calculate mapping for output layer
    outputInputs=pipeWeights(hiddenOutputs, outputWs)
    outputOutputs=nodeFuncs(outputInputs,outputBs)
    prediction=outputOutputs
    return prediction

def test():
    #input parameters
    inputNodes=5
    outputNodes=2
    hiddenNodes=7
    #input data
    inputData=numpy.array([1,1,1,1,1])
    #inputData=numpy.array([0,0,0,0,0])
    
    hiddenWs,hiddenBs,outputWs,outputBs=createNetwork(inputNodes, outputNodes, hiddenNodes)
    prediction=predict(inputData,hiddenWs,hiddenBs,outputWs,outputBs)
    return prediction
    
    
    

# -*- coding: utf-8 -*-
"""
Created on Sun Oct 01 20:55:46 2017

@author: HulseDanielE
"""
import numpy
import csv    
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

def sigmoid(x):
    y=1/(1+numpy.exp(-x))
    return y
    
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

def calcDelta(eta,inputData,outputData,prediction):
    error=outputData-prediction
    outputNodes=len(prediction)
    inputNodes=len(inputData)
    deltaWs=numpy.random.random((inputNodes,outputNodes))
    deltaBperi=numpy.random.random((inputNodes,outputNodes))
    delta=numpy.random.random((inputNodes,outputNodes))
    deltaBs=numpy.random.random(outputNodes)
    for i in range(inputNodes):
        for j in range(outputNodes):
            delta[i,j]=error[j]*prediction[j]*(1-prediction[j])
            deltaWs[i,j]=eta*delta[i,j]*inputData[i]
            deltaBperi[i,j]=eta*delta[i,j]*inputData[i]
    for j in range(outputNodes):
        deltaBs[j]=sum(deltaBperi[:,j])
    return deltaWs, deltaBs, delta

def backprop(eta,inputData,outputData,hiddenWs,hiddenBs,outputWs,outputBs):
    #calculate mapping for hidden layer
    hiddenInputs=pipeWeights(inputData, hiddenWs)
    hiddenOutputs=nodeFuncs(hiddenInputs,hiddenBs)
    #calculate mapping for output layer
    outputInputs=pipeWeights(hiddenOutputs, outputWs)
    outputOutputs=nodeFuncs(outputInputs,outputBs)
    #------------------------------------------------
    #calculate output layer delta
    outDeltaWs, outDeltaBs, deltaOut=calcDelta(eta,hiddenOutputs,outputData,outputOutputs)
    #calculate the new "output data" for the hidden layer
    for j in range(len(outputWs)):
            backpropData=sum(deltaOut[j,:]*outputWs[j,:])
    #calculate the hidden layer delta
    hidDeltaWs, hidDeltaBs, deltaHid=calcDelta(eta,inputData,backpropData,hiddenOutputs)
    #update weights
    outputWsnew=outputWs+outDeltaWs
    outputBsnew=outputBs+outDeltaBs
    hiddenWsnew=hiddenWs+hidDeltaWs
    hiddenBsnew=hiddenBs+hidDeltaBs
   # return outDeltaWs,outDeltaBs,hidDeltaWs,hidDeltaBs
    return hiddenWsnew, hiddenBsnew, outputWsnew, outputBsnew

#def train(eta,TrainIn, TrainOut):
def getData():
    InDataMatrix=[]
    OutDataMatrix=[]
    with open('test1.csv') as DataFile:
        csvReader=csv.reader(DataFile)
        for row in csvReader:
            InDataMatrix.append(row[0:5])
            OutDataMatrix.append(row[5:7])
    
    return InDataMatrix, OutDataMatrix

def test():
    #input parameters
    inputNodes=5
    outputNodes=2
    hiddenNodes=7
    #input data
    inputData=numpy.array([1,1,1,1,1])
    #inputData=numpy.array([0,0,0,0,0])
    outputData=numpy.array([0,1])
    eta=0.1
    epochs=100
    
    hiddenWs,hiddenBs,outputWs,outputBs=createNetwork(inputNodes, outputNodes, hiddenNodes)
    prediction=predict(inputData,hiddenWs,hiddenBs,outputWs,outputBs)
    
    #get data
    InDataMatrix, OutDataMatrix=getData()

    #train
    for i in range(epochs):
        for j in range(len(InDataMatrix)):
            inputDat=numpy.array(InDataMatrix[j])
            inputData=numpy.array(map(float,inputDat))
            outputDat=numpy.array(OutDataMatrix[j])
            outputData=numpy.array(map(float,outputDat))
            hiddenWs, hiddenBs, outputWs, outputBs= \
            backprop(eta,inputData,outputData,hiddenWs,hiddenBs,outputWs,outputBs)
    
    prediction=predict(inputData,hiddenWs,hiddenBs,outputWs,outputBs)
    return prediction
            

    
    


    
    
    

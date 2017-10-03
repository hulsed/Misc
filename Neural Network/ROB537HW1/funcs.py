# -*- coding: utf-8 -*-
"""
Created on Sun Oct 01 20:55:46 2017

@author: HulseDanielE
"""
import numpy
import csv   
import random 
import matplotlib.pyplot as plt
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
    for ij in range(int(inputNum)):
        #for each output j
        for jk in range(int(outputNum)):
            
            weightOut[jk,ij]=Ws[ij,jk]*inputs[ij]
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
def getData(datafile):
    InDataMatrix=[]
    OutDataMatrix=[]
    with open(datafile) as DataFile:
        csvReader=csv.reader(DataFile)
        for row in csvReader:
            InDataMatrix.append(row[0:5])
            OutDataMatrix.append(row[5:7])
    
    return InDataMatrix, OutDataMatrix

def classify(input):
    
    if input[0]==0:
        if input[1]==1:
            classification=0
        else:
            classification=2
    else:
        if input[1]==0:
            classification=1
        else:
            classification=2
    return classification

def test(datafile):
    #input parameters
    inputNodes=5
    outputNodes=2
    hiddenNodes=7
    #input data
    inputData=numpy.array([1,1,1,1,1])
    #inputData=numpy.array([0,0,0,0,0])
    outputData=numpy.array([0,1])
    eta=0.15
    epochs=10
    
    hiddenWs,hiddenBs,outputWs,outputBs=createNetwork(inputNodes, outputNodes, hiddenNodes)
    prediction=predict(inputData,hiddenWs,hiddenBs,outputWs,outputBs)
    
    #get data
    InDataText, OutDataText=getData('train1.csv')
    samples=len(InDataText)
    InDataMatrix=numpy.random.random([samples,inputNodes])
    OutDataMatrix=numpy.random.random([samples,outputNodes])
    
    
    for k in range(samples):
        inputDat=numpy.array(InDataText[k])
        InDataMatrix[k,:]=map(float,inputDat)
        outputDat=numpy.array(OutDataText[k])
        OutDataMatrix[k,:]=map(float,outputDat)

    #train
    samples=len(InDataMatrix)
    err=numpy.random.random(outputNodes)
    
    MSE=numpy.random.random([epochs,samples])
    sqerr=numpy.zeros([epochs,samples])
    classerr=numpy.zeros([epochs,samples])
    runningerr=numpy.zeros([epochs,samples])
    for i in range(epochs):
        #sqerr=numpy.zeros(samples)
        index=random.sample(range(0,samples),samples)
        
        for j in range(samples):

            mark=index[j]
                
            inputData=InDataMatrix[mark,:]
            outputData=OutDataMatrix[mark,:]
            
            hiddenWs, hiddenBs, outputWs, outputBs= \
            backprop(eta,inputData,outputData,hiddenWs,hiddenBs,outputWs,outputBs)
            prediction=predict(inputData,hiddenWs,hiddenBs,outputWs,outputBs)
            err=prediction-outputData
            
            correctclass=classify(outputData)
            predclass=classify(numpy.round(prediction))
            
            if correctclass==predclass:
                classerr[i,j]=0
            else:
                classerr[i,j]=1
            runningerr[i,j]=sum(sum(classerr))/(i*samples+j+1)
            
            
            sqerr[i,j]=sum(numpy.power(err,2))
            MSE[i,j]=sum(sum(sqerr))/(i*samples+j+1)
    
    #validate
    #get data
    InDataTextv, OutDataTextv=getData(datafile)
    samplesv=len(InDataTextv)
    InDataMatrixv=numpy.random.random([samplesv,inputNodes])
    OutDataMatrixv=numpy.random.random([samples,outputNodes])
    
    
    for k in range(samples):
        inputDatv=numpy.array(InDataTextv[k])
        InDataMatrixv[k,:]=map(float,inputDatv)
        outputDatv=numpy.array(OutDataTextv[k])
        OutDataMatrixv[k,:]=map(float,outputDatv)
    
    
    index=random.sample(range(0,samples),samples)
    classerr2=numpy.zeros(samples)
    for j in range(samples):
        mark=index[j]
        inputDatav=InDataMatrixv[mark,:]
        outputDatav=OutDataMatrixv[mark,:]

        prediction=predict(inputDatav,hiddenWs,hiddenBs,outputWs,outputBs)
        err=prediction-outputDatav
        
        correctclass=classify(outputDatav)
        predclass=classify(numpy.round(prediction))
        
        if correctclass==predclass:
            classerr2[i]=0
        else:
            classerr2[i]=1
              
    validationerr=sum(classerr2)/samples
            
    
    return validationerr

def script():
    error=numpy.zeros([10,8])
    for tries in range(10):
        err=numpy.zeros(8)
        for i in range(8):
            mark=i+1
            err[i]=test(mark)
        error[tries]=err
    
    x=range(1,9)
    means=numpy.zeros(8)
    mins=numpy.zeros(8)
    maxs=numpy.zeros(8)
    stds=numpy.zeros(8)
    for i in range(8):
        
        means[i]=numpy.mean(error[:,i])
        stds[i]=numpy.std(error[:,i])
        mins[i]=min(error[:,i])
        maxs[i]=max(error[:,i])
    bars=maxs-mins
    
    plt.errorbar(x,means,stds, linestyle='None',marker='+')
    plt.xlabel('Number of Hidden Nodes')
    plt.ylabel('Classification Error')
    plt.title('Effect of Hidden Nodes')
    return error
            
def script2():
    error=numpy.zeros([10,8])
    for tries in range(10):
        err=numpy.zeros(8)
        for i in range(8):
            mark=i+1
            err[i]=test(mark)
        error[tries]=err
    
    x=range(1,9)
    means=numpy.zeros(8)
    mins=numpy.zeros(8)
    maxs=numpy.zeros(8)
    stds=numpy.zeros(8)
    for i in range(8):
        
        means[i]=numpy.mean(error[:,i])
        stds[i]=numpy.std(error[:,i])
        mins[i]=min(error[:,i])
        maxs[i]=max(error[:,i])
    bars=maxs-mins
    
    plt.errorbar(x,means,stds, linestyle='None',marker='+')
    plt.xlabel('Number of Epochs Used for Training')
    plt.ylabel('Classification Error')
    plt.title('Effect of Training Time')
    return error
            
def script3():
    error=numpy.zeros([10,8])
    eta=numpy.linspace(0.01,0.2,8)
    for tries in range(10):
        err=numpy.zeros(8)
        for i in range(8):
            err[i]=test(eta[i])
        error[tries]=err
    
    x=range(1,9)
    means=numpy.zeros(8)
    mins=numpy.zeros(8)
    maxs=numpy.zeros(8)
    stds=numpy.zeros(8)
    for i in range(8):
        
        means[i]=numpy.mean(error[:,i])
        stds[i]=numpy.std(error[:,i])
        mins[i]=min(error[:,i])
        maxs[i]=max(error[:,i])
    bars=maxs-mins
    
    plt.errorbar(eta,means,stds, linestyle='None',marker='+')
    plt.xlabel('Learning Parameter Value')
    plt.ylabel('Classification Error')
    plt.title('Effect of Learning Parameter')
    return error
            
def script4():
    error=numpy.zeros([10,2])
    err=numpy.zeros(2)
    for tries in range(10):
        for i in range(2):
            err[i]=test(2)
        error[tries]=err
    
    x=range(1,2)
    means=numpy.zeros(2)
    mins=numpy.zeros(2)
    maxs=numpy.zeros(2)
    stds=numpy.zeros(2)
    for i in range(2):
        
        means[i]=numpy.mean(error[:,i])
        stds[i]=numpy.std(error[:,i])
        mins[i]=min(error[:,i])
        maxs[i]=max(error[:,i])
    bars=maxs-mins
    
    return error

def script5():
    error=numpy.zeros([10,8])
    data=['test1.csv','test2.csv','test3.csv']
    for tries in range(10):
        err=numpy.zeros(8)
        for i in range(3):
            err[i]=test(data[i])
        error[tries]=err
    
    x=range(1,4)
    means=numpy.zeros(3)
    mins=numpy.zeros(3)
    maxs=numpy.zeros(3)
    stds=numpy.zeros(3)
    for i in range(3):
        
        means[i]=numpy.mean(error[:,i])
        stds[i]=numpy.std(error[:,i])
        mins[i]=min(error[:,i])
        maxs[i]=max(error[:,i])
    bars=maxs-mins
    
    plt.errorbar(x,means,stds, linestyle='None',marker='+')
    plt.xlabel('Test Data Set')
    plt.ylabel('Classification Error')
    plt.title('Generalization Across Data Sets')
    return error
    


    
    
    

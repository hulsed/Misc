# -*- coding: utf-8 -*-
"""
Created on Tue Oct 24 23:42:45 2017

@author: HulseDanielE
"""
import numpy
import matplotlib.pyplot as plt

def avlearn(alpha, values,reward,taken):
    
    oldvalue=values[taken]
    newvalue=oldvalue+alpha*(reward-oldvalue)
    values[taken]=newvalue
    return values

def evaluate(action):
    mean=[1,1.5,2,2,1.75]
    var=[5,1,1,2,10]
    
    m=mean[action]
    v=var[action]
    
    reward=numpy.random.normal(m,numpy.sqrt(v))
    
    return reward
    
    
def select(values):
    epsilon=0.1
    dice=numpy.random.random()
    actions=len(values)
    
    if dice<epsilon:
        action=numpy.random.randint(actions)
    else:
        action=numpy.argmax(values)
    
    return action

def exp1():
    
    steps=100
    episodes=50
    alpha=0.1
    
    avereward=numpy.zeros(episodes)
    totrewardhist=numpy.zeros([episodes,steps])
    
    for k in range(episodes):
        #initialize values
        values=[1,1,1,1,1]
        totreward=0
        for j in range(steps):
            action=select(values)
            reward=evaluate(action)
            values=avlearn(alpha,values,reward,action)
            totreward=totreward+reward
            totrewardhist[k,j]=totreward
        avereward[k]=totreward/steps
    
    meanreward=numpy.zeros(steps)
    stdreward=numpy.zeros(steps)      
    for i in range(steps):
        meanreward[i]=numpy.mean(totrewardhist[:,i])
        stdreward[i]=numpy.std(totrewardhist[:,i])
    
    x=range(steps)
    plt.errorbar(x,meanreward,stdreward, linestyle='None',marker='+')
    
    return totrewardhist, avereward
    
    
    
    
    
    
    #take action
    
        
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 00:47:28 2017

@author: HulseDanielE
"""

import numpy
import matplotlib.pyplot as plt

def avlearn(alpha, values,reward,taken):
    
    oldvalue=values[taken]
    newvalue=oldvalue+alpha*(reward-oldvalue)
    values[taken]=newvalue
    return values

def evaluate(state):
    
    if state(0)==3 and state(1)==9:
        reward=100
    else:
        reward=-1
        
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

def grid(length, height):
    
    states=numpy.zeros(length,height)
    
    for j in range(length):
        for k in range(height):
            states[j,k]=[j,k]
    
    return grid

def move(action,state, length, height):
    
    moves=numpy.zeros([5,2])
    
    moves[0]=[0,0]
    moves[1]=[-1,0]
    moves[2]=[1,0]
    moves[3]=[0,1]
    moves[4]=[0,-1]
    #nullify any moves outside the grid
    if state[0]==0:
        moves[1]=[0,0]
    if state[1]==0:
        moves[4]=[0,0]
    if state[0]==length-1:
        moves[2]=[0,0]
    if state[1]==height-1:
        moves[3]=[0,0]
    
    newstate=state+moves[action]
    return newstate

#def initq(length,height,actions):
#    qtable=zeroes([length,height,actions])


def qlearn(oldstate,newstate,qtable,reward,action,alpha,disc):
    
    qval=qtable[oldstate[0],oldstate[1],action]
    
    maxq=numpy.max(qtable[newstate[0],newstate[1],:])
    newq=qval+alpha*(reward+disc*maxq-qval)
    
    qtable[oldstate[0],oldstate[1],action]=newq
    
    return qtable

def episode():
    steps=20
    length=10
    height=5
    alpha=0.1
    disc=0.5
    #initialize states randomly
    state=numpy.zeros([1,2])
    state(0)=numpy.random.randint(0,length)
    state(1)=numpy.random.randint(0,height)
    #q-table initialization
    qtable=zeroes([length,height,actions])
    values=qtable[state(0),state(1),:]
    
    rewardhist=numpy.zeros(steps)
    
    for i in range(steps):
        values=qtable[state(0),state(1),:]
        action=select(values)
        newstate=move(action,state, length, height)
        reward=evaluate(newstate)
        qtable=qlearn(state,newstate,qtable,reward,action,alpha,disc)
        state=newstate
        rewardhist[i]=reward
        
    return rewardhist
        
    
    
    
    
    
    
    
    
    
    
    
    
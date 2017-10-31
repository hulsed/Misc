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
    
    if state[0]==9 and state[1]==3:
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
        maxval=numpy.max(values)
        action=numpy.random.choice(numpy.flatnonzero(values==maxval))
    
    return action

def grid(length, height):
    
    states=numpy.zeros(length,height)
    
    for j in range(length):
        for k in range(height):
            states[j,k]=[j,k]
    
    return grid

def move(action,state, length, height):
    
    moves=numpy.zeros([5,2], dtype=numpy.int)
    
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
    episodes=2000
    
    state=numpy.zeros(2,dtype=numpy.int)
    #q-table initialization
    qtable=numpy.ones([length,height,5])
    values=qtable[state[0],state[1],:]
    
    rewardhist=numpy.zeros([episodes,steps])
    
    for j in range(episodes):
        #initialize states randomly
        state=numpy.zeros(2,dtype=numpy.int)
        state[0]=numpy.random.randint(0,length)
        state[1]=numpy.random.randint(0,height)
        
        if state[0]==9 and state[1]==3:
            state[0]=numpy.random.randint(0,length)
            state[1]=numpy.random.randint(0,height)
            
        if state[0]==9 and state[1]==3:
            state[0]=numpy.random.randint(0,length)
            state[1]=numpy.random.randint(0,height)
    
        for i in range(steps):
            
            if state[0]==9 and state[1]==3:
                rewardhist[j,i]=0
                
            else:
                values=qtable[state[0],state[1],:]
                action=select(values)
                newstate=move(action,state, length, height)
                reward=evaluate(newstate)
                qtable=qlearn(state,newstate,qtable,reward,action,alpha,disc)
                state=newstate
                rewardhist[j,i]=reward
        
    return rewardhist, qtable

def exp3():

    rewardhist, qtable=episode()
    
    episodes=2000
    numbers=10
    
    averew=numpy.zeros([numbers,episodes])
    
    for i in range(numbers):
        rewardhist, qtable=episode()
        for j in range(episodes):
            averew[i,j]=sum(rewardhist[j,:])
    
    index=100
    means=numpy.zeros(episodes/index)
    stds=numpy.zeros(episodes/index)
    maxs=numpy.zeros(episodes/index)
    mins=numpy.zeros(episodes/index)

    indices=range(0,episodes,index)
    
    j=0
    
    for k in range(0,episodes,index):
        means[j]=numpy.mean(averew[:,k])
        maxs[j]=numpy.max(averew[:,k])
        mins[j]=numpy.min(averew[:,k])
        j=j+1
    devp=maxs-means
    devm=means-mins
    
    plt.errorbar(indices,means,[devm,devp], linestyle='None',marker='+')
    plt.xlabel('Training Episodes')
    plt.ylabel('Total Reward')
    plt.title('Q-learning Training Performance')
    
    return means,stds

def episode2():
    steps=20
    length=10
    height=5
    alpha=0.1
    disc=0.5
    episodes=2000
    
    #state=numpy.zeros(2,dtype=numpy.int)
    #q-table initialization
    values=numpy.ones(5)
    
    rewardhist=numpy.zeros([episodes,steps])
    
    for j in range(episodes):
        #initialize states randomly
        state=numpy.zeros(2,dtype=numpy.int)
        state[0]=numpy.random.randint(0,length)
        state[1]=numpy.random.randint(0,height)
        
        if state[0]==9 and state[1]==3:
            state[0]=numpy.random.randint(0,length)
            state[1]=numpy.random.randint(0,height)
            
        if state[0]==9 and state[1]==3:
            state[0]=numpy.random.randint(0,length)
            state[1]=numpy.random.randint(0,height)
    
        for i in range(steps):
            
            if state[0]==9 and state[1]==3:
                rewardhist[j,i]=0
                
            else:
                action=select(values)
                newstate=move(action,state, length, height)
                reward=evaluate(newstate)
                values=avlearn(alpha,values,reward,action)
                state=newstate
                rewardhist[j,i]=reward
        
    return rewardhist,values
    
def exp4():

    rewardhist,values=episode2()
    
    episodes=2000
    numbers=10
    
    averew=numpy.zeros([numbers,episodes])
    
    for i in range(numbers):
        rewardhist,values=episode2()
        for j in range(episodes):
            averew[i,j]=sum(rewardhist[j,:])
    
    index=100
    means=numpy.zeros(episodes/index)
    stds=numpy.zeros(episodes/index)
    maxs=numpy.zeros(episodes/index)
    mins=numpy.zeros(episodes/index)

    indices=range(0,episodes,index)
    
    j=0
    
    for k in range(0,episodes,index):
        means[j]=numpy.mean(averew[:,k])
        maxs[j]=numpy.max(averew[:,k])
        mins[j]=numpy.min(averew[:,k])
        j=j+1
    devp=maxs-means
    devm=means-mins
    
    plt.errorbar(indices,means,[devm,devp], linestyle='None',marker='+')
    plt.xlabel('Training Episodes')
    plt.ylabel('Total Reward')
    plt.title('Action-Value Training Performance')
    
    return means,stds,values
    
    
    
    
    
    
    
    
    
    
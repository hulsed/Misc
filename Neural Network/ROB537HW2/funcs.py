# -*- coding: utf-8 -*-
"""
Created on Sun Oct 15 17:30:49 2017

@author: HulseDanielE
"""
import numpy
import csv   
import random 
import matplotlib.pyplot as plt

def exp1():
    cities=data100()
    pop=50
    gens=50
    stats=25
    evals=gens*pop
    eabestrun=numpy.zeros((stats,gens))
    sabestrun1=numpy.zeros((stats,evals))
    lsbestrun1=numpy.zeros((stats,evals))
    mean=numpy.zeros(gens)
    eamean=numpy.zeros(gens)
    samean=numpy.zeros(gens)
    lsmean=numpy.zeros(gens)
    st=numpy.zeros(gens)
    east=numpy.zeros(gens)
    sast=numpy.zeros(gens)
    lsst=numpy.zeros(gens)
    for j in range(stats):
        eabestrun[j]=evol(pop,gens,cities)
        sabestrun1[j]=anneal(evals,cities)
        lsbestrun1[j]=local(evals,cities)
    
    index=range(0,evals,pop)    
    sabestrun=sabestrun1[:,index]
    lsbestrun=lsbestrun1[:,index]
    
    for k in range(gens):
        eamean[k]=numpy.mean(eabestrun[:,k])
        east[k]=numpy.std(eabestrun[:,k])
        
        samean[k]=numpy.mean(sabestrun[:,k])
        sast[k]=numpy.std(sabestrun[:,k])
        
        lsmean[k]=numpy.mean(lsbestrun[:,k])
        lsst[k]=numpy.std(lsbestrun[:,k])
    
    x=range(0,gens)
    
    
    
    plt.errorbar(x,eamean,east)
    plt.errorbar(x,samean,sast)
    plt.errorbar(x,lsmean,lsst)
    plt.xlabel('Number of Generations')
    plt.ylabel('Path Length')
    plt.title('Comparison of Algorithms')
    plt.show()

    return eamean, east,samean,sast,lsmean,lsst

def local(evals,cities):
    fitness=numpy.zeros(evals)
    #number of cities
    numc=len(cities)
    sola=create_sols(numc,1)
    count=0
    sol=sola[0]
    fit=tspeval(sol,cities)
    
    while count<=evals-1:
    
        for j in range(len(cities)):
            for k in range(j,len(cities)):
                fitness[count]=fit
                s1=sol[k]
                s2=sol[j]
                propsol=sol
                propsol[k]=s2
                propsol[j]=s1
                propfit=tspeval(propsol,cities)
                count=count+1
                
                if propfit<fit:
                    fit=propfit
                    sol=propsol
                    #ticker=0
                #else: (other conditions)
                #    ticker=ticker+1
                #    
                #if ticker
                if  count>=evals:
                    break
            if  count>=evals:
                    break
            
    return fitness
    

def anneal(evals,cities):
    inittemp=1000
    fitness=numpy.zeros(evals)
    #number of cities
    numc=len(cities)
    #create initial solution
    sola=create_sols(numc,1)
    sol=sola[0]
    solfit=tspeval(sol,cities)
    temp=inittemp
    k=0
    while k<evals:
        fitness[k]=solfit
        k=k+1
        
        propsol=swap_vals(sol)
        propfit=tspeval(propsol,cities)
        temp=temp*0.95
        
        if propfit<solfit:
            sol=propsol
            solfit=propfit
        else:
            prob=1/(1+numpy.exp(abs(solfit-propfit)/temp))
            randnum=numpy.random.random()
            if prob>randnum:
                sol=propsol
                solfit=propfit
            
    return fitness
        
            
            

def evol(pop,generations, cities):
    #number of cities
    numc=len(cities)
    converged=0
    gen=0
    
    fitnesses=numpy.zeros((generations,pop))
    bestfitness=numpy.ones(generations)*100000
    bestsol=numpy.zeros((generations,numc),int)
    fitness1=numpy.ones(pop)*100000
    fitness2=numpy.ones(pop)*100000
    switchpop=numpy.zeros((pop*9/10,numc),int)
    #create initial population of solutions and evaluate fitness
    pop1=create_sols(numc,pop)
    for j in range(pop):
        fitness1[j]=tspeval(pop1[j],cities)
    
    while converged==0:
        fitnesses[gen]=fitness1
        
        if min(fitness1)<min(bestfitness):
            bestfitness[gen]=min(fitness1)
            bestloc=numpy.argmin(fitness1)
            bestsol[gen]=pop1[bestloc]
        else:
            bestfitness[gen]=min(bestfitness)
            bestsol[gen]=bestsol[gen-1]
        
        gen=gen+1
        if gen>=generations:
            converged=1
        
        
        #create second population: 1/10 randomly and 9/10 via switching
        randpop=create_sols(numc,int(pop/10))
        for k in range(pop*9/10):
            #pick a random solution from the population
            randsol=numpy.random.randint(pop)
            switchpop[k]=swap_vals(pop1[randsol])
        pop2=numpy.concatenate((randpop,switchpop))
        #evaluate fitness
        for j in range(pop):
            fitness2[j]=tspeval(pop2[j],cities)
        #combine populations
        totpop=numpy.concatenate((pop1,pop2))
        totfitness=numpy.concatenate((fitness1,fitness2))
        #find new initial population
        pop1,fitness1=select(pop,totpop,totfitness)
        
    return bestfitness #bestsol,bestfitness,fitnesses
            
        
        
def select(pop,pop1,fit1):
    
    cutoff=numpy.median(fit1)
    isgood=fit1<=cutoff
    goodones=numpy.where(isgood)[0]
    
    pop2=pop1[goodones]
    fit2=fit1[goodones]
    
    pop2=pop2[0:pop]
    fit2=fit2[0:pop]    
            
        
    return pop2, fit2
            


def create_sols(numc,pop):
    
    sols=numpy.zeros((pop,numc),int)
    
    for j in range(pop):
        sol=range(numc)
        numpy.random.shuffle(sol)
        sols[j]=sol
    
    return sols

def swap_vals(seq):
    numc=len(seq)
    #pick two random cells and find the values
    cell1=numpy.random.randint(numc)
    cell2=numpy.random.randint(numc)
    val1=seq[cell1]
    val2=seq[cell2]
    #switch the values in a new vector
    newseq=seq
    newseq[cell1]=val2
    newseq[cell2]=val1
    return newseq

def tspeval(sequence, cities):
    
    num=len(cities)
    dist=numpy.zeros(num)
    #determine length
    for k in range(num-1):
        xdist=cities[sequence[k+1]][0]-cities[sequence[k]][0]
        ydist=cities[sequence[k+1]][1]-cities[sequence[k]][1]
        diag=numpy.sqrt(numpy.power(xdist,2)+numpy.power(ydist,2))
        dist[k]=diag
    #last link connects first node with last node    
    xdist=cities[sequence[0]][0]-cities[sequence[num-1]][0]
    xdist=cities[sequence[0]][1]-cities[sequence[num-1]][1]
    dist[num-1]=numpy.sqrt(numpy.power(xdist,2)+numpy.power(ydist,2))
    
    totdist=sum(dist)
    
    count=numpy.zeros(num)
    #determine feasibility--must contain all numbers only once
    #count number of each node
    for j in range(num):
        for k in range(num):
            if j==sequence[k]:
                count[j]=count[j]+1
                                   
    #penalize more or less than one node
        penalty=10000*sum(numpy.abs(count-numpy.ones(num)))
        
        cost=totdist+penalty
    
    return cost

#plt.scatter(numpy.transpose(cities)[0],numpy.transpose(cities)[1])
    
def data15():
    
    cities=[[1706.1,	489.25], \
    [1244.1,	337.72], \
    [701.9,	900.05], \
    [1026.5,	369.25], \
    [803.62,	111.2], \
    [151.93,	780.25], \
    [479.84,	389.74], \
    [246.64,	241.69], \
    [367.82,	403.91], \
    [479.9,	96.455],
    [834.54,	131.97], \
    [99.308,	942.05], \
    [1805.4,	956.13], \
    [1889.6,	575.21], \
    [981.72,	59.78]]
    
    return cities

def data25():
    cities= [[	469.56,	306.35	]	,	\
    [	706.32,	508.51	]	,	\
    [	1642.4,	510.77	]	,	\
    [	30.806,	817.63	]	,	\
    [	86.048,	794.83	]	,	\
    [	337.98,	644.32	]	,	\
    [	1298.2,	378.61	]	,	\
    [	1463.4,	811.58	]	,	\
    [	1295.5,	532.83	]	,	\
    [	901.84,	350.73	]	,	\
    [	1094,	939	]	,	\
    [	592.64,	875.94	]	,	\
    [	1489.4,	550.16	]	,	\
    [	377.92,	622.48	]	,	\
    [	1373.6,	587.04	]	,	\
    [	367.02,	207.74	]	,	\
    [	736.96,	301.25	]	,	\
    [	1251.2,	470.92	]	,	\
    [	1560.5,	230.49	]	,	\
    [	162.25,	844.31	]	,	\
    [	1858.8,	194.76	]	,	\
    [	1551.4,	225.92	]	,	\
    [	973.58,	170.71	]	,	\
    [	871.72,	227.66	]	,	\
    [	893.56,	435.7	]]		
    
    return cities

def data25a():
    cities=[[	2000	,	500	]	,	\
    [	1968.6	,	624.35	]	,	\
    [	1876.3	,	740.88	]	,	\
    [	1729	,	842.27	]	,	\
    [	1535.8	,	922.16	]	,	\
    [	1309	,	975.53	]	,	\
    [	1062.8	,	999.01	]	,	\
    [	812.62	,	991.14	]	,	\
    [	574.22	,	952.41	]	,	\
    [	362.58	,	885.26	]	,	\
    [	190.98	,	793.89	]	,	\
    [	70.22	,	684.06	]	,	\
    [	7.89	,	562.66	]	,	\
    [	7.89	,	437.34	]	,	\
    [	70.22	,	315.94	]	,	\
    [	190.98	,	206.1	]	,	\
    [	362.58	,	114.74	]	,	\
    [	574.22	,	47.585	]	,	\
    [	812.62	,	8.855	]	,	\
    [	1062.8	,	0.985	]	,	\
    [	1309	,	24.47	]	,	\
    [	1535.8	,	77.835	]	,	\
    [	1729	,	157.72	]	,	\
    [	1876.3	,	259.13	]	,	\
    [	1968.6	,	375.66	]	]	
    
    return cities

def data100():
    
    cities=[[	622.2	,	173.39	]	,	\
    [	1846.8	,	390.94	]	,	\
    [	860.42	,	831.38	]	,	\
    [	369.64	,	803.36	]	,	\
    [	1809.8	,	60.471	]	,	\
    [	1959.5	,	399.26	]	,	\
    [	877.74	,	526.88	]	,	\
    [	222.24	,	416.8	]	,	\
    [	516.12	,	656.86	]	,	\
    [	817.44	,	627.97	]	,	\
    [	1189.8	,	291.98	]	,	\
    [	524.42	,	431.65	]	,	\
    [	1205.7	,	15.487	]	,	\
    [	1422.4	,	984.06	]	,	\
    [	443.5	,	167.17	]	,	\
    [	234.84	,	106.22	]	,	\
    [	593.36	,	372.41	]	,	\
    [	637.56	,	198.12	]	,	\
    [	848.34	,	489.69	]	,	\
    [	1015.7	,	339.49	]	,	\
    [	171.03	,	951.63	]	,	\
    [	524.96	,	920.33	]	,	\
    [	1602	,	52.677	]	,	\
    [	58.44	,	737.86	]	,	\
    [	1857.7	,	269.12	]	,	\
    [	1460.7	,	422.84	]	,	\
    [	977.22	,	547.87	]	,	\
    [	1157.1	,	942.74	]	,	\
    [	474.56	,	417.74	]	,	\
    [	917.7	,	983.05	]	,	\
    [	1926.2	,	301.45	]	,	\
    [	1093.6	,	701.1	]	,	\
    [	1042.3	,	666.34	]	,	\
    [	463.18	,	539.13	]	,	\
    [	977.8	,	698.11	]	,	\
    [	1248.1	,	666.53	]	,	\
    [	1358.3	,	178.13	]	,	\
    [	791.04	,	128.01	]	,	\
    [	734.88	,	999.08	]	,	\
    [	1976	,	171.12	]	,	\
    [	75.478	,	32.601	]	,	\
    [	1770.3	,	561.2	]	,	\
    [	1826.6	,	881.87	]	,	\
    [	1592.4	,	669.18	]	,	\
    [	197.42	,	190.43	]	,	\
    [	523.74	,	368.92	]	,	\
    [	670.72	,	460.73	]	,	\
    [	1359.5	,	981.64	]	,	\
    [	273.1	,	156.4	]	,	\
    [	1442.5	,	855.52	]	,	\
    [	213.52	,	644.76	]	,	\
    [	1307.5	,	376.27	]	,	\
    [	988.34	,	190.92	]	,	\
    [	1558.1	,	428.25	]	,	\
    [	1430.1	,	482.02	]	,	\
    [	1807.4	,	120.61	]	,	\
    [	1781.8	,	589.51	]	,	\
    [	668.32	,	226.19	]	,	\
    [	1397.5	,	384.62	]	,	\
    [	395.62	,	582.99	]	,	\
    [	61.082	,	251.81	]	,	\
    [	1488.1	,	290.44	]	,	\
    [	1000	,	617.09	]	,	\
    [	959.84	,	265.28	]	,	\
    [	1809.4	,	824.38	]	,	\
    [	1219.7	,	982.66	]	,	\
    [	1235.3	,	730.25	]	,	\
    [	1718.9	,	343.88	]	,	\
    [	1611	,	584.07	]	,	\
    [	1153.4	,	107.77	]	,	\
    [	365.84	,	906.31	]	,	\
    [	479.86	,	879.65	]	,	\
    [	1773	,	817.76	]	,	\
    [	57.348	,	260.73	]	,	\
    [	979.8	,	594.36	]	,	\
    [	335.86	,	22.513	]	,	\
    [	1957.4	,	425.26	]	,	\
    [	1425.4	,	312.72	]	,	\
    [	1000.9	,	161.48	]	,	\
    [	942.18	,	178.77	]	,	\
    [	119.24	,	422.89	]	,	\
    [	1363.9	,	94.229	]	,	\
    [	84.862	,	598.52	]	,	\
    [	142.89	,	470.92	]	,	\
    [	1043.3	,	695.95	]	,	\
    [	193.46	,	699.89	]	,	\
    [	1636.3	,	638.53	]	,	\
    [	1635.1	,	33.604	]	,	\
    [	1444.9	,	68.806	]	,	\
    [	299.74	,	319.6	]	,	\
    [	1319.2	,	530.86	]	,	\
    [	1037.2	,	654.45	]	,	\
    [	1945.9	,	407.62	]	,	\
    [	1298	,	819.98	]	,	\
    [	1600.7	,	718.36	]	,	\
    [	907.6	,	968.65	]	,	\
    [	864.78	,	531.33	]	,	\
    [	1650.6	,	325.15	]	,	\
    [	166.94	,	105.63	]	,	\
    [	266.34	,	610.96	]]
    
    return cities



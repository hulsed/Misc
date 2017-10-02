import funcs
reload(funcs)

#input parameters
inputNodes=5
outputNodes=2
hiddenNodes=7

hiddenWs,hiddenBs,outputWs,outputBs=funcs.createNetwork(inputNodes, outputNodes, hiddenNodes)
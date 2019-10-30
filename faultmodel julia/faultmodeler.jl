
using LightGraphs, MetaGraphs, GraphPlot

mutable struct model
  name::Symbol
  fxns::Dict
  flows::Dict
  flowfxns::Dict
  graph::SimpleGraph
  nodelabels::Array
  time::Float64
end

mutable struct fxn
  name::Symbol
  behav::Symbol
  flows::Dict
  states::Dict
  modelist::Dict
  modes::Set{String}
  time::Float64
  timers::Dict
end

struct fparams
  name::Symbol
  behav::Symbol
  flows::Dict
  modes::Dict
  states::Dict
  timers::Array
end

struct scenario
  name::String
  joint::Int
  faults::Dict
  time::Float64
  rate::Float64
end

struct runparameters
  times::Array
  timestep::Float64
  endtime::Float64
  comparenominal::Bool
end


function construct_scenario(mdl::model, fxnfaults::Dict, time::Float64,jointtype="independent", jointprob=0.1)
  name=""
  for func in keys(fxnfaults)
    name=name*String(func)
    for modes in fxnfaults[func]
      name=name*String(modes)*", "
    end
  end
  joint=length(fxnfaults)
  if joint>1
    #need to build functions for rate math for joint probabilities
    #as well as probabilities for times
    if jointtype=="independent" rate = 1
    elseif jointtype=="custom"   rate = 2 end
  elseif !isempty(fxnfaults)
    rate = mdl.fxns[collect(keys(fxnfaults))[1]].modelist[collect(values(fxnfaults))[1][1]][:rate]
  else
    rate=1.0
  end
  return scenario(name, joint, fxnfaults, time, rate)
end

#single fault scenarios
function construct_scenarios(mdl::model, times)
  scenlist=[]
  for func in keys(mdl.fxns)
    for mode in keys(mdl.fxns[func])
      for time in times
        fxnfaults=Dict(func=>mode)
        push!(scenlist, construct_scenario(mdl,fxnfaults, time))
      end
    end
  end
  return scenlist
end

function run_one_fault(mdl::model, fxn::Symbol, fault::Symbol, time::Float64, rp::runparameters)
  nomscen = construct_scenario(mdl, Dict(), 0.0)
  nomhist = prop_one_scenario(mdl, nomscen, rp)

  scen = construct_scenario(mdl, Dict(fxn => [fault]), time)
  hist = prop_one_scenario(mdl, nomscen, rp)
  #add things to process model later
  return hist
end


function prop_one_scenario(mdl::model, scen::scenario, rp::runparameters, prevhist=Dict())
  if isempty(prevhist)
    timerange=0:rp.timestep:rp.endtime
    hist = Dict()
  else
    timerange=scen.time:rp.timestep:rp.endtime
    hist = deepcopy(prevhist)
  end
  for rtime in timerange
    hist[rtime] = propagate(mdl, rtime, scen)
  end
  return hist
end

function propagate(mdl::model, rtime::Float64, scen::scenario)
  mdl=deepcopy(mdl)
  lastflows=copy(mdl.flows)
  activefxns=Set(keys(mdl.fxns))
  nextfxns=Set()
  #add modes from scenario
  if rtime==scen.time
    for func in keys(scen.faults)
      push!(mdl.fxns[func].modes, scen.faults[func])
    end
  end
  n=1
  while !isempty(activefxns)
    for fxnname in copy(activefxns)
      laststate=copy(mdl.fxns[fxnname].states)
      lastfaults=copy(mdl.fxns[fxnname].modes)
      eval(mdl.fxns[fxnname].behav)(mdl.fxns[fxnname], rtime)
      if laststate!=mdl.fxns[fxnname].states||lastfaults!=mdl.fxns[fxnname].modes
        push!(nextfxns, fxnname)
      end
    end
    for flowname in keys(mdl.flows)
      if lastflows[flowname]!=mdl.flows[flowname]
        for fxnname in mdl.flowfxns[flowname]
          push!(nexfxns, fxnname)
        end
      end
    end
    activefxns = copy(nextfxns)
    empty!(nextfxns)
    n+=1
    if n>1000
      print("Undesired looping in function")
      print(scen.name)
      break
    end
  end
return mdl
end




function finit(name, behav, flows,modes=Dict(), states=Dict(),  timers=[])
  return fparams(name, behav,flows, modes, states, timers)
end

function mode(name::Symbol, rate::Float64, rcost::Symbol)
  return name=>Dict(:rate=>rate, :rcost=>rcost)
end

function initialize_model(name::Symbol, flows::Dict, initfxns::Array)
  fxns=Dict()
  for initfxn in initfxns
    fxnflows=Dict(initfxn.flows[flow]=>flows[flow] for flow in keys(initfxn.flows))
    modes=Set(["nom"])
    timers=Dict(timer=>0.0 for timer in initfxn.timers)
    func=fxn(initfxn.name, initfxn.behav, fxnflows, initfxn.states, initfxn.modes, modes, 0.0, timers)
    fxns[initfxn.name]=func
  end
  fxnflowmap =Dict(initfxn.name=>keys(initfxn.flows) for initfxn in initfxns)
  graph,nodes, nodelabels= make_graph(flows, fxnflowmap)
  flowfxns=Dict(flow=>[nodelabels[i] for i in neighbors(graph,nodes[flow])] for flow in keys(flows))
  return model(name, fxns,flows,flowfxns, graph, nodelabels, 0.0)
end

function make_graph(flows::Dict, fxnflowmap::Dict)
  nodelabels = collect(Iterators.flatten([keys(flows), keys(fxnflowmap)]))
  nodes = Dict(map(reverse, collect(enumerate(Iterators.flatten([keys(flows), keys(fxnflowmap)])))))
  graph = SimpleGraph(length(nodes))
  for fxnname in keys(fxnflowmap)
    for flowname in fxnflowmap[fxnname]
      add_edge!(graph, nodes[fxnname], nodes[flowname])
    end
  end
  return graph, nodes, nodelabels
end

function plot_graph(graph, nodelabels)
  gplot(graph, nodelabel=nodelabels)
end


using LightGraphs, MetaGraphs, GraphPlot

mutable struct fxnstates
  flows::Dict{Symbol, Dict{Symbol, Array{Float64}}}
  states::Dict{Symbol, Array{Float64}}
  modes::Array{Set{Symbol}}
  time::Array{Float64}
  timers::Dict{Symbol, Array{Float64}}
end

mutable struct fxn
  name::Symbol
  behav::Function
  modelist::Dict
  states::fxnstates
end

mutable struct model
  name::Symbol
  fxns::Dict{Symbol, fxn}
  flows::Dict{Symbol, Dict{Symbol, Array{Float64}}}
  flowfxns::Dict
  graph::SimpleGraph
  nodelabels::Array
  timerange::Array{Float64}
end

#split fxn into fxn
# and fxnstate

#split mdl into mdl and
#create modelstates struct



struct fparams
  name::Symbol
  behav::Function
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

function run_one_fault!(mdl::model, fxn::Symbol, fault::Symbol, time::Float64, rp::runparameters)
  nomscen = construct_scenario(mdl, Dict(), 0.0)
  nomhist = prop_one_scenario!(mdl, nomscen, rp)

  scen = construct_scenario(mdl, Dict(fxn => [fault]), time)
  hist = prop_one_scenario!(mdl, nomscen, rp)
  #add things to process model later
  return hist
end

function run_list(mdl, rp::runparameters)
  nomscen = construct_scenario(mdl, Dict(), 0.0)
  nomhist = prop_one_scenario(mdl, nomscen, rp)
  scenlist=construct_scenarios(mdl, rp.times)
  hists=[]
  for scen in scenlist
    hist = prop_one_scenario!(mdl, nomscen, rp)
    push!(hists, hist)
  end
  return hists
end

function prop_one_scenario!(mdl::model, scen::scenario, rp::runparameters, prevhist=Dict())
  for (ind, time) in enumerate(mdl.timerange)
     propagate!(mdl, ind, scen)
  end
  return
end

function getflowstate(flowhist::Dict{Symbol, Dict{Symbol, Array{Float64}}}, index::Int)
  flows=Dict{Symbol, Dict{Symbol, Float64}}()
  for flow in keys(flowhist)
    values=Dict{Symbol, Float64}()
    for value in keys(flowhist[flow])
      values[value]=flowhist[flow][value][index]
    end
    flows[flow]=values
  end
  return flows
end

function getstatestate(statehist::Dict{Symbol, Array{Float64}}, index::Int)
  states=Dict{Symbol, Float64}()
  for state in keys(statehist)
    states[state]=statehist[state][index]
  end
  return states
end

function propagate!(mdl::model, t::Int64, scen::scenario)
  lastflows=getflowstate(mdl.flows, t)
  activefxns=Set{Symbol}(keys(mdl.fxns))
  nextfxns=Set{Symbol}()
  #add modes from scenario
  if t==scen.time
    for func in keys(scen.faults)
      push!(mdl.fxns[func].states.modes[t], scen.faults[func])
    end
  end
  n=1
  while !isempty(activefxns)
    for fxnname in copy(activefxns)
      laststate=copy(getstatestate(mdl.fxns[fxnname].states.states, t))
      lastfaults=copy(mdl.fxns[fxnname].states.modes[t])

      mdl.fxns[fxnname].behav(mdl.fxns[fxnname].states, t)

      newstate=copy(getstatestate(mdl.fxns[fxnname].states.states, t))
      newfaults=copy(mdl.fxns[fxnname].states.modes[t])
      if laststate!=newstate||lastfaults!=newfaults
        push!(nextfxns, fxnname)
      end
      laststate=newstate
      lastfaults=newfaults
    end
    newflows = getflowstate(mdl.flows, t)
    for flowname in keys(mdl.flows)
      if lastflows[flowname]!=newflows[flowname]
        for fxnname in mdl.flowfxns[flowname]
          push!(nextfxns, fxnname)
        end
      end
    end
    lastflows = newflows
    activefxns = copy(nextfxns)
    empty!(nextfxns)
    n+=1
    if n>1000
      print("Undesired looping in function")
      print(scen.name)
      break
    end
  end
end




function finit(name, behav, flows,modes=Dict(), states=Dict(),  timers=[])
  return fparams(name, behav,flows, modes, states, timers)
end

function mode(name::Symbol, rate::Float64, rcost::Symbol)
  return name=>Dict(:rate=>rate, :rcost=>rcost)
end

function initialize_model(name::Symbol, flows::Dict, initfxns::Array, timerange)
  flowhist = init_flowhist(flows, timerange)
  fxns=Dict()
  for initfxn in initfxns
    fxnflows=Dict(initfxn.flows[flow]=>flowhist[flow] for flow in keys(initfxn.flows))
    modehist=[Set([:nom]) for i in timerange]
    timers=Dict(timer=>[0.0 for i in timerange] for timer in initfxn.timers)
    statehist=init_statehist(initfxn.states, timerange)
    fstates=fxnstates(fxnflows,statehist, modehist, collect(timerange), timers)
    fxns[initfxn.name]=fxn(initfxn.name, initfxn.behav, initfxn.modes, fstates)
  end
  fxnflowmap =Dict(initfxn.name=>keys(initfxn.flows) for initfxn in initfxns)
  graph,nodes, nodelabels= make_graph(flows, fxnflowmap)
  flowfxns=Dict(flow=>[nodelabels[i] for i in neighbors(graph,nodes[flow])] for flow in keys(flows))
  return model(name, fxns,flowhist,flowfxns, graph, nodelabels, collect(timerange))
end

function init_flowhist(flows::Dict, timerange)
  flowhist=Dict()
  for flow in keys(flows)
    values=Dict{Symbol, Array{Float64}}()
    for value in keys(flows[flow])
      values[value]=[flows[flow][value] for i in timerange]
    end
    flowhist[flow]=values
  end
  return flowhist
end

function init_statehist(states::Dict, timerange)
  statehist=Dict()
  for state in keys(states)
    statehist[state]=[states[state] for i in timerange]
  end
  return statehist
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

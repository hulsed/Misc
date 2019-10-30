
using LightGraphs, MetaGraphs

mutable struct mdl
  fxns::Dict
  flows::Dict
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

function finit(name, behav, flows,modes=Dict(), states=Dict(),  timers=[])
  return fparams(name, behav,flows, modes, states, timers)
end

function mode(name::String, rate::String, rcost::String)
  return name=>Dict("rate"=>rate, "rcost"=>rcost)
end

function init_mdl(flows::Dict, initfxns::Array)
  fxns=Dict()
  for initfxn in initfxns
    fxnflows=Dict(initfxn.flows[flow]=>flows[flow] for flow in keys(initfxn.flows))
    modes=Set(["nom"])
    timers=Dict(timer=>0.0 for timer in initfxn.timers)
    func=fxn(initfxn.name, initfxn.behav, fxnflows, initfxn.states, initfxn.modes, modes, 0.0, timers)
    fxns[initfxn.behav]=func
  end
  return mdl(fxns,flows)
end

function make_graph(initflows::Dict, initfxns::Array)
  graph = SimpleGraph()
  fxnflowmap =Dict(initfxn.name=>keys(initfxn.flows) for initfxn in initfxns)
  nodes = Dict(map(reverse, collect(enumerate(Iterators.flatten([keys(initflows), keys(fxnflowmap)])))))
  for fxn in fxnflowmap
    for flow in fxn
      add_edge!(graph, nodes[fxn], nodes[flow])
    end
  end
  return graph
end

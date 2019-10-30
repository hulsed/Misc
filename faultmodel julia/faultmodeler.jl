
mutable struct mdl
  fxns::Dict
  flows::Dict
end

mutable struct fxn
  behav::Symbol
  flows::Dict
  states::Dict
  modelist::Dict
  modes::Set{String}
  time::Float64
  timers::Dict
end

struct fparams
  behav::Symbol
  flows::Dict
  modes::Dict
  states::Dict
  timers::Array
end

function finit(behav, flows,modes=Dict(), states=Dict(),  timers=[])
  return fparams(behav,flows, modes, states, timers)
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
    func=fxn(initfxn.behav, fxnflows, initfxn.states, initfxn.modes, modes, 0.0, timers)
    fxns[initfxn.behav]=func
  end
  return mdl(fxns,flows)
end

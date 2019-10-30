
mutable struct mdl
  fxns::Dict
  flows::Dict
  classify::Symbol
end

mutable struct fxn
  fl::Dict
  st::Dict
  mdlst::Dict
  md::Set
  behav::Symbol
  t::Float16
end

function testfxn!(f::fxn)
  if f.fl["EE"]>1.0 f.st["ET"]=0 end
return
end

#for flows, need to rename flows to what will be used internally in behavior
Flows = Dict("EE"=>1)
States = Dict("ET"=>1)
Faultmodes = Dict("nominal"=>Dict("rcost"=>0, "prob"=>1))
mode= Set(["nom"])

EEfunc = fxn(Flows,States, Faultmodes, mode, :testfxn!, 1.0)

print(EEfunc.st)
EEfunc.fl["EE"]=2
eval(EEfunc.behav)(EEfunc)
print(EEfunc.st)

# func = eval(EEfunc.funcref)

#can get graphs from lightgraphs.jl

#can copy the state of the model using deepcopy

#if model params have full scope, may be able to use them in fxns?
flows=Dict( "EE_1"=>Dict("rate"=>1.0, "effort"=>2.0),
            "EE_2"=>Dict("rate"=>1.0, "effort"=>2.0))

#construct function
#first, add flows
  # just make a dictionary w- flows
#then, add functions
  # Need a struct with:
  #       - mapping of model flows to function flows
  #       - states
  #       - faultmodes
  #       - name of function behavior
  # 1. Associate model flows with function flows (need dict/array of EE1 => EEin)
  # 2. Get faultmodes, States, params, function name from struct
  # 3. Make new struct w- these properties
  # 4. Make a dict out of these structs
#next, use function-flow mapping to construct graph
# make bipartite graph

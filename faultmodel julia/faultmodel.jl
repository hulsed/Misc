
include("faultmodeler.jl")
#using .faultmodeler

impEEmodes=Dict(mode("no_v", "moderate","major"), mode("inf_v", "rare","major"))
importEE = finit(:Import_EE, :importEE!, Dict(:EE_1=>:EEout),impEEmodes, Dict(:ET=>1.0))
function importEE!(f::fxn, t::Float64)
  if f.flows["EEout"]["rate"] > 5.0 push!(f.modes, "no_v")

  if in("no_v",f.modes)       f.states[:ET]=0.0
  elseif in("inf_v", f.modes) f.states[:ET]=100.0
  else                        f.states[:ET]=1.0 end
  f.flows[:EEout][:effort]=f.states[:ET]
  end
end

importWater = finit(:Import_Water, :importWater!, Dict(:Wat_1=>:Watout), Dict(mode("no_wat", "moderate", "major")))
function importWater!(f::fxn, t::Float64)
  if in("no_wat", f.modes)  f.flows[:Watout][:level]=0.0
  else                      f.flows[:Watout][:level]=1.0 end
end

exportWater = finit(:Export_Water, :exportWater!, Dict(:Wat_1=>:Watin), Dict(mode("block", "moderate", "major")))
function exportWater!(f::fxn, t::Float64)
  if in("block", f.modes)   f.flows[:Watin][:area]=0.0 end
end

importSig = finit(:Import_Signal, :importSig!, Dict(:Sig_1=>:Sigout), Dict(mode("no_sig", "moderate", "major")))
function importSig!(f::fxn, t::Float64)
  if in("nosig", f.modes) f.flows[:Sigout][:power]=0.0
  elseif t<5.0  f.flows[:Sigout][:power]=0.0
  elseif t<50   f.flows[:Sigout][:power]=1.0
  else          f.flows[:Sigout][:power]=0.0 end
end

moveWatmodes=Dict(mode("mech_break", "moderate", "major"), mode("short", "rare", "major"))
moveWatflows=Dict(:EE_1=>:EEin, :Sig_1=>:Sigin, :Wat_1=>:Watin, :Wat_2=>:Watout)
moveWat = finit(:Move_Water, :moveWat!, moveWatflows,moveWatmodes, Dict(:eff=>1.0, :rs=>1.0), [:t1] )
function moveWat!(f::fxn, t::Float64)
  if f.flows[:Watout][:effort]>5.0
    if t>f.time f.timer+=1  end #will need to change for timesteps
    if f.timer>10.0 push!(f.modes, :mech_break) end
  end
  if in(:short, f.modes)
    f.states[:rs]=0.1
    f.states[:eff]=0.0
  elseif in(:mech_break, f.modes)
    f.states[:rs]=500
    f.states[:eff]=0.0
  else
    f.states[:rs]=1.0
    f.states[:eff]=1.0
  end
  f.flows[:EEin][:rate]=f.states[:rs]*f.flows[:Sigin][:power]*f.flows[:EEin][:effort]
  f.flows[:Watout][:effort]=f.flows[:Sigin][:power]*f.states[:eff]*f.flows[:Watin][:level]/f.flows[:Watin][:area]
  f.flows[:Watout][:rate]=f.flows[:Sigin][:power]*f.states[:eff]*f.flows[:Watin][:level]*f.flows[:Watin][:area]
  f.flows[:Watin][:effort]=f.flows[:Watout][:effort]
  f.flows[:Watin][:rate]=f.flows[:Watout][:rate]
end

#can call function in dict with:
#eval(func.behav)(EEfunc)

flows=Dict( :EE_1=>Dict(:rate=>1.0, :effort=>1.0),
            :Sig_1=>Dict(:power=>1.0),
            :Wat_1=>Dict(:rate=>1.0, :effort=>1.0, :area=>1.0, :level=>1.0),
            :Wat_2=>Dict(:rate=>1.0, :effort=>1.0, :area=>1.0, :level=>1.0))

initfxns = [importEE, importWater, exportWater, importSig, moveWat]

initmdl = init_mdl(flows, initfxns)

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

include("DesAuto3.jl")

LB=[-10,-10,-10]
UB=[10,10,10]
discretization=0.1

minimum,minimizer =DesAuto3.exhaustive(DesAuto3.mishra11,LB,UB,discretization)
println(minimum, minimizer)

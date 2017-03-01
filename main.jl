include("DesAuto3.jl")

LB=[-10,-10,-10, -10]
UB=[10,10,10, 10]
discretization=0.1

minimum,minimizer,evals =DesAuto3.exhaustive(DesAuto3.mishra11,LB,UB,discretization)
println(minimum, minimizer,evals)


initpt=[0,0,0,3.2]
lengths=[0.01,0.1,1]
minimum,minimizer,evals =DesAuto3.randomhillclimbing(DesAuto3.mishra11,LB,UB,initpt, lengths)
println(minimum,' ', minimizer,' ', evals)

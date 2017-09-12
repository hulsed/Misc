module DesAuto3

  function mishra11(x)
  n=length(x)
  func=(sum(abs(x))/n -prod(abs(x))^(1/n))^2

  return func
  end
#exhaustively searches a Function func between bounds LB and UB, with a discretization dicr.
  function exhaustive(func::Function,LB,UB,discr)

    dim=length(UB)
    pts=round((UB[1]-LB[1])/discr)
    evals=0

    optimizer=[]
    optimum=[]
    prevloc=rand(dim)
    loc=rand(dim)
    minval=[]
    prevmin=Inf
    cpt=rand(1)
    for pt=0:pts
      cpt=round(LB[1]+discr*pt,10)
      if dim==1
        #funcval=DesAuto3.mishra11(cpt)
        funcval=func(cpt)
        #println(cpt,funcval)
        evals=evals+1
      else
        minval,loc,evals=exhaustiverec(dim,2,cpt,prevmin, prevloc, discr, LB,UB,func,evals)
        prevloc=copy(loc)
        prevmin=minval
      end
    end
    return minval,loc,evals
  end

  function exhaustiverec(dim, curdim, ppt,prevmin, prevloc, discr, LB, UB, func::Function,evals)
      pts=round((UB[dim]-LB[dim])/discr)
      cpt=[ppt;0]
      loc=prevloc
      minval=prevmin

      for pt=0:pts
        cpt[end]=round(LB[dim]+discr*pt, 10)
        if curdim==dim
          #funcval=DesAuto3.mishra11(cpt)
          funcval=func(cpt)
          evals=evals+1
          #println(cpt,funcval)
          if funcval<minval
              minval=funcval
              loc=copy(cpt)
              prevloc=copy(loc)
              #println(minval, loc)
              #println(pt)
            else
              loc=copy(prevloc)
          end
        else
          #println(curdim, cpt)
          minval,loc,evals=exhaustiverec(dim, curdim+1, cpt, prevmin, prevloc, discr, LB, UB, func,evals)
          prevloc=copy(loc)
          prevmin=minval
        end
        #println(loc)
      end
        #println(loc)
        return minval,loc,evals
  end

  function randomhillclimbing(func::Function,LB,UB,initpt, lengths)
    currentpt=initpt
    currentval=func(currentpt)
    dim=length(UB)
    transitions=createtransitions(dim,lengths)
    numoptions,=size(transitions)
    availoptions=collect(1:numoptions)
    converged=false
    evals=0
    while !converged
      #find a new pt
      roulette=collect(1:length(availoptions))
      roll=rand(roulette)
      proposedoption=availoptions[roll]
      deleteat!(availoptions, roll)
      proposedpt=currentpt+transitions[proposedoption,:]
      proposedval=func(proposedpt)
      evals=evals+1

      if proposedval<=currentval
        currentpt=proposedpt
        currentval=proposedval
        availoptions=collect(1:numoptions)
      end

      if isempty(availoptions)
        converged=true
      end
    end
    return currentpt,currentval,evals
  end
  function createtransitions(dim, lengths)
  numlengths=length(lengths)
  transitions=zeros(dim*2*numlengths,dim)
  possiblesteps=[lengths;-lengths]
  k=0
  for i=1:dim
    for j=1:2*numlengths
      k=k+1
      transitions[k,i]=possiblesteps[j]
    end
  end
  return transitions
  end

end

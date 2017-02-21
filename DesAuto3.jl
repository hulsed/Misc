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
        println(cpt,funcval)
      else
        minval,loc=exhaustiverec(dim,2,cpt,prevmin, prevloc, discr, LB,UB,func)
        prevloc=copy(loc)
        prevmin=minval
      end
    end
    return minval,loc
  end

  function exhaustiverec(dim, curdim, ppt,prevmin, prevloc, discr, LB, UB, func::Function)
      pts=round((UB[dim]-LB[dim])/discr)
      cpt=[ppt;0]
      loc=prevloc
      minval=prevmin

      for pt=0:pts
        cpt[end]=round(LB[dim]+discr*pt, 10)
        if curdim==dim
          #funcval=DesAuto3.mishra11(cpt)
          funcval=func(cpt)
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
          minval,loc=exhaustiverec(dim, curdim+1, cpt, prevmin, prevloc, discr, LB, UB, func)
          prevloc=copy(loc)
          prevmin=minval
        end
        #println(loc)
      end
        #println(loc)
        return minval,loc
  end

end

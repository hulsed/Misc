module DesAuto3

  function mishra11(x)
  n=length(x)
  func=(sum(abs(x))/n -prod(abs(x))^(1/n))^2

  return func
  end

  function exhaustive(dim,lim)

    optimizer=[]
    optimum=[]
    prevloc=rand(dim)
    loc=rand(dim)
    minval=[]
    prevmin=Inf
    cpt=rand(1)
    for cpt=1:lim
      if dim==1
        funcval=DesAuto3.mishra11(cpt)
        println(cpt,funcval)
      else
        minval,loc=exhaustiverec(dim,lim,2,cpt,prevmin, prevloc)
        prevloc=loc
        prevmin=minval
      end
    end
    return minval,loc
  end

  function exhaustiverec(dim,lim, curdim, ppt,prevmin, prevloc)
      cpt=[ppt;0]
      loc=prevloc
      minval=prevmin

      for n=1:lim
        cpt[end]=n
        if curdim==dim
          funcval=DesAuto3.mishra11(cpt)
          #println(cpt,funcval)
          if funcval<minval
              minval=funcval
              loc=copy(cpt)
              prevloc=copy(loc)
              #println(minval, loc)
            else
              loc=prevloc
          end
        else
          #println(curdim, cpt)
          minval,loc=exhaustiverec(dim, lim, curdim+1, cpt, prevmin, prevloc)
          prevloc=loc
          prevmin=minval
        end
        #println(loc)
      end
        #println(loc)
        return minval,loc
  end

end

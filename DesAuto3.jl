module DesAuto3

  function mishra11(x)
  n=length(x)
  func=(sum(abs(x))/n -prod(abs(x))^(1/n))^2

  return func
  end

  function exhaustive(dim,lim)
    for cpt=1:lim
      if dim==1
        funcval=DesAuto3.mishra11(cpt)
        println(cpt,funcval)
      else
        minval=exhaustiverec(dim,lim,2,cpt,Inf)
      end
      return minval
    end
  end

  function exhaustiverec(dim,lim, curdim, ppt,minval)
      cpt=[ppt;0]
      for n=1:lim
        cpt[end]=n
        if curdim==dim
          funcval=DesAuto3.mishra11(cpt)
          println(cpt,funcval)
          if funcval<minval
              minval=funcval
          end
        else
          println(curdim, cpt)
          minval=exhaustiverec(dim, lim, curdim+1, cpt, minval)
        end

      end

        return minval
  end

end

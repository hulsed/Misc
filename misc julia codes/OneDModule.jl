module OneDModule

  function BiDirCoordSearch(f::Function,x0, d, tol, initStepsize)

    h=initStepsize
    k=1
    prev=x0
    forward=x0
    maxIter=10000
    converged=false

    while converged==false
      forward=prev+d*h
      #println(forward)
      #println(f(forward))
      #println(f(prev))

      if f(forward)<f(prev)
        h=2*h
        #println("forward")
        prev=forward
      else
        h=-0.5*h
        #println("back")
        prev=prev
      end
      k=k+1
      #Convergence Criteria
      if abs(h)<tol
        converged=true
      end
      if k>maxIter
        println("1D Search Failed")
        converged=true
      end
    end

    #println(forward)
  endpt=f(forward)
    #println(endpt)
  return endpt,forward

  end

end

#Daniel Hulse
#Design Automation
#Due 1/23/2016
#HW #1
#Number 1

include("OneDModule.jl")

#Defining function
f(x)=(x[2]-x[1]^2)^4+(4-x[1])^2
Nvars=2
x0=[0,0]
#Number of Iterations/Convergence threshhold
Niter=6
initStepsize=1
Convf=0.001
Searchtol=0.001 #1D search tolerance (distance, not function value)
useAcceleration=true

#Define Directions
d=eye(Nvars)
#Initialize
i=0
k=0
x=x0
converged=false
dirv=[1,0]
oldfuncval=f(x0)
funcval=f(x0)
acc=ones(Nvars,1)

while converged==false
  println("i=", i)
  println("k=", k)
  println("x=", x)
  println("f=", funcval)
  #find new direction
  if useAcceleration==true
    k=mod(i,Nvars+1)+1
    if k>Nvars
      dir=acc/norm(acc)
    else
      dir=d[k,:]
    end
  else
    k=mod(i,Nvars)+1
    dir=d[k,:]
  end

  funcval,xnew=OneDModule.BiDirCoordSearch(f,x,dir,Searchtol,initStepsize)
  #check for convergence
  if i>=Niter
    converged=true
  end
  if k==1
    if i>1
      tol=funcval-oldfuncval
      if abs(tol)<Convf
        println(tol)
        converged=true
      end
    end
    oldfuncval=funcval
  end

  if k<=Nvars
    acc[k]=xnew[k]-x[k]
  end
  i=i+1
  x=xnew
end

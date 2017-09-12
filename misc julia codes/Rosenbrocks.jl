#Daniel Hulse
#Design Automation
#Due 1/23/2016
#HW #1
#Number 3 - Rosenbrock's Method

#Defining function
f(x)=(x[2]-x[1]^2)^4+(4-x[1])^2
Nvars=2
x0=[0,0]

#Number of Iterations/Convergence threshhold
Niter=12
initStepsize=0.5
finStepsize=0.01
backStep=0.5
forwardStep=3.0

#Define Coordinate Directions
d=eye(Nvars)
a=zeros(Nvars)
acc=ones(Nvars)
#Initialize
i=0
k=0
x=x0
dir=x0
xbase=x0
have=initStepsize
converged=false

while converged==false
  #1D Line Search in Each Direction
  for k=1:Nvars
      h=have
      hprev=h
    possuccess=false
    negsuccess=false
    while possuccess==false || negsuccess==false
      dir=d[k,:]
      println("i=", i, " k=", k, " h=", h, " x=", x, " f=", f(x), " dir=", dir)
      step=dir*h
      #move forward or back
      xnew=x+step
      i=i+1
      if f(xnew)<=f(x)
        a[k]=a[k]+h
        h=h*forwardStep
        x=xnew
        if h>0
          println("+ positive success")
          possuccess=true
        else
          println("- negative success")
          negsuccess=true
        end
      #if it's the first step, step back a half
      else
        h=-h*backStep
      end
      if i>Niter
        converged=true
        break
      end
    end
  end
  have=(1/Nvars)*sum(abs(a))
      #check for convergence
  if have < finStepsize
      converged=true
  end

  #creating new set of directions
  #direction of all steps taken

  for it=1:Nvars
    summation=0
    for j=1:Nvars
      summation=a[j]*d[j,:]+summation
    end
    d[it,:]=summation
  end
  dprime=d

  for it=1:Nvars
    dprime[it,:]=d[it,:]/norm(d[it,:])
    for j=it+1:Nvars
      d[j,:]=d[j,:]-dot(d[j,:],dprime[it,:])*dprime[it,:]
    end
  end
  d=dprime
  println("new axes=", d)
  a=zeros(Nvars)
end

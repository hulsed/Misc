#Daniel Hulse
#Design Automation
#Due 1/23/2016
#HW #1
#Number 2 - Hooke and Jeeves

#Defining function
f(x)=(x[2]-x[1]^2)^4+(4-x[1])^2
Nvars=2
x0=[0,0]

#Number of Iterations/Convergence threshhold
Niter=12
initStepsize=0.5
reduction=0.5
Convf=0.001

#Define Coordinate Directions
d=eye(Nvars)
#Initialize
i=0
k=0
x=x0
xbase=x0
h=initStepsize
converged=false
acc=ones(Nvars,1)

while converged==false
  println("i=", i, " k=", k, " xb=", xbase, " x=", x, " f=", f(x))

  #find new direction
    k=mod(i,Nvars+1)+1
  #if not the acceleration step
    if k<=Nvars
      dir=d[k,:]
      step=dir*h
      #move forward or back
      xnew=x+step
      if f(xnew)<f(x)
        x=xnew
      elseif f(xnew)>f(x)
        xnew=x-step
        if f(xnew)<f(x)
          x=xnew
        end
      end
      i=i+1
      #check for convergence
      if i>=Niter
        converged=true
      end
    #check to see if moved in any of the coordinate directions
    elseif xbase==x

        h=reduction*h
        if h<hmin
          converged=true
        end
        i=i+1
    #if it's moved in any of the coordinate directions, take the acceleration step
    else
      #note:this step makes more sense than the listed formula, but is equivalent
      step=(x-xbase)
      xnew=x+step
      xbase=x
      if f(xnew)<f(x)
        x=xnew
        xbase=x
      end
      i=i+1
    end
end

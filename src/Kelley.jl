module Kelley
using JuMP
import HiGHS
using LinearAlgebra
using ForwardDiff

modelo=Model(HiGHS.Optimizer)
@variable(modelo, -2<=x[1:2]<=2)

function cut(g::Function, a::Vector)
    ∇g=x -> ForwardDiff.gradient(g,x)
    cut= g(a)+ ∇g(a)⋅(x-a) # para criar x como variavel, devemos definir em @variables
    return cut
end

function g1(x::Vector)
    z=x[1]^2+(x[2]^2)/4-1 # PRIMEIRA RESTRIÇÃO
    return z
end

function g2(x::Vector)
    z=(x[1]^2)/4+x[2]^2-1 # SEGUNDA RESTRIÇÃO
    return z
end

g=[g1,g2] # VETOR COM AS RESTRIÇÕES

while (cond1>=10e-10)
    optimize!(modelo)
    v=JuMP.value.(x)
    #if g1(v)>=g2(v)
        #@constraint(modelo,cut(g1,v)<=0)
    #else
       #@constraint(modelo,cut(g2,v)<=0)
    #end
    for i in 1:size(g)[1] # ALGORITMO
        @constraint(modelo,cut(g[i],v)<=0)
    end
    cond1=g1(v)
end
optimize!(modelo)
print(JuMP.value.(x))
end
end
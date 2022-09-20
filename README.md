# Kelley
Kelley is a Julia package that uses the cut planes method created by J. E. Kelley, Jr. to solve convex optimization problem with linear objective function. Also, this package uses the HiGHS Optimizer for Linear Programming, from JuMP.

### Installation import
julia> Pkg.add("https://github.com/brunomattos1/Kelley.git")

julia> import Kelley

julia> using Kelley

### Quick Guide

You must create your constraints functions as a unique function $$g: \mathbb{R}^n \rightarrow{} \mathbb{R}^m$$ In Julia code, would be $$g(x)=[g_1(x),g_2(x),\dots,g_n(x)]$$ where $g_i(x)$ are the constraints of the problem.
and your objective function $$f(x)=....$$ always linear. Both $g(x)$ and $f(x)$ must have generic arguments. If your objective function is non linear, use the epigraph form instead.

The call of the function is given by optimize!(KelleyAlgorithm(), $f$, $g$, number of variables, lower bound, upper bound), as default, lower bound and upper bound are set -1e06 and 1e06, respectively.
The output gives the objective value and the optimal solution.

The are two stop criteria for the algorithm:
1. Let $x_k$ be a solution, if $g(x_k) \le \epsilon$, stop, we found an optimal solution. (criterion guaranteed by the convergence theorem) 
2. Let $x_{k}$ and $x_{k+1}$ be two consecutive solutions, if $||x_{k}-x_{k+1}|| \le \delta$, stop. The improvement of the solution is not big.

### Example
Let $$f(x,y)=x-y$$ and the constraints: $$g_1(x,y)=x^2 + \dfrac{y^2}{4} - 1$$ $$g_2(x,y)=\dfrac{x^2}{4} + y^2 - 1$$
In Julia, it is written as follows:

```julia
f(x)=return x[1]-x[2]

g(x)=return[
  x[1]^2 + (x[2]^2)/4 - 1, 
  x[1]^2/4 + x[2]^2 - 1]
```
Then, we call the function using the lower bound and upper bound as default.
```julia
optimize!(KelleyAlgorithm(),f,g,2)
```
Getting the following result
```julia
(-1.5970674466118795, [-0.7936493370308374, 0.8034181095810422])
```


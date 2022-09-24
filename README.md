# Kelley
Kelley is a Julia package that uses the cut planes method created by J. E. Kelley, Jr. to solve convex optimization problem with linear objective function. Also, this package uses the HiGHS Optimizer for Linear Programming, from JuMP.

### Installation import
julia> Pkg.add("https://github.com/brunomattos1/Kelley.git")

julia> import Kelley

julia> using Kelley

### How the Kelley Cutting Plane algorithm works
Let $f(x)$ be the objective function and $G(x)$ the constraint function (convex). Let $S_0$ be an hypercube, such that $G(x) \le 0 \subset S_0$. 

Then, minimize $f(x)$ in $S_0$. 

Let $t_1$ be the solution. Compute the cut $p(x;t_1)=G(t_1)+\nabla G(t_1)\cdot (x-t_1)$, and set $S_1=S_0 \cap p(x;t_1)\le 0$.

Now, minimize $f(x)$ in $S_1$.

Repeat, until $G(t_k) \le 10^{-6}$

**Remark.** The subproblems minimization ( $f(x)$ in $S_i$ ) is a linear programming problem, since $f(x)$ is linear and $S_i$ is polytope.


### How to use the package

You must create your constraints functions as a unique function $$g: \mathbb{R}^n \rightarrow{} \mathbb{R}^m$$ In Julia code, would be $$g(x)=[g_1(x),g_2(x),\dots,g_n(x)]$$ where $g_i(x)$ are the constraints of the problem.

And your objective function $$f(x)=c\cdot x$$ always linear. Both $g(x)$ and $f(x)$ must have generic arguments. If your objective function is non linear, use the epigraph form instead.

The call of the function is given by 
```julia
optimize!(KelleyAlgorithm(), f, g, number of variables, lb, ub)
```
Where lb and ub are the lower bound of the box containing constraint set, and the upper bound, respectively. As default, $lb=10^{-6}$ and $ub=10^{6}$. If you know better bounds for your problem, you should use it, this way you will decrease the number of iterations.

The output gives the objective value and the approximated optimal solution.

The stop criterion is the following:

Let $x_k$ be a solution. If $g(x_k) \le 10^{-6}$, stop, we found an optimal solution. (criterion guaranteed by the convergence theorem)

### Example
Let $$f(x,y)=x-y$$ and the constraints: $$g_1(x,y)=x^2 + \dfrac{y^2}{4} - 1$$ $$g_2(x,y)=\dfrac{x^2}{4} + y^2 - 1$$
In Julia, it is written as follows:

```julia
f(x)=return x[1]-x[2]

g(x)=return[
  x[1]^2 + (x[2]^2)/4 - 1, #first constraint 
  x[1]^2/4 + x[2]^2 - 1 #second constraint
  ] 
```
Then, we call the function using the lower bound and upper bound as default.
```julia
optimize!(KelleyAlgorithm(),f,g,2)
```
Getting the following result
```julia
(-1.5970674466118795, [-0.7936493370308374, 0.8034181095810422])
```


#import "@preview/lilaq:0.6.0" as lq
#set page("a4")
#set par(justify: true)
#set heading(numbering: "1.") 
#align(center, [
  #text(2.5em)[BOX 2026 - Homework 3]

  #text(1.5em)[Joachim Le Fournis]
])

#counter(heading).update(1)
=
Let's order our set of strings $cal(S)$ as ${s_1, s_2, ... s_n}$, and have a few helper function from the previous question : 
$ "ov"(s_i, s_j) &= "length of the longest suffix of" s_i "which is a prefix of" s_j\
  "merge"(s_i, s_j) &= s_i dot s_j ["ov"(s_i, s_j):] quad "a function that merge two strings like previously"
 $

Our weighted directed graph $G=(V, E, w)$ will be :
- $V={0, 1, ... n}$ where each node $i>=1$ represents $s_i$ and $0$ is the virtual source used for the reduction
- $E={(0,i) | forall i in [|1;n|]} union.sq {(i,j) | forall i,j in [|1; n|], i!=j}$
- $forall i in [|1; n|], w(0,i)=abs(s_i)$ and $forall i,j in [|1; n|]^2 "where" i!=j, w(i,j)=abs(s_j)-"ov"(s_i,s_j)$

When we have $(0, v_1, ... v_n)$ a solution of open-TSP in this graph $G$, we can reconstruct the superstring as such : $s="merge"(... "merge"("merge"(s_(v_1), s_(v_2)), s_(v_3)) ..., s_(v_n))$

=
One first remark we can make is that $abs(s) = abs(s_(v_1)) + sum_(k=1)^(n-1) (abs(s_(v_(n+1))) - "ov"(s_(v_n), s_(v_(n+1))))$ by definition of the $"merge"$ function. \
However, by definition of solution to open-TSP, $abs(s)=w(0,v_1) + sum_(k=1)^(n-1) w(v_k, v_(k+1))$.

Firstly, we know that the superstring $s$ is built using only merge on its substring, thus it is obviously a valid superstring/solution to the SCS problem.

Thus, we only need to prove that $ "opt"_"SCS" (S) = min_("Hamiltonian path") (w(0,v_1)+sum_k w(v_k, v_(k+1))) $

- $<=$ : let's suppose that this isn't the case, and we have an hamiltonian path whose right hand size of the previous equality is smaller that $"opt"_"SCS" (S)$. Then, we can construct as explained in the previous question a new superstring that is shorter than $"opt"_"SCS" (S)$, which means we didn't have the optimal solution : absurd.
- $>=$ : Let $t$ be an optimal solution to the SCS problem, i.e. $abs(t) = "opt"_"SCS"(S)$. For each $s_i in S$, let $p_i$ denote the starting position of its leftmost occurrence in $t$. Let $v_1, ..., v_n$ be the strings of $S$ sorted by increasing $p_(v_i)$ (ties broken arbitrarily).

  Let's prove by absurd that this order also respects the ending positions, i.e. $ p_(v_k) + abs(s_(v_k)) <= p_(v_(k+1)) + abs(s_(v_(k+1))) quad "for all" k. $

  The occurrence of $s_(v_(k+1))$ starts after (or at) the start of $s_(v_k)$'s occurrence but ends before it, i.e. it lies entirely inside $s_(v_k)$'s occurrence in $t$. This means $s_(v_(k+1))$ occurs as a substring of $s_(v_k)$, i.e. $s_(v_(k+1)) subset s_(v_k)$, contradicting the hypothesis $forall (u,v) in S, u subset.not v$.

  So the occurrences of $s_(v_1), dots, s_(v_n)$ form a genuine left-to-right chain inside $t$. Let $"step"_k = p_(v_(k+1)) - p_(v_k) >= 0$. If $"step"_k <= abs(s_(v_k))$, the two occurrences overlap inside $t$ over a region of length $abs(s_(v_k)) - "step"_k$, which is by construction a common suffix of $s_(v_k)$ and prefix of $s_(v_(k+1))$ -- hence, since $"ov"$ is by definition the *maximal* such length,
  $ "ov"(s_(v_k), s_(v_(k+1))) >= abs(s_(v_k)) - "step"_k, quad "i.e." quad "step"_k >= abs(s_(v_k)) - "ov"(s_(v_k),s_(v_(k+1))). $
  
  If instead $"step"_k > abs(s_(v_k))$ (no overlap), the same inequality holds trivially since $"ov"(s_(v_k),s_(v_(k+1))) <= abs(s_(v_k))$ always. So in either case $ "step"_k >= abs(s_(v_k)) - "ov"(s_(v_k), s_(v_(k+1))) quad "for all" k. $

  Summing over $k = 1, dots, n-1$, we get by telescope sum $ p_(v_n) - p_(v_1) = sum_(k=1)^(n-1) "step"_k >= sum_(k=1)^(n-1) abs(s_(v_k)) - sum_(k=1)^(n-1) "ov"(s_(v_k), s_(v_(k+1))). $

  Adding $abs(s_(v_n))$ to both sides and re-indexing the length sum on the right ($sum_(k=1)^(n-1) abs(s_(v_k)) + abs(s_(v_n)) = abs(s_(v_1)) + sum_(k=1)^(n-1) abs(s_(v_(k+1)))$) allows us to get to $ p_(v_n) + abs(s_(v_n)) - p_(v_1) >= abs(s_(v_1)) + sum_(k=1)^(n-1) (abs(s_(v_(k+1))) - "ov"(s_(v_k), s_(v_(k+1)))) = w(0,v_1) + sum_(k=1)^(n-1) w(v_k, v_(k+1)). $

  Since $p_(v_1) >= 0$ and the occurrence of $s_(v_n)$ lies inside $t$ (so $p_(v_n)+abs(s_(v_n)) <= abs(t)$), the left-hand side is at most $abs(t)$, thus $ abs(t) >= w(0,v_1) + sum_(k=1)^(n-1) w(v_k, v_(k+1)) >= min_("Hamiltonian path") (w(0,v_1) + sum_k w(v_k, v_(k+1))). $

  As this holds for $t$ optimal, i.e. $abs(t) = "opt"_"SCS"(S)$, we get $ "opt"_"SCS"(S) >= min_("Hamiltonian path") (w(0,v_1) + sum_k w(v_k, v_(k+1))). $

#counter(heading).update(4)
=
#let data = json("result.json")
First thing we can notice is that the impact of $k$ is only not directly corelated to the results : for instance, the complex part isn't generating the distance matrix (which depends of $k$), but rather the number of reads $n$ made. We can compute that however, $k$ and $n$ are linked in probability : $EE[n]=(2L)/(k+1)$. Thus, to get more precise results, we tried to repeat the same experiment with different seed and then take the mean of time and quality of result.

Speaking of that, to measure the quality of the result, we did chose to use the levenshtein distance. It is probably not the perfect solution, but at least it gives idea of how far away the result is away from the base genome. To be able to compare it at different $k$ value, we did normalize it like so $"normalized"(a,b) = 1-("levenshtein"(a,b))/(max(abs(a), abs(b)))$, to be able to get a result between $0%$ and $100%$, and higher is better.

Also, we couldn't run the algorithm on the whole genome, which was about a few megabytes, because it generated way to many reads, which caused way too long overlap check. We chose to only use about $400"bp"$ for this exercice. Moreover, our TSP solver is using dynamic programming, which caused it to often crash due to Out-of-Memory. We limited in our experiment to only run it when we have less than 19 reads to avoid crashing our computer.

#let (greedy_k,greedy_ms,greedy_leven) = ((),(),())
#let (tsp_k,tsp_ms,tsp_leven) = ((),(),())
#for dic in data {
  greedy_k.push(dic.k)
  greedy_ms.push(dic.greedy_ms_avg)
  greedy_leven.push(dic.greedy_levenshtein)
  if dic.tsp_ms_avg != none {
    tsp_k.push(dic.k)
    tsp_ms.push(dic.tsp_ms_avg)
    tsp_leven.push(dic.tsp_levenshtein)
  }
}

#figure(
  lq.diagram(
    width: 10cm,
    height: 5cm,
    xlabel: $k$,
    ylabel: [Time (ms)],
    yscale: "log",
    lq.plot(greedy_k, greedy_ms, label: [Greedy]),
    lq.plot(tsp_k, tsp_ms, label: [TSP])
  )
)

As expected, when $k$ grows, $n$ get smaller and thus the algorithm get faster and faster. Also expected, whenever $k$ is big or small, the TSP solution is very slow compared to the greedy algorithm.

#figure(
  lq.diagram(
    width: 10cm,
    height: 5cm,
    xlabel: $k$,
    ylabel: [Normalized levenshtein\ (Higher is better)],
    yscale: "log",
    lq.plot(greedy_k, greedy_leven, label: [Greedy]),
    lq.plot(tsp_k, tsp_leven, label: [TSP])
  )
)

We can also notice that when $k$ is getting higher, our result is getting better and better. Starting at $k=140$, we're even getting the exact same genome as the one we started with (which can be expected because of the small part of the genome we worked on). Also, the TSP solution is never worse on these exemples than the greedy one, which was expected too.

On both of these figures, we can also notice that all data points are not perfectly following what we expected: the reads are random, we will get for some high values of $k$ more reads than for some lower ones, which directly impacts our algorithms.

import numpy as np
from python_tsp.exact import solve_tsp_dynamic_programming
from readfa import readfq
from simreads import simulate_reads_of_fixed_size
import time
import json

def overlap(u, v):
    max_len = min(len(u), len(v))
    for k in range(max_len, 0, -1):
        if u[-k:] == v[:k]:
            return k
    return 0

def merge(u, v):
    k = overlap(u, v)
    return u + v[k:]

def get_strings_with_maximal_overlap(S):
    best_u = best_v = None
    best_overlap = -1
    for i, u in enumerate(S):
        for j, v in enumerate(S):
            if i == j:
                continue
            ov = overlap(u, v)
            if ov > best_overlap:
                best_overlap = ov
                best_u, best_v = u, v
    return best_u, best_v    


def greedy_shortest_common_superstring(S):
    S = list(S)
    while len(S) > 1:
        u, v = get_strings_with_maximal_overlap(S)
        w = merge(u, v)

        S.remove(u)
        S.remove(v)
        S.append(w)

    return S[0]

# python_tsp solves closedTSP problem, so we will reduce the openTSP to closedTSP with a dummy closing node
def build_distance_matrix(S):
    n = len(S)
    size = n + 2  # + source node 0, + dummy closing node n+1

    # We can't fill with non-present edge, so we take a very large integer as infinity (which will never be taken in our solution)
    BIG = sum(len(s) for s in S) + 1
    D = np.full((size, size), BIG, dtype=int)

    # Basic edges : string to string, source to string, string to closing, closing to source
    np.fill_diagonal(D, 0)
    for i, s in enumerate(S, start=1):
        D[0, i] = len(s)              # source  -> string
        D[i, size - 1] = 0            # string  -> closing
    D[size - 1, 0] = 0                # closing -> source

    # Definition of our reduction :
    for i, u in enumerate(S, start=1):
        for j, v in enumerate(S, start=1):
            if i != j:
                D[i, j] = len(v) - overlap(u, v)
    return D

def tsp_shortest_common_superstring(S):
    n = len(S)
    if n == 1: return S[0]

    D = build_distance_matrix(S)
    perm, weight = solve_tsp_dynamic_programming(D)

    # Because we're solving the closedTSP, we need to rotate our cycle to the first node first
    zero_pos = perm.index(0)
    perm = perm[zero_pos:] + perm[:zero_pos]
    order = [p - 1 for p in perm if p not in (0, n + 1)]  # drop source & dummy

    w = S[order[0]]
    for idx in order[1:]:
        w = merge(w, S[idx])
    return w

############################### Measurement

def levenshtein(a,b) :
	if a == '' :
		return len(b)
	if b == '' :
		return len(a)
	n = len(a)
	m = len(b)
	lev = np.zeros((n+1,m+1))
	for i in range(0,n+1) :
		lev[i,0] = i 
	for i in range(0,m+1) :
		lev[0,i] = i
	for i in range(1,n+1) :
		for j in range(1,m+1) :
			insertion = lev[i-1,j] + 1
			deletion = lev[i,j-1] + 1
			substitution = lev[i-1,j-1] + (1 if a[i-1]!= b[j-1] else 0)
			lev[i,j] = min(insertion,deletion,substitution)
	return lev[n,m]

def normalized_levenshtein(a,b):
    # Higher is better, 100% = perfect reconstruction
    dist = levenshtein(a, b)
    return 100.0 * (1.0 - dist / max(len(a), len(b)))

def timed(f, *args, **kwargs):
    t0 = time.perf_counter()
    res = f(*args, **kwargs)
    t1 = time.perf_counter()
    return res, t1 - t0


def experiment(genome, n_cap_exact=18, n_seeds=10,
    k_values=(15, 20, 30, 40, 50, 60, 75, 110, 140, 200, 250)):
    """
    Runtime is directly linked to n the number of read and not to the k-value.
    However, n is based on probability based on k (with E[n]=2L/(k+1)).
    Thus, we will plot depending on k, by repeating the measurement for n_seeds different seed.
    However, exact resolution through TSP is too slow when k is low, we will then avoid
    plotting it for low value because we don't have this much time to spend.
    """
    rows = []
    for k in k_values:
        ns = []
        g_times, g_leven = [], []
        t_times, t_leven = [], []
        for seed in range(n_seeds):
            reads = simulate_reads_of_fixed_size(genome, k, seed=seed * 97 + k)
            n = len(reads)
            if len(ns) > 5:
                break
            ns.append(n)
            g_res, g_t = timed(greedy_shortest_common_superstring, reads)
            g_times.append(g_t * 1000)
            g_leven.append(normalized_levenshtein(g_res, genome))
            if n > n_cap_exact:
                # Let's avoid OOM my whole computer for the 20th time .___.
                continue
            t_res, t_t = timed(tsp_shortest_common_superstring, reads)
            t_times.append(t_t * 1000)
            t_leven.append(normalized_levenshtein(t_res, genome))
        rows.append(dict(
            k=k,
            n_avg=float(np.mean(ns)),
            greedy_ms_avg=float(np.mean(g_times)),
            greedy_levenshtein=float(np.mean(g_leven)),
            tsp_ms_avg=(float(np.mean(t_times)) if t_times else None),
            tsp_levenshtein=(float(np.mean(t_leven))if t_leven else None),
        ))
    return rows


if __name__ == "__main__":
    S = ["aabc", "bcde", "cda"]
    print(f"Small reconstruction test with {S} : ")
    print(f"Greedy(S)={greedy_shortest_common_superstring(S)}, TSP={tsp_shortest_common_superstring(S)}")

    f = open("genome.fa", "r")
    genome_length = 400
    seq = next(readfq(f))[1][:genome_length]
    f.close()

    print("Result of the experiment :")
    print(json.dumps(experiment(seq)))

from matplotlib import pyplot as plt
import random
import os
from multiprocessing import Pool

GENOMES = None
POOL_SIZE = 8

def init_worker(genomes):
    global GENOMES
    GENOMES = genomes

def F(k):
    seen = set()
    mask = (1 << (2 * k)) - 1
    for g in GENOMES:
        if len(g) < k:
            continue
        code = 0
        for c in g[:k]:
            code = (code << 2) | c
        seen.add(code)
        for c in g[k:]:
            code = ((code << 2) | c) & mask
            seen.add(code)
    return len(seen)

def plotF(genomes):
    with Pool(POOL_SIZE, initializer=init_worker, initargs=(genomes,)) as p:
        x = list(range(2, 31))
        y = p.map(F, x)
        print("Results :")
        print(x)
        print(y)
        plt.plot(x, y)
        plt.xlabel("Length k of the subword")
        plt.ylabel("F(k) subword complexity")
        plt.show()

BASE = {
    "A": 0,
    "C": 1,
    "G": 2,
    "T": 3,
}

def parsefile(filename):
    location = os.path.join(
        os.path.dirname(os.path.realpath(__file__)),
        filename
    )
    with open(location, "r") as f:
        result = []
        current = []
        for line in f:
            if line.startswith(">"):
                result.append(current)
                current = []
            else:
                current += map(lambda c : BASE[c], line.strip())
        result.append(current)
        return result
def lengthGenomes(genomes):
    return list(map(len, genomes))

def genomeRandom(k):
    return [random.randint(0, 3) for _ in range(k)]

def randomGenomes(genomesLength):
    with Pool(POOL_SIZE) as p:
        return p.map(genomeRandom, genomesLength)

def fibonacci(length):
    result = [0]
    while len(result) < length:
        temporary = []
        for c in result:
            if c == 0:
                temporary.append(0)
                temporary.append(1)
            else:
                temporary.append(0)
        result = temporary
    return result

def fibonacciGenomes(genomesLength):
    with Pool(POOL_SIZE) as p:
        return p.map(fibonacci, genomesLength)

if __name__ == "__main__":
    genomes = parsefile("genome_hw1.fa")
    print("Loaded file")
    plotF(genomes)
    genomesLength = lengthGenomes(genomes)
    print("Generated genomes length")
    randomgenomes = randomGenomes(genomesLength)
    print("Generated random genomes")
    plotF(randomgenomes)
    fibonaccigenomes = fibonacciGenomes(genomesLength)
    print("Generated fibonacci genomes")
    plotF(fibonaccigenomes)

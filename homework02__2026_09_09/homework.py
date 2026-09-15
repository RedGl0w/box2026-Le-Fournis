from readfa import readfq
import os
import itertools
from collections import defaultdict, Counter

def loadFiles():
    directory = os.path.dirname(os.path.realpath(__file__))
    result = []
    for f in os.listdir(directory):
        location = os.path.join(directory, f)
        if os.path.isfile(location) and (f.endswith(".fa") or f.endswith(".fq")):
            fq = open(location, "r")
            result.append((fq, readfq(fq)))
    return result

def closeFiles(loaded):
    for file, _ in loaded:
        file.close()

# Question 5 :
BASE = {
    "A": 0b00,
    "C": 0b01,
    "G": 0b10,
    "T": 0b11,
}

def encode_kmers(seq, k):
    value = 0
    length = 0
    mask = (1 << (2 * k)) - 1
    for nucleotide in seq.upper(): # Watchout for ambiguities with lower/upper case
        # Remarks : if we encounter an unkown nucleotide, we start a new sequence
        if nucleotide not in BASE:
            value = 0
            length = 0
            continue
        value = ((value << 2) | BASE[nucleotide]) & mask
        length += 1
        if length >= k:
            yield value

def computeSize(loaded):
    print("Sizes :")
    for f, content in loaded:
        count, length = 0, 0
        for _, seq, _ in content:
            count += 1
            length += len(seq)
        print(f"{os.path.basename(f.name)} : {count} sequences for {length} cummulative length")

def computeJaccard(loaded, k=20):
    # We're using sets here, in order to compute intersection and union
    sets = {}
    for f, content in loaded:
        name = os.path.basename(f.name)
        sets[name] = set()
        for _, seq, _ in content:
            # Without question 5 :
            # for i in range(len(seq)-k+1):
            #     sets[name].add(seq[i:i+k])
            # With question 5 :
            for kmer in encode_kmers(seq, k):
                sets[name].add(kmer)

    result = defaultdict(dict)
    for i, j in itertools.product(sets, repeat=2):
    # Other possibility : we could use symetry of Jaccard indexes :
    # for i, j in itertools.combinations(sets, 2):
        J = len(sets[i] & sets[j])/len(sets[i] | sets[j])
        result[i][j] = J
    print(dict(result))


def reverse_complement(value, k):
    rc = 0
    # We iter on value from the rightmost bits to the leftmost bits,
    # while we produce rc from the leftmost bits to the rightmost bits
    # Thus, we're reversing the value.
    for _ in range(k):
        # With our encoding, we have
        # A : 0b00 <-> T : 0b11
        # C : 0b01 <-> G : 0b10
        # Thus, to have the complementary nucleotid, we XOR with 0b11
        nucleotide = value & 0b11
        complement = nucleotide ^ 0b11
        rc = (rc << 2) | complement
        value >>= 2
    return rc

def canonical_kmer(value, k):
    # Thus, the canonical kmer is the minimum between the k-mer and its reverse complement
    rc = reverse_complement(value, k)
    return min(value, rc)

def count_canonical_kmers(content, k=20):
    counts = Counter()
    for _, seq, _ in content:
        for kmer in encode_kmers(seq, k):
            counts[canonical_kmer(kmer, k)] += 1
    return counts

def abundance_histogram(counts):
    histogram = Counter(counts.values())
    abundances = sorted(histogram)
    numbers = [histogram[a] for a in abundances]
    print(abundances)
    print(numbers)


if __name__ == "__main__":
    print("Question 2:")
    files = loadFiles()
    computeSize(files)
    closeFiles(files)

    print("Question 4:")
    files = loadFiles()
    computeJaccard(files)
    closeFiles(files)

    print("Question 6:")
    files = loadFiles()
    f, con = files[0]
    counts = count_canonical_kmers(con)
    print(f"File: {os.path.basename(f.name)}")
    print(f"Number of distinct canonical k-mers: {len(counts)}")
    abundance_histogram(counts)
    closeFiles(files)



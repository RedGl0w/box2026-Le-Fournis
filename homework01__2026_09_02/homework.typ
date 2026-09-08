#import "@preview/lilaq:0.6.0" as lq
#set page("a4")
#set par(justify: true)
#set heading(numbering: "1.") 
#align(center, [
  #text(2.5em)[BOX 2026 - Homework 1]

  #text(1.5em)[Joachim Le Fournis]
])

#counter(heading).update(1)
=
After selecting a chunk of the `genome_hw1.fa` file of more than 300 lines (without any header within them) of 70 characters per line, and going on nucleotide BLAST, I got a lot of result, all of them which corresponded to *Streptococcus pneumoniae*. I then tried to check with a different chunk of the file the same procedure, which got me the same result.

=
#show: lq.set-diagram(width: 10cm, height: 5cm)

#let x = range(2, 31)
#let yBaseGenome = (16, 64, 256, 1024, 4096, 16384, 65101, 241952, 691301, 1298893, 1730646, 1924270, 1992657, 2015184, 2022978, 2026270, 2028150, 2029518, 2030690, 2031761, 2032753, 2033682, 2034565, 2035391, 2036178, 2036934, 2037651, 2038321, 2038948)
#figure(lq.diagram(
  lq.plot(x, yBaseGenome),
  xlabel: $k "length of the substring"$,
  ylabel: $F(k) "subword complexity"$
), caption: [Subword complexity of the base genome])

=
#let yRandom = (16, 64, 256, 1024, 4096, 16384, 65536, 262055, 901435, 1627278, 1938142, 2028400, 2051862, 2057739, 2059105, 2059345, 2059281, 2059156, 2059008, 2058857, 2058705, 2058552, 2058399, 2058246, 2058093, 2057940, 2057787, 2057634, 2057481)
#figure(lq.diagram(
  lq.plot(x, yRandom),
  xlabel: $k "length of the substring"$,
  ylabel: $F(k) "subword complexity"$
), caption: [Subword complexity of a similar (in length) random genome])

=
#let yFibonacci = (3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31)
#figure(lq.diagram(
  lq.plot(x, yFibonacci),
  xlabel: $k "length of the substring"$,
  ylabel: $F(k) "subword complexity"$
), caption: [Subword complexity of genome made out of Fibonacci words])

=
Both the genome given with this homework and the random genome we generated based on the previous one share a lot of similarities, which shows that they have a really complex structure :
- At first, the number of different k-mers quickly increase as $k$ increases, and get up to its limit ($4^k$ with $k=7$ for instance)
- However, the subword complexity then get away of its theorical limit, because the genomes are still finite, and there are less and less possible position for a $k-"mer"$ when $k$ increase.
- The only difference between both of them is that the random genomes subword complexity at the end decreases when $k$ increases, while the base genome continues to grow, just at a really slow pace.

At the opposite, the $k$ subword complexity of a genome made out of Fibonacci words increase linearly with $k$, showing that this genome has an extremly low complexity.

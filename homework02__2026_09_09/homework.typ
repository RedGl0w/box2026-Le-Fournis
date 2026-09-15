#import "@preview/lilaq:0.6.0" as lq
#set page("a4")
#set par(justify: true)
#set heading(numbering: "1.") 
#align(center, [
  #text(2.5em)[BOX 2026 - Homework 2]

  #text(1.5em)[Joachim Le Fournis]
])
#show table.header: text.with(weight: "bold")

#underline[*Remarks on the notes :*]

When we encounter non-usual bases (such as `Y` or `N`), we decided to split the read sequences as two sequences, in order to avoid creating non-existent k-mer.

#counter(heading).update(1)
=
=
#table(
  columns: 4,
  align: center+horizon,
  table.header(
    [Filename], [Number of\ sequences], [Cummulative length\ of sequences], [Species found]
  ),
  [`file1.fa`], [1], [2221315], [Streptococcus pneumoniae],
  [`file2.fa`], [1], [29903], [Severe acute respiratory syndrome coronavirus 2],
  [`file3.fa`], [1], [9181], [Human Immunodeficiency Virus (HIV)],
  [`file4.fa`], [7], [2553358], [Different results depending of the sequence : Streptococcus hyointestinalis, no results on other sequences, ...],
  [`file5.fa`], [1], [29706], [Severe acute respiratory syndrome coronavirus 2],
  [`file6.fa`], [1], [213008], [Streptococcus suis strain]
)

=
#let colormap(data, title) = {
  let cells = (
    table.cell(title), ..data.keys().map(it => table.cell(it)),
  )
  for i in data.keys() {
    cells.push(table.cell(raw(i)))
    for j in data.at(i).keys() {
      cells.push(
        table.cell(
          str(data.at(i).at(j))
        )
      )
    }
  }

  table(
    columns: data.len()+1,
    ..cells
  )
}

#figure(
  colormap(
    (
      "file1.fa": ("file1.fa": "1.0", "file2.fa": "9.17e-07", "file3.fa": "0.0", "file4.fa": "0.0033", "file5.fa": "0.0", "file6.fa": "2.64e-05"), 
      "file2.fa": ("file1.fa": "9.17e-07", "file2.fa": "1.0", "file3.fa": "0.0", "file4.fa": "0.0", "file5.fa": "0.82", "file6.fa": "0.0"),
      "file3.fa": ("file1.fa": "0.0", "file2.fa": "0.0", "file3.fa": "1.0", "file4.fa": "0.0", "file5.fa": "0.0", "file6.fa": "0.0"), 
      "file4.fa": ("file1.fa": "0.0033", "file2.fa": "0.0", "file3.fa": "0.0", "file4.fa": "1.0", "file5.fa": "0.0", "file6.fa": "0.088"), 
      "file5.fa": ("file1.fa": "0.0", "file2.fa": "0.82", "file3.fa": "0.0", "file4.fa": "0.0", "file5.fa": "1.0", "file6.fa": "0.0"),
      "file6.fa": ("file1.fa": "2.64-05", "file2.fa": "0.0", "file3.fa": "0.0", "file4.fa": "0.088",  "file5.fa": "0.0", "file6.fa": "1.0")
    ), [*Jaccard indexes*]
  )
)

As expected, most of the cells are filled with 0, and 1 on the diagonale (because most of the genomes are different, and every genome is the same as itself). However, we also find that both `file2.fa` and `file5.fa` are very similar (82%), as expected because both of them matches Severe acute respiratory syndrome coronavirus 2. Also, `file4.fa`, `file1.fa` and `file6.fa` have similarities (non-null Jaccard indexes), probably because all of them are Streptococcus. 

/* #lq.diagram(
  width: 5cm,
  height: 5cm,
  lq.colormesh(
    range(result.keys().len()),
    range(result.keys().len()),
    (i, j) => result.at(
      result.keys().at(i)
    ).at(result.keys().at(j)),
    interpolation: "smooth"
  )
) */

#counter(heading).update(5)
=
#figure(
  lq.diagram(
    yscale: "symlog",
    width: 10cm,
    height: 7cm,
    lq.bar(
      (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 45, 46, 48, 49, 51, 52, 53, 54, 55, 56, 57, 58, 60, 61, 64, 65, 66, 68, 70, 75, 76, 78, 83, 84, 86, 94),
      (2100070, 61399, 9652, 7267, 2132, 7328, 1636, 1356, 3532, 1219, 835, 297, 317, 410, 267, 367, 367, 274, 316, 292, 351, 1110, 232, 347, 178, 116, 79, 115, 22, 38, 19, 17, 24, 52, 22, 11, 12, 57, 29, 142, 223, 170, 12, 3, 3, 4, 6, 4, 7, 1, 1, 7, 2, 2, 3, 1, 1, 1, 1, 1, 1, 3, 1, 3, 1, 8, 9, 1, 1)
    )
  ),
  caption: [canonical $k-"mer"$ abudances with $k=40$ for `file4.fa`]
)



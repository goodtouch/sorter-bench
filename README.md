# Sorter Bench

Quick benchmarks for sorting methods

Ran with `ruby 2.2.2`

## Big Array (1 x 100_000 elements)

```
Rehearsal -----------------------------------------------------------------------------
jekyll                                      0.100000   0.010000   0.110000 (  0.108136)
sort inline block w/ reverse!               0.100000   0.000000   0.100000 (  0.104075)
sort inline block w/o reverse!              0.100000   0.000000   0.100000 (  0.111214)
sorter inline no args block                 0.100000   0.000000   0.100000 (  0.108116)
sorter inline block w/o cache w/o nesting   0.150000   0.000000   0.150000 (  0.161309)
sorter inline block w/ cache w/o nesting    0.160000   0.000000   0.160000 (  0.166381)
sorter inline block w/o cache w/ nesting    0.550000   0.020000   0.570000 (  0.592609)
sorter inline block w/ cache w/ nesting     0.510000   0.010000   0.520000 (  0.535080)
sorter lambda w/o cache w/o nesting         0.150000   0.000000   0.150000 (  0.151971)
sorter lambda w/ cache w/o nesting          0.150000   0.000000   0.150000 (  0.155084)
sorter lambda w/o cache w/ nesting          0.510000   0.010000   0.520000 (  0.537954)
sorter lambda w/ cache w/ nesting           0.510000   0.000000   0.510000 (  0.523030)
sorter proc w/o cache w/o nesting           0.150000   0.000000   0.150000 (  0.163229)
sorter proc w cache w/o nesting             0.160000   0.000000   0.160000 (  0.156773)
sorter proc w/o cache w/ nesting            0.500000   0.000000   0.500000 (  0.515055)
sorter proc w/ cache w/ nesting             0.510000   0.000000   0.510000 (  0.529283)
sorter class eval w/ cache (w/ nesting)     0.070000   0.000000   0.070000 (  0.069242)
-------------------------------------------------------------------- total: 4.530000sec

                                                user     system      total        real
jekyll                                      0.110000   0.000000   0.110000 (  0.104057)
sort inline block w/ reverse!               0.100000   0.000000   0.100000 (  0.100295)
sort inline block w/o reverse!              0.100000   0.000000   0.100000 (  0.104163)
sorter inline no args block                 0.100000   0.000000   0.100000 (  0.116552)
sorter inline block w/o cache w/o nesting   0.160000   0.000000   0.160000 (  0.165166)
sorter inline block w/ cache w/o nesting    0.160000   0.000000   0.160000 (  0.159142)
sorter inline block w/o cache w/ nesting    0.500000   0.000000   0.500000 (  0.510829)
sorter inline block w/ cache w/ nesting     0.490000   0.010000   0.500000 (  0.503434)
sorter lambda w/o cache w/o nesting         0.140000   0.000000   0.140000 (  0.150984)
sorter lambda w/ cache w/o nesting          0.150000   0.000000   0.150000 (  0.152537)
sorter lambda w/o cache w/ nesting          0.490000   0.000000   0.490000 (  0.492966)
sorter lambda w/ cache w/ nesting           0.480000   0.000000   0.480000 (  0.498932)
sorter proc w/o cache w/o nesting           0.150000   0.000000   0.150000 (  0.154746)
sorter proc w cache w/o nesting             0.150000   0.000000   0.150000 (  0.154552)
sorter proc w/o cache w/ nesting            0.500000   0.010000   0.510000 (  0.525547)
sorter proc w/ cache w/ nesting             0.500000   0.000000   0.500000 (  0.525802)
sorter class eval w/ cache (w/ nesting)     0.060000   0.000000   0.060000 (  0.067487)
```

## Small Arrays (1_000 x 100 elements)

```
Rehearsal -----------------------------------------------------------------------------
jekyll                                      0.110000   0.000000   0.110000 (  0.120541)
sort inline block w/ reverse!               0.110000   0.000000   0.110000 (  0.108034)
sort inline block w/o reverse!              0.100000   0.000000   0.100000 (  0.111441)
sorter inline no args block                 0.100000   0.000000   0.100000 (  0.109939)
sorter inline block w/o cache w/o nesting   0.170000   0.000000   0.170000 (  0.174447)
sorter inline block w/ cache w/o nesting    0.180000   0.000000   0.180000 (  0.177864)
sorter inline block w/o cache w/ nesting    0.540000   0.010000   0.550000 (  0.549647)
sorter inline block w/ cache w/ nesting     0.530000   0.000000   0.530000 (  0.565755)
sorter lambda w/o cache w/o nesting         0.190000   0.000000   0.190000 (  0.193383)
sorter lambda w/ cache w/o nesting          0.160000   0.000000   0.160000 (  0.161372)
sorter lambda w/o cache w/ nesting          0.530000   0.000000   0.530000 (  0.540227)
sorter lambda w/ cache w/ nesting           0.510000   0.000000   0.510000 (  0.517911)
sorter proc w/o cache w/o nesting           0.220000   0.000000   0.220000 (  0.220492)
sorter proc w cache w/o nesting             0.170000   0.000000   0.170000 (  0.174906)
sorter proc w/o cache w/ nesting            0.570000   0.010000   0.580000 (  0.582071)
sorter proc w/ cache w/ nesting             0.530000   0.000000   0.530000 (  0.538940)
sorter class eval w/ cache (w/ nesting)     0.070000   0.000000   0.070000 (  0.085528)
-------------------------------------------------------------------- total: 4.810000sec

                                                user     system      total        real
jekyll                                      0.110000   0.000000   0.110000 (  0.111950)
sort inline block w/ reverse!               0.100000   0.000000   0.100000 (  0.115478)
sort inline block w/o reverse!              0.110000   0.000000   0.110000 (  0.105195)
sorter inline no args block                 0.100000   0.000000   0.100000 (  0.102058)
sorter inline block w/o cache w/o nesting   0.180000   0.000000   0.180000 (  0.181931)
sorter inline block w/ cache w/o nesting    0.180000   0.000000   0.180000 (  0.178988)
sorter inline block w/o cache w/ nesting    0.530000   0.000000   0.530000 (  0.540531)
sorter inline block w/ cache w/ nesting     0.530000   0.000000   0.530000 (  0.548634)
sorter lambda w/o cache w/o nesting         0.190000   0.000000   0.190000 (  0.185490)
sorter lambda w/ cache w/o nesting          0.160000   0.000000   0.160000 (  0.165312)
sorter lambda w/o cache w/ nesting          0.530000   0.000000   0.530000 (  0.533625)
sorter lambda w/ cache w/ nesting           0.510000   0.000000   0.510000 (  0.516132)
sorter proc w/o cache w/o nesting           0.190000   0.000000   0.190000 (  0.193368)
sorter proc w cache w/o nesting             0.160000   0.000000   0.160000 (  0.171554)
sorter proc w/o cache w/ nesting            0.550000   0.000000   0.550000 (  0.557575)
sorter proc w/ cache w/ nesting             0.520000   0.000000   0.520000 (  0.545146)
sorter class eval w/ cache (w/ nesting)     0.070000   0.000000   0.070000 (  0.077700)
```

## Interpretation

- Using block, lambda or proc doesn't make much difference
- Main source of latency comes from accessing nested elements in the hash (~x5)
- If we don't use nesting, the impact is pretty low (< x2).
- Cached string manipulation have a small impact (see Small Arrays)
- The overall is still quite good considering we are sorting 100_000 Elements on an Core 2 Duo laptop.
- In case it's an issue for GitHub Pages, I also added a dynamic `class_eval` sorter that provides the same performance as the current Jekyll sorting method, with caching (so that we don't class eval every time), inline nested access to the data hash, and quite easy to secure against potential user input security concerns (see `Sorter#ce_order`)

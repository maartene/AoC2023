# AoC2023

Advent of Code 2023. First time participating! 🎉

## Input files

The creator of the Advent of Code site requested for the input files not to be shared. So they are part of the `.gitignore` file.

Within each day project, you should create an `Input.swift` file where you add a `let input = """ """` with the input for that day.

## Day specific remarks

- Day 10: My solution assumes the input is padded with one extra '.' at the top, left, bottom and right of the input matrix.
- Day 23: This solution generates uses Dijkstra to generate valid paths, but not necesarrily the longest path. However, if you run it often enough and take the highest returned value. Eventually you will get lucky. This was my approach for part 1. For Part 2 I had to implemdent DFS and copy/paste it in a separate project because when running in test target, the stack overflowed. I'm not sure why, but I suspect it has something to do with how Xcode handles tests. The project ran for a couple of hours, each time showing when a new maximum was found. I eventually wound up just trying every value when I got a new maximum in the AoC site until the right one was found. Not the most elegant solution, but it netted me the stars. 🤷‍♂️ (I was actually busy writing up a solution that first creates a simplified graph while the DFS was running, but the right answer came before I could finish the more elegant solution.)
- Day 24: I did Part 2 using SageMath. Just plugged in the values from my input. No idea how to solve this in pure Swift.
- Day 25: I did this one using GraphViz. So, again not a lot of 'real code'. I transformed the input format into the 'dot' format and then used GraphViz to generate an SVG image. In Curve I could find the correct three lines to cut visually, color them to make tracing easier. And then follow them to nodes (components). I could use the `ring(for connections: Set<Connection>, removing: Set<Connection>)` function to check whether the graph was really cut (when the count of the set of connections returned (+3), is less than the number of connections passed in).

### Note

The tests that validate the actual input (usually called `test_part1` and `test_part2`) validate against the input I received. You might get different input, meaning the expected output value will be different.

import input from "./input.txt";

export function day11(input: string, expansionFactor = 2): number {
  // 1. find galaxies
  const galaxies: [number, number][] = [];
  input.split("\n").forEach((row, y) => {
    row.split("").forEach((item, x) => {
      if (item === "#") galaxies.push([x, y]);
    });
  });

  // 2. expand galaxies
  const occupiedX = [...new Set(galaxies.map((g) => g[0]))];
  const occupiedY = [...new Set(galaxies.map((g) => g[1]))];
  const expandedGalaxies = galaxies.map(([x, y]) => {
    const offsetX = x - occupiedX.filter((occX) => occX < x).length;
    const offsetY = y - occupiedY.filter((occY) => occY < y).length;
    return [
      x + offsetX * (expansionFactor - 1),
      y + offsetY * (expansionFactor - 1),
    ];
  });

  // 3. sum distances between galaxies
  return (
    expandedGalaxies
      .map((g1) => {
        return expandedGalaxies
          .map((g2) => Math.abs(g1[1] - g2[1]) + Math.abs(g1[0] - g2[0]))
          .reduce((a, b) => a + b);
      })
      // divides by 2 since we calculate the pairs in both directions
      .reduce((a, b) => a + b) / 2
  );
}

console.log(`part1: ${day11(input)}`);
console.log(`part2: ${day11(input)}`);

import input from "./input.txt";

export function day12(input: string): number {
  const values = input.split("\n").map((line) => {
    if (!line) return 0;
    const [arrangement, conditions] = line.split(" ");
    const conditionRecord = conditions.split(",").map((x) => parseInt(x));
    return day12Recursive(arrangement, conditionRecord);
  });
  return values.reduce((a, b) => a + b);
}

function day12Recursive(
  arrangement: string,
  conditionRecord: number[]
): number {
  if (arrangement.includes("?")) {
    const partial = arrangement.substring(0, arrangement.indexOf("?"));
    if (!isValidPartial(partial, conditionRecord)) return 0;
    const ending = arrangement.substring(arrangement.indexOf("?") + 1);
    return (
      day12Recursive(partial + "#" + ending, conditionRecord) +
      day12Recursive(partial + "." + ending, conditionRecord)
    );
  } else {
    const value = isValid(arrangement, conditionRecord) ? 1 : 0;
    // console.log(arrangement, value);
    return value;
  }
}

function isValidPartial(
  partialArrangement: string,
  conditionRecord: number[]
): boolean {
  const groups = partialArrangement
    .split(".")
    .map((g) => g.length)
    .filter((g) => g > 0);
  if (groups.length > conditionRecord.length) return false;
  return groups.every((g, i) =>
    i === groups.length - 1 ? g <= conditionRecord[i] : g === conditionRecord[i]
  );
}

function isValid(arrangement: string, conditionRecord: number[]): boolean {
  const groups = arrangement.split(".").filter((g) => g.length);
  if (groups.length !== conditionRecord.length) return false;
  return groups.every((g, i) => g.length === conditionRecord[i]);
}

console.log(`part1: ${day12(input)}`);
console.log(`part2: ${day12(input)}`);

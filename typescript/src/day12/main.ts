import input from "./input.txt";

export function day12(input: string, unfold = false): number {
  const values = input.split("\n").map((line) => {
    if (!line) return 0;
    let [arrangement, conditions] = line.split(" ");
    if (unfold) {
      arrangement = Array(5).fill(arrangement).join("?");
      conditions = Array(5).fill(conditions).join(",");
    }
    const conditionRecord = conditions.split(",").map((x) => parseInt(x));

    return day12Recursive(arrangement, conditionRecord);
  });
  return values.reduce((a, b) => a + b);
}

function allPossibilities(arrangement: string): number[][] {
  return arrangement.split(".").map((part) => {
    if (!part) {
      return [];
    } else if (!part.includes("?")) {
      return [part.length];
    } else {
      return [];
    }
  });
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

function matchConditions(
  partial: string,
  conditions: number[]
): [number, number[]] | false {
  const groups = partial
    .split(".")
    .map((g) => g.length)
    .filter((g) => g > 0);
  if (groups.length > conditions.length) return false;
  for (let i = 0; i < groups.length - 1; i++) {
    if (groups[i] !== conditions[i]) return false;
    conditions.shift();
  }
  let total = groups.length - 1;
  if (groups[groups.length] === conditions[0]) {
    total += 1;
    conditions.unshift();
  } else if (groups[groups.length] > conditions[0]) {
    return false;
  }
  return [total, conditions];
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
    i === groups.length - 1 && partialArrangement.endsWith("#")
      ? g <= conditionRecord[i]
      : g === conditionRecord[i]
  );
}

function isValid(arrangement: string, conditionRecord: number[]): boolean {
  const groups = arrangement.split(".").filter((g) => g.length);
  if (groups.length !== conditionRecord.length) return false;
  return groups.every((g, i) => g.length === conditionRecord[i]);
}

// console.log(`part1: ${day12(input)}`);
// console.log(`part2: ${day12(input)}`);
day12("????.#...#... 4,1,1", true);

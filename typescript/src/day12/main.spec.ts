import { expect, test } from "bun:test";
import { day12 } from "./main";
import input from "./test.txt";

test("part1", () => {
  expect(day12(input)).toBe(21);
  expect(day12("???.### 1,1,3")).toBe(1);
  expect(day12(".??..??...?##. 1,1,3")).toBe(4);
  expect(day12("?#?#?#?#?#?#?#? 1,3,1,6")).toBe(1);
  expect(day12("????.#...#... 4,1,1")).toBe(1);
  expect(day12("????.######..#####. 1,6,5")).toBe(4);
  expect(day12("?###???????? 3,2,1")).toBe(10);
});

// test("part2", () => {
//   expect(day12(input, 10)).toBe(1030);
//   expect(day12(input, 100)).toBe(8410);
// });

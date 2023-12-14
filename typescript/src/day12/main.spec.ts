import { expect, test } from "bun:test";
import { day12 } from "./main";
import input from "./test.txt";

test("part1", () => {
  // expect(day12(input)).toBe(21);
  // expect(day12("???.### 1,1,3")).toBe(1);
  // expect(day12(".??..??...?##. 1,1,3")).toBe(4);
  // expect(day12("?#?#?#?#?#?#?#? 1,3,1,6")).toBe(1);
  // expect(day12("????.#...#... 4,1,1")).toBe(1);
  // expect(day12("????.######..#####. 1,6,5")).toBe(4);
  // expect(day12("?###???????? 3,2,1")).toBe(10);
});

test("part2", () => {
  // expect(day12(input, true)).toBe(525152);
  // expect(day12("???.### 1,1,3", true)).toBe(1);
  // expect(day12(".??..??...?##. 1,1,3", true)).toBe(16384);
  // expect(day12("?#?#?#?#?#?#?#? 1,3,1,6", true)).toBe(1);
  expect(day12("????.#...#... 4,1,1", true)).toBe(16);
  // expect(day12("????.######..#####. 1,6,5", true)).toBe(2500);
  // expect(day12("?###???????? 3,2,1", true)).toBe(506250);
});

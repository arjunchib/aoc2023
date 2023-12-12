import { expect, test } from "bun:test";
import { day11 } from "./main";
import input from "./test.txt";

test("part1", () => {
  expect(day11(input)).toBe(374);
});

test("part2", () => {
  expect(day11(input, 10)).toBe(1030);
  expect(day11(input, 100)).toBe(8410);
});

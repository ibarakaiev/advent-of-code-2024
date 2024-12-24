defmodule AdventOfCode2024.Day23Test do
  use ExUnit.Case

  @input """
  kh-tc
  qp-kh
  de-cg
  ka-co
  yn-aq
  qp-ub
  cg-tb
  vc-aq
  tb-ka
  wh-tc
  yn-cg
  kh-ub
  ta-co
  de-co
  tc-td
  tb-wq
  wh-td
  ta-ka
  td-qp
  aq-cg
  wq-ub
  ub-vc
  de-ta
  wq-aq
  wq-vc
  wh-yn
  ka-de
  kh-ta
  co-tc
  wh-qp
  tb-vc
  td-yn
  """

  test "part 1" do
    assert AdventOfCode2024.Day23.solve(@input, part: 1) == 7
  end

  test "part 2" do
    assert AdventOfCode2024.Day23.solve(@input, part: 2) == "co,de,ka,ta"
  end
end

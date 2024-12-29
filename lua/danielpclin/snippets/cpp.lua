require("luasnip.session.snippet_collection").clear_snippets "cpp"

local luasnip = require "luasnip"

local s = luasnip.snippet
local i = luasnip.insert_node

local fmt = require("luasnip.extras.fmt").fmt

luasnip.add_snippets("cpp", {
  s(
    "cf",
    fmt(
      [[
#include <bits/stdc++.h>

using namespace std;

int main() {{
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    int tt;
    cin >> tt;
    while (tt--) {{
        {}
    }}
    return 0;
}}
]],
      { i(0) }
    )
  ),
})

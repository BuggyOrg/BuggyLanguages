/* This file is part of Buggy.
 
 Buggy is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 Buggy is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Buggy.  If not, see <http://www.gnu.org/licenses/>.
 */

lsc-desc = {
  # tabSize: 2  (optional, default 2)
  group: "implements: \"{{symbol}}\"\n{{id}} = -> \n{{contents}}"
  contents: "{{\#each generic}}  Out{{id}} = {{id}} {{inputs id}}\n{{/each}}\n  return {{outputs id}}"
  input: " {{to.connector}}: {{from.generic}}.{{from.connector}} "
  output: " {{to.connector}}: {{from.generic}}.{{from.connector}} "
}

define ["ls!src/generator", "LiveScript"],  (Generator, LiveScript) ->
  {
    name: "LiveScript"
    /** generates the source for the given dataflow
      */
    generate: Generator.from-description lsc-desc
    
    /** parses the source code and generates the dataflow
      */
    parse: (source) ->
      if source == ""
        throw new Error "Cannot convert empty"
      ast = LiveScript.ast source
      generics = ast.lines.1.right.body.lines |> filter -> "right" of it
      vars = generics |> map -> name: it.left.value, generic: it.right.head.value
      connections = generics |> map (nc) -> 
        nc.right.tails.0.args.0.items |> map -> {
          from: { id: nc.right.head.value, connector: it.key.name },
          to: { id: it.val.head.value, connector: it.val.tails.0.key.name }
        }
      connections = connections |> flatten
      connections |> each (c) ->
        vars |> each -> 
          if it.name == c.to.id
            c.to.id = it.generic
      generics = generics |> map -> it.right.head.value
      symbol = ast.lines.0.items.0.val.value
      {
        name: ast.lines.1.left.value
        generics: generics
        connections: connections
        symbol: symbol.substring 1, symbol.length - 1
      }
      
  }

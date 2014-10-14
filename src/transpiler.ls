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
 
define ->
  Transpiler = {
    /** creates a new transpiler from a given language to 
      * another language
      */
    create: (from, to, langs) ->
      if from != "dataflow" and to != "dataflow"
        # there must always be a way to transform to the dataflow Description
        # with that we can transpile from everywhere to everywhere
        flow = Transpiler.create from, "dataflow", langs
        source = Transpiler.create "dataflow", to, langs
        return Transpiler.compose source, flow
      functionSelect = "generate";
      lang = to
      if to == "dataflow"
        functionSelect = "parse"
        lang = from
      transpilerLang = head filter (-> it.name == lang), langs
      transpiler = transpilerLang[functionSelect];
      transpiler.from = from
      transpiler.to = to
      return transpiler
    
    compose: (t1, t2) ->
      transpiler = t1 . t2
      transpiler.from = t2.from
      transpiler.to = t1.to
      return transpiler
  }

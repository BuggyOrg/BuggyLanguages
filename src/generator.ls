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

default-desc = {
  tabSize: 2
}
 
define ["Buggy","clone", "handlebars"], (Buggy, Clone, Handlebars) ->
  Buggy = Buggy.Buggy
  Implementation = Buggy.Implementation
  Group = Buggy.Group
  Symbol = Buggy.Symbol
  
  register-helper = (impl, desc) ->
    to-handler = (templ, id) -->
      id_outputs = Group.connections-to impl, id
      id_outputs |> fold (-> &0 + templ &1), ""
    out-templ = Handlebars.compile desc.output
    in-templ = Handlebars.compile desc.input
    Handlebars.registerHelper "outputs", to-handler out-templ
    Handlebars.registerHelper "inputs", to-handler in-templ
  
  unregister-helper = ->
    Handlebars.unregisterHelper "outputs"
    Handlebars.unregisterHelper "inputs"
  
  connector-name = (impl, conn) ->
    gid = Implementation.identifier impl
    if conn.id == gid
      "this.#{conn.connector}"
    else
      "#{conn.id}.#{conn.connector}"
  
  generate-group = (impl, desc) ->
    gid = Implementation.identifier impl
    register-helper impl, desc
    content = (Handlebars.compile desc.contents) id: gid, symbol: impl.symbol
    res = (Handlebars.compile desc.group) id: gid, contents: content
    unregister-helper!
    return res
  
  generate-atomic = (impl) ->
    throw new Error "[Generator(LiveScript).generate-atomic] Not implemented"
  
  Generator = {
    from-description: (desc) ->
      new-desc = Clone default-desc
      new-desc <<< Clone desc
      
      (impl) ->
        if Implementation.is-group impl
          generate-group impl, new-desc
        else 
          generate-atomic impl, new-desc
  }

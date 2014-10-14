
global <<< require \prelude-ls
require! chai
chai.should!

Transpiler = requirejs "ls!src/transpiler"

describe "Transpiler", (...) ->
  # language that writes into the name and reads from it
  l1 = name: "l1", parse: (-> name: it), generate: -> it.name
  # language that prepends l2 to every parsed stuff
  l2 = name: "l2", parse: (-> name: "l2#it"), generate: -> "#{it.name}l2"
  
  langs = [l1,l2]
  
  it "should find existing languages", !->
    t1 = Transpiler.create "l1", "dataflow", langs
    t2 = Transpiler.create "dataflow", "l2", langs
    
    t1.should.be.ok
    t2.should.be.ok
    
  it "should return the correct existing language", !->
    t11 = Transpiler.create "l1", "dataflow", langs
    t12 = Transpiler.create "dataflow", "l1", langs
    t21 = Transpiler.create "l2", "dataflow", langs
    t22 = Transpiler.create "dataflow", "l2", langs
    
    (t11 "a").name.should.equal "a"
    (t12 name: "b").should.equal "b"
    
    (t21 "c").name.should.equal "l2c"
    (t22 name: "d").should.equal "dl2"
  
  it "should fail if a language doesn't exist", !->
    (-> Transpiler.create "fail", "dataflow", langs).should.throw Error
    (-> Transpiler.create "dataflow", "fail", langs).should.throw Error
    (-> Transpiler.create "fail", "fail", langs).should.throw Error
  
  it "should compose exisiting languages", !->
    t1 = Transpiler.create "l1", "l2", langs
    t2 = Transpiler.create "l2", "l1", langs
    
    t1.should.be.ok
    t2.should.be.ok
    
    (t1 "e").should.equal "el2"
    (t2 "f").should.equal "l2f"

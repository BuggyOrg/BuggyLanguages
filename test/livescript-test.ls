
global <<< require \prelude-ls
require! chai
chai.should!

Buggy = (requirejs "Buggy").Buggy
livescript = requirejs "ls!src/livescript"

describe "LiveScript Language", (...) !->
  grp = Buggy.Group.create!
  
  it "should generate ASTable LiveScript Code", !->
    source = livescript.generate grp
    ast = LiveScript.ast source
    
  it "should fail for empty sources", !->
    source = ""
    (-> livescript.parse source).should.throw Error
    
  it "composing generate and parse should create the same implementation", !->
    source = livescript.generate grp
    new-grp = livescript.parse source
    console.log source
    console.log JSON.stringify new-grp, null, 2
    new-grp.should.deep.equal grp
    
  it "should convert a given source", !->
    source = requirejs "text!fixtures/livescript-node.ls"
    new-grp = livescript.parse source
    (Buggy.Implementation.identifier new-grp).should.equal "NodeName"

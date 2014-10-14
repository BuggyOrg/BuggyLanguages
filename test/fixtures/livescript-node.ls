implements: "Symbol"
NodeName = -> 
  OutA = A in1: OutNodeName.first in2: 4
  OutB = B in1: OutA.first in2: OutA.second
  return { res: OutB.first more: OutA.third }

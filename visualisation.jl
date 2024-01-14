include("../TICTACTOE/logic/GameUtiliatries.jl")

JAN = "a0b2c2d35e1f1g4h5i0/034"

nombreDuJAN = lastNumberOnly(DismantleBoard(JAN))
winner = 2;

if(nombreDuJAN[5] != 9 )
   # VerifyJAN ligne passant par le centre
   if(winAtThisligne(nombreDuJAN[2],nombreDuJAN[5],nombreDuJAN[8]))
   elseif winAtThisligne(nombreDuJAN[4],nombreDuJAN[5],nombreDuJAN[6])
   elseif winAtThisligne(nombreDuJAN[1],nombreDuJAN[5],nombreDuJAN[9])
   elseif winAtThisligne(nombreDuJAN[3],nombreDuJAN[5],nombreDuJAN[7])
   else
   end  

end    

if(nombreDuJAN[1] != 9 )
    # VerifyJAN ligne passant par a verticalement et horizontalement
    winAtThisligne(nombreDuJAN[1],nombreDuJAN[2],nombreDuJAN[3]);
    winAtThisligne(nombreDuJAN[1],nombreDuJAN[4],nombreDuJAN[7]);
end 

if(nombreDuJAN[9] != 9 )
    # VerifyJAN ligne passant par i verticalement et horizontalement
    winAtThisligne(nombreDuJAN[3],nombreDuJAN[6],nombreDuJAN[9]);
    winAtThisligne(nombreDuJAN[7],nombreDuJAN[8],nombreDuJAN[9]);
end







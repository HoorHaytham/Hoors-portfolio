type Position = (Int,Int)
data Color = W | B deriving (Eq, Show)
data Peg = Peg Position Color deriving (Eq, Show)
data Move = M Position deriving (Eq, Show)
type Board = [Peg]
data State = S Move Board deriving (Eq, Show)
isGoal :: Board -> Bool
isGoal [] = True --We've checked every peg and found it was white -> Winning configuration
isGoal ((Peg _ color) : t) | color == B = False --If this peg is black , we haven't won yet
						   |otherwise = isGoal t --otherwise, keep checking the rest of the pegs to be white also
isValidMove :: Move -> Board -> Bool
isValidMove _ [] = False --A move cannot be made on an empty board
isValidMove (M position) board = isBlack position board && aroundWhite position board 
													 
isBlack :: 	Position -> Board -> Bool 
isBlack _ [] = False 																						
isBlack position ((Peg position1 color) : t) |position1 == position && color == W = False --Cannot flip white peg
  											 |position == position1 && color /= W  = True 
											 |otherwise = isBlack position t --Otherwise, search for the desired peg												 
													 
													 
--We check in the possible 4 directions (up,down,left,right) to see if there exists at least one white peg		
aroundWhite :: Position -> Board -> Bool											 
aroundWhite (x,y) board = elem (Peg (x,(y+1)) W) board || elem (Peg (x,(y-1)) W) board || elem (Peg ((x-1),y) W) board || elem (Peg ((x+1),y) W) board
createBoard:: Position-> Board
createBoard position |checkValid position validPos = createHelper position validPos --If position exists, go ahead and create the board
					 |otherwise = error "The position is not valid"   --Otherwise, throw an error
					where validPos =[(-3,-1), (-3,0), (-3,1), (-2,-1), (-2,0), (-2,1), (-1,-3), (-1,-2), (-1,-1), (-1,0), (-1,1), (-1,2), (-1,3), (0,-3), (0,-2), (0,-1), (0,0), (0,1), (0,2), (0,3), (1,-3), (1,-2), (1,-1), (1,0), (1,1), (1,2), (1,3), (2,-1), (2,0), (2,1), (3,-1), (3,0), (3,1)]
checkValid :: Position -> [Position] -> Bool
checkValid position validPos = elem position validPos
createHelper _ [] = [] --I am now done with my board when all positions have been placed
createHelper position ((x,y) : t) |position == (x,y) = [Peg position W] ++ createHelper position t --This is my initial white peg
								  |otherwise = [Peg (x,y) B] ++ createHelper position t --Otherwise, it should be black
								  
								  
showPossibleNextStates:: Board-> [State]
showPossibleNextStates myboard | isGoal myboard = error " No Possible States Exist"
							   | otherwise = movesHelper moves myboard 
							   where moves = [(-3,-1), (-3,0), (-3,1), (-2,-1), (-2,0), (-2,1), (-1,-3), (-1,-2), (-1,-1), (-1,0), (-1,1), (-1,2), (-1,3), (0,-3), (0,-2), (0,-1), (0,0), (0,1), (0,2), (0,3), (1,-3), (1,-2), (1,-1), (1,0), (1,1), (1,2), (1,3), (2,-1), (2,0), (2,1), (3,-1), (3,0), (3,1)]

--checks if a move is valid , then performs this move 
movesHelper :: [Position] -> Board -> [State]
movesHelper _ [] = [] 
movesHelper [] _ = [] 
movesHelper (position :t) board | isValidMove (M position) board = (S (M position) changed) : movesHelper t board 
								   | otherwise = movesHelper t board 
								   where changed = changeBoard position board 

--changes color of pos node to white , performs this move
changeBoard :: Position -> Board -> Board
changeBoard position [] = []
changeBoard position ((Peg position1 color) : t) | position == position1 =  (Peg position1 W) : t
												 | otherwise = (Peg position1 color) : changeBoard position t
  







							
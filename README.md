# Project description

This project's goal was to implement an engine for a variant of the game TicTacToe.
Each player has two small pieces, two mediums, and two larges. The goal remains the same: make three in a row.
When it is their turn to play, a player can place a piece or move an available piece.
The piece can be placed on a square if it is bigger than what is already on it. Every piece can be placed on an empty square.
A player can't move a piece that is under another one.
If a player moves a piece and reveals a tictactoe for the opponent, he automatically loses. Even if he intended to place his piece back to block the diagonal.
This rule makes it very important to keep track of what is under what.
If a player is out of moves, it loses.
The added rules make the game a lot more difficult and interesting.

The original goal of this project was to implement a way to implement a program that is able to determine, given a position, who is winning and what is the best move in that position.

The current version has accomplished this goal, although it is not user-friendly. One can play against the engine by running the Playing.jl in vscode and write the command play($1), play($1,$2), or play($1,$2,$3) in the REPL.
The first arguments given in play are 0 for playing first (X) and 1 for playing second (O).
The second (optional) argument is to determine the depth. I don't recommend going further than 5.
The third (optional) argument is a number between 1 and 3. This will determine the pieceset's use.
Warning: Julia has to be able to be run on VSCode.

# Futur improvements for futur versions
- [ ] **A transposition table:** there is a lot of transposition and, therefore, a lot of wasted time.

- [ ] **A better eval function and a proper alpha-beta algorithm:** the position should be a number between 0 and 1, where 0 O has won and 1 X has won. If no force win has been found, the ratio of (available move)/(oponent available move) would be, in my opinion, a good indicator of who is currently in a better position.

- [ ] **A more fluent way to analyze positions:** It is possible if you know how JAN works, but it isn't a pleasant experience.

- [ ] **A better user interface:** Interface isn't something I know a lot about, so it could be interesting to learn more about it. The library Mousetrap looks promising.

- [ ] **A neural network-based evaluation:** It could be an interesting project to train a neural network-base to evaluate position.
# 4x4 Tic Tac Toe with a twist
# After every 3 turns, a random empty cell gets blocked (#)

.data
board:          .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0  # 4x4 board (0=empty, 1=X, 2=O, 3=blocked)
currentPlayer:  .word 1                                               # 1 for X, 2 for O
moveCount:      .word 0                                               # Counter for moves made
gameOver:       .word 0                                               # 0 if game is ongoing, 1 if game is over

# Display strings
newline:        .asciiz "\n"
horizontalLine: .asciiz "+---+---+---+---+\n"
verticalLine:   .asciiz "| "
prompt:         .asciiz "Player "
xSymbol:        .asciiz "X"
oSymbol:        .asciiz "O"
enterRowCol:    .asciiz ", enter row (1-4) and column (1-4): "
invalidMove:    .asciiz "Invalid move! Try again.\n"
winMessage:     .asciiz " wins!\n"
drawMessage:    .asciiz "It's a draw!\n"
blockMessage:   .asciiz "A random cell has been blocked!\n"
emptyCell:      .asciiz "  "
xCell:          .asciiz "X "
oCell:          .asciiz "O "
blockedCell:    .asciiz "# "
gameTitle:      .asciiz "=== 4x4 TIC TAC TOE WITH RANDOM BLOCKING ===\n\n"
gameRules:      .asciiz "Rules:\n1. Players take turns placing X and O\n2. Every 3 turns, a random empty cell is blocked (#)\n3. First to get 4 in a row (horizontal, vertical, or diagonal) wins\n\n"

.text
.globl main

main:
    # Display game title and rules
    li $v0, 4
    la $a0, gameTitle
    syscall
    
    li $v0, 4
    la $a0, gameRules
    syscall
    
    # Initialize the board
    jal initializeBoard
    
    # Main game loop
gameLoop:
    # Display the board
    jal displayBoard
    
    # Get player move
    jal getPlayerMove
    
    # Make the move
    jal makeMove
    
    # Increment move counter
    lw $t0, moveCount
    addi $t0, $t0, 1
    sw $t0, moveCount
    
    # Check for win
    jal checkWin
    lw $t0, gameOver
    bne $t0, $zero, endGame
    
    # Check for draw
    jal checkDraw
    lw $t0, gameOver
    bne $t0, $zero, endGame
    
    # Check if we need to block a cell (every 3 turns)
    lw $t0, moveCount
    div $t0, $t0, 3
    mfhi $t1              # $t1 contains remainder
    bne $t1, $zero, skipBlock
    
    # Block a random cell
    jal blockRandomCell
    
skipBlock:
    # Switch player
    jal switchPlayer
    
    # Continue the game loop
    j gameLoop
    
endGame:
    # Display the final board
    jal displayBoard
    
    # Exit the program
    li $v0, 10
    syscall

#------------------------------------------------------------------
# Function: initializeBoard
# Initialize all board cells to empty (0)
#------------------------------------------------------------------
initializeBoard:
    li $t0, 0              # Index counter
    la $t1, board          # Load board address
    
initLoop:
    sw $zero, 0($t1)       # Set current cell to 0 (empty)
    addi $t1, $t1, 4       # Move to next cell
    addi $t0, $t0, 1       # Increment counter
    blt $t0, 16, initLoop  # Loop until all 16 cells are initialized
    
    jr $ra                 # Return

#------------------------------------------------------------------
# Function: displayBoard
# Display the current state of the board
#------------------------------------------------------------------
displayBoard:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $v0, 4
    la $a0, newline
    syscall
    
    li $t0, 0              # Row counter
    li $t1, 0              # Cell index

displayLoop:
    # Print horizontal line
    li $v0, 4
    la $a0, horizontalLine
    syscall
    
    # Print one row
    li $t2, 0              # Column counter
    
displayRowLoop:
    # Print vertical line
    li $v0, 4
    la $a0, verticalLine
    syscall
    
    # Calculate board index
    mul $t3, $t0, 4        # row * 4
    add $t3, $t3, $t2      # row * 4 + col
    mul $t3, $t3, 4        # (row * 4 + col) * 4 (byte offset)
    la $t4, board
    add $t4, $t4, $t3      # Address of board[row][col]
    lw $t5, 0($t4)         # Load value from board
    
    # Display the appropriate symbol
    beq $t5, $zero, printEmpty
    beq $t5, 1, printX
    beq $t5, 2, printO
    
    # Must be blocked cell (3)
    li $v0, 4
    la $a0, blockedCell
    syscall
    j displayContinue
    
printEmpty:
    li $v0, 4
    la $a0, emptyCell
    syscall
    j displayContinue
    
printX:
    li $v0, 4
    la $a0, xCell
    syscall
    j displayContinue
    
printO:
    li $v0, 4
    la $a0, oCell
    syscall
    
displayContinue:
    addi $t2, $t2, 1       # Increment column counter
    blt $t2, 4, displayRowLoop  # Continue if not end of row
    
    # End of row, print vertical line and newline
    li $v0, 4
    la $a0, verticalLine
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall
    
    addi $t0, $t0, 1       # Increment row counter
    blt $t0, 4, displayLoop  # Continue if not last row
    
    # Print the last horizontal line
    li $v0, 4
    la $a0, horizontalLine
    syscall
    
    # Print newline
    li $v0, 4
    la $a0, newline
    syscall
    
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------
# Function: getPlayerMove
# Get row and column from the player (stored in $v0 and $v1)
#------------------------------------------------------------------
getPlayerMove:
    # Save registers
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    
promptMove:
    # Display prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # Display current player symbol
    lw $t0, currentPlayer
    beq $t0, 1, displayX
    
    li $v0, 4
    la $a0, oSymbol
    syscall
    j continuePrompt
    
displayX:
    li $v0, 4
    la $a0, xSymbol
    syscall
    
continuePrompt:
    # Display the rest of the prompt
    li $v0, 4
    la $a0, enterRowCol
    syscall
    
    # Read row
    li $v0, 5
    syscall
    move $s0, $v0          # $s0 = row
    
    # Read column
    li $v0, 5
    syscall
    move $s1, $v0          # $s1 = column
    
    # Validate input range (1-4)
    blt $s0, 1, invalidInput
    bgt $s0, 4, invalidInput
    blt $s1, 1, invalidInput
    bgt $s1, 4, invalidInput
    
    # Convert to 0-based indices
    addi $s0, $s0, -1
    addi $s1, $s1, -1
    
    # Calculate board index
    mul $t0, $s0, 4        # row * 4
    add $t0, $t0, $s1      # row * 4 + col
    mul $t0, $t0, 4        # (row * 4 + col) * 4 (byte offset)
    la $t1, board
    add $t1, $t1, $t0      # Address of board[row][col]
    lw $t2, 0($t1)         # Load value from board
    
    # Check if cell is empty
    bne $t2, $zero, invalidInput
    
    # Valid move, return row and column
    move $v0, $s0
    move $v1, $s1
    
    # Restore registers and return
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra
    
invalidInput:
    # Display invalid move message
    li $v0, 4
    la $a0, invalidMove
    syscall
    
    # Try again
    j promptMove

#------------------------------------------------------------------
# Function: makeMove
# Make a move at position ($v0, $v1) for the current player
#------------------------------------------------------------------
makeMove:
    # Calculate board index
    mul $t0, $v0, 4        # row * 4
    add $t0, $t0, $v1      # row * 4 + col
    mul $t0, $t0, 4        # (row * 4 + col) * 4 (byte offset)
    la $t1, board
    add $t1, $t1, $t0      # Address of board[row][col]
    
    # Place current player's symbol
    lw $t2, currentPlayer
    sw $t2, 0($t1)
    
    jr $ra

#------------------------------------------------------------------
# Function: checkWin
# Check if the current player has won
#------------------------------------------------------------------
checkWin:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    lw $t0, currentPlayer  # Current player (1 for X, 2 for O)
    
    # Check rows
    li $t1, 0              # Row counter
    
checkRowsLoop:
    li $t2, 0              # Column counter
    li $t3, 0              # Count of matching cells in this row
    
    checkRowCellsLoop:
        # Calculate board index
        mul $t4, $t1, 4        # row * 4
        add $t4, $t4, $t2      # row * 4 + col
        mul $t4, $t4, 4        # (row * 4 + col) * 4 (byte offset)
        la $t5, board
        add $t5, $t5, $t4      # Address of board[row][col]
        lw $t6, 0($t5)         # Load value from board
        
        # If cell matches current player, increment counter
        bne $t6, $t0, rowCellNoMatch
        addi $t3, $t3, 1       # Increment counter
        
    rowCellNoMatch:
        addi $t2, $t2, 1       # Increment column counter
        blt $t2, 4, checkRowCellsLoop
        
        # If all 4 cells in this row match, we have a win
        beq $t3, 4, playerWins
        
        # Move to next row
        addi $t1, $t1, 1
        blt $t1, 4, checkRowsLoop
    
    # No row win, check columns
    li $t1, 0              # Column counter
    
checkColsLoop:
    li $t2, 0              # Row counter
    li $t3, 0              # Count of matching cells in this column
    
    checkColCellsLoop:
        # Calculate board index
        mul $t4, $t2, 4        # row * 4
        add $t4, $t4, $t1      # row * 4 + col
        mul $t4, $t4, 4        # (row * 4 + col) * 4 (byte offset)
        la $t5, board
        add $t5, $t5, $t4      # Address of board[row][col]
        lw $t6, 0($t5)         # Load value from board
        
        # If cell matches current player, increment counter
        bne $t6, $t0, colCellNoMatch
        addi $t3, $t3, 1       # Increment counter
        
    colCellNoMatch:
        addi $t2, $t2, 1       # Increment row counter
        blt $t2, 4, checkColCellsLoop
        
        # If all 4 cells in this column match, we have a win
        beq $t3, 4, playerWins
        
        # Move to next column
        addi $t1, $t1, 1
        blt $t1, 4, checkColsLoop
    
    # No column win, check main diagonal (top-left to bottom-right)
    li $t1, 0              # Diagonal position counter
    li $t3, 0              # Count of matching cells in the diagonal
    
checkMainDiagLoop:
    # Calculate board index
    mul $t4, $t1, 4        # row * 4
    add $t4, $t4, $t1      # row * 4 + col (where row = col for main diagonal)
    mul $t4, $t4, 4        # (row * 4 + col) * 4 (byte offset)
    la $t5, board
    add $t5, $t5, $t4      # Address of board[diag][diag]
    lw $t6, 0($t5)         # Load value from board
    
    # If cell matches current player, increment counter
    bne $t6, $t0, mainDiagCellNoMatch
    addi $t3, $t3, 1       # Increment counter
    
mainDiagCellNoMatch:
    addi $t1, $t1, 1       # Increment diagonal position
    blt $t1, 4, checkMainDiagLoop
    
    # If all 4 cells in the main diagonal match, we have a win
    beq $t3, 4, playerWins
    
    # No main diagonal win, check other diagonal (top-right to bottom-left)
    li $t1, 0              # Row counter
    li $t3, 0              # Count of matching cells in the diagonal
    
checkOtherDiagLoop:
    # Calculate board index for other diagonal: (row, 3-row)
    mul $t4, $t1, 4        # row * 4
    add $t4, $t4, 3        # row * 4 + 3
    sub $t4, $t4, $t1      # row * 4 + 3 - row
    mul $t4, $t4, 4        # (row * 4 + (3 - row)) * 4 (byte offset)
    la $t5, board
    add $t5, $t5, $t4      # Address of board[row][3-row]
    lw $t6, 0($t5)         # Load value from board
    
    # If cell matches current player, increment counter
    bne $t6, $t0, otherDiagCellNoMatch
    addi $t3, $t3, 1       # Increment counter
    
otherDiagCellNoMatch:
    addi $t1, $t1, 1       # Increment row
    blt $t1, 4, checkOtherDiagLoop
    
    # If all 4 cells in the other diagonal match, we have a win
    beq $t3, 4, playerWins
    
    # No win found
    j noWin

playerWins:
    # Display win message
    li $v0, 4
    la $a0, prompt
    syscall
    
    lw $t0, currentPlayer
    beq $t0, 1, winnerX
    
    li $v0, 4
    la $a0, oSymbol
    syscall
    j continueWin
    
winnerX:
    li $v0, 4
    la $a0, xSymbol
    syscall
    
continueWin:
    li $v0, 4
    la $a0, winMessage
    syscall
    
    # Set game over flag
    li $t0, 1
    sw $t0, gameOver
    
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

noWin:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------
# Function: checkDraw
# Check if the game is a draw (all cells filled)
#------------------------------------------------------------------
checkDraw:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    li $t0, 0              # Index counter
    la $t1, board          # Load board address
    
checkDrawLoop:
    lw $t2, 0($t1)         # Load value from board
    
    # If cell is empty, not a draw yet
    beq $t2, $zero, notDraw
    
    addi $t1, $t1, 4       # Move to next cell
    addi $t0, $t0, 1       # Increment counter
    blt $t0, 16, checkDrawLoop  # Loop until all 16 cells are checked
    
    # All cells filled, it's a draw
    li $v0, 4
    la $a0, drawMessage
    syscall
    
    # Set game over flag
    li $t0, 1
    sw $t0, gameOver
    
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra
    
notDraw:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------
# Function: blockRandomCell
# Block a random empty cell on the board
#------------------------------------------------------------------
blockRandomCell:
    # Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # First, count empty cells
    li $t0, 0              # Empty cell counter
    li $t1, 0              # Index counter
    la $t2, board          # Load board address
    
countEmptyLoop:
    lw $t3, 0($t2)         # Load value from board
    
    # If cell is empty, increment counter
    bne $t3, $zero, notEmpty
    addi $t0, $t0, 1
    
notEmpty:
    addi $t2, $t2, 4       # Move to next cell
    addi $t1, $t1, 1       # Increment counter
    blt $t1, 16, countEmptyLoop  # Loop until all 16 cells are checked
    
    # If no empty cells, return
    beq $t0, $zero, blockDone
    
    # Generate a random number between 0 and (empty_count - 1)
    li $v0, 42             # Random int range
    li $a0, 0              # Random generator ID
    move $a1, $t0          # Upper bound (exclusive)
    syscall
    move $t4, $a0          # $t4 = random number
    
    # Find the corresponding empty cell
    li $t0, 0              # Empty cell counter
    li $t1, 0              # Index counter
    la $t2, board          # Load board address
    
findEmptyLoop:
    lw $t3, 0($t2)         # Load value from board
    
    # If cell is empty
    bne $t3, $zero, notTargetEmpty
    
    # Check if this is our target empty cell
    beq $t0, $t4, blockThisCell
    
    # Increment counter
    addi $t0, $t0, 1
    
notTargetEmpty:
    addi $t2, $t2, 4       # Move to next cell
    addi $t1, $t1, 1       # Increment counter
    blt $t1, 16, findEmptyLoop  # Loop until all 16 cells are checked
    
    # Should not reach here, but just in case
    j blockDone
    
blockThisCell:
    # Mark the cell as blocked (value 3)
    li $t3, 3
    sw $t3, 0($t2)
    
    # Display block message
    li $v0, 4
    la $a0, blockMessage
    syscall
    
blockDone:
    # Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#------------------------------------------------------------------
# Function: switchPlayer
# Switch to the other player
#------------------------------------------------------------------
switchPlayer:
    lw $t0, currentPlayer
    beq $t0, 1, setPlayerO
    
    # Current player is O, switch to X
    li $t0, 1
    sw $t0, currentPlayer
    jr $ra
    
setPlayerO:
    # Current player is X, switch to O
    li $t0, 2
    sw $t0, currentPlayer
    jr $ra
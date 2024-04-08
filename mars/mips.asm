main:
    add $1 $2 $3
    sub $4 $5 $6
    and $7 $8 $9
    or $10 $11 $12
    slt $13 $14 $15
    andi $16 $17 0x0001
    beq $18 $18 here

here:
    andi $1 $1 0x0
    lw $2 0($3)
    sw $4 0($5)
    j main
.text
main:
    add $1 $2 $3
    addi $a0 $5 10
    jal	toFUN				# jump totoFUN and save position to $ra
    add $1 $v0 $0
toFUN:
    addi $a0 $a0 10
    add  $v0 $a0 $0
    jr $ra

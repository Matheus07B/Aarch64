.global _start

.data
  msg: .ascii "1\n"
  len = . - msg

  msg1: .ascii "2\n"
  len1 = . - msg1

  msg2: .ascii "3\n"
  len2 = . - msg2

  msg3: .ascii "4\n"
  len3 = . - msg3

  msg4: .ascii "olá\n"
  len4 = . - msg4

.text
_start:
  mov x7, 5

  cmp x7, #1
  beq b1

  cmp x7, #2
  beq b2

  cmp x7, #3
  beq b3

  cmp x7, #4
  beq b4

  b else

b1:
  mov x0, 1
  ldr x1, =msg
  ldr x2, =len
  mov x8, 64
  svc 0

  b exit

b2:
  mov x0, 1
  ldr x1, =msg1
  ldr x2, =len1
  mov x8, 64
  svc 0

  b exit

b3:
  mov x0, 1
  ldr x1, =msg2
  ldr x2, =len2
  mov x8, 64
  svc 0

  b exit

b4:
  mov x0, 1
  ldr x1, =msg3
  ldr x2, =len3
  mov x8, 64
  svc 0

  b exit

else:
  mov x0, 1
  ldr x1, =msg4
  ldr x2, =len4
  mov x8, 64
  svc 0

  b exit

exit:
  mov x0, 0
  mov x8, 93
  svc 0

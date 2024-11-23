.global _start

.data

.text
_start:
  mov x0, 10
  mov x1, 2

  udiv x2, x0, x1

  b exit

exit:
  mov x0, 0
  mov x8, 93
  svc 0

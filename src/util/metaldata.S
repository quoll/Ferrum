.section __DATA,__data
.globl _binary_ferrum_bin_start
.globl _binary_ferrum_bin_end
.globl _binary_ferrum_bin_size
_binary_ferrum_bin_start:
.incbin "ferrum.metallib"
_binary_ferrum_bin_end:
_binary_ferrum_bin_size:
.quad _binary_ferrum_bin_end - _binary_ferrum_bin_start

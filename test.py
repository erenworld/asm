# Labels denoting functions should be global; others should be local.
# You do not assume that registers hold zero “by default.”
# You save and restore callee-saved registers if you are using them.
# In fact, by decreasing rsp you allocate memory on the stack. 7
# We consider spaces, tabulation, and line breaks as whitespace characters. Their codes are 0x20, 0x9, and 0x10, respectively
# You save caller-saved registers you need before call and restore them after.
# You do not use buffers in .data. Instead, you allocate them on the stack, which allows you to adapt multithreading if needed.
# Your functions accept arguments in rdi, rsi, rdx, rcx, r8, and r9
# You do not print numbers digit after digit. Instead you transform them into strings of characters and use print_string.
# parse_int and parse_uint are setting rdx correctly. It will be really important in the next assignment.
# All parsing functions and read_word work when the input is terminated via Ctrl-D.

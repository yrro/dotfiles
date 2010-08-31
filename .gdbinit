set prompt \n(gdb) 
set pagination off
#handle SIG32 nostop print pass

set print array on
set print object on
set print pretty on
set print vtbl on

python
import os, sys
if os.path.exists ('/home/sam/src/gdb/python'):
	sys.path.insert (0, '/home/sam/src/gdb/python')
	from libstdcxx.v6.printers import register_libstdcxx_printers
	register_libstdcxx_printers (None)
end

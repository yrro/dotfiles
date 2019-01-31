set prompt \n(gdb) 
set pagination off
#handle SIG32 nostop print pass

set print array on
set print object on
set print pretty on
set print vtbl on

python
import sys

sys.path.insert(0, '/usr/share/gcc-8/python')
try:
	from libstdcxx.v6.printers import register_libstdcxx_printers
except ImportError:
	pass
else:
	register_libstdcxx_printers (None)

sys.path.insert (0, '/home/sam/src/gdb/boost')
try:
	from boost_printers import register_boost_printers
except ImportError:
	pass
else:
	register_boost_printers (None)

sys.path.insert(0, '/usr/share/glib-2.0/gdb')
try:
	import glib_gdb, gobject_gdb
except ImportError:
	pass
else:
	glib_gdb.register(None)
	gobject_gdb.register(None)
end

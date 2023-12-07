import sys
import selinux.audit2why as audit2why

try:
  audit2why.init()
except:
  sys.exit(1)
sys.exit(0)

import libvirt
conn = libvirt.open("test:///default")
print(conn.getType())

import numpy as np

density = 2670 # kg m-3
vs = 3464 # m s-1
vp = 6000 # m s-1

mu = vs**2 * density
la = vp**2 * density - 2*mu

print("1st Lame parameter = {} Pa.".format(la))
print("Rigidity = {} Pa.".format(mu))

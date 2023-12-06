import math

time = 48989083
distance = 390110311121360
startbound = 0
endbound = time

def winsrace(chargetime):
    return ((time-chargetime) * chargetime) > distance

delta = time
while True:
    delta = int(delta / 2)
    if winsrace(startbound):
        startbound -= delta
    else:
        startbound += delta
    if winsrace(startbound) and not winsrace(startbound-1):
        break
print("start bound", startbound)

delta = time
while True:
    delta = int(delta / 2)
    if delta < 1:
        delta = 1
    if winsrace(endbound):
        endbound += delta
    else:
        endbound -= delta
    if winsrace(endbound) and not winsrace(endbound+1):
        break
print("end bound", endbound)

print("bound len", endbound - startbound + 1)
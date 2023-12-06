import math

times = [48,98,90,83]
distances = [390,1103,1112,1360]
twins = []

for (t,d) in zip(times, distances):
    wins = 0
    for ct in range(t):
        traveled = (t-ct) * ct
        print(ct, t-ct, traveled)
        if traveled > d:
            wins += 1
    twins.append(wins)
    print("wins", wins)
print("prod", math.prod(twins))
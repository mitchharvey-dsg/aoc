import re, math
total = 0
with open("234input") as input:
    for line in input:
        parts = line.split("|")
        mynums = re.findall(r"\S+", parts[0].strip())
        winnums = re.findall(r"\S+", parts[1].strip())
        winset = list(set(mynums) & set(winnums))
        wins = len(winset)
        if wins > 0:
            points = int(math.pow(2, (wins-1)))
            print(points, wins, winset)
            total += points

print(total)
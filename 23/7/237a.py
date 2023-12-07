import functools

type = ["FVOK", "FROK", "FLHS", "TROK", "TWPR", "ONPR", "HIGH"]
label = [x for x in "AKQJT98765432"]

def getlabel(hand):
    counts = {}
    for letter in hand:
        counts[letter] = hand.count(letter)
    if len(counts) == 1:
        return "FVOK"
    if len(counts) == 2:
        if 4 in list(counts.values()):
            return "FROK"
        if 3 in list(counts.values()):
            return "FLHS"
    if len(counts) == 3:
        if 3 in list(counts.values()):
            return "TROK"
        if 2 in list(counts.values()):
            return "TWPR"
    if len(counts) == 4:
        return "ONPR"
    if len(counts) == 5:
        return "HIGH"
    raise Exception("not found")

def compare(a, b):
    if a[2] < b[2]:
        return 1
    if a[2] > b[2]:
        return -1
    for x in zip(a[3], b[3]):
        if x[0] == x[1]:
            continue
        if x[0] < x[1]:
            return 1
        return -1
    return 0

cards = []
with open('input') as input:
    for line in input:
        cards.append(line.split())

for hand in cards:
    hand.append(type.index(getlabel(hand[0])))
    hand.append([label.index(x) for x in hand[0]])
print("assigned")

cards.sort(key=functools.cmp_to_key(compare))
print("sorted")

winnings = 0
for i, card in enumerate(cards, start=1):
    # print(card, i)
    winnings += int(card[1]) * i
print(winnings)
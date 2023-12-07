import functools

type = ["FVOK", "FROK", "FLHS", "TROK", "TWPR", "ONPR", "HIGH"]
label = [x for x in "AKQT98765432J"]

def getlabel(hand):
    counts = {}
    js = hand.count("J")
    if js == 5:
        return "FVOK"
    hand = hand.replace("J", "")
    for letter in hand:
        counts[letter] = hand.count(letter)
    if 5 in list(counts.values()):
        return "FVOK"
    if 4 in list(counts.values()):
        if js == 1:
            return "FVOK"
        return "FROK"
    if 3 in list(counts.values()):
        if js == 2:
            return "FVOK"
        if js == 1:
            return "FROK"
        if 2 in list(counts.values()):
            return "FLHS"
        return "TROK"
    if 2 in list(counts.values()):
        if js == 3:
            return "FVOK"
        if js == 2:
            return "FROK"
        if js == 1:
            if list(counts.values())[0] == 2 and list(counts.values())[1] == 2:
                return "FLHS"
            return "TROK"
        return "ONPR"
    if 1 in list(counts.values()):
        if js == 4:
            return "FVOK"
        if js == 3:
            return "FROK"
        if js == 2:
            return "TROK"
        if js == 1:
            return "ONPR"
        return "HIGH"
    print(hand, js)
    raise Exception(f'not found {hand}'+hand)

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
    # print(hand[0], label[hand[2]])
print("assigned")

cards.sort(key=functools.cmp_to_key(compare))
# print(cards)
print("sorted")

for hand in cards:
    print(hand[0], getlabel(hand[0]))

winnings = 0
for i, card in enumerate(cards, start=1):
    # print(card, i)
    winnings += int(card[1]) * i
    print(i, int(card[1]), winnings)
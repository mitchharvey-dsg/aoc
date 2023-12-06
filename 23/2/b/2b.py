with open("input") as input:
        summ = 0
        for line in input:
                min_dice = {}
                lparts = line.split(":")
                gid = lparts[0].replace("Game ","")
                draws = lparts[1].split(";")
                power = 1
                for draw in draws:
                        dice = draw.split(",")
                        for die in dice:
                                die = die.strip()
                                num = int(die.split(' ')[0])
                                color = die.split(' ')[1]
                                if min_dice.get(color, 0) < num:
                                        min_dice[color] = num
                for color in min_dice:
                        power *= min_dice[color]
                summ += power
                print(gid, power)
        print(summ)
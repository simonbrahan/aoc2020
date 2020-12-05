def row(seat_def):
    row_def = seat_def[:7]
    return int(row_def.replace("B", "1").replace("F", "0"), 2)


def col(seat_def):
    col_def = seat_def[7:]
    return int(col_def.replace("R", "1").replace("L", "0"), 2)


def seatNum(seat_def):
    return row(seat_def) * 8 + col(seat_def)


highest_num = None
seats = []

with open("input.txt") as f:
    for line in f:
        seat_num = seatNum(line.strip())
        seats.append(seat_num)
        if highest_num < seat_num:
            highest_num = seat_num

print highest_num

seats.sort()

last_seat = None

for seat in seats:
    if last_seat == None:
        last_seat = seat
        continue

    if last_seat < seat - 1:
        print seat - 1
        break

    last_seat = seat
